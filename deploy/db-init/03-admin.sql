-- ============================================================================
-- Glint — Perfiles, roles y presencia (para el panel de administración)
-- ============================================================================
-- Se ejecuta automáticamente en el primer arranque del contenedor `db`.
-- Sobre una base ya existente:
--   docker exec -i glint-db psql -U postgres -d postgres < deploy/db-init/03-admin.sql
--
-- Es idempotente.
--
-- Ojo con el orden: este script referencia auth.users, que crea GoTrue en su
-- primera migración. Por eso las partes que dependen de auth se envuelven en
-- comprobaciones y hay un backfill al final para las cuentas ya existentes.
-- ============================================================================

-- ── Perfiles ────────────────────────────────────────────────────────────────
-- Una fila por usuario. `es_admin` decide quién ve el panel; `ultima_actividad`
-- es lo que permite saber quién está en línea.
create table if not exists public.profiles (
  id               uuid primary key,
  email            text,
  nombre           text,
  es_admin         boolean     not null default false,
  creado_en        timestamptz not null default now(),
  ultima_actividad timestamptz,
  plataforma       text                 -- 'android', 'ios', 'web'
);

create index if not exists profiles_actividad_idx
  on public.profiles (ultima_actividad desc nulls last);
create index if not exists profiles_admin_idx
  on public.profiles (es_admin) where es_admin;

-- ── Alta automática de perfil al registrarse ────────────────────────────────
create or replace function public.crear_perfil_al_registrarse()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, nombre, creado_en)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data ->> 'nombre', split_part(new.email, '@', 1)),
    now()
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

do $$
begin
  if exists (select 1 from information_schema.tables
             where table_schema = 'auth' and table_name = 'users') then
    drop trigger if exists crear_perfil on auth.users;
    create trigger crear_perfil
      after insert on auth.users
      for each row execute function public.crear_perfil_al_registrarse();
  end if;
end $$;

-- ── ¿Quién es admin? ────────────────────────────────────────────────────────
-- SECURITY DEFINER para que la política de profiles pueda consultar la propia
-- tabla profiles sin entrar en recursión infinita de RLS.
create or replace function public.es_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(
    (select p.es_admin from public.profiles p where p.id = auth.uid()),
    false
  );
$$;

-- ── Latido de presencia ─────────────────────────────────────────────────────
-- La app la llama al abrirse y cada pocos minutos. Solo puede tocar la fila
-- del propio usuario: el id sale del JWT, no de un parámetro.
create or replace function public.registrar_actividad(p_plataforma text default null)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    return;
  end if;
  update public.profiles
     set ultima_actividad = now(),
         plataforma       = coalesce(p_plataforma, plataforma)
   where id = auth.uid();
end;
$$;

-- ── Resumen para el panel ───────────────────────────────────────────────────
-- "En línea" = actividad en los últimos 5 minutos.
create or replace view public.admin_resumen as
select
  (select count(*) from public.profiles)                                     as usuarios_total,
  (select count(*) from public.profiles
     where ultima_actividad > now() - interval '5 minutes')                   as en_linea,
  (select count(*) from public.profiles
     where ultima_actividad > now() - interval '1 day')                       as activos_hoy,
  (select count(*) from public.profiles
     where ultima_actividad > now() - interval '7 days')                      as activos_semana,
  (select count(*) from public.profiles
     where creado_en > now() - interval '7 days')                             as nuevos_semana,
  (select count(*) from public.habits)                                        as habitos_total,
  (select count(*) from public.habit_completions
     where fecha > current_date - 7)                                          as completaciones_semana;

-- Listado de usuarios con su estado. Es una vista aparte para poder darle
-- permisos distintos del resumen.
create or replace view public.admin_usuarios as
select
  p.id,
  p.email,
  p.nombre,
  p.es_admin,
  p.creado_en,
  p.ultima_actividad,
  p.plataforma,
  (p.ultima_actividad > now() - interval '5 minutes')      as en_linea,
  (select count(*) from public.habits h where h.user_id = p.id) as habitos
from public.profiles p
order by p.ultima_actividad desc nulls last, p.creado_en desc;

-- Altas por día de las últimas 4 semanas, para la gráfica del panel.
create or replace view public.admin_altas_por_dia as
select d::date as dia,
       (select count(*) from public.profiles p
         where p.creado_en::date = d::date) as altas
from generate_series(current_date - 27, current_date, interval '1 day') d
order by dia;

-- ── Permisos y RLS ──────────────────────────────────────────────────────────
grant usage on schema public to anon, authenticated, service_role;
grant all    on public.profiles to anon, authenticated, service_role;
grant select on public.admin_resumen, public.admin_usuarios,
                public.admin_altas_por_dia to authenticated, service_role;
grant execute on function public.registrar_actividad(text) to authenticated;
grant execute on function public.es_admin() to authenticated;

alter table public.profiles enable row level security;

-- Cada quien ve y edita su perfil; los admins ven todos.
drop policy if exists "profiles: leer el propio o ser admin" on public.profiles;
create policy "profiles: leer el propio o ser admin"
  on public.profiles for select to authenticated
  using (id = auth.uid() or public.es_admin());

drop policy if exists "profiles: editar el propio" on public.profiles;
create policy "profiles: editar el propio"
  on public.profiles for update to authenticated
  using (id = auth.uid()) with check (id = auth.uid());

drop policy if exists "profiles: admins editan a cualquiera" on public.profiles;
create policy "profiles: admins editan a cualquiera"
  on public.profiles for update to authenticated
  using (public.es_admin()) with check (public.es_admin());

-- Las vistas heredan los permisos del creador (postgres), así que sin este
-- filtro cualquier autenticado vería los datos de todos. `security_invoker`
-- las obliga a respetar el RLS de profiles de quien consulta.
alter view public.admin_resumen       set (security_invoker = true);
alter view public.admin_usuarios      set (security_invoker = true);
alter view public.admin_altas_por_dia set (security_invoker = true);

-- ── Backfill de cuentas anteriores a este script ────────────────────────────
do $$
begin
  if exists (select 1 from information_schema.tables
             where table_schema = 'auth' and table_name = 'users') then
    insert into public.profiles (id, email, nombre, creado_en)
    select u.id,
           u.email,
           coalesce(u.raw_user_meta_data ->> 'nombre', split_part(u.email, '@', 1)),
           u.created_at
      from auth.users u
    on conflict (id) do nothing;
  end if;
end $$;
