import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/foundation.dart';

import 'package:glint/core/constants/app_constants.dart';

/// Conexión web moderna con WasmDatabase: los datos se guardan en
/// OPFS/IndexedDB (persistentes entre recargas), a diferencia del
/// almacenamiento volátil anterior que se borraba al refrescar.
/// Requiere web/sqlite3.wasm y web/drift_worker.js (incluidos en el repo).
DatabaseConnection connect() {
  return DatabaseConnection.delayed(Future(() async {
    final result = await WasmDatabase.open(
      databaseName: AppConstants.driftDbName.replaceAll('.db', ''),
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );

    if (result.missingFeatures.isNotEmpty) {
      debugPrint(
        'Glint web: usando ${result.chosenImplementation} '
        '(faltan: ${result.missingFeatures})',
      );
    }

    return result.resolvedExecutor;
  }));
}
