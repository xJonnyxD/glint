-- ============================================================================
-- Glint — Gestión de cuentas desde el panel de administración
-- ============================================================================
-- Añade lo necesario para ver el detalle de una cuenta, bloquearla, editarla y
-- eliminarla desde /admin/.
--
-- POR QUÉ TODO VA EN FUNCIONES `security definer` Y NO EN LA API DIRECTA:
-- estas operaciones tocan `auth.users`, que normalmente exige la clave
-- `service_role`. Esa clave NO puede vivir en el panel: es un HTML público y
-- cualquiera que lo abriera tendría control total de la base de datos. Con
-- funciones que comprueban `es_admin()` internamente, el secreto se queda en
-- el servidor y el panel sigue usando solo la clave anónima.
--
-- Idempotente. Aplicar:
--   docker exec -i glint-db psql -U postgres -d postgres < deploy/db-init/20-admin-cuentas.sql
--   docker exec glint-db psql -U postgres -d postgres -c "NOTIFY pgrst, 'reload schema';"
--
-- Depende de: 03-admin.sql (es_admin, profiles), 04-seguridad-roles.sql.
-- ============================================================================

-- ── Detalle de una cuenta ───────────────────────────────────────────────────
-- Reúne lo que hoy está repartido entre `profiles` y `auth.users`: cuándo entró
-- por última vez, si tiene el correo confirmado, si está bloqueada, y cuánto ha
-- creado en cada módulo.
create or replace function public.admin_detalle_usuario(p_id uuid)
returns table (
  id                 uuid,
  email              text,
  nombre             text,
  es_admin           boolean,
  creado_en          timestamptz,
  ultima_actividad   timestamptz,
  plataforma         text,
  xp                 integer,
  codigo_amigo       text,
  ultimo_acceso      timestamptz,
  email_confirmado   boolean,
  bloqueado_hasta    timestamptz,
  esta_bloqueado     boolean,
  total_habitos      bigint,
  total_transacciones bigint,
  total_notas        bigint,
  total_eventos      bigint,
  total_rutinas      bigint,
  total_grupos       bigint
)
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  if not public.es_admin() then
    raise exception 'Solo un administrador puede consultar cuentas'
      using errcode = '42501';
  end if;

  return query
  select p.id, p.email, p.nombre, p.es_admin, p.creado_en, p.ultima_actividad,
         p.plataforma, coalesce(p.xp, 0), p.codigo_amigo,
         u.last_sign_in_at,
         (u.email_confirmed_at is not null),
         u.banned_until,
         (u.banned_until is not null and u.banned_until > now()),
         (select count(*) from public.habits       h where h.user_id    = p.id),
         (select count(*) from public.transactions t where t.usuario_id = p.id),
         (select count(*) from public.notes        n where n.usuario_id = p.id),
         (select count(*) from public.events       e where e.usuario_id = p.id),
         (select count(*) from public.routines     r where r.usuario_id = p.id),
         (select count(*) from public.grupo_miembros g where g.user_id  = p.id)
    from public.profiles p
    left join auth.users u on u.id = p.id
   where p.id = p_id;
end;
$$;

-- ── Bloquear / desbloquear ──────────────────────────────────────────────────
-- Usa `banned_until` de GoTrue, que es lo que consulta al iniciar sesión.
--
-- OJO: un token ya emitido sigue siendo válido hasta que caduque (GOTRUE_JWT_EXP
-- = 1 hora). Bloquear impide entrar de nuevo, no expulsa al instante; por eso
-- además se borran sus sesiones activas, que es lo que corta el refresco.
create or replace function public.admin_bloquear_usuario(
  p_id uuid,
  p_bloquear boolean
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.es_admin() then
    raise exception 'Solo un administrador puede bloquear cuentas'
      using errcode = '42501';
  end if;

  -- Un admin que se bloquee a sí mismo se deja fuera y no puede deshacerlo.
  if p_id = auth.uid() then
    raise exception 'No puedes bloquear tu propia cuenta';
  end if;

  if p_bloquear then
    -- 100 años ≈ indefinido. Se desbloquea poniendo null, no esperando.
    update auth.users
       set banned_until = now() + interval '100 years'
     where id = p_id;
    -- Cortar las sesiones abiertas: si no, seguiría dentro hasta que caduque
    -- su token y podría refrescarlo indefinidamente.
    delete from auth.sessions where user_id = p_id;
  else
    update auth.users set banned_until = null where id = p_id;
  end if;

  if not found then
    raise exception 'No existe esa cuenta';
  end if;
end;
$$;

-- ── Editar los datos de una cuenta ──────────────────────────────────────────
-- Solo campos de presentación. El email NO se toca desde aquí: cambiarlo sin
-- verificación permitiría apropiarse de la identidad de otra persona (el correo
-- es lo que usa `buscar_perfil` para encontrarte). El propio usuario lo cambia
-- desde la app, con confirmación por correo.
create or replace function public.admin_actualizar_usuario(
  p_id uuid,
  p_nombre text default null,
  p_nombres text default null,
  p_apellidos text default null,
  p_telefono text default null,
  p_bio text default null
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.es_admin() then
    raise exception 'Solo un administrador puede editar cuentas'
      using errcode = '42501';
  end if;

  update public.profiles
     set nombre        = coalesce(nullif(trim(p_nombre), ''), nombre),
         nombres       = coalesce(nullif(trim(p_nombres), ''), nombres),
         apellidos     = coalesce(nullif(trim(p_apellidos), ''), apellidos),
         telefono      = coalesce(nullif(trim(p_telefono), ''), telefono),
         bio           = coalesce(nullif(trim(p_bio), ''), bio),
         -- Marca de tiempo nueva para que el cambio gane al bajar a los
         -- dispositivos del usuario (last-write-wins del sync).
         actualizado_en = now()
   where id = p_id;

  if not found then
    raise exception 'No existe esa cuenta';
  end if;
end;
$$;

-- ── Eliminar una cuenta ─────────────────────────────────────────────────────
-- Ninguna tabla de `public` tiene clave foránea hacia `auth.users`, así que
-- borrar el usuario de GoTrue dejaría todos sus datos huérfanos. Hay que
-- borrarlos a mano, y en orden.
--
-- Protecciones:
--   · exige repetir el email exacto (el panel lo pide por escrito),
--   · no puedes borrarte a ti mismo,
--   · no se puede borrar al último administrador,
--   · no se puede borrar a quien tenga saldos pendientes en un grupo, porque
--     eso descuadraría las cuentas de OTRAS personas.
--
-- Sobre los grupos: sus membresías NO se borran, se DESVINCULAN (`user_id` a
-- null). La app ya admite "miembros virtuales" (gente sin cuenta), así que la
-- persona queda como uno de ellos, con su nombre. Si se borrara la membresía,
-- la cascada de `grupo_gastos.pagado_por` se llevaría por delante los gastos
-- que pagó y descuadraría el histórico de los demás miembros.
create or replace function public.admin_eliminar_usuario(
  p_id uuid,
  p_email_confirmacion text
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_email text;
  v_es_admin boolean;
  v_admins_restantes int;
  v_saldo numeric;
begin
  if not public.es_admin() then
    raise exception 'Solo un administrador puede eliminar cuentas'
      using errcode = '42501';
  end if;

  if p_id = auth.uid() then
    raise exception 'No puedes eliminar tu propia cuenta desde el panel';
  end if;

  select email, es_admin into v_email, v_es_admin
    from public.profiles where id = p_id;

  if v_email is null then
    raise exception 'No existe esa cuenta';
  end if;

  -- Confirmación explícita: evita borrar la fila equivocada por un clic.
  if lower(trim(p_email_confirmacion)) is distinct from lower(v_email) then
    raise exception 'El correo de confirmación no coincide con la cuenta';
  end if;

  if v_es_admin then
    select count(*) into v_admins_restantes
      from public.profiles where es_admin and id <> p_id;
    if v_admins_restantes = 0 then
      raise exception 'No puedes eliminar al último administrador';
    end if;
  end if;

  -- Deudas compartidas. Ojo: `grupo_gastos.pagado_por` y `gasto_partes.
  -- miembro_id` apuntan a `grupo_miembros(id)`, NO al uuid del usuario, así que
  -- hay que pasar por sus membresías.
  --   saldo = lo que pagó − lo que le tocaba pagar
  select coalesce(
           (select sum(g.monto) from public.grupo_gastos g
             where g.pagado_por in (select id from public.grupo_miembros
                                     where user_id = p_id)), 0)
         - coalesce(
           (select sum(pa.monto) from public.gasto_partes pa
             where pa.miembro_id in (select id from public.grupo_miembros
                                      where user_id = p_id)), 0)
    into v_saldo;

  if abs(coalesce(v_saldo, 0)) > 0.01 then
    raise exception
      'Esta cuenta tiene saldos pendientes en grupos compartidos (%). '
      'Salda las deudas antes de eliminarla.', round(v_saldo::numeric, 2);
  end if;

  -- Datos personales.
  delete from public.habit_completions  where user_id    = p_id;
  delete from public.habits             where user_id    = p_id;
  delete from public.transactions       where usuario_id = p_id;
  delete from public.budgets            where usuario_id = p_id;
  delete from public.savings_goals      where usuario_id = p_id;
  delete from public.debts              where usuario_id = p_id;
  delete from public.recurring_expenses where usuario_id = p_id;
  delete from public.notes              where usuario_id = p_id;
  delete from public.events             where usuario_id = p_id;
  delete from public.routines           where usuario_id = p_id;
  delete from public.device_tokens      where user_id    = p_id;

  -- Capa social.
  delete from public.amistades
   where solicitante = p_id or destinatario = p_id;

  -- Grupos: desvincular, no borrar (ver la nota de la cabecera). El histórico
  -- de gastos del grupo se conserva intacto para los demás.
  update public.grupo_miembros
     set user_id = null, actualizado_en = now()
   where user_id = p_id;

  delete from public.profiles where id = p_id;
  -- Lo de GoTrue (sesiones, identidades…) sí cae en cascada.
  delete from auth.users where id = p_id;
end;
$$;

-- ── Permisos ────────────────────────────────────────────────────────────────
-- `authenticated` puede invocarlas, pero cada una comprueba `es_admin()` por
-- dentro: quien no lo sea recibe un 42501. `anon` no puede ni llamarlas.
revoke all on function public.admin_detalle_usuario(uuid)             from public, anon;
revoke all on function public.admin_bloquear_usuario(uuid, boolean)   from public, anon;
revoke all on function public.admin_actualizar_usuario(uuid, text, text, text, text, text) from public, anon;
revoke all on function public.admin_eliminar_usuario(uuid, text)      from public, anon;

grant execute on function public.admin_detalle_usuario(uuid)             to authenticated;
grant execute on function public.admin_bloquear_usuario(uuid, boolean)   to authenticated;
grant execute on function public.admin_actualizar_usuario(uuid, text, text, text, text, text) to authenticated;
grant execute on function public.admin_eliminar_usuario(uuid, text)      to authenticated;

-- ── Vista de usuarios: añadir el estado de bloqueo ──────────────────────────
-- La vista existente (03-admin.sql) no dice si una cuenta está bloqueada, que
-- es justo lo que hay que ver de un vistazo en la tabla del panel.
--
-- IMPORTANTE — por qué esta vista NO lleva `security_invoker = true` como las
-- otras: necesita leer `auth.users` (último acceso, confirmación, bloqueo) y el
-- rol `authenticated` no tiene permiso sobre esa tabla; con security_invoker
-- daría "permission denied for table users" y el panel dejaría de funcionar.
-- Se ejecuta entonces con los permisos del propietario, y el filtro de acceso
-- se hace explícito con el `where public.es_admin()` del final: quien no sea
-- administrador obtiene cero filas. Mismo efecto que el RLS que se buscaba en
-- 03-admin.sql:167-172, pero dicho en voz alta.
drop view if exists public.admin_usuarios;
create view public.admin_usuarios as
  select p.id,
         p.email,
         p.nombre,
         p.es_admin,
         p.creado_en,
         p.ultima_actividad,
         p.plataforma,
         coalesce(p.xp, 0) as xp,
         u.last_sign_in_at as ultimo_acceso,
         (u.email_confirmed_at is not null) as email_confirmado,
         (u.banned_until is not null and u.banned_until > now()) as bloqueado,
         -- "En línea" = actividad en los últimos 5 minutos, que es el ritmo al
         -- que la app manda su latido (presence_service, cada 2 min).
         (p.ultima_actividad is not null
          and p.ultima_actividad > now() - interval '5 minutes') as en_linea,
         (select count(*) from public.habits h where h.user_id = p.id) as habitos,
         (select count(*) from public.grupo_miembros g where g.user_id = p.id) as grupos
    from public.profiles p
    left join auth.users u on u.id = p.id
   -- El control de acceso de la vista. Sin esto, al no llevar security_invoker,
   -- cualquier autenticado vería a todos los usuarios.
   where public.es_admin()
   order by p.ultima_actividad desc nulls last, p.creado_en desc;

grant select on public.admin_usuarios to authenticated;

notify pgrst, 'reload schema';
