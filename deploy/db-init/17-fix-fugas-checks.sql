-- ============================================================================
-- Glint — Fix seguridad SEC-21 (fuga de email) + SEC-11 (validación de montos)
-- ============================================================================
-- SEC-21: ranking_amigos devolvía el email de todos los amigos, pero el
--   leaderboard solo necesita nombre + XP. Se quita el email.
-- SEC-11 (parcial): grupo_gastos/gasto_partes no tenían ninguna validación de
--   monto → se añade CHECK (monto >= 0). La validación de "las partes suman el
--   total" y "los miembros pertenecen al grupo" requiere una RPC transaccional
--   (cambia el contrato del cliente) y queda como tarea aparte a coordinar.
--
-- Idempotente. Aplicar:
--   docker exec -i glint-db psql -U postgres -d postgres < deploy/db-init/17-fix-fugas-checks.sql
-- ============================================================================

-- ── SEC-21: ranking sin email ────────────────────────────────────────────────
-- DROP necesario: cambia el tipo de retorno (se quita la columna email).
drop function if exists public.ranking_amigos();
create or replace function public.ranking_amigos()
returns table (id uuid, nombre text, xp integer, es_yo boolean)
language sql
stable
security definer
set search_path = public
as $$
  select p.id, p.nombre, coalesce(p.xp, 0) as xp, (p.id = auth.uid()) as es_yo
    from public.profiles p
   where p.id = auth.uid()
      or p.id in (
        select case when a.solicitante = auth.uid()
                    then a.destinatario else a.solicitante end
          from public.amistades a
         where (a.solicitante = auth.uid() or a.destinatario = auth.uid())
           and a.estado = 'aceptada'
      )
   order by coalesce(p.xp, 0) desc, p.nombre;
$$;

-- El DROP borró el grant; se vuelve a conceder.
revoke all on function public.ranking_amigos() from public, anon;
grant execute on function public.ranking_amigos() to authenticated;

-- ── SEC-11: montos no negativos en gastos compartidos ────────────────────────
do $$
begin
  if not exists (select 1 from pg_constraint where conname = 'grupo_gastos_monto_no_neg') then
    alter table public.grupo_gastos add constraint grupo_gastos_monto_no_neg check (monto >= 0);
  end if;
  if not exists (select 1 from pg_constraint where conname = 'gasto_partes_monto_no_neg') then
    alter table public.gasto_partes add constraint gasto_partes_monto_no_neg check (monto >= 0);
  end if;
end $$;
