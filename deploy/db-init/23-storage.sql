-- ============================================================================
-- Glint — Supabase Storage (fotos de perfil)
-- ============================================================================
-- Crea el rol con el que se conecta `supabase/storage-api` y le da lo justo
-- para que pueda crear su propio esquema `storage` y correr sus migraciones.
--
-- El rol NO se hace superusuario, a diferencia de como quedó en el stack de
-- `~/vet/`: el reporte de seguridad ya señala ese patrón (SEC-18, roles con más
-- privilegio del necesario) y no hace falta para que storage-api funcione.
--
-- La contraseña NO se pone aquí a propósito: este archivo va al repositorio.
-- Se asigna aparte con `deploy/clave_storage.sh`, que la lee del entorno del
-- propio contenedor de Postgres, de modo que nunca pasa por un archivo ni por
-- el historial de la terminal.
--
-- Idempotente: se puede volver a aplicar sin romper nada.
--
-- Aplicar en el servidor:
--   cat deploy/db-init/23-storage.sql | \
--     ssh jonny@192.168.1.9 'docker exec -i glint-db psql -U postgres -d postgres'
-- ============================================================================

do $$
begin
  if not exists (select 1 from pg_roles where rolname = 'supabase_storage_admin') then
    create role supabase_storage_admin login noinherit;
  end if;
end $$;

-- Necesita CREATE en la base para levantar el esquema `storage` la primera vez
-- que arranca y correr sus migraciones.
grant create on database postgres to supabase_storage_admin;
grant usage on schema public to supabase_storage_admin;

-- storage-api usa knex y no aplica el search_path por sí solo; el compose lo
-- refuerza además con PGOPTIONS, igual que hubo que hacer en el stack de vet.
alter role supabase_storage_admin set search_path = storage, public;

-- ── Realtime del perfil ─────────────────────────────────────────────────────
-- `profiles` estaba fuera de la publicación por miedo a un bucle: el latido de
-- presencia (`registrar_actividad`) hace UPDATE de la fila cada 2 minutos.
-- Verificado en producción que ese miedo no aplica: la tabla solo tiene el
-- trigger `profiles_codigo_amigo`, no hay ninguno que toque `actualizado_en`,
-- así que el latido no cambia la columna por la que el cliente decide si algo
-- viajó. El cliente además ignora los eventos en los que `actualizado_en` no
-- se movió, con lo que el latido no provoca ni una sincronización.
--
-- REPLICA IDENTITY FULL para que el payload traiga la fila completa.
alter table public.profiles replica identity full;

do $$
begin
  if not exists (
    select 1 from pg_publication_tables
     where pubname = 'supabase_realtime' and tablename = 'profiles'
  ) then
    alter publication supabase_realtime add table public.profiles;
  end if;
end $$;
