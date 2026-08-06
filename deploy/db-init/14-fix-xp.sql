-- ============================================================================
-- Glint — Fix seguridad SEC-09: XP no falseable desde el cliente
-- ============================================================================
-- Antes, `actualizar_xp(p_xp)` fijaba `profiles.xp` a CUALQUIER valor que
-- mandara el cliente → un usuario podía poner 999999999 y falsear el ranking.
-- Ahora solo se aceptan INCREMENTOS y se acota el salto por llamada (un cliente
-- honesto solo sube el XP en pasos pequeños; un salto absurdo se recorta).
--
-- Mitigación, no solución total: para eliminarlo por completo el XP debería
-- derivarse en el servidor de hechos reales (completar hábito, etc.). Eso queda
-- como deuda técnica; esto sube el listón de "1 request" a "miles con rate-limit".
--
-- Idempotente. Aplicar:
--   docker exec -i glint-db psql -U postgres -d postgres < deploy/db-init/14-fix-xp.sql
-- ============================================================================

create or replace function public.actualizar_xp(p_xp integer)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_actual integer;
begin
  if auth.uid() is null then return; end if;
  select coalesce(xp, 0) into v_actual from public.profiles where id = auth.uid();
  -- Solo hacia arriba, y como máximo +2000 XP por llamada (muy holgado para uso
  -- legítimo: cada acción da 5-25 XP). Un valor menor o igual, o nulo, se ignora.
  if p_xp is null or p_xp <= v_actual then return; end if;
  update public.profiles
     set xp = least(p_xp, v_actual + 2000)
   where id = auth.uid();
end;
$$;
