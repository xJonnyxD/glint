-- ============================================================================
-- Glint — Notificaciones push (FCM) para gastos compartidos
-- ============================================================================
-- Guarda los tokens de dispositivo (FCM) de cada usuario y avisa por
-- pg_notify cuando se crea un gasto en un grupo, para que un worker externo
-- (glint-push) envíe el push a los demás miembros vía FCM.
--
-- Esta parte no necesita credenciales de Firebase: solo prepara la BD. El
-- envío real lo hace el worker con la cuenta de servicio de Firebase.
--
-- Idempotente. Aplicar:
--   docker exec -i glint-db psql -U postgres -d postgres < deploy/db-init/09-push.sql
--   docker exec glint-db psql -U postgres -d postgres -c "NOTIFY pgrst, 'reload schema';"
-- ============================================================================

create table if not exists public.device_tokens (
  id             text primary key,
  user_id        uuid not null,
  token          text not null,
  plataforma     text,               -- 'android' | 'ios' | 'web'
  actualizado_en timestamptz not null default now(),
  unique (user_id, token)
);

create index if not exists device_tokens_user_idx on public.device_tokens (user_id);

grant all on public.device_tokens to anon, authenticated, service_role;
alter table public.device_tokens enable row level security;

-- Cada quien gestiona solo sus propios tokens.
drop policy if exists "device_tokens: propios" on public.device_tokens;
create policy "device_tokens: propios"
  on public.device_tokens for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

-- ── Aviso al worker cuando se crea un gasto en un grupo ──────────────────────
-- El worker (glint-push) hace LISTEN sobre 'glint_gasto_nuevo', mira los
-- miembros del grupo (menos quien lo creó), busca sus device_tokens y envía FCM.
create or replace function public.notificar_gasto_nuevo()
returns trigger
language plpgsql
as $$
begin
  if new.tipo = 'gasto' then
    perform pg_notify('glint_gasto_nuevo', json_build_object(
      'gasto_id',    new.id,
      'grupo_id',    new.grupo_id,
      'creado_por',  new.creado_por,
      'descripcion', new.descripcion,
      'monto',       new.monto,
      'moneda',      new.moneda
    )::text);
  end if;
  return new;
end;
$$;

drop trigger if exists grupo_gastos_push on public.grupo_gastos;
create trigger grupo_gastos_push
  after insert on public.grupo_gastos
  for each row execute function public.notificar_gasto_nuevo();
