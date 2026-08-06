-- ============================================================================
-- Glint — Amigos (capa social para gastos compartidos)
-- ============================================================================
-- Permite enviar solicitudes de amistad, aceptarlas y tener una lista de
-- amigos para añadirlos rápido a un grupo. La escritura pasa por funciones
-- SECURITY DEFINER (como el resto), y la lectura de perfiles ajenos también,
-- para no abrir la tabla profiles.
--
-- Idempotente. Depende de 03-admin.sql (profiles). Aplicar:
--   docker exec -i glint-db psql -U postgres -d postgres < deploy/db-init/08-amigos.sql
--   docker exec glint-db psql -U postgres -d postgres -c "NOTIFY pgrst, 'reload schema';"
-- ============================================================================

create table if not exists public.amistades (
  id           text primary key,
  solicitante  uuid not null,
  destinatario uuid not null,
  estado       text not null default 'pendiente', -- 'pendiente' | 'aceptada'
  creado_en    timestamptz not null default now()
);

create unique index if not exists amistades_par_idx
  on public.amistades (solicitante, destinatario);
create index if not exists amistades_dest_idx on public.amistades (destinatario);
create index if not exists amistades_soli_idx on public.amistades (solicitante);

grant all on public.amistades to anon, authenticated, service_role;
alter table public.amistades enable row level security;

-- Cada quien ve sus propias relaciones; la escritura va por RPC.
drop policy if exists "amistades: ver propias" on public.amistades;
create policy "amistades: ver propias"
  on public.amistades for select to authenticated
  using (solicitante = auth.uid() or destinatario = auth.uid());

-- ── Enviar solicitud (o aceptar la del otro si ya te la había enviado) ───────
create or replace function public.solicitar_amistad(p_destinatario uuid)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id  text;
  v_row public.amistades%rowtype;
begin
  if auth.uid() is null or p_destinatario = auth.uid() then
    raise exception 'Destinatario inválido' using errcode = '22023';
  end if;

  select * into v_row from public.amistades
   where (solicitante = auth.uid() and destinatario = p_destinatario)
      or (solicitante = p_destinatario and destinatario = auth.uid())
   limit 1;

  if found then
    -- Si el otro me la envió y sigue pendiente, la acepto de una vez.
    if v_row.destinatario = auth.uid() and v_row.estado = 'pendiente' then
      update public.amistades set estado = 'aceptada' where id = v_row.id;
    end if;
    return v_row.id;
  end if;

  v_id := gen_random_uuid()::text;
  insert into public.amistades (id, solicitante, destinatario, estado)
  values (v_id, auth.uid(), p_destinatario, 'pendiente');
  return v_id;
end;
$$;

-- ── Responder una solicitud recibida (aceptar o rechazar/eliminar) ───────────
create or replace function public.responder_amistad(p_id text, p_aceptar boolean)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if p_aceptar then
    update public.amistades set estado = 'aceptada'
     where id = p_id and destinatario = auth.uid() and estado = 'pendiente';
  else
    delete from public.amistades
     where id = p_id and (destinatario = auth.uid() or solicitante = auth.uid());
  end if;
end;
$$;

-- ── Eliminar a un amigo ──────────────────────────────────────────────────────
create or replace function public.eliminar_amigo(p_amigo uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  delete from public.amistades
   where (solicitante = auth.uid() and destinatario = p_amigo)
      or (solicitante = p_amigo and destinatario = auth.uid());
end;
$$;

-- ── Lista de amigos aceptados (con su perfil) ────────────────────────────────
create or replace function public.mis_amigos()
returns table (id uuid, nombre text, email text, codigo_amigo text, avatar_url text)
language sql
stable
security definer
set search_path = public
as $$
  select p.id, p.nombre, p.email, p.codigo_amigo, p.avatar_url
    from public.amistades a
    join public.profiles p
      on p.id = case when a.solicitante = auth.uid()
                     then a.destinatario else a.solicitante end
   where (a.solicitante = auth.uid() or a.destinatario = auth.uid())
     and a.estado = 'aceptada'
   order by p.nombre;
$$;

-- ── Solicitudes recibidas pendientes (con perfil del solicitante) ────────────
create or replace function public.solicitudes_amistad()
returns table (id text, solicitante uuid, nombre text, email text,
               codigo_amigo text, avatar_url text)
language sql
stable
security definer
set search_path = public
as $$
  select a.id, a.solicitante, p.nombre, p.email, p.codigo_amigo, p.avatar_url
    from public.amistades a
    join public.profiles p on p.id = a.solicitante
   where a.destinatario = auth.uid() and a.estado = 'pendiente'
   order by a.creado_en desc;
$$;

do $$
declare f text;
begin
  foreach f in array array[
    'solicitar_amistad(uuid)', 'responder_amistad(text, boolean)',
    'eliminar_amigo(uuid)', 'mis_amigos()', 'solicitudes_amistad()'
  ]
  loop
    execute format('revoke all on function public.%s from public, anon', f);
    execute format('grant execute on function public.%s to authenticated', f);
  end loop;
end $$;
