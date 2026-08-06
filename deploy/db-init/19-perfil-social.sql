-- ============================================================================
-- Glint — Pack social en profiles (perfil editable y sincronizado)
-- ============================================================================
-- Hasta ahora el perfil vivía repartido en tres sitios que no se hablaban:
-- SharedPreferences del móvil (foto, estado), `auth.users.raw_user_meta_data`
-- (nombre, apellidos, teléfono) y esta tabla. La app NUNCA escribía aquí, que
-- es justo la única fuente que ven los demás usuarios: por eso cambiabas tu
-- nombre y tus amigos seguían viendo el viejo en la lista de amigos, en el
-- ranking de XP, en los miembros de grupo y en el panel de admin.
--
-- Este script deja `public.profiles` como única fuente de verdad: añade los
-- campos que faltaban y — lo importante — AMPLÍA el permiso por columna de
-- 04-seguridad-roles.sql para que el usuario pueda escribirlos.
--
-- Idempotente. Aplicar:
--   docker exec -i glint-db psql -U postgres -d postgres < deploy/db-init/19-perfil-social.sql
--   docker exec glint-db psql -U postgres -d postgres -c "NOTIFY pgrst, 'reload schema';"
--
-- Depende de: 03-admin.sql (tabla), 04-seguridad-roles.sql (grants por
-- columna), 06-grupos.sql (avatar_url, codigo_amigo).
-- ============================================================================

-- ── Columnas del pack social ────────────────────────────────────────────────
-- `nombre` se CONSERVA como nombre para mostrar: es lo que devuelven
-- buscar_perfil, mis_amigos y ranking_amigos, y lo que lee grupo_miembros. El
-- cliente lo escribe como '<nombres> <apellidos>' en el mismo UPDATE. No se
-- hace columna generada porque ya tiene datos y el trigger de alta la escribe.
--
-- `avatar_url` ya existe (06-grupos.sql:24) — hasta hoy siempre NULL porque
-- nadie la escribía.
alter table public.profiles
  add column if not exists nombres          text,
  add column if not exists apellidos        text,
  add column if not exists bio              text,
  add column if not exists fecha_nacimiento date,
  add column if not exists telefono         text,
  add column if not exists zona_horaria     text,
  add column if not exists visibilidad      text not null default 'amigos',
  add column if not exists actualizado_en   timestamptz not null default now();

comment on column public.profiles.visibilidad is
  'Quién puede encontrarte: todos | amigos | nadie. Primitiva para el futuro chat/foro.';
comment on column public.profiles.actualizado_en is
  'Marca para el last-write-wins del sync. La pone el CLIENTE, igual que en el '
  'resto de tablas sincronizables (ver 05-sync-tables.sql).';

-- ── Validaciones ────────────────────────────────────────────────────────────
-- OJO: nada de current_date/now() en un CHECK — Postgres solo admite
-- expresiones IMMUTABLE en constraints. Por eso el rango de la fecha es fijo y
-- el "no puede ser futura" se valida en el cliente.
do $$ begin
  if not exists (select 1 from pg_constraint where conname = 'profiles_visibilidad_valida') then
    alter table public.profiles add constraint profiles_visibilidad_valida
      check (visibilidad in ('todos', 'amigos', 'nadie'));
  end if;

  if not exists (select 1 from pg_constraint where conname = 'profiles_bio_len') then
    alter table public.profiles add constraint profiles_bio_len
      check (bio is null or char_length(bio) <= 200);
  end if;

  if not exists (select 1 from pg_constraint where conname = 'profiles_avatar_url_len') then
    alter table public.profiles add constraint profiles_avatar_url_len
      check (avatar_url is null or char_length(avatar_url) <= 500);
  end if;

  if not exists (select 1 from pg_constraint where conname = 'profiles_nacimiento_rango') then
    alter table public.profiles add constraint profiles_nacimiento_rango
      check (fecha_nacimiento is null
             or (fecha_nacimiento > date '1900-01-01'
                 and fecha_nacimiento < date '2100-01-01'));
  end if;

  if not exists (select 1 from pg_constraint where conname = 'profiles_nombres_len') then
    alter table public.profiles add constraint profiles_nombres_len
      check ((nombres   is null or char_length(nombres)   <= 80)
         and (apellidos is null or char_length(apellidos) <= 80)
         and (telefono  is null or char_length(telefono)  <= 30)
         and (zona_horaria is null or char_length(zona_horaria) <= 60));
  end if;
end $$;

-- ── Permisos por columna (el bloqueo real) ──────────────────────────────────
-- 04-seguridad-roles.sql:23 dejó `grant update (nombre, plataforma)`. Sin
-- ampliarlo, escribir cualquier campo nuevo falla con 42501 — y en PostgREST
-- un PATCH que incluya UNA columna sin permiso se rechaza ENTERO, así que el
-- perfil no se guardaría en absoluto.
--
-- `grant update (cols)` es ADITIVO: no retira lo ya concedido, así que esto es
-- idempotente y no rompe nada de lo anterior.
--
-- Fuera del alcance del usuario A PROPÓSITO: id, email, es_admin, creado_en,
-- ultima_actividad, codigo_amigo, xp. Es decir, sigue sin poder hacerse
-- administrador ni falsear su XP ni suplantar un email.
grant update (
  nombre,
  nombres,
  apellidos,
  plataforma,
  avatar_url,
  bio,
  fecha_nacimiento,
  telefono,
  zona_horaria,
  visibilidad,
  actualizado_en
) on public.profiles to authenticated;

-- ── Mantener profiles.email al día tras un cambio de email ──────────────────
-- `email` no está (ni debe estar) en el grant de arriba: si el usuario pudiera
-- escribirlo, se apropiaría de la identidad de otro, porque el email es lo que
-- usa buscar_perfil para encontrarte. Pero GoTrue sí lo cambia en auth.users
-- cuando el usuario confirma un cambio de correo, y si esta tabla se queda con
-- el viejo el usuario DEJA DE SER ENCONTRABLE y el admin ve datos falsos.
--
-- SECURITY DEFINER porque el trigger corre con los permisos de quien dispara
-- el UPDATE en auth.users, que no tiene permiso sobre esta columna.
create or replace function public.sincronizar_email_perfil()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.profiles set email = new.email where id = new.id;
  return new;
end;
$$;

do $$ begin
  if exists (select 1 from information_schema.tables
              where table_schema = 'auth' and table_name = 'users') then
    drop trigger if exists sincronizar_email on auth.users;
    create trigger sincronizar_email
      after update of email on auth.users
      for each row
      when (old.email is distinct from new.email)
      execute function public.sincronizar_email_perfil();
  end if;
end $$;

-- ── Relleno inicial ─────────────────────────────────────────────────────────
-- Los perfiles existentes tienen `nombre` pero no `nombres`. Se parte por el
-- primer espacio para que la app no muestre los campos nuevos vacíos el primer
-- día. Solo afecta a filas que aún no se han tocado.
update public.profiles
   set nombres   = coalesce(nombres,   split_part(nombre, ' ', 1)),
       apellidos = coalesce(apellidos,
                            nullif(trim(substr(nombre, strpos(nombre, ' ') + 1)), ''))
 where nombre is not null
   and nombre <> ''
   and nombres is null;

-- Recordatorio: PostgREST cachea el esquema. Sin esto, las columnas nuevas
-- devuelven 404/400 hasta que se reinicie el contenedor.
notify pgrst, 'reload schema';
