-- ============================================================================
-- Glint — Tablas remotas para el sync de finanzas, notas, agenda y rutinas
-- ============================================================================
-- Cada tabla espeja EXACTAMENTE los nombres de columna de la tabla local de
-- Drift (snake_case), para que el motor de sync copie el JSON sin traducir
-- nombres. `usuario_id` es el uuid del dueño; lo que aísla los datos es RLS.
--
-- No hay trigger que toque `actualizado_en` en el servidor a propósito: esa
-- marca la pone el cliente y es la que decide el conflicto (última escritura
-- gana). Si el servidor la sobrescribiera, rompería esa comparación.
--
-- Idempotente. Aplicar:
--   docker exec -i glint-db psql -U postgres -d postgres < deploy/db-init/05-sync-tables.sql
-- ============================================================================

-- ── Transacciones ───────────────────────────────────────────────────────────
create table if not exists public.transactions (
  id              text primary key,
  tipo            text not null,
  monto           double precision not null,
  descripcion     text not null default '',
  categoria       text not null default '',
  categoria_emoji text not null default '',
  fecha           timestamptz not null,
  notas           text,
  imagen_path     text,
  usuario_id      uuid not null,
  creada_en       timestamptz not null default now(),
  actualizado_en  timestamptz not null default now()
);

-- ── Presupuestos ────────────────────────────────────────────────────────────
create table if not exists public.budgets (
  id             text primary key,
  categoria      text not null,
  limite         double precision not null,
  mes            integer not null,
  anio           integer not null,
  usuario_id     uuid not null,
  creado_en      timestamptz not null default now(),
  actualizado_en timestamptz not null default now()
);

-- ── Metas de ahorro ─────────────────────────────────────────────────────────
create table if not exists public.savings_goals (
  id             text primary key,
  nombre         text not null,
  emoji          text not null default '🎯',
  monto_meta     double precision not null,
  monto_actual   double precision not null default 0,
  fecha_meta     timestamptz,
  color          text not null default '#1E88E5',
  usuario_id     uuid not null,
  creado_en      timestamptz not null default now(),
  actualizado_en timestamptz not null default now()
);

-- ── Deudas ──────────────────────────────────────────────────────────────────
create table if not exists public.debts (
  id             text primary key,
  nombre         text not null,
  concepto       text not null default '',
  monto          double precision not null,
  tipo           integer not null,
  pagado         boolean not null default false,
  fecha          timestamptz not null,
  usuario_id     uuid not null,
  creado_en      timestamptz not null default now(),
  actualizado_en timestamptz not null default now()
);

-- ── Gastos recurrentes ──────────────────────────────────────────────────────
create table if not exists public.recurring_expenses (
  id              text primary key,
  nombre          text not null,
  categoria       text not null,
  categoria_emoji text not null default '📦',
  monto           double precision not null,
  frecuencia      integer not null default 2,
  dia_del_mes     integer not null default 1,
  activo          boolean not null default true,
  usuario_id      uuid not null,
  creado_en       timestamptz not null default now(),
  actualizado_en  timestamptz not null default now()
);

-- ── Notas ───────────────────────────────────────────────────────────────────
create table if not exists public.notes (
  id             text primary key,
  titulo         text not null default '',
  contenido      text not null default '',
  categoria      integer not null default 0,
  color          text not null default '#FFF9C4',
  es_fijada      boolean not null default false,
  es_checklist   boolean not null default false,
  items_json     text not null default '[]',
  usuario_id     uuid not null,
  creada_en      timestamptz not null default now(),
  actualizada_en timestamptz not null default now(),
  tags           text not null default '',
  actualizado_en timestamptz not null default now()
);

-- ── Eventos / agenda ────────────────────────────────────────────────────────
create table if not exists public.events (
  id             text primary key,
  titulo         text not null,
  descripcion    text,
  fecha          timestamptz not null,
  hora           text,
  todo_el_dia    boolean not null default false,
  completado     boolean not null default false,
  color          text not null default '#6750A4',
  tipo           text not null default 'evento',
  usuario_id     uuid not null,
  creado_en      timestamptz not null default now(),
  actualizado_en timestamptz not null default now()
);

-- ── Rutinas ─────────────────────────────────────────────────────────────────
create table if not exists public.routines (
  id             text primary key,
  nombre         text not null,
  icono          text not null default 'default',
  periodo        integer not null,
  hora           text not null default '07:00',
  completada_hoy boolean not null default false,
  racha_actual   integer not null default 0,
  orden          integer not null default 0,
  usuario_id     uuid not null,
  creada_en      timestamptz not null default now(),
  actualizado_en timestamptz not null default now()
);

-- ── Índices por usuario ─────────────────────────────────────────────────────
create index if not exists transactions_user_idx       on public.transactions (usuario_id);
create index if not exists budgets_user_idx            on public.budgets (usuario_id);
create index if not exists savings_goals_user_idx      on public.savings_goals (usuario_id);
create index if not exists debts_user_idx              on public.debts (usuario_id);
create index if not exists recurring_expenses_user_idx on public.recurring_expenses (usuario_id);
create index if not exists notes_user_idx              on public.notes (usuario_id);
create index if not exists events_user_idx             on public.events (usuario_id);
create index if not exists routines_user_idx           on public.routines (usuario_id);

-- ── Permisos + RLS (una política por tabla: solo tus propias filas) ─────────
do $$
declare
  t text;
begin
  foreach t in array array[
    'transactions','budgets','savings_goals','debts',
    'recurring_expenses','notes','events','routines'
  ]
  loop
    execute format('grant all on public.%I to anon, authenticated, service_role', t);
    execute format('alter table public.%I enable row level security', t);
    execute format('drop policy if exists "solo lo propio" on public.%I', t);
    execute format(
      'create policy "solo lo propio" on public.%I for all to authenticated '
      'using (auth.uid() = usuario_id) with check (auth.uid() = usuario_id)', t);
  end loop;
end $$;
