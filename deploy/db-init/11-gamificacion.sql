-- ============================================================================
-- Glint — Gamificación: XP en el servidor y ranking entre amigos
-- ============================================================================
-- Guarda el XP total del usuario en profiles (para poder compararlo entre
-- amigos) y expone un ranking. La escritura de XP va por RPC porque el UPDATE
-- directo a profiles está restringido por columnas (ver 04-seguridad-roles.sql).
--
-- Idempotente. Depende de 03-admin.sql (profiles) y 08-amigos.sql (amistades).
-- Aplicar:
--   docker exec -i glint-db psql -U postgres -d postgres < deploy/db-init/11-gamificacion.sql
--   docker exec glint-db psql -U postgres -d postgres -c "NOTIFY pgrst, 'reload schema';"
-- ============================================================================

alter table public.profiles add column if not exists xp integer not null default 0;

-- ── Guardar el XP propio ─────────────────────────────────────────────────────
create or replace function public.actualizar_xp(p_xp integer)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then return; end if;
  update public.profiles set xp = greatest(coalesce(p_xp, 0), 0) where id = auth.uid();
end;
$$;

-- ── Ranking: yo + mis amigos aceptados, ordenados por XP ─────────────────────
create or replace function public.ranking_amigos()
returns table (id uuid, nombre text, email text, xp integer, es_yo boolean)
language sql
stable
security definer
set search_path = public
as $$
  select p.id, p.nombre, p.email, coalesce(p.xp, 0) as xp, (p.id = auth.uid()) as es_yo
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

do $$
declare f text;
begin
  foreach f in array array['actualizar_xp(integer)', 'ranking_amigos()']
  loop
    execute format('revoke all on function public.%s from public, anon', f);
    execute format('grant execute on function public.%s to authenticated', f);
  end loop;
end $$;
