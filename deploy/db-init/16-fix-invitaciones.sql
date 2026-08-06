-- ============================================================================
-- Glint — Fix seguridad SEC-07 + SEC-12: códigos de invitación
-- ============================================================================
-- Antes el código de invitación lo generaba el CLIENTE con un PRNG no
-- criptográfico sembrado con microsecondsSinceEpoch → predecible; y podía
-- insertar `expira_en` nulo (invitación eterna). `aceptar_invitacion` lo canjea
-- como bearer, así que un código adivinable = acceso a datos de grupos ajenos.
--
-- Ahora:
--   - El código se genera EN EL SERVIDOR con gen_random_uuid (criptográfico).
--   - La expiración es obligatoria (por defecto 7 días).
--   - Se BLOQUEA la inserción/modificación directa de grupo_invitaciones vía
--     PostgREST; solo se crean por esta RPC (SECURITY DEFINER).
--
-- Idempotente. Depende de 06-grupos.sql.
-- ============================================================================

create or replace function public.crear_invitacion_grupo(
  p_grupo_id text,
  p_dias integer default 7
)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_codigo text;
  v_id     text;
  v_dias   integer := least(greatest(coalesce(p_dias, 7), 1), 30);
begin
  if not public.es_miembro_grupo(p_grupo_id) then
    raise exception 'No eres miembro de este grupo' using errcode = '42501';
  end if;

  -- 10 hex de un uuid criptográficamente aleatorio (~40 bits), único.
  loop
    v_codigo := upper(substr(replace(gen_random_uuid()::text, '-', ''), 1, 10));
    exit when not exists (select 1 from public.grupo_invitaciones where codigo = v_codigo);
  end loop;

  v_id := gen_random_uuid()::text;
  insert into public.grupo_invitaciones (id, grupo_id, codigo, invitado_por, estado, expira_en)
  values (v_id, p_grupo_id, v_codigo, auth.uid(), 'pendiente',
          now() + make_interval(days => v_dias));
  return v_codigo;
end;
$$;

revoke all on function public.crear_invitacion_grupo(text, integer) from public, anon;
grant execute on function public.crear_invitacion_grupo(text, integer) to authenticated;

-- Bloquear escritura directa de invitaciones vía PostgREST: solo lectura/borrado
-- para miembros; la creación pasa por la RPC de arriba (que corre como owner).
drop policy if exists "invitaciones: miembros" on public.grupo_invitaciones;
create policy "invitaciones: leer y borrar"
  on public.grupo_invitaciones for select to authenticated
  using (public.es_miembro_grupo(grupo_id));
create policy "invitaciones: borrar"
  on public.grupo_invitaciones for delete to authenticated
  using (public.es_miembro_grupo(grupo_id));
-- (sin políticas de INSERT/UPDATE → PostgREST no permite crear/modificar directo)
