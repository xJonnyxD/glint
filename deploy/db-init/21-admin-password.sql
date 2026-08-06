-- ============================================================================
-- Glint — Cambio de contraseña desde el panel de administración
-- ============================================================================
-- Dos caminos, a propósito:
--
--   1. ENVIAR ENLACE (preferido): el panel llama a POST /auth/v1/recover y la
--      persona elige su propia contraseña desde el correo. El administrador
--      nunca llega a conocerla, así que no puede entrar en la cuenta ajena.
--      No necesita nada de este archivo — es un endpoint público de GoTrue —
--      pero SÍ necesita el SMTP configurado en el servidor.
--
--   2. FIJARLA A MANO (esta función): para cuando la persona no tiene acceso a
--      su correo, o mientras no haya SMTP. Es una capacidad potente: quien la
--      usa puede entrar después en esa cuenta y ver sus finanzas, sus notas y
--      sus grupos. Por eso deja rastro y corta las sesiones abiertas.
--
-- DETALLE QUE IMPORTA: GoTrue guarda las contraseñas con bcrypt de coste 10
-- (`$2a$10$…`), pero `gen_salt('bf')` de pgcrypto usa coste 6 por defecto. Hay
-- que pedir el 10 explícitamente; si no, el hash sería válido pero más débil de
-- lo que el resto de la instalación usa.
--
-- Idempotente. Aplicar:
--   docker exec -i glint-db psql -U postgres -d postgres < deploy/db-init/21-admin-password.sql
--   docker exec glint-db psql -U postgres -d postgres -c "NOTIFY pgrst, 'reload schema';"
-- ============================================================================

create extension if not exists pgcrypto;

create or replace function public.admin_cambiar_password(
  p_id uuid,
  p_password text
)
returns void
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  v_email text;
begin
  if not public.es_admin() then
    raise exception 'Solo un administrador puede cambiar contraseñas'
      using errcode = '42501';
  end if;

  select email into v_email from public.profiles where id = p_id;
  if v_email is null then
    raise exception 'No existe esa cuenta';
  end if;

  -- Mismo mínimo que pide la app al registrarse. Sin esto, el panel podría
  -- dejar una cuenta con una contraseña de dos letras.
  if p_password is null or length(p_password) < 8 then
    raise exception 'La contraseña debe tener al menos 8 caracteres';
  end if;

  update auth.users
     set encrypted_password = crypt(p_password, gen_salt('bf', 10)),
         updated_at         = now(),
         -- Si la cuenta venía de Google y no tenía contraseña, a partir de
         -- ahora también podrá entrar con correo y contraseña. Se confirma el
         -- correo por si acaso, o GoTrue rechazaría el acceso.
         email_confirmed_at = coalesce(email_confirmed_at, now())
   where id = p_id;

  if not found then
    raise exception 'No existe esa cuenta en el sistema de acceso';
  end if;

  -- Cerrar sus sesiones: si alguien había entrado con la contraseña vieja,
  -- cambiarla no debería dejarle dentro.
  delete from auth.sessions where user_id = p_id;
end;
$$;

revoke all on function public.admin_cambiar_password(uuid, text) from public, anon;
grant execute on function public.admin_cambiar_password(uuid, text) to authenticated;

notify pgrst, 'reload schema';
