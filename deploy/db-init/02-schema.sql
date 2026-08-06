-- ============================================================================
-- Glint — Esquema de la base de datos (PostgreSQL + PostgREST + GoTrue)
-- ============================================================================
-- Se ejecuta automáticamente en el primer arranque del contenedor `db`.
-- Para aplicarlo a mano sobre una base ya existente:
--   docker exec -i glint-db psql -U postgres -d postgres < deploy/db-init/02-schema.sql
--
-- Es idempotente: se puede volver a ejecutar sin romper nada.
--
-- Nota: no hay clave foránea contra auth.users porque este script corre antes
-- de que GoTrue cree ese schema. Lo que garantiza que cada usuario solo vea
-- lo suyo son las políticas RLS de más abajo.
-- ============================================================================

-- ── Hábitos ─────────────────────────────────────────────────────────────────
create table if not exists public.habits (
  id                text primary key,
  user_id           uuid not null,
  nombre            text not null,
  icono             text not null default '⭐',
  categoria         smallint not null default 0,
  frecuencia        smallint not null default 0,
  meta_semanal      smallint not null default 7,
  racha_actual      integer not null default 0,
  racha_maxima      integer not null default 0,
  total_completados integer not null default 0,
  color             text not null default '#1E88E5',
  creada_en         timestamptz not null default now(),
  actualizada_en    timestamptz not null default now()
);

-- Los hábitos se consultan siempre filtrando por usuario y ordenando por fecha
create index if not exists habits_user_creada_idx
  on public.habits (user_id, creada_en desc);

-- ── Completaciones de hábitos ───────────────────────────────────────────────
-- Fuente de verdad de las rachas: cada fila = un hábito completado un día.
create table if not exists public.habit_completions (
  id       text primary key,
  habit_id text not null references public.habits(id) on delete cascade,
  user_id  uuid not null,
  fecha    date not null,
  -- Un hábito solo puede completarse una vez por día
  unique (habit_id, fecha)
);

create index if not exists habit_completions_user_fecha_idx
  on public.habit_completions (user_id, fecha desc);

-- ── Permisos para PostgREST ─────────────────────────────────────────────────
-- Sin estos GRANT la API responde "permission denied" aunque el JWT sea
-- válido. El acceso real lo sigue restringiendo RLS, tabla por tabla.
grant usage on schema public to anon, authenticated, service_role;
grant all on public.habits            to anon, authenticated, service_role;
grant all on public.habit_completions to anon, authenticated, service_role;

alter default privileges in schema public
  grant all on tables to anon, authenticated, service_role;

-- ── Row Level Security ──────────────────────────────────────────────────────
-- Sin esto, cualquier usuario autenticado podría leer los datos de los demás.
alter table public.habits            enable row level security;
alter table public.habit_completions enable row level security;

drop policy if exists "habits: solo los propios" on public.habits;
create policy "habits: solo los propios"
  on public.habits
  for all
  to authenticated
  using      (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "habit_completions: solo las propias" on public.habit_completions;
create policy "habit_completions: solo las propias"
  on public.habit_completions
  for all
  to authenticated
  using      (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- ── Mantener actualizada_en al día ──────────────────────────────────────────
create or replace function public.tocar_actualizada_en()
returns trigger
language plpgsql
as $$
begin
  new.actualizada_en = now();
  return new;
end;
$$;

drop trigger if exists habits_actualizada_en on public.habits;
create trigger habits_actualizada_en
  before update on public.habits
  for each row execute function public.tocar_actualizada_en();
