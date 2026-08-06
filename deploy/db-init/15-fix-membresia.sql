-- ============================================================================
-- Glint — Fix seguridad SEC-14: membresía forzada de grupos
-- ============================================================================
-- Antes, la política INSERT de grupo_miembros permitía a cualquier miembro
-- insertar una fila con CUALQUIER user_id → podías meter a un extraño en un
-- grupo sin su consentimiento (ve tus gastos, spam, acoso).
--
-- Ahora un miembro solo puede insertar:
--   - un miembro VIRTUAL (user_id null), o
--   - a sí mismo (user_id = auth.uid()), o
--   - a un AMIGO aceptado suyo.
-- Los extraños se unen por código de invitación (aceptar_invitacion), no
-- siendo añadidos por otros.
--
-- Idempotente. Depende de 06-grupos.sql y 08-amigos.sql.
-- ============================================================================

-- ¿p_otro es amigo aceptado del que llama? (SECURITY DEFINER para no recursar RLS)
create or replace function public.es_amigo(p_otro uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.amistades a
     where a.estado = 'aceptada'
       and ((a.solicitante = auth.uid() and a.destinatario = p_otro)
         or (a.solicitante = p_otro     and a.destinatario = auth.uid()))
  );
$$;

drop policy if exists "miembros: agregar" on public.grupo_miembros;
create policy "miembros: agregar"
  on public.grupo_miembros for insert to authenticated
  with check (
    (public.es_miembro_grupo(grupo_id) or public.es_creador_grupo(grupo_id))
    and (
      user_id is null                 -- miembro virtual
      or user_id = auth.uid()         -- yo mismo (creador / al aceptar)
      or public.es_amigo(user_id)     -- un amigo aceptado
    )
  );
