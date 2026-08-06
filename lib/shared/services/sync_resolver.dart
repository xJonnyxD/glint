/// Decisiones de sincronización, aisladas como funciones puras para poder
/// testearlas sin base de datos ni red.
library;

// ── Conversión de tipos entre SQLite y JSON de Supabase ─────────────────────
// Drift guarda las fechas como enteros (segundos epoch) y los booleanos como
// 0/1; Supabase los quiere como ISO-8601 y true/false. Estas funciones puras
// son el punto donde es fácil equivocarse, así que están testeadas.

/// Segundos epoch (como los guarda Drift) → texto ISO-8601 UTC.
String segundosAIso(int segundos) =>
    DateTime.fromMillisecondsSinceEpoch(segundos * 1000, isUtc: true)
        .toIso8601String();

/// Texto ISO-8601 → segundos epoch para guardar en SQLite. `null` si vacío.
int? isoASegundos(String? iso) => (iso == null || iso.isEmpty)
    ? null
    : DateTime.parse(iso).toUtc().millisecondsSinceEpoch ~/ 1000;

/// Qué hacer con una fila cuando existe en local y/o en remoto.
enum AccionSync {
  /// Subir la versión local (gana local o no existe en remoto).
  subir,

  /// Bajar la versión remota (gana remoto).
  bajar,

  /// Ambos lados coinciden: no hacer nada.
  nada,
}

/// Resuelve un conflicto por "última escritura gana" (last-write-wins).
///
/// - Si la fila solo existe en un lado, se copia al otro.
/// - Si existe en ambos, gana la marca de tiempo más reciente.
/// - Empate exacto: se considera igual y no se toca (evita rebotes infinitos
///   entre dos dispositivos con la misma marca).
///
/// [localActualizado] / [remotoActualizado] son las marcas de la fila en cada
/// lado, o null si no existe en ese lado.
AccionSync resolver({
  required DateTime? localActualizado,
  required DateTime? remotoActualizado,
}) {
  if (localActualizado == null && remotoActualizado == null) {
    return AccionSync.nada;
  }
  if (remotoActualizado == null) return AccionSync.subir;
  if (localActualizado == null) return AccionSync.bajar;

  if (localActualizado.isAfter(remotoActualizado)) return AccionSync.subir;
  if (remotoActualizado.isAfter(localActualizado)) return AccionSync.bajar;
  return AccionSync.nada;
}
