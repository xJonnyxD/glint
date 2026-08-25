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

-- ── Lectura y escritura ─────────────────────────────────────────────────────
-- IMPORTANTE (aprendido a la mala): en este stack de storage-api, dentro del
-- `WITH CHECK` de la RLS **ni `auth.uid()` ni la columna `owner` resuelven** el
-- usuario (auth.uid() sale NULL; el owner no está disponible en ese punto). Por
-- eso NO se puede meter el "solo tu carpeta" en el WITH CHECK: si se hace, toda
-- subida se rechaza con "new row violates row-level security policy" y el bucket
-- queda con 0 objetos aunque el cliente suba bien. La restricción de propiedad
-- se hace con el TRIGGER de más abajo, que sí ve el `owner` fiable.
--
-- Además, el upsert de storage-api es `insert ... on conflict do update
-- returning *`, así que hacen falta las TRES políticas (insert, update y
-- SELECT); sin la de SELECT, el `returning` se deniega y también falla.

-- Lectura pública (el bucket es público) y necesaria para el `returning`.
drop policy if exists "avatares: ver" on storage.objects;
create policy "avatares: ver"
  on storage.objects for select to public
  using (bucket_id = 'avatares');

-- Escritura de cualquier sesión autenticada en el bucket (la carpeta se acota
-- en el trigger).
drop policy if exists "avatares: escribir autenticado" on storage.objects;
create policy "avatares: escribir autenticado"
  on storage.objects for insert to authenticated
  with check (bucket_id = 'avatares');

drop policy if exists "avatares: actualizar autenticado" on storage.objects;
create policy "avatares: actualizar autenticado"
  on storage.objects for update to authenticated
  using (bucket_id = 'avatares')
  with check (bucket_id = 'avatares');

drop policy if exists "avatares: borrar autenticado" on storage.objects;
create policy "avatares: borrar autenticado"
  on storage.objects for delete to authenticated
  using (bucket_id = 'avatares');

-- Limpieza de las políticas viejas basadas en auth.uid() (por si se aplicó una
-- versión anterior de este archivo).
drop policy if exists "avatares: subir el propio" on storage.objects;
drop policy if exists "avatares: reemplazar el propio" on storage.objects;
drop policy if exists "avatares: borrar el propio" on storage.objects;

-- ── Quién puede escribir en cada carpeta (la reja real) ─────────────────────
-- `owner` lo rellena storage-api con el `sub` del JWT VERIFICADO, no con datos
-- del cliente; y un trigger BEFORE sí lo ve (a diferencia del WITH CHECK). Así
-- se garantiza que cada quien solo escribe bajo `avatares/<su-uid>/`: si alguien
-- intenta subir a la carpeta de otro, su `owner` (su propio uid) no coincide con
-- la carpeta y se rechaza. Es el equivalente a SEC-14 para Storage.
create or replace function storage.avatares_dueno() returns trigger
  language plpgsql as $func$
begin
  if NEW.bucket_id = 'avatares'
     and (storage.foldername(NEW.name))[1] is distinct from NEW.owner::text then
    raise exception 'avatares: solo puedes escribir en tu propia carpeta'
      using errcode = '42501';
  end if;
  return NEW;
end
$func$;

drop trigger if exists avatares_dueno on storage.objects;
create trigger avatares_dueno
  before insert or update on storage.objects
  for each row execute function storage.avatares_dueno();
