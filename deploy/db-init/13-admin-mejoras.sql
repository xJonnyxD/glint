-- ============================================================================
-- Glint — Panel de administración: métricas globales correctas
-- ============================================================================
-- Las vistas admin_* usan security_invoker, así que sus "totales" en realidad
-- solo cuentan lo que el admin puede ver por RLS (sus propias filas). Estas
-- funciones van SECURITY DEFINER (saltan RLS) pero comprueban es_admin()
-- primero, así que devuelven conteos GLOBALES reales solo a administradores.
--
-- Idempotente. Depende de 03-admin.sql (es_admin) y del resto de tablas.
-- Aplicar:
--   docker exec -i glint-db psql -U postgres -d postgres < deploy/db-init/13-admin-mejoras.sql
--   docker exec glint-db psql -U postgres -d postgres -c "NOTIFY pgrst, 'reload schema';"
-- ============================================================================

-- ── Métricas globales de toda la app ─────────────────────────────────────────
create or replace function public.admin_metricas()
returns table (
  usuarios_total        bigint,
  en_linea              bigint,
  activos_hoy           bigint,
  activos_semana        bigint,
  nuevos_semana         bigint,
  habitos_total         bigint,
  completaciones_semana bigint,
  grupos_total          bigint,
  gastos_compartidos    bigint,
  transacciones_total   bigint,
  notas_total           bigint,
  eventos_total         bigint,
  rutinas_total         bigint,
  xp_total              bigint
)
language sql
stable
security definer
set search_path = public
as $$
  select
    (select count(*) from public.profiles),
    (select count(*) from public.profiles where ultima_actividad > now() - interval '5 minutes'),
    (select count(*) from public.profiles where ultima_actividad > now() - interval '1 day'),
    (select count(*) from public.profiles where ultima_actividad > now() - interval '7 days'),
    (select count(*) from public.profiles where creado_en > now() - interval '7 days'),
    (select count(*) from public.habits),
    (select count(*) from public.habit_completions where fecha > current_date - 7),
    (select count(*) from public.grupos),
    (select count(*) from public.grupo_gastos),
    (select count(*) from public.transactions),
    (select count(*) from public.notes),
    (select count(*) from public.events),
    (select count(*) from public.routines),
    (select coalesce(sum(xp), 0) from public.profiles)
  where public.es_admin();
$$;

-- ── Lista de usuarios con conteos reales por usuario ─────────────────────────
create or replace function public.admin_lista_usuarios()
returns table (
  id               uuid,
  email            text,
  nombre           text,
  es_admin         boolean,
  plataforma       text,
  xp               integer,
  creado_en        timestamptz,
  ultima_actividad timestamptz,
  en_linea         boolean,
  habitos          bigint,
  grupos           bigint
)
language sql
stable
security definer
set search_path = public
as $$
  select
    p.id, p.email, p.nombre, p.es_admin, p.plataforma, coalesce(p.xp, 0),
    p.creado_en, p.ultima_actividad,
    (p.ultima_actividad > now() - interval '5 minutes'),
    (select count(*) from public.habits h where h.user_id = p.id),
    (select count(*) from public.grupo_miembros m where m.user_id = p.id and m.activo)
  from public.profiles p
  where public.es_admin()
  order by p.ultima_actividad desc nulls last, p.creado_en desc;
$$;

-- ── Ranking global por XP ────────────────────────────────────────────────────
create or replace function public.admin_top_xp(p_limite integer default 10)
returns table (nombre text, email text, xp integer)
language sql
stable
security definer
set search_path = public
as $$
  select p.nombre, p.email, coalesce(p.xp, 0) as xp
    from public.profiles p
   where public.es_admin()
   order by coalesce(p.xp, 0) desc, p.nombre
   limit greatest(coalesce(p_limite, 10), 1);
$$;

do $$
declare f text;
begin
  foreach f in array array[
    'admin_metricas()', 'admin_lista_usuarios()', 'admin_top_xp(integer)'
  ]
  loop
    execute format('revoke all on function public.%s from public, anon', f);
    execute format('grant execute on function public.%s to authenticated', f);
  end loop;
end $$;
