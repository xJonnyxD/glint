-- ============================================================================
-- Glint — Gastos compartidos (grupos, miembros, gastos y saldos)
-- ============================================================================
-- Trae a Glint el modelo de Settle Up: grupos con miembros (reales o
-- "virtuales"), gastos que se reparten entre miembros y liquidación de deudas.
--
-- A diferencia de las tablas de 05-sync-tables.sql (que son de UN solo usuario
-- y el motor de sync filtra por `usuario_id`), estas tablas son COMPARTIDAS:
-- lo que decide quién ve/edita qué es la MEMBRESÍA del grupo, expresada con
-- RLS. La app las consume directo por Supabase + Realtime (no por el
-- GenericSyncEngine).
--
-- Se ejecuta automáticamente en el primer arranque del contenedor `db`.
-- Sobre una base ya existente:
--   docker exec -i glint-db psql -U postgres -d postgres < deploy/db-init/06-grupos.sql
--
-- Es idempotente. Depende de 03-admin.sql (tabla public.profiles).
-- ============================================================================

-- ── Código de amigo en el perfil ─────────────────────────────────────────────
-- Sirve para invitar a alguien a un grupo sin exponer su correo: un código
-- corto, único y compartible. Se asigna solo (trigger) al crearse el perfil.
alter table public.profiles add column if not exists codigo_amigo text;
alter table public.profiles add column if not exists avatar_url   text;

create unique index if not exists profiles_codigo_amigo_idx
  on public.profiles (codigo_amigo) where codigo_amigo is not null;

-- Genera un código legible de 8 caracteres (sin 0/O/1/I para evitar confusión).
create or replace function public.generar_codigo_amigo()
returns text
language plpgsql
as $$
declare
  v_alfabeto text := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  v_codigo   text;
  v_i        int;
begin
  loop
    v_codigo := '';
    for v_i in 1..8 loop
      v_codigo := v_codigo || substr(v_alfabeto, 1 + floor(random() * length(v_alfabeto))::int, 1);
    end loop;
    -- Repetir en el caso (rarísimo) de colisión.
    exit when not exists (select 1 from public.profiles where codigo_amigo = v_codigo);
  end loop;
  return v_codigo;
end;
$$;

-- Al insertarse un perfil, si no trae código, se le pone uno.
create or replace function public.asignar_codigo_amigo()
returns trigger
language plpgsql
as $$
begin
  if new.codigo_amigo is null then
    new.codigo_amigo := public.generar_codigo_amigo();
  end if;
  return new;
end;
$$;

drop trigger if exists profiles_codigo_amigo on public.profiles;
create trigger profiles_codigo_amigo
  before insert on public.profiles
  for each row execute function public.asignar_codigo_amigo();

-- Backfill para los perfiles que ya existían.
update public.profiles
   set codigo_amigo = public.generar_codigo_amigo()
 where codigo_amigo is null;

-- ── Grupos ────────────────────────────────────────────────────────────────────
create table if not exists public.grupos (
  id             text primary key,
  nombre         text not null,
  moneda         text not null default 'USD',
  color          text not null default '#6750A4',
  emoji          text not null default '👥',
  creado_por     uuid not null,
  creado_en      timestamptz not null default now(),
  actualizado_en timestamptz not null default now()
);

-- ── Miembros de un grupo ──────────────────────────────────────────────────────
-- user_id NULL  → miembro "virtual" (una persona sin cuenta en Glint, ej. Pablo).
-- user_id != NULL → miembro real, ligado a un usuario autenticado.
create table if not exists public.grupo_miembros (
  id             text primary key,
  grupo_id       text not null references public.grupos(id) on delete cascade,
  user_id        uuid,
  nombre         text not null,
  avatar_url     text,
  peso           double precision not null default 1,   -- peso de reparto
  rol            text not null default 'miembro',       -- 'dueno' | 'miembro'
  activo         boolean not null default true,
  creado_en      timestamptz not null default now(),
  actualizado_en timestamptz not null default now()
);

-- Un usuario real no puede estar dos veces en el mismo grupo. (Los virtuales,
-- con user_id NULL, no chocan porque en índices únicos los NULL no son iguales.)
create unique index if not exists grupo_miembros_grupo_user_idx
  on public.grupo_miembros (grupo_id, user_id) where user_id is not null;
create index if not exists grupo_miembros_grupo_idx on public.grupo_miembros (grupo_id);
create index if not exists grupo_miembros_user_idx  on public.grupo_miembros (user_id);

-- ── Gastos de un grupo ────────────────────────────────────────────────────────
-- tipo 'gasto'         → alguien pagó algo que se reparte (ver gasto_partes).
-- tipo 'transferencia' → un pago directo de `pagado_por` a `transferido_a` para
--                        saldar deudas (no lleva partes).
create table if not exists public.grupo_gastos (
  id             text primary key,
  grupo_id       text not null references public.grupos(id) on delete cascade,
  descripcion    text not null default '',
  monto          double precision not null,
  moneda         text not null default 'USD',
  pagado_por     text not null references public.grupo_miembros(id) on delete cascade,
  transferido_a  text references public.grupo_miembros(id) on delete cascade,
  fecha          timestamptz not null,
  tipo           text not null default 'gasto',
  creado_por     uuid not null,
  creado_en      timestamptz not null default now(),
  actualizado_en timestamptz not null default now()
);

create index if not exists grupo_gastos_grupo_fecha_idx
  on public.grupo_gastos (grupo_id, fecha desc);

-- ── Partes de un gasto (para quién y cuánto) ──────────────────────────────────
create table if not exists public.gasto_partes (
  id         text primary key,
  gasto_id   text not null references public.grupo_gastos(id) on delete cascade,
  miembro_id text not null references public.grupo_miembros(id) on delete cascade,
  monto      double precision not null
);

create unique index if not exists gasto_partes_gasto_miembro_idx
  on public.gasto_partes (gasto_id, miembro_id);

-- ── Invitaciones a un grupo ───────────────────────────────────────────────────
create table if not exists public.grupo_invitaciones (
  id           text primary key,
  grupo_id     text not null references public.grupos(id) on delete cascade,
  codigo       text unique not null,
  email        text,
  invitado_por uuid not null,
  estado       text not null default 'pendiente',   -- 'pendiente'|'aceptada'|'cancelada'
  creado_en    timestamptz not null default now(),
  expira_en    timestamptz
);

create index if not exists grupo_invitaciones_grupo_idx on public.grupo_invitaciones (grupo_id);

-- ============================================================================
-- Funciones de membresía (SECURITY DEFINER)
-- ============================================================================
-- Igual que public.es_admin() en 03-admin.sql: van con SECURITY DEFINER para
-- que las políticas RLS puedan consultar grupo_miembros/grupos sin caer en
-- recursión infinita de RLS (la función corre como su dueño, saltándose el RLS
-- de las tablas que lee).

create or replace function public.es_miembro_grupo(p_grupo_id text)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.grupo_miembros m
     where m.grupo_id = p_grupo_id
       and m.user_id  = auth.uid()
       and m.activo
  );
$$;

create or replace function public.es_creador_grupo(p_grupo_id text)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.grupos g
     where g.id = p_grupo_id and g.creado_por = auth.uid()
  );
$$;

-- ¿El que llama es miembro del grupo dueño de este gasto? (para gasto_partes)
create or replace function public.es_miembro_por_gasto(p_gasto_id text)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
      from public.grupo_gastos g
      join public.grupo_miembros m on m.grupo_id = g.grupo_id
     where g.id = p_gasto_id
       and m.user_id = auth.uid()
       and m.activo
  );
$$;

-- ============================================================================
-- Permisos + Row Level Security
-- ============================================================================
grant usage on schema public to anon, authenticated, service_role;
grant all on public.grupos             to anon, authenticated, service_role;
grant all on public.grupo_miembros     to anon, authenticated, service_role;
grant all on public.grupo_gastos       to anon, authenticated, service_role;
grant all on public.gasto_partes       to anon, authenticated, service_role;
grant all on public.grupo_invitaciones to anon, authenticated, service_role;

alter table public.grupos             enable row level security;
alter table public.grupo_miembros     enable row level security;
alter table public.grupo_gastos       enable row level security;
alter table public.gasto_partes       enable row level security;
alter table public.grupo_invitaciones enable row level security;

-- ── grupos ────────────────────────────────────────────────────────────────────
-- Ver/editar/borrar solo si eres miembro; crear solo poniéndote como creador.
drop policy if exists "grupos: miembros ven"     on public.grupos;
create policy "grupos: miembros ven"
  on public.grupos for select to authenticated
  using (public.es_miembro_grupo(id) or creado_por = auth.uid());

drop policy if exists "grupos: crear propio"     on public.grupos;
create policy "grupos: crear propio"
  on public.grupos for insert to authenticated
  with check (creado_por = auth.uid());

drop policy if exists "grupos: miembros editan"  on public.grupos;
create policy "grupos: miembros editan"
  on public.grupos for update to authenticated
  using (public.es_miembro_grupo(id)) with check (public.es_miembro_grupo(id));

drop policy if exists "grupos: creador borra"    on public.grupos;
create policy "grupos: creador borra"
  on public.grupos for delete to authenticated
  using (public.es_creador_grupo(id));

-- ── grupo_miembros ────────────────────────────────────────────────────────────
-- El "or es_creador_grupo" resuelve el huevo-y-gallina: al crear el grupo aún
-- no hay miembros, así que el creador debe poder insertarse a sí mismo.
drop policy if exists "miembros: ver"     on public.grupo_miembros;
create policy "miembros: ver"
  on public.grupo_miembros for select to authenticated
  using (public.es_miembro_grupo(grupo_id) or public.es_creador_grupo(grupo_id));

drop policy if exists "miembros: agregar" on public.grupo_miembros;
create policy "miembros: agregar"
  on public.grupo_miembros for insert to authenticated
  with check (public.es_miembro_grupo(grupo_id) or public.es_creador_grupo(grupo_id));

drop policy if exists "miembros: editar"  on public.grupo_miembros;
create policy "miembros: editar"
  on public.grupo_miembros for update to authenticated
  using (public.es_miembro_grupo(grupo_id) or public.es_creador_grupo(grupo_id))
  with check (public.es_miembro_grupo(grupo_id) or public.es_creador_grupo(grupo_id));

drop policy if exists "miembros: borrar"  on public.grupo_miembros;
create policy "miembros: borrar"
  on public.grupo_miembros for delete to authenticated
  using (public.es_miembro_grupo(grupo_id) or public.es_creador_grupo(grupo_id));

-- ── grupo_gastos ──────────────────────────────────────────────────────────────
drop policy if exists "gastos: miembros" on public.grupo_gastos;
create policy "gastos: miembros"
  on public.grupo_gastos for all to authenticated
  using (public.es_miembro_grupo(grupo_id))
  with check (public.es_miembro_grupo(grupo_id));

-- ── gasto_partes ──────────────────────────────────────────────────────────────
drop policy if exists "partes: miembros" on public.gasto_partes;
create policy "partes: miembros"
  on public.gasto_partes for all to authenticated
  using (public.es_miembro_por_gasto(gasto_id))
  with check (public.es_miembro_por_gasto(gasto_id));

-- ── grupo_invitaciones ────────────────────────────────────────────────────────
-- Los miembros gestionan invitaciones del grupo. Aceptar una invitación por
-- código va por la RPC aceptar_invitacion() de abajo (no por SELECT directo),
-- para no exponer invitaciones de grupos ajenos.
drop policy if exists "invitaciones: miembros" on public.grupo_invitaciones;
create policy "invitaciones: miembros"
  on public.grupo_invitaciones for all to authenticated
  using (public.es_miembro_grupo(grupo_id))
  with check (public.es_miembro_grupo(grupo_id));

-- ── Mantener actualizado_en al día ──────────────────────────────────────────
-- Reusa public.tocar_actualizada_en()? No: esa toca `actualizada_en` (con 'a').
-- Aquí las columnas son `actualizado_en` (con 'o'), así que va su propia
-- función.
create or replace function public.tocar_actualizado_en()
returns trigger
language plpgsql
as $$
begin
  new.actualizado_en = now();
  return new;
end;
$$;

drop trigger if exists grupos_actualizado_en on public.grupos;
create trigger grupos_actualizado_en
  before update on public.grupos
  for each row execute function public.tocar_actualizado_en();

drop trigger if exists grupo_miembros_actualizado_en on public.grupo_miembros;
create trigger grupo_miembros_actualizado_en
  before update on public.grupo_miembros
  for each row execute function public.tocar_actualizado_en();

drop trigger if exists grupo_gastos_actualizado_en on public.grupo_gastos;
create trigger grupo_gastos_actualizado_en
  before update on public.grupo_gastos
  for each row execute function public.tocar_actualizado_en();

-- ============================================================================
-- RPCs de la capa social
-- ============================================================================

-- Buscar a alguien para invitarlo, SIN exponer toda la tabla profiles: solo
-- por correo exacto o por código de amigo, y devolviendo lo mínimo.
create or replace function public.buscar_perfil(p_texto text)
returns table (id uuid, nombre text, email text, codigo_amigo text, avatar_url text)
language sql
stable
security definer
set search_path = public
as $$
  select p.id, p.nombre, p.email, p.codigo_amigo, p.avatar_url
    from public.profiles p
   where p.id <> auth.uid()
     and (lower(p.email) = lower(trim(p_texto))
          or upper(p.codigo_amigo) = upper(trim(p_texto)))
   limit 5;
$$;

revoke all on function public.buscar_perfil(text) from public, anon;
grant execute on function public.buscar_perfil(text) to authenticated;

-- Aceptar una invitación por código: agrega al que llama como miembro real del
-- grupo. SECURITY DEFINER porque el invitado aún NO es miembro (el RLS de
-- grupo_miembros no lo dejaría insertarse por sí solo).
create or replace function public.aceptar_invitacion(p_codigo text)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_inv    public.grupo_invitaciones%rowtype;
  v_nombre text;
  v_id     text;
begin
  if auth.uid() is null then
    raise exception 'Sesión no válida' using errcode = '42501';
  end if;

  select * into v_inv
    from public.grupo_invitaciones
   where codigo = upper(trim(p_codigo))
     and estado = 'pendiente'
     and (expira_en is null or expira_en > now())
   limit 1;

  if not found then
    raise exception 'Invitación no válida o vencida' using errcode = 'P0002';
  end if;

  -- Si ya es miembro (real), no duplicar: solo reactivar.
  update public.grupo_miembros
     set activo = true
   where grupo_id = v_inv.grupo_id and user_id = auth.uid();

  if not found then
    select coalesce(nombre, split_part(email, '@', 1)) into v_nombre
      from public.profiles where id = auth.uid();
    v_id := gen_random_uuid()::text;
    insert into public.grupo_miembros (id, grupo_id, user_id, nombre, rol, activo)
    values (v_id, v_inv.grupo_id, auth.uid(), coalesce(v_nombre, 'Miembro'), 'miembro', true);
  end if;

  update public.grupo_invitaciones set estado = 'aceptada' where id = v_inv.id;
  return v_inv.grupo_id;
end;
$$;

revoke all on function public.aceptar_invitacion(text) from public, anon;
grant execute on function public.aceptar_invitacion(text) to authenticated;

-- ============================================================================
-- Realtime
-- ============================================================================
-- Añadir las tablas compartidas a la publicación de Realtime para que los
-- cambios de un miembro lleguen en vivo a los demás. Se hace con guardas por
-- si la publicación no existe (instalación sin Realtime) o la tabla ya está.
do $$
declare
  t text;
begin
  if exists (select 1 from pg_publication where pubname = 'supabase_realtime') then
    foreach t in array array[
      'grupos','grupo_miembros','grupo_gastos','gasto_partes'
    ]
    loop
      if not exists (
        select 1 from pg_publication_tables
         where pubname = 'supabase_realtime'
           and schemaname = 'public' and tablename = t
      ) then
        execute format('alter publication supabase_realtime add table public.%I', t);
      end if;
      -- REPLICA IDENTITY FULL: sin esto un evento DELETE de Realtime solo trae
      -- la PK, y el cliente no sabría a qué grupo pertenecía la fila borrada
      -- (no podría filtrar por grupo_id). Con FULL, el "old record" viaja
      -- completo.
      execute format('alter table public.%I replica identity full', t);
    end loop;
  end if;
end $$;
