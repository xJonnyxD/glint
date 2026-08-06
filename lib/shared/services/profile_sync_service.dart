import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:glint/shared/database/app_database.dart';
import 'package:glint/shared/services/sync_resolver.dart';

/// Sincroniza el perfil del usuario con `public.profiles`.
///
/// Va aparte del [GenericSyncEngine] a propósito. Esa tabla no encaja en el
/// motor genérico por cinco motivos, y meterle cinco interruptores a un motor
/// que hoy mueve ocho tablas en producción no compensa:
///
///  1. La fila se identifica por `id` (= auth.uid()), no por `usuario_id`.
///  2. Solo unas columnas concretas pueden viajar (ver [columnasQueViajan]).
///  3. No hay tumbas: el perfil no se borra.
///  4. No se puede borrar por ausencia: si el servidor no responde, la fila
///     local debe quedarse como está.
///  5. Se manda `UPDATE`, no `upsert`: la fila la crea el trigger de alta del
///     servidor y el cliente no tiene permiso de INSERT.
///
/// Se reutiliza en cambio todo lo que sí sirve: [resolver] para los conflictos,
/// la convención `actualizado_en` y la supresión de triggers de
/// [AppDatabase.marcarSyncActivo].
class ProfileSyncService {
  final AppDatabase _db;
  final SupabaseClient _supabase;

  ProfileSyncService(this._db, this._supabase);

  /// Columnas que se envían al servidor. Es una lista EXPLÍCITA, no derivada
  /// de las columnas de la tabla, y eso es deliberado:
  ///
  /// `deploy/db-init/04-seguridad-roles.sql` concede UPDATE columna por
  /// columna. Si el envío incluye una sola columna sin permiso (`es_admin`,
  /// `email`, `xp`, `codigo_amigo`…), PostgREST rechaza **la fila entera** con
  /// un 42501 y el perfil no se guarda en absoluto.
  ///
  /// `avatar_bytes` y `avatar_pendiente` son puramente locales.
  ///
  /// ⚠️ Ampliar esta lista exige ampliar también el `grant update (...)` de la
  /// migración `19-perfil-social.sql`. Hay un test que lo vigila.
  static const Set<String> columnasQueViajan = {
    'nombre',
    'nombres',
    'apellidos',
    'bio',
    'fecha_nacimiento',
    'telefono',
    'zona_horaria',
    'visibilidad',
    'avatar_url',
    'actualizado_en',
  };

  /// Columnas que son fechas en Postgres pero enteros en SQLite.
  static const _columnasFecha = {'actualizado_en', 'fecha_nacimiento'};

  /// `fecha_nacimiento` es un `date` en Postgres, no un `timestamptz`: hay que
  /// mandar 'YYYY-MM-DD' y no un ISO completo, o la zona horaria puede correr
  /// el día.
  static const _columnasSoloFecha = {'fecha_nacimiento'};

  Future<void> sincronizar(String uid) async {
    await _subir(uid);
    await _bajar(uid);
  }

  // ── Subida ───────────────────────────────────────────────────────────────

  Future<void> _subir(String uid) async {
    final filas = await _db.customSelect(
      'SELECT * FROM profiles WHERE id = ? AND pendiente_sync = 1',
      variables: [Variable<String>(uid)],
    ).get();
    if (filas.isEmpty) return;

    final datos = aJsonRemoto(filas.first.data);
    if (datos.isEmpty) return;

    // UPDATE, no upsert: la fila ya existe (la crea el trigger del servidor) y
    // el cliente no tiene permiso para insertarla ni para escribir `id`.
    await _supabase.from('profiles').update(datos).eq('id', uid);

    // Solo si la subida fue bien se limpia la marca, y en modo sync para que
    // el trigger no la vuelva a poner.
    await _enModoSync(() async {
      await _db.customStatement(
        'UPDATE profiles SET pendiente_sync = 0 WHERE id = ?',
        [uid],
      );
    });
  }

  /// Convierte una fila local al JSON que espera Supabase, quedándose solo con
  /// las columnas permitidas. Función pura y visible para poder testearla sin
  /// red: es justo donde es fácil colar una columna sin permiso.
  @visibleForTesting
  static Map<String, dynamic> aJsonRemoto(Map<String, dynamic> fila) {
    final salida = <String, dynamic>{};
    for (final entrada in fila.entries) {
      if (!columnasQueViajan.contains(entrada.key)) continue;
      final valor = entrada.value;

      if (valor != null && _columnasFecha.contains(entrada.key)) {
        final iso = segundosAIso(valor as int);
        salida[entrada.key] =
            _columnasSoloFecha.contains(entrada.key) ? iso.split('T').first : iso;
      } else {
        salida[entrada.key] = valor;
      }
    }
    return salida;
  }

  // ── Bajada ───────────────────────────────────────────────────────────────

  Future<void> _bajar(String uid) async {
    final remoto = await _supabase
        .from('profiles')
        .select()
        .eq('id', uid)
        .maybeSingle();

    // Sin fila remota no se toca nada. Puede ser un fallo puntual o que el
    // trigger de alta aún no haya corrido; borrar el perfil local por eso
    // sería destruir datos del usuario.
    if (remoto == null) return;

    final localFila = await _db.customSelect(
      'SELECT actualizado_en, pendiente_sync FROM profiles WHERE id = ?',
      variables: [Variable<String>(uid)],
    ).getSingleOrNull();

    final localSegundos = localFila?.data['actualizado_en'] as int?;
    final local = localSegundos == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(localSegundos * 1000, isUtc: true);
    final remotoFecha = _fechaDe(remoto['actualizado_en']);

    if (resolver(localActualizado: local, remotoActualizado: remotoFecha) !=
        AccionSync.bajar) {
      return;
    }

    // Se escriben solo las columnas que vienen del servidor: `avatar_bytes` y
    // `avatar_pendiente` son locales y se conservan tal cual.
    await _enModoSync(() async {
      await (_db.update(_db.profiles)..where((p) => p.id.equals(uid))).write(
        ProfilesCompanion(
          email: _valor<String>(remoto['email']),
          nombre: _valor<String>(remoto['nombre']),
          nombres: Value(remoto['nombres'] as String?),
          apellidos: Value(remoto['apellidos'] as String?),
          bio: Value(remoto['bio'] as String?),
          fechaNacimiento: Value(_fechaDe(remoto['fecha_nacimiento'])),
          telefono: Value(remoto['telefono'] as String?),
          zonaHoraria: Value(remoto['zona_horaria'] as String?),
          visibilidad: _valor<String>(remoto['visibilidad']),
          avatarUrl: Value(remoto['avatar_url'] as String?),
          actualizadoEn:
              remotoFecha == null ? const Value.absent() : Value(remotoFecha),
          pendienteSync: const Value(false),
        ),
      );
    });

    // El motor de Drift no se entera de los cambios hechos con SQL crudo ni de
    // los que ocurren en modo sync, así que hay que despertar a los `.watch()`
    // a mano. Sin esto, la pantalla de perfil no se refresca.
    _db.notifyUpdates({TableUpdate('profiles', kind: UpdateKind.update)});
  }

  static Value<T> _valor<T>(Object? v) =>
      v == null ? const Value.absent() : Value(v as T);

  static DateTime? _fechaDe(Object? v) {
    if (v == null) return null;
    final texto = v.toString();
    if (texto.isEmpty) return null;
    final segundos = isoASegundos(texto);
    return segundos == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(segundos * 1000, isUtc: true);
  }

  Future<void> _enModoSync(Future<void> Function() accion) async {
    await _db.marcarSyncActivo(true);
    try {
      await accion();
    } finally {
      await _db.marcarSyncActivo(false);
    }
  }
}
