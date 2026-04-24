import 'package:drift/drift.dart';

/// Tabla de metas de ahorro
class SavingsGoals extends Table {
  TextColumn     get id          => text()();
  TextColumn     get nombre      => text()();
  TextColumn     get emoji       => text().withDefault(const Constant('🎯'))();
  RealColumn     get montoMeta   => real()();
  RealColumn     get montoActual => real().withDefault(const Constant(0.0))();
  DateTimeColumn get fechaMeta   => dateTime().nullable()();
  TextColumn     get color       => text().withDefault(const Constant('#1E88E5'))();
  TextColumn     get usuarioId   => text()();
  DateTimeColumn get creadoEn    => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
