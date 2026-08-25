-- ============================================================================
-- Glint — Bucket de fotos de perfil
-- ============================================================================
-- ⚠️ Aplicar DESPUÉS de que `glint-storage` haya arrancado al menos una vez:
-- las tablas `storage.buckets` y `storage.objects` las crea storage-api con sus
-- propias migraciones, no existen antes.
--
-- Idempotente: se puede volver a aplicar sin romper nada.
--
-- Aplicar en el servidor:
--   cat deploy/db-init/24-avatares.sql | \
--     ssh jonny@192.168.1.9 'docker exec -i glint-db psql -U postgres -d postgres'
-- ============================================================================

-- ── Acceso de los roles de la API al esquema storage ────────────────────────
-- storage-api evalúa la RLS cambiando de rol a `authenticated`/`anon`. Para que
-- esos roles "vean" storage.objects/buckets hace falta USAGE sobre el esquema y
-- privilegios sobre sus tablas; sin ello fallan con 42P01 "relation objects
-- does not exist" (el esquema del search_path no es visible para el rol). Las
-- FILAS siguen protegidas por las políticas RLS de más abajo — esto solo abre
-- la puerta del esquema, no de los datos. Es lo que hace la init de Supabase.
grant usage on schema storage to anon, authenticated, service_role;
grant all on all tables    in schema storage to anon, authenticated, service_role;
grant all on all sequences in schema storage to anon, authenticated, service_role;
-- Y para las tablas que storage-api cree en el futuro (migraciones nuevas):
alter default privileges for role supabase_storage_admin in schema storage
  grant all on tables    to anon, authenticated, service_role;
alter default privileges for role supabase_storage_admin in schema storage
  grant all on sequences to anon, authenticated, service_role;

-- ── El bucket ───────────────────────────────────────────────────────────────
-- `public = true` significa que la LECTURA no pide token, y es deliberado:
-- la foto tiene que poder pintarse en la lista de amigos, en el ranking y en el
-- panel de admin, y esos sitios leen el perfil por vistas `security definer`
-- donde el visitante no tiene permiso sobre `profiles`. Con URL firmada habría
-- que renovarla y `avatar_url` dejaría de ser un valor estable que se pueda
-- guardar y sincronizar.
--
-- El precio es que quien tenga la URL exacta ve la foto sin estar logueado. Se
-- acota de dos formas: el nombre del archivo va bajo una carpeta con el UUID
-- del usuario (no es adivinable) y no se concede permiso para LISTAR el bucket,
-- así que no se puede enumerar.
--
-- El límite de 5 MB y los tipos permitidos se validan también aquí, no solo en
-- el cliente: el cliente es sugerencia, esto es la reja.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'avatares', 'avatares', true, 5242880,
  array['image/jpeg', 'image/png', 'image/webp']
)
on conflict (id) do update
   set public             = excluded.public,
       file_size_limit    = excluded.file_size_limit,
       allowed_mime_types = excluded.allowed_mime_types;

-- ── Quién puede escribir ────────────────────────────────────────────────────
-- Cada quien solo toca los archivos que cuelgan de su propia carpeta, que se
-- llama como su UUID: `avatares/<uid>/avatar.jpg`. `storage.foldername(name)`
-- devuelve el array de carpetas, así que el primer elemento es el dueño.
--
-- Sin esto, cualquier sesión válida podría sobrescribir la foto de otro, que es
-- la misma clase de fallo que SEC-14 (membresía forzada): el servidor no puede
-- fiarse de que el cliente mande su propio id.

drop policy if exists "avatares: subir el propio" on storage.objects;
create policy "avatares: subir el propio"
  on storage.objects for insert to authenticated
  with check (
    bucket_id = 'avatares'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "avatares: reemplazar el propio" on storage.objects;
create policy "avatares: reemplazar el propio"
  on storage.objects for update to authenticated
  using (
    bucket_id = 'avatares'
    and (storage.foldername(name))[1] = auth.uid()::text
  )
  with check (
    bucket_id = 'avatares'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "avatares: borrar el propio" on storage.objects;
create policy "avatares: borrar el propio"
  on storage.objects for delete to authenticated
  using (
    bucket_id = 'avatares'
    and (storage.foldername(name))[1] = auth.uid()::text
  );
