import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:glint/features/profile/domain/profile_entity.dart';
import 'package:glint/shared/database/app_database.dart';

/// Acceso al perfil en la base local. La fuente de verdad está en el servidor
/// (`public.profiles`); aquí se guarda su reflejo, que es lo que pinta la UI y
/// lo que sube `ProfileSyncService`.
class ProfileRepository {
  final AppDatabase _db;

  ProfileRepository(this._db);

  // Claves del antiguo ProfileSettings, que guardaba el perfil en el móvil y
  // no llegaba nunca al servidor. Solo se leen una vez, al migrar.
  static const _kFotoVieja = 'glint_perfil_foto';
  static const _kEstadoVieja = 'glint_perfil_estado';
  static const _kNombreVieja = 'glint_perfil_nombre';
  static const _kMigrado = 'glint_perfil_migrado_v11';

  /// Stream del perfil del usuario. Emite en cada cambio local o del sync.
  Stream<ProfileEntity?> observar(String uid) =>
      (_db.select(_db.profiles)..where((p) => p.id.equals(uid)))
          .watchSingleOrNull()
          .map((fila) => fila == null ? null : _aEntidad(fila));

  Future<ProfileEntity?> leer(String uid) async {
    final fila = await (_db.select(_db.profiles)
          ..where((p) => p.id.equals(uid)))
        .getSingleOrNull();
    return fila == null ? null : _aEntidad(fila);
  }

  /// Garantiza que existe la fila local del usuario y arrastra lo que hubiera
  /// en SharedPreferences. Llamar al abrir sesión, antes de leer nada.
  Future<ProfileEntity> asegurarFila(String uid, String email) async {
    final existente = await leer(uid);
    if (existente != null) {
      await _migrarDesdeSharedPreferences(uid);
      return (await leer(uid))!;
    }

    // Fila nueva: nace pendiente de sincronizar, pero con `actualizado_en` en
    // el origen del tiempo para que el primer sync deje ganar SIEMPRE a lo que
    // haya en el servidor (que es la verdad) en vez de pisarlo con un perfil
    // vacío recién creado.
    await _db.into(_db.profiles).insert(
          ProfilesCompanion.insert(
            id: uid,
            email: Value(email),
            actualizadoEn: Value(DateTime.fromMillisecondsSinceEpoch(0)),
            pendienteSync: const Value(false),
          ),
          mode: InsertMode.insertOrIgnore,
        );
    await _migrarDesdeSharedPreferences(uid);
    return (await leer(uid))!;
  }

  /// Guarda los cambios del usuario. El trigger `glint_touch_profiles` se
  /// encarga de marcar la fila como pendiente y de poner la marca de tiempo.
  Future<void> guardar(ProfileEntity p) async {
    await (_db.update(_db.profiles)..where((t) => t.id.equals(p.id))).write(
      ProfilesCompanion(
        nombre: Value(p.nombreCompleto),
        nombres: Value(p.nombres),
        apellidos: Value(p.apellidos),
        bio: Value(p.bio),
        fechaNacimiento: Value(p.fechaNacimiento),
        telefono: Value(p.telefono),
        zonaHoraria: Value(p.zonaHoraria),
        visibilidad: Value(p.visibilidad.texto),
        avatarUrl: Value(p.avatarUrl),
        avatarBytes: Value(p.avatarBytes),
        avatarPendiente: Value(p.avatarPendiente),
      ),
    );
  }

  /// Escribe solo lo relativo al avatar, sin tocar el resto de campos.
  Future<void> guardarAvatar(
    String uid, {
    required Uint8List? bytes,
    required String? url,
    required bool pendiente,
  }) async {
    await (_db.update(_db.profiles)..where((t) => t.id.equals(uid))).write(
      ProfilesCompanion(
        avatarBytes: Value(bytes),
        avatarUrl: Value(url),
        avatarPendiente: Value(pendiente),
      ),
    );
  }

  // ── Migración desde el antiguo ProfileSettings ────────────────────────────

  /// Trae la foto y el estado que vivían en SharedPreferences a la fila local,
  /// una sola vez. Sin esto, al actualizar la app el usuario vería desaparecer
  /// su foto y su frase.
  ///
  /// La foto era solo una RUTA a un archivo temporal del selector de imágenes;
  /// no se arrastra porque puede haber sido purgada por el sistema y en la web
  /// nunca fue válida. Sí se arrastra el estado, que pasa a ser la `bio`.
  Future<void> _migrarDesdeSharedPreferences(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_kMigrado) ?? false) return;

    final estadoViejo = prefs.getString(_kEstadoVieja);
    final nombreViejo = prefs.getString(_kNombreVieja);

    final actual = await leer(uid);
    if (actual != null) {
      final bioVacia = (actual.bio ?? '').trim().isEmpty;
      final nombreVacio = actual.nombre.trim().isEmpty;

      if ((bioVacia && estadoViejo != null && estadoViejo.trim().isNotEmpty) ||
          (nombreVacio && nombreViejo != null && nombreViejo.trim().isNotEmpty)) {
        await (_db.update(_db.profiles)..where((t) => t.id.equals(uid))).write(
          ProfilesCompanion(
            bio: bioVacia && estadoViejo != null
                ? Value(estadoViejo)
                : const Value.absent(),
            nombre: nombreVacio && nombreViejo != null
                ? Value(nombreViejo)
                : const Value.absent(),
          ),
        );
      }
    }

    await prefs.setBool(_kMigrado, true);
    await prefs.remove(_kFotoVieja);
    await prefs.remove(_kEstadoVieja);
    await prefs.remove(_kNombreVieja);
  }

  // ── Conversión ───────────────────────────────────────────────────────────

  ProfileEntity _aEntidad(Profile f) => ProfileEntity(
        id: f.id,
        email: f.email,
        nombre: f.nombre,
        nombres: f.nombres,
        apellidos: f.apellidos,
        bio: f.bio,
        fechaNacimiento: f.fechaNacimiento,
        telefono: f.telefono,
        zonaHoraria: f.zonaHoraria,
        visibilidad: VisibilidadPerfil.desdeTexto(f.visibilidad),
        avatarUrl: f.avatarUrl,
        avatarBytes: f.avatarBytes,
        avatarPendiente: f.avatarPendiente,
        actualizadoEn: f.actualizadoEn,
      );
}
