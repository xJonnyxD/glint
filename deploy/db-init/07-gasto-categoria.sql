-- ============================================================================
-- Glint — Categoría (emoji) en los gastos compartidos
-- ============================================================================
-- Da variedad visual a los gastos de un grupo: cada uno lleva un emoji de
-- categoría (🍽️ comida, ⛽ gasolina, 🏠 alquiler…). Es solo presentación; no
-- afecta al reparto ni a los saldos.
--
-- Idempotente. Aplicar sobre una base ya existente:
--   docker exec -i glint-db psql -U postgres -d postgres < deploy/db-init/07-gasto-categoria.sql
--   docker exec glint-db psql -U postgres -d postgres -c "NOTIFY pgrst, 'reload schema';"
-- ============================================================================

alter table public.grupo_gastos
  add column if not exists categoria text not null default '🧾';
