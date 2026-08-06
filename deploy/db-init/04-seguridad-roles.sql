-- ============================================================================
-- Glint — Cierre de la escalada de privilegios en profiles
-- ============================================================================
-- La política "editar el propio perfil" permitía al usuario cambiar CUALQUIER
-- columna de su fila, incluida `es_admin`. Es decir: cualquiera podía hacerse
-- administrador con un PATCH a su propio perfil. Verificado con:
--
--   set local role authenticated;
--   set local request.jwt.claims = '{"sub":"<id>","role":"authenticated"}';
--   update public.profiles set es_admin = true where id = auth.uid();  -- UPDATE 1
--
-- RLS controla QUÉ FILAS se tocan, no QUÉ COLUMNAS. Para lo segundo hacen
-- falta permisos por columna, que es lo que hace este script.
--
-- Idempotente.
-- ============================================================================

-- ── Permisos por columna ────────────────────────────────────────────────────
-- Se retira el UPDATE global y se concede solo sobre los campos que el propio
-- usuario tiene derecho a cambiar. `es_admin`, `email`, `id` y `creado_en`
-- quedan fuera de su alcance.
revoke update on public.profiles from anon, authenticated;
grant  update (nombre, plataforma) on public.profiles to authenticated;

-- `ultima_actividad` la escribe registrar_actividad(), que es SECURITY DEFINER
-- y por tanto no necesita este permiso.

-- La política de "admins editan a cualquiera" ya no puede funcionar por sí
-- sola (admins y usuarios comparten el rol `authenticated`, así que el permiso
-- por columna les afecta igual). Los cambios de rol pasan por la función de
-- abajo, que sí comprueba quién llama.
drop policy if exists "profiles: admins editan a cualquiera" on public.profiles;

-- ── Cambiar el rol de alguien ───────────────────────────────────────────────
-- SECURITY DEFINER para poder escribir en es_admin, pero comprueba primero que
-- quien llama sea administrador. Sin esa comprobación, sería la misma puerta
-- abierta con otro nombre.
create or replace function public.definir_admin(p_email text, p_es_admin boolean)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_afectadas int;
begin
  if not public.es_admin() then
    raise exception 'Solo un administrador puede cambiar roles'
      using errcode = '42501';
  end if;

  -- Evita que el último administrador se quite el rol a sí mismo y deje la
  -- instalación sin nadie que pueda administrarla.
  if p_es_admin = false then
    if (select count(*) from public.profiles where es_admin) <= 1 then
      raise exception 'No puedes quitar el último administrador'
        using errcode = '42501';
    end if;
  end if;

  update public.profiles set es_admin = p_es_admin where email = p_email;
  get diagnostics v_afectadas = row_count;
  if v_afectadas = 0 then
    raise exception 'No existe ningún usuario con ese correo'
      using errcode = 'P0002';
  end if;
end;
$$;

revoke all on function public.definir_admin(text, boolean) from public, anon;
grant execute on function public.definir_admin(text, boolean) to authenticated;

-- ── Las vistas de admin no deben ser escribibles ────────────────────────────
revoke insert, update, delete on public.admin_usuarios      from anon, authenticated;
revoke insert, update, delete on public.admin_resumen       from anon, authenticated;
revoke insert, update, delete on public.admin_altas_por_dia from anon, authenticated;

-- ── anon no pinta nada aquí ─────────────────────────────────────────────────
-- Sin sesión iniciada no hay perfil que consultar; dejarle SELECT solo abre
-- superficie de ataque.
revoke all on public.profiles from anon;
