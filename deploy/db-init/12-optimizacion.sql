-- ============================================================================
-- Glint — Optimización: índices para el sync incremental
-- ============================================================================
-- El cliente pasará a bajar solo las filas con `actualizado_en` más reciente
-- que su marca de agua. Un índice compuesto (usuario_id, actualizado_en) hace
-- esa consulta instantánea aunque el usuario tenga miles de filas.
--
-- Idempotente. Aplicar:
--   docker exec -i glint-db psql -U postgres -d postgres < deploy/db-init/12-optimizacion.sql
-- ============================================================================

do $$
declare t text;
begin
  foreach t in array array[
    'transactions','budgets','savings_goals','debts',
    'recurring_expenses','notes','events','routines'
  ]
  loop
    if to_regclass('public.' || t) is not null then
      execute format(
        'create index if not exists %I on public.%I (usuario_id, actualizado_en)',
        t || '_user_actualizado_idx', t);
    end if;
  end loop;
end $$;

-- Hábitos usan `user_id` / `actualizada_en`.
create index if not exists habits_user_actualizada_idx
  on public.habits (user_id, actualizada_en);

-- Grupos: los gastos se consultan por grupo y fecha (ya existe grupo_gastos
-- por (grupo_id, fecha)); reforzamos la de partes por gasto.
create index if not exists gasto_partes_gasto_idx
  on public.gasto_partes (gasto_id);

analyze;
