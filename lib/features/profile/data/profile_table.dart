import 'package:drift/drift.dart';

/// Espejo local de `public.profiles`.
///
/// A diferencia del resto de tablas sincronizables, esta guarda UNA fila (la
/// del usuario activo) y su clave es `id` — que es el `auth.uid()` — en vez de
/// tener una columna `usuario_id` aparte. Por eso NO entra en
/// [AppDatabase.tablasSincronizables]: el trigger de tumbas que se genera ahí
/// referencia `OLD.usuario_id`, que aquí no existe, y el `CREATE TRIGGER`
/// fallaría dejando la base local rota. Lleva su propio trigger, sin tumba
/// (el perfil no se borra), creado en `AppDatabase._crearTriggerPerfil`.
///
/// Ojo con las columnas: el servidor solo concede UPDATE sobre unas pocas
/// (ver `deploy/db-init/19-perfil-social.sql`). Las que NO viajan están
/// marcadas abajo; la lista autoritativa es
/// `ProfileSyncService.columnasQueViajan`.
class Profiles extends Table {
  /// = `auth.uid()`. No hay `usuario_id`: esta columna hace ese papel.
  TextColumn get id => text()();

  // ── Solo lectura desde el cliente (las escribe el servidor) ──────────────
  TextColumn get email => text().withDefault(const Constant(''))();

  // ── Editables por el usuario ─────────────────────────────────────────────
  /// Nombre para mostrar. Es lo que ven los demás en amigos, ranking y grupos.
  /// Se compone como `nombres apellidos`.
  TextColumn get nombre => text().withDefault(const Constant(''))();
  TextColumn get nombres => text().nullable()();
  TextColumn get apellidos => text().nullable()();
  TextColumn get bio => text().nullable()();
  DateTimeColumn get fechaNacimiento => dateTime().nullable()();
  TextColumn get telefono => text().nullable()();
  TextColumn get zonaHoraria => text().nullable()();

  /// `todos` | `amigos` | `nadie`. Quién puede encontrarte.
  TextColumn get visibilidad =>
      text().withDefault(const Constant('amigos'))();

  /// URL pública del avatar en Storage, con `?v=` para invalidar la caché.
  TextColumn get avatarUrl => text().nullable()();

  // ── Puramente local (NO viaja al servidor) ───────────────────────────────
  /// Bytes del avatar cacheados en el dispositivo. Es lo que hace que la foto
  /// se vea al instante al elegirla, sobreviva a un reinicio y funcione sin
  /// red. No se sube: al servidor va la URL, no el binario. Sí entra en la
  /// copia de seguridad (en base64).
  BlobColumn get avatarBytes => blob().nullable()();

  /// Hay bytes elegidos que aún no se han podido subir (sin red al elegirlos).
  /// El siguiente ciclo de sincronización reintenta la subida.
  BoolColumn get avatarPendiente =>
      boolean().withDefault(const Constant(false))();

  // ── Sincronización ───────────────────────────────────────────────────────
  DateTimeColumn get actualizadoEn =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get pendienteSync => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}
