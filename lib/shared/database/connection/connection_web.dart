import 'package:drift/drift.dart';
// ignore: deprecated_member_use
import 'package:drift/web.dart';

// ignore: deprecated_member_use
DatabaseConnection connect() => DatabaseConnection(
      // ignore: deprecated_member_use
      WebDatabase.withStorage(DriftWebStorage.volatile()),
    );
