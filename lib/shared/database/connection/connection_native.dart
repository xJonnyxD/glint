import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:glint/core/constants/app_constants.dart';

DatabaseConnection connect() {
  return DatabaseConnection.delayed(Future(() async {
    final dir  = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, AppConstants.driftDbName);
    final file = File(path);
    // NativeDatabase directo (sin background isolate) — más confiable en release
    return DatabaseConnection(NativeDatabase(file, logStatements: false));
  }));
}
