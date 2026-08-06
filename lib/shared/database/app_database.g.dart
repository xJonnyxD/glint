// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RoutinesTable extends Routines with TableInfo<$RoutinesTable, Routine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconoMeta = const VerificationMeta('icono');
  @override
  late final GeneratedColumn<String> icono = GeneratedColumn<String>(
    'icono',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('default'),
  );
  static const VerificationMeta _periodoMeta = const VerificationMeta(
    'periodo',
  );
  @override
  late final GeneratedColumn<int> periodo = GeneratedColumn<int>(
    'periodo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _horaMeta = const VerificationMeta('hora');
  @override
  late final GeneratedColumn<String> hora = GeneratedColumn<String>(
    'hora',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('07:00'),
  );
  static const VerificationMeta _completadaHoyMeta = const VerificationMeta(
    'completadaHoy',
  );
  @override
  late final GeneratedColumn<bool> completadaHoy = GeneratedColumn<bool>(
    'completada_hoy',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completada_hoy" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _rachaActualMeta = const VerificationMeta(
    'rachaActual',
  );
  @override
  late final GeneratedColumn<int> rachaActual = GeneratedColumn<int>(
    'racha_actual',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _ordenMeta = const VerificationMeta('orden');
  @override
  late final GeneratedColumn<int> orden = GeneratedColumn<int>(
    'orden',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creadaEnMeta = const VerificationMeta(
    'creadaEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadaEn = GeneratedColumn<DateTime>(
    'creada_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _pendienteSyncMeta = const VerificationMeta(
    'pendienteSync',
  );
  @override
  late final GeneratedColumn<bool> pendienteSync = GeneratedColumn<bool>(
    'pendiente_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pendiente_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    icono,
    periodo,
    hora,
    completadaHoy,
    rachaActual,
    orden,
    usuarioId,
    creadaEn,
    actualizadoEn,
    pendienteSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routines';
  @override
  VerificationContext validateIntegrity(
    Insertable<Routine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('icono')) {
      context.handle(
        _iconoMeta,
        icono.isAcceptableOrUnknown(data['icono']!, _iconoMeta),
      );
    }
    if (data.containsKey('periodo')) {
      context.handle(
        _periodoMeta,
        periodo.isAcceptableOrUnknown(data['periodo']!, _periodoMeta),
      );
    } else if (isInserting) {
      context.missing(_periodoMeta);
    }
    if (data.containsKey('hora')) {
      context.handle(
        _horaMeta,
        hora.isAcceptableOrUnknown(data['hora']!, _horaMeta),
      );
    }
    if (data.containsKey('completada_hoy')) {
      context.handle(
        _completadaHoyMeta,
        completadaHoy.isAcceptableOrUnknown(
          data['completada_hoy']!,
          _completadaHoyMeta,
        ),
      );
    }
    if (data.containsKey('racha_actual')) {
      context.handle(
        _rachaActualMeta,
        rachaActual.isAcceptableOrUnknown(
          data['racha_actual']!,
          _rachaActualMeta,
        ),
      );
    }
    if (data.containsKey('orden')) {
      context.handle(
        _ordenMeta,
        orden.isAcceptableOrUnknown(data['orden']!, _ordenMeta),
      );
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('creada_en')) {
      context.handle(
        _creadaEnMeta,
        creadaEn.isAcceptableOrUnknown(data['creada_en']!, _creadaEnMeta),
      );
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    if (data.containsKey('pendiente_sync')) {
      context.handle(
        _pendienteSyncMeta,
        pendienteSync.isAcceptableOrUnknown(
          data['pendiente_sync']!,
          _pendienteSyncMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Routine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Routine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      icono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icono'],
      )!,
      periodo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}periodo'],
      )!,
      hora: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hora'],
      )!,
      completadaHoy: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completada_hoy'],
      )!,
      rachaActual: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}racha_actual'],
      )!,
      orden: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}orden'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usuario_id'],
      )!,
      creadaEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creada_en'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
      pendienteSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pendiente_sync'],
      )!,
    );
  }

  @override
  $RoutinesTable createAlias(String alias) {
    return $RoutinesTable(attachedDatabase, alias);
  }
}

class Routine extends DataClass implements Insertable<Routine> {
  final String id;
  final String nombre;
  final String icono;
  final int periodo;
  final String hora;
  final bool completadaHoy;
  final int rachaActual;
  final int orden;
  final String usuarioId;
  final DateTime creadaEn;
  final DateTime actualizadoEn;
  final bool pendienteSync;
  const Routine({
    required this.id,
    required this.nombre,
    required this.icono,
    required this.periodo,
    required this.hora,
    required this.completadaHoy,
    required this.rachaActual,
    required this.orden,
    required this.usuarioId,
    required this.creadaEn,
    required this.actualizadoEn,
    required this.pendienteSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['icono'] = Variable<String>(icono);
    map['periodo'] = Variable<int>(periodo);
    map['hora'] = Variable<String>(hora);
    map['completada_hoy'] = Variable<bool>(completadaHoy);
    map['racha_actual'] = Variable<int>(rachaActual);
    map['orden'] = Variable<int>(orden);
    map['usuario_id'] = Variable<String>(usuarioId);
    map['creada_en'] = Variable<DateTime>(creadaEn);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    map['pendiente_sync'] = Variable<bool>(pendienteSync);
    return map;
  }

  RoutinesCompanion toCompanion(bool nullToAbsent) {
    return RoutinesCompanion(
      id: Value(id),
      nombre: Value(nombre),
      icono: Value(icono),
      periodo: Value(periodo),
      hora: Value(hora),
      completadaHoy: Value(completadaHoy),
      rachaActual: Value(rachaActual),
      orden: Value(orden),
      usuarioId: Value(usuarioId),
      creadaEn: Value(creadaEn),
      actualizadoEn: Value(actualizadoEn),
      pendienteSync: Value(pendienteSync),
    );
  }

  factory Routine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Routine(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      icono: serializer.fromJson<String>(json['icono']),
      periodo: serializer.fromJson<int>(json['periodo']),
      hora: serializer.fromJson<String>(json['hora']),
      completadaHoy: serializer.fromJson<bool>(json['completadaHoy']),
      rachaActual: serializer.fromJson<int>(json['rachaActual']),
      orden: serializer.fromJson<int>(json['orden']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      creadaEn: serializer.fromJson<DateTime>(json['creadaEn']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
      pendienteSync: serializer.fromJson<bool>(json['pendienteSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'icono': serializer.toJson<String>(icono),
      'periodo': serializer.toJson<int>(periodo),
      'hora': serializer.toJson<String>(hora),
      'completadaHoy': serializer.toJson<bool>(completadaHoy),
      'rachaActual': serializer.toJson<int>(rachaActual),
      'orden': serializer.toJson<int>(orden),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'creadaEn': serializer.toJson<DateTime>(creadaEn),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
      'pendienteSync': serializer.toJson<bool>(pendienteSync),
    };
  }

  Routine copyWith({
    String? id,
    String? nombre,
    String? icono,
    int? periodo,
    String? hora,
    bool? completadaHoy,
    int? rachaActual,
    int? orden,
    String? usuarioId,
    DateTime? creadaEn,
    DateTime? actualizadoEn,
    bool? pendienteSync,
  }) => Routine(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    icono: icono ?? this.icono,
    periodo: periodo ?? this.periodo,
    hora: hora ?? this.hora,
    completadaHoy: completadaHoy ?? this.completadaHoy,
    rachaActual: rachaActual ?? this.rachaActual,
    orden: orden ?? this.orden,
    usuarioId: usuarioId ?? this.usuarioId,
    creadaEn: creadaEn ?? this.creadaEn,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    pendienteSync: pendienteSync ?? this.pendienteSync,
  );
  Routine copyWithCompanion(RoutinesCompanion data) {
    return Routine(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      icono: data.icono.present ? data.icono.value : this.icono,
      periodo: data.periodo.present ? data.periodo.value : this.periodo,
      hora: data.hora.present ? data.hora.value : this.hora,
      completadaHoy: data.completadaHoy.present
          ? data.completadaHoy.value
          : this.completadaHoy,
      rachaActual: data.rachaActual.present
          ? data.rachaActual.value
          : this.rachaActual,
      orden: data.orden.present ? data.orden.value : this.orden,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      creadaEn: data.creadaEn.present ? data.creadaEn.value : this.creadaEn,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
      pendienteSync: data.pendienteSync.present
          ? data.pendienteSync.value
          : this.pendienteSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Routine(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('icono: $icono, ')
          ..write('periodo: $periodo, ')
          ..write('hora: $hora, ')
          ..write('completadaHoy: $completadaHoy, ')
          ..write('rachaActual: $rachaActual, ')
          ..write('orden: $orden, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('creadaEn: $creadaEn, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('pendienteSync: $pendienteSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    icono,
    periodo,
    hora,
    completadaHoy,
    rachaActual,
    orden,
    usuarioId,
    creadaEn,
    actualizadoEn,
    pendienteSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Routine &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.icono == this.icono &&
          other.periodo == this.periodo &&
          other.hora == this.hora &&
          other.completadaHoy == this.completadaHoy &&
          other.rachaActual == this.rachaActual &&
          other.orden == this.orden &&
          other.usuarioId == this.usuarioId &&
          other.creadaEn == this.creadaEn &&
          other.actualizadoEn == this.actualizadoEn &&
          other.pendienteSync == this.pendienteSync);
}

class RoutinesCompanion extends UpdateCompanion<Routine> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String> icono;
  final Value<int> periodo;
  final Value<String> hora;
  final Value<bool> completadaHoy;
  final Value<int> rachaActual;
  final Value<int> orden;
  final Value<String> usuarioId;
  final Value<DateTime> creadaEn;
  final Value<DateTime> actualizadoEn;
  final Value<bool> pendienteSync;
  final Value<int> rowid;
  const RoutinesCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.icono = const Value.absent(),
    this.periodo = const Value.absent(),
    this.hora = const Value.absent(),
    this.completadaHoy = const Value.absent(),
    this.rachaActual = const Value.absent(),
    this.orden = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.creadaEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutinesCompanion.insert({
    required String id,
    required String nombre,
    this.icono = const Value.absent(),
    required int periodo,
    this.hora = const Value.absent(),
    this.completadaHoy = const Value.absent(),
    this.rachaActual = const Value.absent(),
    this.orden = const Value.absent(),
    required String usuarioId,
    this.creadaEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre),
       periodo = Value(periodo),
       usuarioId = Value(usuarioId);
  static Insertable<Routine> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? icono,
    Expression<int>? periodo,
    Expression<String>? hora,
    Expression<bool>? completadaHoy,
    Expression<int>? rachaActual,
    Expression<int>? orden,
    Expression<String>? usuarioId,
    Expression<DateTime>? creadaEn,
    Expression<DateTime>? actualizadoEn,
    Expression<bool>? pendienteSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (icono != null) 'icono': icono,
      if (periodo != null) 'periodo': periodo,
      if (hora != null) 'hora': hora,
      if (completadaHoy != null) 'completada_hoy': completadaHoy,
      if (rachaActual != null) 'racha_actual': rachaActual,
      if (orden != null) 'orden': orden,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (creadaEn != null) 'creada_en': creadaEn,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
      if (pendienteSync != null) 'pendiente_sync': pendienteSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutinesCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<String>? icono,
    Value<int>? periodo,
    Value<String>? hora,
    Value<bool>? completadaHoy,
    Value<int>? rachaActual,
    Value<int>? orden,
    Value<String>? usuarioId,
    Value<DateTime>? creadaEn,
    Value<DateTime>? actualizadoEn,
    Value<bool>? pendienteSync,
    Value<int>? rowid,
  }) {
    return RoutinesCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      icono: icono ?? this.icono,
      periodo: periodo ?? this.periodo,
      hora: hora ?? this.hora,
      completadaHoy: completadaHoy ?? this.completadaHoy,
      rachaActual: rachaActual ?? this.rachaActual,
      orden: orden ?? this.orden,
      usuarioId: usuarioId ?? this.usuarioId,
      creadaEn: creadaEn ?? this.creadaEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      pendienteSync: pendienteSync ?? this.pendienteSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (icono.present) {
      map['icono'] = Variable<String>(icono.value);
    }
    if (periodo.present) {
      map['periodo'] = Variable<int>(periodo.value);
    }
    if (hora.present) {
      map['hora'] = Variable<String>(hora.value);
    }
    if (completadaHoy.present) {
      map['completada_hoy'] = Variable<bool>(completadaHoy.value);
    }
    if (rachaActual.present) {
      map['racha_actual'] = Variable<int>(rachaActual.value);
    }
    if (orden.present) {
      map['orden'] = Variable<int>(orden.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (creadaEn.present) {
      map['creada_en'] = Variable<DateTime>(creadaEn.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    if (pendienteSync.present) {
      map['pendiente_sync'] = Variable<bool>(pendienteSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutinesCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('icono: $icono, ')
          ..write('periodo: $periodo, ')
          ..write('hora: $hora, ')
          ..write('completadaHoy: $completadaHoy, ')
          ..write('rachaActual: $rachaActual, ')
          ..write('orden: $orden, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('creadaEn: $creadaEn, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('pendienteSync: $pendienteSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _montoMeta = const VerificationMeta('monto');
  @override
  late final GeneratedColumn<double> monto = GeneratedColumn<double>(
    'monto',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaMeta = const VerificationMeta(
    'categoria',
  );
  @override
  late final GeneratedColumn<String> categoria = GeneratedColumn<String>(
    'categoria',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaEmojiMeta = const VerificationMeta(
    'categoriaEmoji',
  );
  @override
  late final GeneratedColumn<String> categoriaEmoji = GeneratedColumn<String>(
    'categoria_emoji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notasMeta = const VerificationMeta('notas');
  @override
  late final GeneratedColumn<String> notas = GeneratedColumn<String>(
    'notas',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imagenPathMeta = const VerificationMeta(
    'imagenPath',
  );
  @override
  late final GeneratedColumn<String> imagenPath = GeneratedColumn<String>(
    'imagen_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creadaEnMeta = const VerificationMeta(
    'creadaEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadaEn = GeneratedColumn<DateTime>(
    'creada_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _pendienteSyncMeta = const VerificationMeta(
    'pendienteSync',
  );
  @override
  late final GeneratedColumn<bool> pendienteSync = GeneratedColumn<bool>(
    'pendiente_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pendiente_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tipo,
    monto,
    descripcion,
    categoria,
    categoriaEmoji,
    fecha,
    notas,
    imagenPath,
    usuarioId,
    creadaEn,
    actualizadoEn,
    pendienteSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('monto')) {
      context.handle(
        _montoMeta,
        monto.isAcceptableOrUnknown(data['monto']!, _montoMeta),
      );
    } else if (isInserting) {
      context.missing(_montoMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('categoria')) {
      context.handle(
        _categoriaMeta,
        categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta),
      );
    } else if (isInserting) {
      context.missing(_categoriaMeta);
    }
    if (data.containsKey('categoria_emoji')) {
      context.handle(
        _categoriaEmojiMeta,
        categoriaEmoji.isAcceptableOrUnknown(
          data['categoria_emoji']!,
          _categoriaEmojiMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoriaEmojiMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('notas')) {
      context.handle(
        _notasMeta,
        notas.isAcceptableOrUnknown(data['notas']!, _notasMeta),
      );
    }
    if (data.containsKey('imagen_path')) {
      context.handle(
        _imagenPathMeta,
        imagenPath.isAcceptableOrUnknown(data['imagen_path']!, _imagenPathMeta),
      );
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('creada_en')) {
      context.handle(
        _creadaEnMeta,
        creadaEn.isAcceptableOrUnknown(data['creada_en']!, _creadaEnMeta),
      );
    } else if (isInserting) {
      context.missing(_creadaEnMeta);
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    if (data.containsKey('pendiente_sync')) {
      context.handle(
        _pendienteSyncMeta,
        pendienteSync.isAcceptableOrUnknown(
          data['pendiente_sync']!,
          _pendienteSyncMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      monto: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monto'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      )!,
      categoria: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria'],
      )!,
      categoriaEmoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria_emoji'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      notas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notas'],
      ),
      imagenPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}imagen_path'],
      ),
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usuario_id'],
      )!,
      creadaEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creada_en'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
      pendienteSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pendiente_sync'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final String id;
  final String tipo;
  final double monto;
  final String descripcion;
  final String categoria;
  final String categoriaEmoji;
  final DateTime fecha;
  final String? notas;
  final String? imagenPath;
  final String usuarioId;
  final DateTime creadaEn;
  final DateTime actualizadoEn;
  final bool pendienteSync;
  const Transaction({
    required this.id,
    required this.tipo,
    required this.monto,
    required this.descripcion,
    required this.categoria,
    required this.categoriaEmoji,
    required this.fecha,
    this.notas,
    this.imagenPath,
    required this.usuarioId,
    required this.creadaEn,
    required this.actualizadoEn,
    required this.pendienteSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tipo'] = Variable<String>(tipo);
    map['monto'] = Variable<double>(monto);
    map['descripcion'] = Variable<String>(descripcion);
    map['categoria'] = Variable<String>(categoria);
    map['categoria_emoji'] = Variable<String>(categoriaEmoji);
    map['fecha'] = Variable<DateTime>(fecha);
    if (!nullToAbsent || notas != null) {
      map['notas'] = Variable<String>(notas);
    }
    if (!nullToAbsent || imagenPath != null) {
      map['imagen_path'] = Variable<String>(imagenPath);
    }
    map['usuario_id'] = Variable<String>(usuarioId);
    map['creada_en'] = Variable<DateTime>(creadaEn);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    map['pendiente_sync'] = Variable<bool>(pendienteSync);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      tipo: Value(tipo),
      monto: Value(monto),
      descripcion: Value(descripcion),
      categoria: Value(categoria),
      categoriaEmoji: Value(categoriaEmoji),
      fecha: Value(fecha),
      notas: notas == null && nullToAbsent
          ? const Value.absent()
          : Value(notas),
      imagenPath: imagenPath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagenPath),
      usuarioId: Value(usuarioId),
      creadaEn: Value(creadaEn),
      actualizadoEn: Value(actualizadoEn),
      pendienteSync: Value(pendienteSync),
    );
  }

  factory Transaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<String>(json['id']),
      tipo: serializer.fromJson<String>(json['tipo']),
      monto: serializer.fromJson<double>(json['monto']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      categoria: serializer.fromJson<String>(json['categoria']),
      categoriaEmoji: serializer.fromJson<String>(json['categoriaEmoji']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      notas: serializer.fromJson<String?>(json['notas']),
      imagenPath: serializer.fromJson<String?>(json['imagenPath']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      creadaEn: serializer.fromJson<DateTime>(json['creadaEn']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
      pendienteSync: serializer.fromJson<bool>(json['pendienteSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tipo': serializer.toJson<String>(tipo),
      'monto': serializer.toJson<double>(monto),
      'descripcion': serializer.toJson<String>(descripcion),
      'categoria': serializer.toJson<String>(categoria),
      'categoriaEmoji': serializer.toJson<String>(categoriaEmoji),
      'fecha': serializer.toJson<DateTime>(fecha),
      'notas': serializer.toJson<String?>(notas),
      'imagenPath': serializer.toJson<String?>(imagenPath),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'creadaEn': serializer.toJson<DateTime>(creadaEn),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
      'pendienteSync': serializer.toJson<bool>(pendienteSync),
    };
  }

  Transaction copyWith({
    String? id,
    String? tipo,
    double? monto,
    String? descripcion,
    String? categoria,
    String? categoriaEmoji,
    DateTime? fecha,
    Value<String?> notas = const Value.absent(),
    Value<String?> imagenPath = const Value.absent(),
    String? usuarioId,
    DateTime? creadaEn,
    DateTime? actualizadoEn,
    bool? pendienteSync,
  }) => Transaction(
    id: id ?? this.id,
    tipo: tipo ?? this.tipo,
    monto: monto ?? this.monto,
    descripcion: descripcion ?? this.descripcion,
    categoria: categoria ?? this.categoria,
    categoriaEmoji: categoriaEmoji ?? this.categoriaEmoji,
    fecha: fecha ?? this.fecha,
    notas: notas.present ? notas.value : this.notas,
    imagenPath: imagenPath.present ? imagenPath.value : this.imagenPath,
    usuarioId: usuarioId ?? this.usuarioId,
    creadaEn: creadaEn ?? this.creadaEn,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    pendienteSync: pendienteSync ?? this.pendienteSync,
  );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      monto: data.monto.present ? data.monto.value : this.monto,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      categoriaEmoji: data.categoriaEmoji.present
          ? data.categoriaEmoji.value
          : this.categoriaEmoji,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      notas: data.notas.present ? data.notas.value : this.notas,
      imagenPath: data.imagenPath.present
          ? data.imagenPath.value
          : this.imagenPath,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      creadaEn: data.creadaEn.present ? data.creadaEn.value : this.creadaEn,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
      pendienteSync: data.pendienteSync.present
          ? data.pendienteSync.value
          : this.pendienteSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('monto: $monto, ')
          ..write('descripcion: $descripcion, ')
          ..write('categoria: $categoria, ')
          ..write('categoriaEmoji: $categoriaEmoji, ')
          ..write('fecha: $fecha, ')
          ..write('notas: $notas, ')
          ..write('imagenPath: $imagenPath, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('creadaEn: $creadaEn, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('pendienteSync: $pendienteSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tipo,
    monto,
    descripcion,
    categoria,
    categoriaEmoji,
    fecha,
    notas,
    imagenPath,
    usuarioId,
    creadaEn,
    actualizadoEn,
    pendienteSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.tipo == this.tipo &&
          other.monto == this.monto &&
          other.descripcion == this.descripcion &&
          other.categoria == this.categoria &&
          other.categoriaEmoji == this.categoriaEmoji &&
          other.fecha == this.fecha &&
          other.notas == this.notas &&
          other.imagenPath == this.imagenPath &&
          other.usuarioId == this.usuarioId &&
          other.creadaEn == this.creadaEn &&
          other.actualizadoEn == this.actualizadoEn &&
          other.pendienteSync == this.pendienteSync);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<String> id;
  final Value<String> tipo;
  final Value<double> monto;
  final Value<String> descripcion;
  final Value<String> categoria;
  final Value<String> categoriaEmoji;
  final Value<DateTime> fecha;
  final Value<String?> notas;
  final Value<String?> imagenPath;
  final Value<String> usuarioId;
  final Value<DateTime> creadaEn;
  final Value<DateTime> actualizadoEn;
  final Value<bool> pendienteSync;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.tipo = const Value.absent(),
    this.monto = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.categoria = const Value.absent(),
    this.categoriaEmoji = const Value.absent(),
    this.fecha = const Value.absent(),
    this.notas = const Value.absent(),
    this.imagenPath = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.creadaEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    required String tipo,
    required double monto,
    required String descripcion,
    required String categoria,
    required String categoriaEmoji,
    required DateTime fecha,
    this.notas = const Value.absent(),
    this.imagenPath = const Value.absent(),
    required String usuarioId,
    required DateTime creadaEn,
    this.actualizadoEn = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tipo = Value(tipo),
       monto = Value(monto),
       descripcion = Value(descripcion),
       categoria = Value(categoria),
       categoriaEmoji = Value(categoriaEmoji),
       fecha = Value(fecha),
       usuarioId = Value(usuarioId),
       creadaEn = Value(creadaEn);
  static Insertable<Transaction> custom({
    Expression<String>? id,
    Expression<String>? tipo,
    Expression<double>? monto,
    Expression<String>? descripcion,
    Expression<String>? categoria,
    Expression<String>? categoriaEmoji,
    Expression<DateTime>? fecha,
    Expression<String>? notas,
    Expression<String>? imagenPath,
    Expression<String>? usuarioId,
    Expression<DateTime>? creadaEn,
    Expression<DateTime>? actualizadoEn,
    Expression<bool>? pendienteSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tipo != null) 'tipo': tipo,
      if (monto != null) 'monto': monto,
      if (descripcion != null) 'descripcion': descripcion,
      if (categoria != null) 'categoria': categoria,
      if (categoriaEmoji != null) 'categoria_emoji': categoriaEmoji,
      if (fecha != null) 'fecha': fecha,
      if (notas != null) 'notas': notas,
      if (imagenPath != null) 'imagen_path': imagenPath,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (creadaEn != null) 'creada_en': creadaEn,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
      if (pendienteSync != null) 'pendiente_sync': pendienteSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith({
    Value<String>? id,
    Value<String>? tipo,
    Value<double>? monto,
    Value<String>? descripcion,
    Value<String>? categoria,
    Value<String>? categoriaEmoji,
    Value<DateTime>? fecha,
    Value<String?>? notas,
    Value<String?>? imagenPath,
    Value<String>? usuarioId,
    Value<DateTime>? creadaEn,
    Value<DateTime>? actualizadoEn,
    Value<bool>? pendienteSync,
    Value<int>? rowid,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      monto: monto ?? this.monto,
      descripcion: descripcion ?? this.descripcion,
      categoria: categoria ?? this.categoria,
      categoriaEmoji: categoriaEmoji ?? this.categoriaEmoji,
      fecha: fecha ?? this.fecha,
      notas: notas ?? this.notas,
      imagenPath: imagenPath ?? this.imagenPath,
      usuarioId: usuarioId ?? this.usuarioId,
      creadaEn: creadaEn ?? this.creadaEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      pendienteSync: pendienteSync ?? this.pendienteSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (monto.present) {
      map['monto'] = Variable<double>(monto.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (categoriaEmoji.present) {
      map['categoria_emoji'] = Variable<String>(categoriaEmoji.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (notas.present) {
      map['notas'] = Variable<String>(notas.value);
    }
    if (imagenPath.present) {
      map['imagen_path'] = Variable<String>(imagenPath.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (creadaEn.present) {
      map['creada_en'] = Variable<DateTime>(creadaEn.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    if (pendienteSync.present) {
      map['pendiente_sync'] = Variable<bool>(pendienteSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('monto: $monto, ')
          ..write('descripcion: $descripcion, ')
          ..write('categoria: $categoria, ')
          ..write('categoriaEmoji: $categoriaEmoji, ')
          ..write('fecha: $fecha, ')
          ..write('notas: $notas, ')
          ..write('imagenPath: $imagenPath, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('creadaEn: $creadaEn, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('pendienteSync: $pendienteSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, Budget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaMeta = const VerificationMeta(
    'categoria',
  );
  @override
  late final GeneratedColumn<String> categoria = GeneratedColumn<String>(
    'categoria',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _limiteMeta = const VerificationMeta('limite');
  @override
  late final GeneratedColumn<double> limite = GeneratedColumn<double>(
    'limite',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mesMeta = const VerificationMeta('mes');
  @override
  late final GeneratedColumn<int> mes = GeneratedColumn<int>(
    'mes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anioMeta = const VerificationMeta('anio');
  @override
  late final GeneratedColumn<int> anio = GeneratedColumn<int>(
    'anio',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _pendienteSyncMeta = const VerificationMeta(
    'pendienteSync',
  );
  @override
  late final GeneratedColumn<bool> pendienteSync = GeneratedColumn<bool>(
    'pendiente_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pendiente_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoria,
    limite,
    mes,
    anio,
    usuarioId,
    creadoEn,
    actualizadoEn,
    pendienteSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Budget> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('categoria')) {
      context.handle(
        _categoriaMeta,
        categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta),
      );
    } else if (isInserting) {
      context.missing(_categoriaMeta);
    }
    if (data.containsKey('limite')) {
      context.handle(
        _limiteMeta,
        limite.isAcceptableOrUnknown(data['limite']!, _limiteMeta),
      );
    } else if (isInserting) {
      context.missing(_limiteMeta);
    }
    if (data.containsKey('mes')) {
      context.handle(
        _mesMeta,
        mes.isAcceptableOrUnknown(data['mes']!, _mesMeta),
      );
    } else if (isInserting) {
      context.missing(_mesMeta);
    }
    if (data.containsKey('anio')) {
      context.handle(
        _anioMeta,
        anio.isAcceptableOrUnknown(data['anio']!, _anioMeta),
      );
    } else if (isInserting) {
      context.missing(_anioMeta);
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    if (data.containsKey('pendiente_sync')) {
      context.handle(
        _pendienteSyncMeta,
        pendienteSync.isAcceptableOrUnknown(
          data['pendiente_sync']!,
          _pendienteSyncMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Budget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Budget(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      categoria: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria'],
      )!,
      limite: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}limite'],
      )!,
      mes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mes'],
      )!,
      anio: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}anio'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usuario_id'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
      pendienteSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pendiente_sync'],
      )!,
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }
}

class Budget extends DataClass implements Insertable<Budget> {
  final String id;
  final String categoria;
  final double limite;
  final int mes;
  final int anio;
  final String usuarioId;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  final bool pendienteSync;
  const Budget({
    required this.id,
    required this.categoria,
    required this.limite,
    required this.mes,
    required this.anio,
    required this.usuarioId,
    required this.creadoEn,
    required this.actualizadoEn,
    required this.pendienteSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['categoria'] = Variable<String>(categoria);
    map['limite'] = Variable<double>(limite);
    map['mes'] = Variable<int>(mes);
    map['anio'] = Variable<int>(anio);
    map['usuario_id'] = Variable<String>(usuarioId);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    map['pendiente_sync'] = Variable<bool>(pendienteSync);
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: Value(id),
      categoria: Value(categoria),
      limite: Value(limite),
      mes: Value(mes),
      anio: Value(anio),
      usuarioId: Value(usuarioId),
      creadoEn: Value(creadoEn),
      actualizadoEn: Value(actualizadoEn),
      pendienteSync: Value(pendienteSync),
    );
  }

  factory Budget.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Budget(
      id: serializer.fromJson<String>(json['id']),
      categoria: serializer.fromJson<String>(json['categoria']),
      limite: serializer.fromJson<double>(json['limite']),
      mes: serializer.fromJson<int>(json['mes']),
      anio: serializer.fromJson<int>(json['anio']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
      pendienteSync: serializer.fromJson<bool>(json['pendienteSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'categoria': serializer.toJson<String>(categoria),
      'limite': serializer.toJson<double>(limite),
      'mes': serializer.toJson<int>(mes),
      'anio': serializer.toJson<int>(anio),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
      'pendienteSync': serializer.toJson<bool>(pendienteSync),
    };
  }

  Budget copyWith({
    String? id,
    String? categoria,
    double? limite,
    int? mes,
    int? anio,
    String? usuarioId,
    DateTime? creadoEn,
    DateTime? actualizadoEn,
    bool? pendienteSync,
  }) => Budget(
    id: id ?? this.id,
    categoria: categoria ?? this.categoria,
    limite: limite ?? this.limite,
    mes: mes ?? this.mes,
    anio: anio ?? this.anio,
    usuarioId: usuarioId ?? this.usuarioId,
    creadoEn: creadoEn ?? this.creadoEn,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    pendienteSync: pendienteSync ?? this.pendienteSync,
  );
  Budget copyWithCompanion(BudgetsCompanion data) {
    return Budget(
      id: data.id.present ? data.id.value : this.id,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      limite: data.limite.present ? data.limite.value : this.limite,
      mes: data.mes.present ? data.mes.value : this.mes,
      anio: data.anio.present ? data.anio.value : this.anio,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
      pendienteSync: data.pendienteSync.present
          ? data.pendienteSync.value
          : this.pendienteSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Budget(')
          ..write('id: $id, ')
          ..write('categoria: $categoria, ')
          ..write('limite: $limite, ')
          ..write('mes: $mes, ')
          ..write('anio: $anio, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('pendienteSync: $pendienteSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    categoria,
    limite,
    mes,
    anio,
    usuarioId,
    creadoEn,
    actualizadoEn,
    pendienteSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Budget &&
          other.id == this.id &&
          other.categoria == this.categoria &&
          other.limite == this.limite &&
          other.mes == this.mes &&
          other.anio == this.anio &&
          other.usuarioId == this.usuarioId &&
          other.creadoEn == this.creadoEn &&
          other.actualizadoEn == this.actualizadoEn &&
          other.pendienteSync == this.pendienteSync);
}

class BudgetsCompanion extends UpdateCompanion<Budget> {
  final Value<String> id;
  final Value<String> categoria;
  final Value<double> limite;
  final Value<int> mes;
  final Value<int> anio;
  final Value<String> usuarioId;
  final Value<DateTime> creadoEn;
  final Value<DateTime> actualizadoEn;
  final Value<bool> pendienteSync;
  final Value<int> rowid;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.categoria = const Value.absent(),
    this.limite = const Value.absent(),
    this.mes = const Value.absent(),
    this.anio = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetsCompanion.insert({
    required String id,
    required String categoria,
    required double limite,
    required int mes,
    required int anio,
    required String usuarioId,
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       categoria = Value(categoria),
       limite = Value(limite),
       mes = Value(mes),
       anio = Value(anio),
       usuarioId = Value(usuarioId);
  static Insertable<Budget> custom({
    Expression<String>? id,
    Expression<String>? categoria,
    Expression<double>? limite,
    Expression<int>? mes,
    Expression<int>? anio,
    Expression<String>? usuarioId,
    Expression<DateTime>? creadoEn,
    Expression<DateTime>? actualizadoEn,
    Expression<bool>? pendienteSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoria != null) 'categoria': categoria,
      if (limite != null) 'limite': limite,
      if (mes != null) 'mes': mes,
      if (anio != null) 'anio': anio,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
      if (pendienteSync != null) 'pendiente_sync': pendienteSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetsCompanion copyWith({
    Value<String>? id,
    Value<String>? categoria,
    Value<double>? limite,
    Value<int>? mes,
    Value<int>? anio,
    Value<String>? usuarioId,
    Value<DateTime>? creadoEn,
    Value<DateTime>? actualizadoEn,
    Value<bool>? pendienteSync,
    Value<int>? rowid,
  }) {
    return BudgetsCompanion(
      id: id ?? this.id,
      categoria: categoria ?? this.categoria,
      limite: limite ?? this.limite,
      mes: mes ?? this.mes,
      anio: anio ?? this.anio,
      usuarioId: usuarioId ?? this.usuarioId,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      pendienteSync: pendienteSync ?? this.pendienteSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (limite.present) {
      map['limite'] = Variable<double>(limite.value);
    }
    if (mes.present) {
      map['mes'] = Variable<int>(mes.value);
    }
    if (anio.present) {
      map['anio'] = Variable<int>(anio.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    if (pendienteSync.present) {
      map['pendiente_sync'] = Variable<bool>(pendienteSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('categoria: $categoria, ')
          ..write('limite: $limite, ')
          ..write('mes: $mes, ')
          ..write('anio: $anio, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('pendienteSync: $pendienteSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavingsGoalsTable extends SavingsGoals
    with TableInfo<$SavingsGoalsTable, SavingsGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('🎯'),
  );
  static const VerificationMeta _montoMetaMeta = const VerificationMeta(
    'montoMeta',
  );
  @override
  late final GeneratedColumn<double> montoMeta = GeneratedColumn<double>(
    'monto_meta',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _montoActualMeta = const VerificationMeta(
    'montoActual',
  );
  @override
  late final GeneratedColumn<double> montoActual = GeneratedColumn<double>(
    'monto_actual',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _fechaMetaMeta = const VerificationMeta(
    'fechaMeta',
  );
  @override
  late final GeneratedColumn<DateTime> fechaMeta = GeneratedColumn<DateTime>(
    'fecha_meta',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#1E88E5'),
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _pendienteSyncMeta = const VerificationMeta(
    'pendienteSync',
  );
  @override
  late final GeneratedColumn<bool> pendienteSync = GeneratedColumn<bool>(
    'pendiente_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pendiente_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    emoji,
    montoMeta,
    montoActual,
    fechaMeta,
    color,
    usuarioId,
    creadoEn,
    actualizadoEn,
    pendienteSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingsGoal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    }
    if (data.containsKey('monto_meta')) {
      context.handle(
        _montoMetaMeta,
        montoMeta.isAcceptableOrUnknown(data['monto_meta']!, _montoMetaMeta),
      );
    } else if (isInserting) {
      context.missing(_montoMetaMeta);
    }
    if (data.containsKey('monto_actual')) {
      context.handle(
        _montoActualMeta,
        montoActual.isAcceptableOrUnknown(
          data['monto_actual']!,
          _montoActualMeta,
        ),
      );
    }
    if (data.containsKey('fecha_meta')) {
      context.handle(
        _fechaMetaMeta,
        fechaMeta.isAcceptableOrUnknown(data['fecha_meta']!, _fechaMetaMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    } else if (isInserting) {
      context.missing(_creadoEnMeta);
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    if (data.containsKey('pendiente_sync')) {
      context.handle(
        _pendienteSyncMeta,
        pendienteSync.isAcceptableOrUnknown(
          data['pendiente_sync']!,
          _pendienteSyncMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsGoal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      )!,
      montoMeta: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monto_meta'],
      )!,
      montoActual: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monto_actual'],
      )!,
      fechaMeta: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_meta'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usuario_id'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
      pendienteSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pendiente_sync'],
      )!,
    );
  }

  @override
  $SavingsGoalsTable createAlias(String alias) {
    return $SavingsGoalsTable(attachedDatabase, alias);
  }
}

class SavingsGoal extends DataClass implements Insertable<SavingsGoal> {
  final String id;
  final String nombre;
  final String emoji;
  final double montoMeta;
  final double montoActual;
  final DateTime? fechaMeta;
  final String color;
  final String usuarioId;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  final bool pendienteSync;
  const SavingsGoal({
    required this.id,
    required this.nombre,
    required this.emoji,
    required this.montoMeta,
    required this.montoActual,
    this.fechaMeta,
    required this.color,
    required this.usuarioId,
    required this.creadoEn,
    required this.actualizadoEn,
    required this.pendienteSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['emoji'] = Variable<String>(emoji);
    map['monto_meta'] = Variable<double>(montoMeta);
    map['monto_actual'] = Variable<double>(montoActual);
    if (!nullToAbsent || fechaMeta != null) {
      map['fecha_meta'] = Variable<DateTime>(fechaMeta);
    }
    map['color'] = Variable<String>(color);
    map['usuario_id'] = Variable<String>(usuarioId);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    map['pendiente_sync'] = Variable<bool>(pendienteSync);
    return map;
  }

  SavingsGoalsCompanion toCompanion(bool nullToAbsent) {
    return SavingsGoalsCompanion(
      id: Value(id),
      nombre: Value(nombre),
      emoji: Value(emoji),
      montoMeta: Value(montoMeta),
      montoActual: Value(montoActual),
      fechaMeta: fechaMeta == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaMeta),
      color: Value(color),
      usuarioId: Value(usuarioId),
      creadoEn: Value(creadoEn),
      actualizadoEn: Value(actualizadoEn),
      pendienteSync: Value(pendienteSync),
    );
  }

  factory SavingsGoal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsGoal(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      emoji: serializer.fromJson<String>(json['emoji']),
      montoMeta: serializer.fromJson<double>(json['montoMeta']),
      montoActual: serializer.fromJson<double>(json['montoActual']),
      fechaMeta: serializer.fromJson<DateTime?>(json['fechaMeta']),
      color: serializer.fromJson<String>(json['color']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
      pendienteSync: serializer.fromJson<bool>(json['pendienteSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'emoji': serializer.toJson<String>(emoji),
      'montoMeta': serializer.toJson<double>(montoMeta),
      'montoActual': serializer.toJson<double>(montoActual),
      'fechaMeta': serializer.toJson<DateTime?>(fechaMeta),
      'color': serializer.toJson<String>(color),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
      'pendienteSync': serializer.toJson<bool>(pendienteSync),
    };
  }

  SavingsGoal copyWith({
    String? id,
    String? nombre,
    String? emoji,
    double? montoMeta,
    double? montoActual,
    Value<DateTime?> fechaMeta = const Value.absent(),
    String? color,
    String? usuarioId,
    DateTime? creadoEn,
    DateTime? actualizadoEn,
    bool? pendienteSync,
  }) => SavingsGoal(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    emoji: emoji ?? this.emoji,
    montoMeta: montoMeta ?? this.montoMeta,
    montoActual: montoActual ?? this.montoActual,
    fechaMeta: fechaMeta.present ? fechaMeta.value : this.fechaMeta,
    color: color ?? this.color,
    usuarioId: usuarioId ?? this.usuarioId,
    creadoEn: creadoEn ?? this.creadoEn,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    pendienteSync: pendienteSync ?? this.pendienteSync,
  );
  SavingsGoal copyWithCompanion(SavingsGoalsCompanion data) {
    return SavingsGoal(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      montoMeta: data.montoMeta.present ? data.montoMeta.value : this.montoMeta,
      montoActual: data.montoActual.present
          ? data.montoActual.value
          : this.montoActual,
      fechaMeta: data.fechaMeta.present ? data.fechaMeta.value : this.fechaMeta,
      color: data.color.present ? data.color.value : this.color,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
      pendienteSync: data.pendienteSync.present
          ? data.pendienteSync.value
          : this.pendienteSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoal(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('emoji: $emoji, ')
          ..write('montoMeta: $montoMeta, ')
          ..write('montoActual: $montoActual, ')
          ..write('fechaMeta: $fechaMeta, ')
          ..write('color: $color, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('pendienteSync: $pendienteSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    emoji,
    montoMeta,
    montoActual,
    fechaMeta,
    color,
    usuarioId,
    creadoEn,
    actualizadoEn,
    pendienteSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsGoal &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.emoji == this.emoji &&
          other.montoMeta == this.montoMeta &&
          other.montoActual == this.montoActual &&
          other.fechaMeta == this.fechaMeta &&
          other.color == this.color &&
          other.usuarioId == this.usuarioId &&
          other.creadoEn == this.creadoEn &&
          other.actualizadoEn == this.actualizadoEn &&
          other.pendienteSync == this.pendienteSync);
}

class SavingsGoalsCompanion extends UpdateCompanion<SavingsGoal> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String> emoji;
  final Value<double> montoMeta;
  final Value<double> montoActual;
  final Value<DateTime?> fechaMeta;
  final Value<String> color;
  final Value<String> usuarioId;
  final Value<DateTime> creadoEn;
  final Value<DateTime> actualizadoEn;
  final Value<bool> pendienteSync;
  final Value<int> rowid;
  const SavingsGoalsCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.emoji = const Value.absent(),
    this.montoMeta = const Value.absent(),
    this.montoActual = const Value.absent(),
    this.fechaMeta = const Value.absent(),
    this.color = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavingsGoalsCompanion.insert({
    required String id,
    required String nombre,
    this.emoji = const Value.absent(),
    required double montoMeta,
    this.montoActual = const Value.absent(),
    this.fechaMeta = const Value.absent(),
    this.color = const Value.absent(),
    required String usuarioId,
    required DateTime creadoEn,
    this.actualizadoEn = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre),
       montoMeta = Value(montoMeta),
       usuarioId = Value(usuarioId),
       creadoEn = Value(creadoEn);
  static Insertable<SavingsGoal> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? emoji,
    Expression<double>? montoMeta,
    Expression<double>? montoActual,
    Expression<DateTime>? fechaMeta,
    Expression<String>? color,
    Expression<String>? usuarioId,
    Expression<DateTime>? creadoEn,
    Expression<DateTime>? actualizadoEn,
    Expression<bool>? pendienteSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (emoji != null) 'emoji': emoji,
      if (montoMeta != null) 'monto_meta': montoMeta,
      if (montoActual != null) 'monto_actual': montoActual,
      if (fechaMeta != null) 'fecha_meta': fechaMeta,
      if (color != null) 'color': color,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
      if (pendienteSync != null) 'pendiente_sync': pendienteSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavingsGoalsCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<String>? emoji,
    Value<double>? montoMeta,
    Value<double>? montoActual,
    Value<DateTime?>? fechaMeta,
    Value<String>? color,
    Value<String>? usuarioId,
    Value<DateTime>? creadoEn,
    Value<DateTime>? actualizadoEn,
    Value<bool>? pendienteSync,
    Value<int>? rowid,
  }) {
    return SavingsGoalsCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      emoji: emoji ?? this.emoji,
      montoMeta: montoMeta ?? this.montoMeta,
      montoActual: montoActual ?? this.montoActual,
      fechaMeta: fechaMeta ?? this.fechaMeta,
      color: color ?? this.color,
      usuarioId: usuarioId ?? this.usuarioId,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      pendienteSync: pendienteSync ?? this.pendienteSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (montoMeta.present) {
      map['monto_meta'] = Variable<double>(montoMeta.value);
    }
    if (montoActual.present) {
      map['monto_actual'] = Variable<double>(montoActual.value);
    }
    if (fechaMeta.present) {
      map['fecha_meta'] = Variable<DateTime>(fechaMeta.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    if (pendienteSync.present) {
      map['pendiente_sync'] = Variable<bool>(pendienteSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoalsCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('emoji: $emoji, ')
          ..write('montoMeta: $montoMeta, ')
          ..write('montoActual: $montoActual, ')
          ..write('fechaMeta: $fechaMeta, ')
          ..write('color: $color, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('pendienteSync: $pendienteSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DebtsTable extends Debts with TableInfo<$DebtsTable, Debt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebtsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conceptoMeta = const VerificationMeta(
    'concepto',
  );
  @override
  late final GeneratedColumn<String> concepto = GeneratedColumn<String>(
    'concepto',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _montoMeta = const VerificationMeta('monto');
  @override
  late final GeneratedColumn<double> monto = GeneratedColumn<double>(
    'monto',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<int> tipo = GeneratedColumn<int>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pagadoMeta = const VerificationMeta('pagado');
  @override
  late final GeneratedColumn<bool> pagado = GeneratedColumn<bool>(
    'pagado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pagado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _pendienteSyncMeta = const VerificationMeta(
    'pendienteSync',
  );
  @override
  late final GeneratedColumn<bool> pendienteSync = GeneratedColumn<bool>(
    'pendiente_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pendiente_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    concepto,
    monto,
    tipo,
    pagado,
    fecha,
    usuarioId,
    creadoEn,
    actualizadoEn,
    pendienteSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Debt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('concepto')) {
      context.handle(
        _conceptoMeta,
        concepto.isAcceptableOrUnknown(data['concepto']!, _conceptoMeta),
      );
    }
    if (data.containsKey('monto')) {
      context.handle(
        _montoMeta,
        monto.isAcceptableOrUnknown(data['monto']!, _montoMeta),
      );
    } else if (isInserting) {
      context.missing(_montoMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('pagado')) {
      context.handle(
        _pagadoMeta,
        pagado.isAcceptableOrUnknown(data['pagado']!, _pagadoMeta),
      );
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    } else if (isInserting) {
      context.missing(_creadoEnMeta);
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    if (data.containsKey('pendiente_sync')) {
      context.handle(
        _pendienteSyncMeta,
        pendienteSync.isAcceptableOrUnknown(
          data['pendiente_sync']!,
          _pendienteSyncMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Debt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Debt(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      concepto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}concepto'],
      )!,
      monto: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monto'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tipo'],
      )!,
      pagado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pagado'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usuario_id'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
      pendienteSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pendiente_sync'],
      )!,
    );
  }

  @override
  $DebtsTable createAlias(String alias) {
    return $DebtsTable(attachedDatabase, alias);
  }
}

class Debt extends DataClass implements Insertable<Debt> {
  final String id;
  final String nombre;
  final String concepto;
  final double monto;
  final int tipo;
  final bool pagado;
  final DateTime fecha;
  final String usuarioId;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  final bool pendienteSync;
  const Debt({
    required this.id,
    required this.nombre,
    required this.concepto,
    required this.monto,
    required this.tipo,
    required this.pagado,
    required this.fecha,
    required this.usuarioId,
    required this.creadoEn,
    required this.actualizadoEn,
    required this.pendienteSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['concepto'] = Variable<String>(concepto);
    map['monto'] = Variable<double>(monto);
    map['tipo'] = Variable<int>(tipo);
    map['pagado'] = Variable<bool>(pagado);
    map['fecha'] = Variable<DateTime>(fecha);
    map['usuario_id'] = Variable<String>(usuarioId);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    map['pendiente_sync'] = Variable<bool>(pendienteSync);
    return map;
  }

  DebtsCompanion toCompanion(bool nullToAbsent) {
    return DebtsCompanion(
      id: Value(id),
      nombre: Value(nombre),
      concepto: Value(concepto),
      monto: Value(monto),
      tipo: Value(tipo),
      pagado: Value(pagado),
      fecha: Value(fecha),
      usuarioId: Value(usuarioId),
      creadoEn: Value(creadoEn),
      actualizadoEn: Value(actualizadoEn),
      pendienteSync: Value(pendienteSync),
    );
  }

  factory Debt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Debt(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      concepto: serializer.fromJson<String>(json['concepto']),
      monto: serializer.fromJson<double>(json['monto']),
      tipo: serializer.fromJson<int>(json['tipo']),
      pagado: serializer.fromJson<bool>(json['pagado']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
      pendienteSync: serializer.fromJson<bool>(json['pendienteSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'concepto': serializer.toJson<String>(concepto),
      'monto': serializer.toJson<double>(monto),
      'tipo': serializer.toJson<int>(tipo),
      'pagado': serializer.toJson<bool>(pagado),
      'fecha': serializer.toJson<DateTime>(fecha),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
      'pendienteSync': serializer.toJson<bool>(pendienteSync),
    };
  }

  Debt copyWith({
    String? id,
    String? nombre,
    String? concepto,
    double? monto,
    int? tipo,
    bool? pagado,
    DateTime? fecha,
    String? usuarioId,
    DateTime? creadoEn,
    DateTime? actualizadoEn,
    bool? pendienteSync,
  }) => Debt(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    concepto: concepto ?? this.concepto,
    monto: monto ?? this.monto,
    tipo: tipo ?? this.tipo,
    pagado: pagado ?? this.pagado,
    fecha: fecha ?? this.fecha,
    usuarioId: usuarioId ?? this.usuarioId,
    creadoEn: creadoEn ?? this.creadoEn,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    pendienteSync: pendienteSync ?? this.pendienteSync,
  );
  Debt copyWithCompanion(DebtsCompanion data) {
    return Debt(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      concepto: data.concepto.present ? data.concepto.value : this.concepto,
      monto: data.monto.present ? data.monto.value : this.monto,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      pagado: data.pagado.present ? data.pagado.value : this.pagado,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
      pendienteSync: data.pendienteSync.present
          ? data.pendienteSync.value
          : this.pendienteSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Debt(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('concepto: $concepto, ')
          ..write('monto: $monto, ')
          ..write('tipo: $tipo, ')
          ..write('pagado: $pagado, ')
          ..write('fecha: $fecha, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('pendienteSync: $pendienteSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    concepto,
    monto,
    tipo,
    pagado,
    fecha,
    usuarioId,
    creadoEn,
    actualizadoEn,
    pendienteSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Debt &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.concepto == this.concepto &&
          other.monto == this.monto &&
          other.tipo == this.tipo &&
          other.pagado == this.pagado &&
          other.fecha == this.fecha &&
          other.usuarioId == this.usuarioId &&
          other.creadoEn == this.creadoEn &&
          other.actualizadoEn == this.actualizadoEn &&
          other.pendienteSync == this.pendienteSync);
}

class DebtsCompanion extends UpdateCompanion<Debt> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String> concepto;
  final Value<double> monto;
  final Value<int> tipo;
  final Value<bool> pagado;
  final Value<DateTime> fecha;
  final Value<String> usuarioId;
  final Value<DateTime> creadoEn;
  final Value<DateTime> actualizadoEn;
  final Value<bool> pendienteSync;
  final Value<int> rowid;
  const DebtsCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.concepto = const Value.absent(),
    this.monto = const Value.absent(),
    this.tipo = const Value.absent(),
    this.pagado = const Value.absent(),
    this.fecha = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DebtsCompanion.insert({
    required String id,
    required String nombre,
    this.concepto = const Value.absent(),
    required double monto,
    required int tipo,
    this.pagado = const Value.absent(),
    required DateTime fecha,
    required String usuarioId,
    required DateTime creadoEn,
    this.actualizadoEn = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre),
       monto = Value(monto),
       tipo = Value(tipo),
       fecha = Value(fecha),
       usuarioId = Value(usuarioId),
       creadoEn = Value(creadoEn);
  static Insertable<Debt> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? concepto,
    Expression<double>? monto,
    Expression<int>? tipo,
    Expression<bool>? pagado,
    Expression<DateTime>? fecha,
    Expression<String>? usuarioId,
    Expression<DateTime>? creadoEn,
    Expression<DateTime>? actualizadoEn,
    Expression<bool>? pendienteSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (concepto != null) 'concepto': concepto,
      if (monto != null) 'monto': monto,
      if (tipo != null) 'tipo': tipo,
      if (pagado != null) 'pagado': pagado,
      if (fecha != null) 'fecha': fecha,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
      if (pendienteSync != null) 'pendiente_sync': pendienteSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DebtsCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<String>? concepto,
    Value<double>? monto,
    Value<int>? tipo,
    Value<bool>? pagado,
    Value<DateTime>? fecha,
    Value<String>? usuarioId,
    Value<DateTime>? creadoEn,
    Value<DateTime>? actualizadoEn,
    Value<bool>? pendienteSync,
    Value<int>? rowid,
  }) {
    return DebtsCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      concepto: concepto ?? this.concepto,
      monto: monto ?? this.monto,
      tipo: tipo ?? this.tipo,
      pagado: pagado ?? this.pagado,
      fecha: fecha ?? this.fecha,
      usuarioId: usuarioId ?? this.usuarioId,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      pendienteSync: pendienteSync ?? this.pendienteSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (concepto.present) {
      map['concepto'] = Variable<String>(concepto.value);
    }
    if (monto.present) {
      map['monto'] = Variable<double>(monto.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<int>(tipo.value);
    }
    if (pagado.present) {
      map['pagado'] = Variable<bool>(pagado.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    if (pendienteSync.present) {
      map['pendiente_sync'] = Variable<bool>(pendienteSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebtsCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('concepto: $concepto, ')
          ..write('monto: $monto, ')
          ..write('tipo: $tipo, ')
          ..write('pagado: $pagado, ')
          ..write('fecha: $fecha, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('pendienteSync: $pendienteSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurringExpensesTable extends RecurringExpenses
    with TableInfo<$RecurringExpensesTable, RecurringExpense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaMeta = const VerificationMeta(
    'categoria',
  );
  @override
  late final GeneratedColumn<String> categoria = GeneratedColumn<String>(
    'categoria',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaEmojiMeta = const VerificationMeta(
    'categoriaEmoji',
  );
  @override
  late final GeneratedColumn<String> categoriaEmoji = GeneratedColumn<String>(
    'categoria_emoji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('📦'),
  );
  static const VerificationMeta _montoMeta = const VerificationMeta('monto');
  @override
  late final GeneratedColumn<double> monto = GeneratedColumn<double>(
    'monto',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frecuenciaMeta = const VerificationMeta(
    'frecuencia',
  );
  @override
  late final GeneratedColumn<int> frecuencia = GeneratedColumn<int>(
    'frecuencia',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _diaDelMesMeta = const VerificationMeta(
    'diaDelMes',
  );
  @override
  late final GeneratedColumn<int> diaDelMes = GeneratedColumn<int>(
    'dia_del_mes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _pendienteSyncMeta = const VerificationMeta(
    'pendienteSync',
  );
  @override
  late final GeneratedColumn<bool> pendienteSync = GeneratedColumn<bool>(
    'pendiente_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pendiente_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    categoria,
    categoriaEmoji,
    monto,
    frecuencia,
    diaDelMes,
    activo,
    usuarioId,
    creadoEn,
    actualizadoEn,
    pendienteSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecurringExpense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('categoria')) {
      context.handle(
        _categoriaMeta,
        categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta),
      );
    } else if (isInserting) {
      context.missing(_categoriaMeta);
    }
    if (data.containsKey('categoria_emoji')) {
      context.handle(
        _categoriaEmojiMeta,
        categoriaEmoji.isAcceptableOrUnknown(
          data['categoria_emoji']!,
          _categoriaEmojiMeta,
        ),
      );
    }
    if (data.containsKey('monto')) {
      context.handle(
        _montoMeta,
        monto.isAcceptableOrUnknown(data['monto']!, _montoMeta),
      );
    } else if (isInserting) {
      context.missing(_montoMeta);
    }
    if (data.containsKey('frecuencia')) {
      context.handle(
        _frecuenciaMeta,
        frecuencia.isAcceptableOrUnknown(data['frecuencia']!, _frecuenciaMeta),
      );
    }
    if (data.containsKey('dia_del_mes')) {
      context.handle(
        _diaDelMesMeta,
        diaDelMes.isAcceptableOrUnknown(data['dia_del_mes']!, _diaDelMesMeta),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    } else if (isInserting) {
      context.missing(_creadoEnMeta);
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    if (data.containsKey('pendiente_sync')) {
      context.handle(
        _pendienteSyncMeta,
        pendienteSync.isAcceptableOrUnknown(
          data['pendiente_sync']!,
          _pendienteSyncMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringExpense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringExpense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      categoria: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria'],
      )!,
      categoriaEmoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria_emoji'],
      )!,
      monto: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monto'],
      )!,
      frecuencia: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frecuencia'],
      )!,
      diaDelMes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dia_del_mes'],
      )!,
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usuario_id'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
      pendienteSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pendiente_sync'],
      )!,
    );
  }

  @override
  $RecurringExpensesTable createAlias(String alias) {
    return $RecurringExpensesTable(attachedDatabase, alias);
  }
}

class RecurringExpense extends DataClass
    implements Insertable<RecurringExpense> {
  final String id;
  final String nombre;
  final String categoria;
  final String categoriaEmoji;
  final double monto;
  final int frecuencia;
  final int diaDelMes;
  final bool activo;
  final String usuarioId;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  final bool pendienteSync;
  const RecurringExpense({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.categoriaEmoji,
    required this.monto,
    required this.frecuencia,
    required this.diaDelMes,
    required this.activo,
    required this.usuarioId,
    required this.creadoEn,
    required this.actualizadoEn,
    required this.pendienteSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['categoria'] = Variable<String>(categoria);
    map['categoria_emoji'] = Variable<String>(categoriaEmoji);
    map['monto'] = Variable<double>(monto);
    map['frecuencia'] = Variable<int>(frecuencia);
    map['dia_del_mes'] = Variable<int>(diaDelMes);
    map['activo'] = Variable<bool>(activo);
    map['usuario_id'] = Variable<String>(usuarioId);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    map['pendiente_sync'] = Variable<bool>(pendienteSync);
    return map;
  }

  RecurringExpensesCompanion toCompanion(bool nullToAbsent) {
    return RecurringExpensesCompanion(
      id: Value(id),
      nombre: Value(nombre),
      categoria: Value(categoria),
      categoriaEmoji: Value(categoriaEmoji),
      monto: Value(monto),
      frecuencia: Value(frecuencia),
      diaDelMes: Value(diaDelMes),
      activo: Value(activo),
      usuarioId: Value(usuarioId),
      creadoEn: Value(creadoEn),
      actualizadoEn: Value(actualizadoEn),
      pendienteSync: Value(pendienteSync),
    );
  }

  factory RecurringExpense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringExpense(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      categoria: serializer.fromJson<String>(json['categoria']),
      categoriaEmoji: serializer.fromJson<String>(json['categoriaEmoji']),
      monto: serializer.fromJson<double>(json['monto']),
      frecuencia: serializer.fromJson<int>(json['frecuencia']),
      diaDelMes: serializer.fromJson<int>(json['diaDelMes']),
      activo: serializer.fromJson<bool>(json['activo']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
      pendienteSync: serializer.fromJson<bool>(json['pendienteSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'categoria': serializer.toJson<String>(categoria),
      'categoriaEmoji': serializer.toJson<String>(categoriaEmoji),
      'monto': serializer.toJson<double>(monto),
      'frecuencia': serializer.toJson<int>(frecuencia),
      'diaDelMes': serializer.toJson<int>(diaDelMes),
      'activo': serializer.toJson<bool>(activo),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
      'pendienteSync': serializer.toJson<bool>(pendienteSync),
    };
  }

  RecurringExpense copyWith({
    String? id,
    String? nombre,
    String? categoria,
    String? categoriaEmoji,
    double? monto,
    int? frecuencia,
    int? diaDelMes,
    bool? activo,
    String? usuarioId,
    DateTime? creadoEn,
    DateTime? actualizadoEn,
    bool? pendienteSync,
  }) => RecurringExpense(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    categoria: categoria ?? this.categoria,
    categoriaEmoji: categoriaEmoji ?? this.categoriaEmoji,
    monto: monto ?? this.monto,
    frecuencia: frecuencia ?? this.frecuencia,
    diaDelMes: diaDelMes ?? this.diaDelMes,
    activo: activo ?? this.activo,
    usuarioId: usuarioId ?? this.usuarioId,
    creadoEn: creadoEn ?? this.creadoEn,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    pendienteSync: pendienteSync ?? this.pendienteSync,
  );
  RecurringExpense copyWithCompanion(RecurringExpensesCompanion data) {
    return RecurringExpense(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      categoriaEmoji: data.categoriaEmoji.present
          ? data.categoriaEmoji.value
          : this.categoriaEmoji,
      monto: data.monto.present ? data.monto.value : this.monto,
      frecuencia: data.frecuencia.present
          ? data.frecuencia.value
          : this.frecuencia,
      diaDelMes: data.diaDelMes.present ? data.diaDelMes.value : this.diaDelMes,
      activo: data.activo.present ? data.activo.value : this.activo,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
      pendienteSync: data.pendienteSync.present
          ? data.pendienteSync.value
          : this.pendienteSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringExpense(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('categoria: $categoria, ')
          ..write('categoriaEmoji: $categoriaEmoji, ')
          ..write('monto: $monto, ')
          ..write('frecuencia: $frecuencia, ')
          ..write('diaDelMes: $diaDelMes, ')
          ..write('activo: $activo, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('pendienteSync: $pendienteSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    categoria,
    categoriaEmoji,
    monto,
    frecuencia,
    diaDelMes,
    activo,
    usuarioId,
    creadoEn,
    actualizadoEn,
    pendienteSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringExpense &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.categoria == this.categoria &&
          other.categoriaEmoji == this.categoriaEmoji &&
          other.monto == this.monto &&
          other.frecuencia == this.frecuencia &&
          other.diaDelMes == this.diaDelMes &&
          other.activo == this.activo &&
          other.usuarioId == this.usuarioId &&
          other.creadoEn == this.creadoEn &&
          other.actualizadoEn == this.actualizadoEn &&
          other.pendienteSync == this.pendienteSync);
}

class RecurringExpensesCompanion extends UpdateCompanion<RecurringExpense> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String> categoria;
  final Value<String> categoriaEmoji;
  final Value<double> monto;
  final Value<int> frecuencia;
  final Value<int> diaDelMes;
  final Value<bool> activo;
  final Value<String> usuarioId;
  final Value<DateTime> creadoEn;
  final Value<DateTime> actualizadoEn;
  final Value<bool> pendienteSync;
  final Value<int> rowid;
  const RecurringExpensesCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.categoria = const Value.absent(),
    this.categoriaEmoji = const Value.absent(),
    this.monto = const Value.absent(),
    this.frecuencia = const Value.absent(),
    this.diaDelMes = const Value.absent(),
    this.activo = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurringExpensesCompanion.insert({
    required String id,
    required String nombre,
    required String categoria,
    this.categoriaEmoji = const Value.absent(),
    required double monto,
    this.frecuencia = const Value.absent(),
    this.diaDelMes = const Value.absent(),
    this.activo = const Value.absent(),
    required String usuarioId,
    required DateTime creadoEn,
    this.actualizadoEn = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre),
       categoria = Value(categoria),
       monto = Value(monto),
       usuarioId = Value(usuarioId),
       creadoEn = Value(creadoEn);
  static Insertable<RecurringExpense> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? categoria,
    Expression<String>? categoriaEmoji,
    Expression<double>? monto,
    Expression<int>? frecuencia,
    Expression<int>? diaDelMes,
    Expression<bool>? activo,
    Expression<String>? usuarioId,
    Expression<DateTime>? creadoEn,
    Expression<DateTime>? actualizadoEn,
    Expression<bool>? pendienteSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (categoria != null) 'categoria': categoria,
      if (categoriaEmoji != null) 'categoria_emoji': categoriaEmoji,
      if (monto != null) 'monto': monto,
      if (frecuencia != null) 'frecuencia': frecuencia,
      if (diaDelMes != null) 'dia_del_mes': diaDelMes,
      if (activo != null) 'activo': activo,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
      if (pendienteSync != null) 'pendiente_sync': pendienteSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurringExpensesCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<String>? categoria,
    Value<String>? categoriaEmoji,
    Value<double>? monto,
    Value<int>? frecuencia,
    Value<int>? diaDelMes,
    Value<bool>? activo,
    Value<String>? usuarioId,
    Value<DateTime>? creadoEn,
    Value<DateTime>? actualizadoEn,
    Value<bool>? pendienteSync,
    Value<int>? rowid,
  }) {
    return RecurringExpensesCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      categoria: categoria ?? this.categoria,
      categoriaEmoji: categoriaEmoji ?? this.categoriaEmoji,
      monto: monto ?? this.monto,
      frecuencia: frecuencia ?? this.frecuencia,
      diaDelMes: diaDelMes ?? this.diaDelMes,
      activo: activo ?? this.activo,
      usuarioId: usuarioId ?? this.usuarioId,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      pendienteSync: pendienteSync ?? this.pendienteSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (categoriaEmoji.present) {
      map['categoria_emoji'] = Variable<String>(categoriaEmoji.value);
    }
    if (monto.present) {
      map['monto'] = Variable<double>(monto.value);
    }
    if (frecuencia.present) {
      map['frecuencia'] = Variable<int>(frecuencia.value);
    }
    if (diaDelMes.present) {
      map['dia_del_mes'] = Variable<int>(diaDelMes.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    if (pendienteSync.present) {
      map['pendiente_sync'] = Variable<bool>(pendienteSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringExpensesCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('categoria: $categoria, ')
          ..write('categoriaEmoji: $categoriaEmoji, ')
          ..write('monto: $monto, ')
          ..write('frecuencia: $frecuencia, ')
          ..write('diaDelMes: $diaDelMes, ')
          ..write('activo: $activo, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('pendienteSync: $pendienteSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EventsTable extends Events with TableInfo<$EventsTable, Event> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  @override
  late final GeneratedColumn<String> titulo = GeneratedColumn<String>(
    'titulo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _horaMeta = const VerificationMeta('hora');
  @override
  late final GeneratedColumn<String> hora = GeneratedColumn<String>(
    'hora',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _duracionMinutosMeta = const VerificationMeta(
    'duracionMinutos',
  );
  @override
  late final GeneratedColumn<int> duracionMinutos = GeneratedColumn<int>(
    'duracion_minutos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(60),
  );
  static const VerificationMeta _todoElDiaMeta = const VerificationMeta(
    'todoElDia',
  );
  @override
  late final GeneratedColumn<bool> todoElDia = GeneratedColumn<bool>(
    'todo_el_dia',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("todo_el_dia" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completadoMeta = const VerificationMeta(
    'completado',
  );
  @override
  late final GeneratedColumn<bool> completado = GeneratedColumn<bool>(
    'completado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#6750A4'),
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('evento'),
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _pendienteSyncMeta = const VerificationMeta(
    'pendienteSync',
  );
  @override
  late final GeneratedColumn<bool> pendienteSync = GeneratedColumn<bool>(
    'pendiente_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pendiente_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    titulo,
    descripcion,
    fecha,
    hora,
    duracionMinutos,
    todoElDia,
    completado,
    color,
    tipo,
    usuarioId,
    creadoEn,
    actualizadoEn,
    pendienteSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(
    Insertable<Event> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('titulo')) {
      context.handle(
        _tituloMeta,
        titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta),
      );
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('hora')) {
      context.handle(
        _horaMeta,
        hora.isAcceptableOrUnknown(data['hora']!, _horaMeta),
      );
    }
    if (data.containsKey('duracion_minutos')) {
      context.handle(
        _duracionMinutosMeta,
        duracionMinutos.isAcceptableOrUnknown(
          data['duracion_minutos']!,
          _duracionMinutosMeta,
        ),
      );
    }
    if (data.containsKey('todo_el_dia')) {
      context.handle(
        _todoElDiaMeta,
        todoElDia.isAcceptableOrUnknown(data['todo_el_dia']!, _todoElDiaMeta),
      );
    }
    if (data.containsKey('completado')) {
      context.handle(
        _completadoMeta,
        completado.isAcceptableOrUnknown(data['completado']!, _completadoMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    } else if (isInserting) {
      context.missing(_creadoEnMeta);
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    if (data.containsKey('pendiente_sync')) {
      context.handle(
        _pendienteSyncMeta,
        pendienteSync.isAcceptableOrUnknown(
          data['pendiente_sync']!,
          _pendienteSyncMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Event map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Event(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      titulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titulo'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      ),
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      hora: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hora'],
      ),
      duracionMinutos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duracion_minutos'],
      )!,
      todoElDia: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}todo_el_dia'],
      )!,
      completado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completado'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usuario_id'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
      pendienteSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pendiente_sync'],
      )!,
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }
}

class Event extends DataClass implements Insertable<Event> {
  final String id;
  final String titulo;
  final String? descripcion;
  final DateTime fecha;
  final String? hora;

  /// Cuánto dura el evento, en minutos. Sin esto no se puede dibujar un bloque
  /// en la rejilla horaria: habría que inventarse su altura. Se guardan minutos
  /// en vez de una hora de fin para no tratar como caso especial los eventos
  /// que se pasan de la medianoche.
  final int duracionMinutos;
  final bool todoElDia;
  final bool completado;
  final String color;
  final String tipo;
  final String usuarioId;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  final bool pendienteSync;
  const Event({
    required this.id,
    required this.titulo,
    this.descripcion,
    required this.fecha,
    this.hora,
    required this.duracionMinutos,
    required this.todoElDia,
    required this.completado,
    required this.color,
    required this.tipo,
    required this.usuarioId,
    required this.creadoEn,
    required this.actualizadoEn,
    required this.pendienteSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['titulo'] = Variable<String>(titulo);
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    map['fecha'] = Variable<DateTime>(fecha);
    if (!nullToAbsent || hora != null) {
      map['hora'] = Variable<String>(hora);
    }
    map['duracion_minutos'] = Variable<int>(duracionMinutos);
    map['todo_el_dia'] = Variable<bool>(todoElDia);
    map['completado'] = Variable<bool>(completado);
    map['color'] = Variable<String>(color);
    map['tipo'] = Variable<String>(tipo);
    map['usuario_id'] = Variable<String>(usuarioId);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    map['pendiente_sync'] = Variable<bool>(pendienteSync);
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      titulo: Value(titulo),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      fecha: Value(fecha),
      hora: hora == null && nullToAbsent ? const Value.absent() : Value(hora),
      duracionMinutos: Value(duracionMinutos),
      todoElDia: Value(todoElDia),
      completado: Value(completado),
      color: Value(color),
      tipo: Value(tipo),
      usuarioId: Value(usuarioId),
      creadoEn: Value(creadoEn),
      actualizadoEn: Value(actualizadoEn),
      pendienteSync: Value(pendienteSync),
    );
  }

  factory Event.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Event(
      id: serializer.fromJson<String>(json['id']),
      titulo: serializer.fromJson<String>(json['titulo']),
      descripcion: serializer.fromJson<String?>(json['descripcion']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      hora: serializer.fromJson<String?>(json['hora']),
      duracionMinutos: serializer.fromJson<int>(json['duracionMinutos']),
      todoElDia: serializer.fromJson<bool>(json['todoElDia']),
      completado: serializer.fromJson<bool>(json['completado']),
      color: serializer.fromJson<String>(json['color']),
      tipo: serializer.fromJson<String>(json['tipo']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
      pendienteSync: serializer.fromJson<bool>(json['pendienteSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'titulo': serializer.toJson<String>(titulo),
      'descripcion': serializer.toJson<String?>(descripcion),
      'fecha': serializer.toJson<DateTime>(fecha),
      'hora': serializer.toJson<String?>(hora),
      'duracionMinutos': serializer.toJson<int>(duracionMinutos),
      'todoElDia': serializer.toJson<bool>(todoElDia),
      'completado': serializer.toJson<bool>(completado),
      'color': serializer.toJson<String>(color),
      'tipo': serializer.toJson<String>(tipo),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
      'pendienteSync': serializer.toJson<bool>(pendienteSync),
    };
  }

  Event copyWith({
    String? id,
    String? titulo,
    Value<String?> descripcion = const Value.absent(),
    DateTime? fecha,
    Value<String?> hora = const Value.absent(),
    int? duracionMinutos,
    bool? todoElDia,
    bool? completado,
    String? color,
    String? tipo,
    String? usuarioId,
    DateTime? creadoEn,
    DateTime? actualizadoEn,
    bool? pendienteSync,
  }) => Event(
    id: id ?? this.id,
    titulo: titulo ?? this.titulo,
    descripcion: descripcion.present ? descripcion.value : this.descripcion,
    fecha: fecha ?? this.fecha,
    hora: hora.present ? hora.value : this.hora,
    duracionMinutos: duracionMinutos ?? this.duracionMinutos,
    todoElDia: todoElDia ?? this.todoElDia,
    completado: completado ?? this.completado,
    color: color ?? this.color,
    tipo: tipo ?? this.tipo,
    usuarioId: usuarioId ?? this.usuarioId,
    creadoEn: creadoEn ?? this.creadoEn,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    pendienteSync: pendienteSync ?? this.pendienteSync,
  );
  Event copyWithCompanion(EventsCompanion data) {
    return Event(
      id: data.id.present ? data.id.value : this.id,
      titulo: data.titulo.present ? data.titulo.value : this.titulo,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      hora: data.hora.present ? data.hora.value : this.hora,
      duracionMinutos: data.duracionMinutos.present
          ? data.duracionMinutos.value
          : this.duracionMinutos,
      todoElDia: data.todoElDia.present ? data.todoElDia.value : this.todoElDia,
      completado: data.completado.present
          ? data.completado.value
          : this.completado,
      color: data.color.present ? data.color.value : this.color,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
      pendienteSync: data.pendienteSync.present
          ? data.pendienteSync.value
          : this.pendienteSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Event(')
          ..write('id: $id, ')
          ..write('titulo: $titulo, ')
          ..write('descripcion: $descripcion, ')
          ..write('fecha: $fecha, ')
          ..write('hora: $hora, ')
          ..write('duracionMinutos: $duracionMinutos, ')
          ..write('todoElDia: $todoElDia, ')
          ..write('completado: $completado, ')
          ..write('color: $color, ')
          ..write('tipo: $tipo, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('pendienteSync: $pendienteSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    titulo,
    descripcion,
    fecha,
    hora,
    duracionMinutos,
    todoElDia,
    completado,
    color,
    tipo,
    usuarioId,
    creadoEn,
    actualizadoEn,
    pendienteSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          other.id == this.id &&
          other.titulo == this.titulo &&
          other.descripcion == this.descripcion &&
          other.fecha == this.fecha &&
          other.hora == this.hora &&
          other.duracionMinutos == this.duracionMinutos &&
          other.todoElDia == this.todoElDia &&
          other.completado == this.completado &&
          other.color == this.color &&
          other.tipo == this.tipo &&
          other.usuarioId == this.usuarioId &&
          other.creadoEn == this.creadoEn &&
          other.actualizadoEn == this.actualizadoEn &&
          other.pendienteSync == this.pendienteSync);
}

class EventsCompanion extends UpdateCompanion<Event> {
  final Value<String> id;
  final Value<String> titulo;
  final Value<String?> descripcion;
  final Value<DateTime> fecha;
  final Value<String?> hora;
  final Value<int> duracionMinutos;
  final Value<bool> todoElDia;
  final Value<bool> completado;
  final Value<String> color;
  final Value<String> tipo;
  final Value<String> usuarioId;
  final Value<DateTime> creadoEn;
  final Value<DateTime> actualizadoEn;
  final Value<bool> pendienteSync;
  final Value<int> rowid;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.titulo = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.fecha = const Value.absent(),
    this.hora = const Value.absent(),
    this.duracionMinutos = const Value.absent(),
    this.todoElDia = const Value.absent(),
    this.completado = const Value.absent(),
    this.color = const Value.absent(),
    this.tipo = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventsCompanion.insert({
    required String id,
    required String titulo,
    this.descripcion = const Value.absent(),
    required DateTime fecha,
    this.hora = const Value.absent(),
    this.duracionMinutos = const Value.absent(),
    this.todoElDia = const Value.absent(),
    this.completado = const Value.absent(),
    this.color = const Value.absent(),
    this.tipo = const Value.absent(),
    required String usuarioId,
    required DateTime creadoEn,
    this.actualizadoEn = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       titulo = Value(titulo),
       fecha = Value(fecha),
       usuarioId = Value(usuarioId),
       creadoEn = Value(creadoEn);
  static Insertable<Event> custom({
    Expression<String>? id,
    Expression<String>? titulo,
    Expression<String>? descripcion,
    Expression<DateTime>? fecha,
    Expression<String>? hora,
    Expression<int>? duracionMinutos,
    Expression<bool>? todoElDia,
    Expression<bool>? completado,
    Expression<String>? color,
    Expression<String>? tipo,
    Expression<String>? usuarioId,
    Expression<DateTime>? creadoEn,
    Expression<DateTime>? actualizadoEn,
    Expression<bool>? pendienteSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (titulo != null) 'titulo': titulo,
      if (descripcion != null) 'descripcion': descripcion,
      if (fecha != null) 'fecha': fecha,
      if (hora != null) 'hora': hora,
      if (duracionMinutos != null) 'duracion_minutos': duracionMinutos,
      if (todoElDia != null) 'todo_el_dia': todoElDia,
      if (completado != null) 'completado': completado,
      if (color != null) 'color': color,
      if (tipo != null) 'tipo': tipo,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
      if (pendienteSync != null) 'pendiente_sync': pendienteSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventsCompanion copyWith({
    Value<String>? id,
    Value<String>? titulo,
    Value<String?>? descripcion,
    Value<DateTime>? fecha,
    Value<String?>? hora,
    Value<int>? duracionMinutos,
    Value<bool>? todoElDia,
    Value<bool>? completado,
    Value<String>? color,
    Value<String>? tipo,
    Value<String>? usuarioId,
    Value<DateTime>? creadoEn,
    Value<DateTime>? actualizadoEn,
    Value<bool>? pendienteSync,
    Value<int>? rowid,
  }) {
    return EventsCompanion(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      fecha: fecha ?? this.fecha,
      hora: hora ?? this.hora,
      duracionMinutos: duracionMinutos ?? this.duracionMinutos,
      todoElDia: todoElDia ?? this.todoElDia,
      completado: completado ?? this.completado,
      color: color ?? this.color,
      tipo: tipo ?? this.tipo,
      usuarioId: usuarioId ?? this.usuarioId,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      pendienteSync: pendienteSync ?? this.pendienteSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (hora.present) {
      map['hora'] = Variable<String>(hora.value);
    }
    if (duracionMinutos.present) {
      map['duracion_minutos'] = Variable<int>(duracionMinutos.value);
    }
    if (todoElDia.present) {
      map['todo_el_dia'] = Variable<bool>(todoElDia.value);
    }
    if (completado.present) {
      map['completado'] = Variable<bool>(completado.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    if (pendienteSync.present) {
      map['pendiente_sync'] = Variable<bool>(pendienteSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('titulo: $titulo, ')
          ..write('descripcion: $descripcion, ')
          ..write('fecha: $fecha, ')
          ..write('hora: $hora, ')
          ..write('duracionMinutos: $duracionMinutos, ')
          ..write('todoElDia: $todoElDia, ')
          ..write('completado: $completado, ')
          ..write('color: $color, ')
          ..write('tipo: $tipo, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('pendienteSync: $pendienteSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitsTable extends Habits with TableInfo<$HabitsTable, Habit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconoMeta = const VerificationMeta('icono');
  @override
  late final GeneratedColumn<String> icono = GeneratedColumn<String>(
    'icono',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('⭐'),
  );
  static const VerificationMeta _categoriaMeta = const VerificationMeta(
    'categoria',
  );
  @override
  late final GeneratedColumn<int> categoria = GeneratedColumn<int>(
    'categoria',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _frecuenciaMeta = const VerificationMeta(
    'frecuencia',
  );
  @override
  late final GeneratedColumn<int> frecuencia = GeneratedColumn<int>(
    'frecuencia',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _metaSemanalMeta = const VerificationMeta(
    'metaSemanal',
  );
  @override
  late final GeneratedColumn<int> metaSemanal = GeneratedColumn<int>(
    'meta_semanal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(7),
  );
  static const VerificationMeta _completadoHoyMeta = const VerificationMeta(
    'completadoHoy',
  );
  @override
  late final GeneratedColumn<bool> completadoHoy = GeneratedColumn<bool>(
    'completado_hoy',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completado_hoy" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _rachaActualMeta = const VerificationMeta(
    'rachaActual',
  );
  @override
  late final GeneratedColumn<int> rachaActual = GeneratedColumn<int>(
    'racha_actual',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _rachaMaximaMeta = const VerificationMeta(
    'rachaMaxima',
  );
  @override
  late final GeneratedColumn<int> rachaMaxima = GeneratedColumn<int>(
    'racha_maxima',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalCompletadosMeta = const VerificationMeta(
    'totalCompletados',
  );
  @override
  late final GeneratedColumn<int> totalCompletados = GeneratedColumn<int>(
    'total_completados',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#1E88E5'),
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _pendienteSyncMeta = const VerificationMeta(
    'pendienteSync',
  );
  @override
  late final GeneratedColumn<bool> pendienteSync = GeneratedColumn<bool>(
    'pendiente_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pendiente_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    icono,
    categoria,
    frecuencia,
    metaSemanal,
    completadoHoy,
    rachaActual,
    rachaMaxima,
    totalCompletados,
    color,
    usuarioId,
    creadoEn,
    actualizadoEn,
    pendienteSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits';
  @override
  VerificationContext validateIntegrity(
    Insertable<Habit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('icono')) {
      context.handle(
        _iconoMeta,
        icono.isAcceptableOrUnknown(data['icono']!, _iconoMeta),
      );
    }
    if (data.containsKey('categoria')) {
      context.handle(
        _categoriaMeta,
        categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta),
      );
    }
    if (data.containsKey('frecuencia')) {
      context.handle(
        _frecuenciaMeta,
        frecuencia.isAcceptableOrUnknown(data['frecuencia']!, _frecuenciaMeta),
      );
    }
    if (data.containsKey('meta_semanal')) {
      context.handle(
        _metaSemanalMeta,
        metaSemanal.isAcceptableOrUnknown(
          data['meta_semanal']!,
          _metaSemanalMeta,
        ),
      );
    }
    if (data.containsKey('completado_hoy')) {
      context.handle(
        _completadoHoyMeta,
        completadoHoy.isAcceptableOrUnknown(
          data['completado_hoy']!,
          _completadoHoyMeta,
        ),
      );
    }
    if (data.containsKey('racha_actual')) {
      context.handle(
        _rachaActualMeta,
        rachaActual.isAcceptableOrUnknown(
          data['racha_actual']!,
          _rachaActualMeta,
        ),
      );
    }
    if (data.containsKey('racha_maxima')) {
      context.handle(
        _rachaMaximaMeta,
        rachaMaxima.isAcceptableOrUnknown(
          data['racha_maxima']!,
          _rachaMaximaMeta,
        ),
      );
    }
    if (data.containsKey('total_completados')) {
      context.handle(
        _totalCompletadosMeta,
        totalCompletados.isAcceptableOrUnknown(
          data['total_completados']!,
          _totalCompletadosMeta,
        ),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    if (data.containsKey('pendiente_sync')) {
      context.handle(
        _pendienteSyncMeta,
        pendienteSync.isAcceptableOrUnknown(
          data['pendiente_sync']!,
          _pendienteSyncMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Habit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Habit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      icono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icono'],
      )!,
      categoria: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}categoria'],
      )!,
      frecuencia: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frecuencia'],
      )!,
      metaSemanal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}meta_semanal'],
      )!,
      completadoHoy: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completado_hoy'],
      )!,
      rachaActual: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}racha_actual'],
      )!,
      rachaMaxima: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}racha_maxima'],
      )!,
      totalCompletados: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_completados'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usuario_id'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
      pendienteSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pendiente_sync'],
      )!,
    );
  }

  @override
  $HabitsTable createAlias(String alias) {
    return $HabitsTable(attachedDatabase, alias);
  }
}

class Habit extends DataClass implements Insertable<Habit> {
  final String id;
  final String nombre;
  final String icono;
  final int categoria;
  final int frecuencia;
  final int metaSemanal;
  final bool completadoHoy;
  final int rachaActual;
  final int rachaMaxima;
  final int totalCompletados;
  final String color;
  final String usuarioId;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  final bool pendienteSync;
  const Habit({
    required this.id,
    required this.nombre,
    required this.icono,
    required this.categoria,
    required this.frecuencia,
    required this.metaSemanal,
    required this.completadoHoy,
    required this.rachaActual,
    required this.rachaMaxima,
    required this.totalCompletados,
    required this.color,
    required this.usuarioId,
    required this.creadoEn,
    required this.actualizadoEn,
    required this.pendienteSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['icono'] = Variable<String>(icono);
    map['categoria'] = Variable<int>(categoria);
    map['frecuencia'] = Variable<int>(frecuencia);
    map['meta_semanal'] = Variable<int>(metaSemanal);
    map['completado_hoy'] = Variable<bool>(completadoHoy);
    map['racha_actual'] = Variable<int>(rachaActual);
    map['racha_maxima'] = Variable<int>(rachaMaxima);
    map['total_completados'] = Variable<int>(totalCompletados);
    map['color'] = Variable<String>(color);
    map['usuario_id'] = Variable<String>(usuarioId);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    map['pendiente_sync'] = Variable<bool>(pendienteSync);
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      id: Value(id),
      nombre: Value(nombre),
      icono: Value(icono),
      categoria: Value(categoria),
      frecuencia: Value(frecuencia),
      metaSemanal: Value(metaSemanal),
      completadoHoy: Value(completadoHoy),
      rachaActual: Value(rachaActual),
      rachaMaxima: Value(rachaMaxima),
      totalCompletados: Value(totalCompletados),
      color: Value(color),
      usuarioId: Value(usuarioId),
      creadoEn: Value(creadoEn),
      actualizadoEn: Value(actualizadoEn),
      pendienteSync: Value(pendienteSync),
    );
  }

  factory Habit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Habit(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      icono: serializer.fromJson<String>(json['icono']),
      categoria: serializer.fromJson<int>(json['categoria']),
      frecuencia: serializer.fromJson<int>(json['frecuencia']),
      metaSemanal: serializer.fromJson<int>(json['metaSemanal']),
      completadoHoy: serializer.fromJson<bool>(json['completadoHoy']),
      rachaActual: serializer.fromJson<int>(json['rachaActual']),
      rachaMaxima: serializer.fromJson<int>(json['rachaMaxima']),
      totalCompletados: serializer.fromJson<int>(json['totalCompletados']),
      color: serializer.fromJson<String>(json['color']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
      pendienteSync: serializer.fromJson<bool>(json['pendienteSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'icono': serializer.toJson<String>(icono),
      'categoria': serializer.toJson<int>(categoria),
      'frecuencia': serializer.toJson<int>(frecuencia),
      'metaSemanal': serializer.toJson<int>(metaSemanal),
      'completadoHoy': serializer.toJson<bool>(completadoHoy),
      'rachaActual': serializer.toJson<int>(rachaActual),
      'rachaMaxima': serializer.toJson<int>(rachaMaxima),
      'totalCompletados': serializer.toJson<int>(totalCompletados),
      'color': serializer.toJson<String>(color),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
      'pendienteSync': serializer.toJson<bool>(pendienteSync),
    };
  }

  Habit copyWith({
    String? id,
    String? nombre,
    String? icono,
    int? categoria,
    int? frecuencia,
    int? metaSemanal,
    bool? completadoHoy,
    int? rachaActual,
    int? rachaMaxima,
    int? totalCompletados,
    String? color,
    String? usuarioId,
    DateTime? creadoEn,
    DateTime? actualizadoEn,
    bool? pendienteSync,
  }) => Habit(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    icono: icono ?? this.icono,
    categoria: categoria ?? this.categoria,
    frecuencia: frecuencia ?? this.frecuencia,
    metaSemanal: metaSemanal ?? this.metaSemanal,
    completadoHoy: completadoHoy ?? this.completadoHoy,
    rachaActual: rachaActual ?? this.rachaActual,
    rachaMaxima: rachaMaxima ?? this.rachaMaxima,
    totalCompletados: totalCompletados ?? this.totalCompletados,
    color: color ?? this.color,
    usuarioId: usuarioId ?? this.usuarioId,
    creadoEn: creadoEn ?? this.creadoEn,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    pendienteSync: pendienteSync ?? this.pendienteSync,
  );
  Habit copyWithCompanion(HabitsCompanion data) {
    return Habit(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      icono: data.icono.present ? data.icono.value : this.icono,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      frecuencia: data.frecuencia.present
          ? data.frecuencia.value
          : this.frecuencia,
      metaSemanal: data.metaSemanal.present
          ? data.metaSemanal.value
          : this.metaSemanal,
      completadoHoy: data.completadoHoy.present
          ? data.completadoHoy.value
          : this.completadoHoy,
      rachaActual: data.rachaActual.present
          ? data.rachaActual.value
          : this.rachaActual,
      rachaMaxima: data.rachaMaxima.present
          ? data.rachaMaxima.value
          : this.rachaMaxima,
      totalCompletados: data.totalCompletados.present
          ? data.totalCompletados.value
          : this.totalCompletados,
      color: data.color.present ? data.color.value : this.color,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
      pendienteSync: data.pendienteSync.present
          ? data.pendienteSync.value
          : this.pendienteSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Habit(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('icono: $icono, ')
          ..write('categoria: $categoria, ')
          ..write('frecuencia: $frecuencia, ')
          ..write('metaSemanal: $metaSemanal, ')
          ..write('completadoHoy: $completadoHoy, ')
          ..write('rachaActual: $rachaActual, ')
          ..write('rachaMaxima: $rachaMaxima, ')
          ..write('totalCompletados: $totalCompletados, ')
          ..write('color: $color, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('pendienteSync: $pendienteSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    icono,
    categoria,
    frecuencia,
    metaSemanal,
    completadoHoy,
    rachaActual,
    rachaMaxima,
    totalCompletados,
    color,
    usuarioId,
    creadoEn,
    actualizadoEn,
    pendienteSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Habit &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.icono == this.icono &&
          other.categoria == this.categoria &&
          other.frecuencia == this.frecuencia &&
          other.metaSemanal == this.metaSemanal &&
          other.completadoHoy == this.completadoHoy &&
          other.rachaActual == this.rachaActual &&
          other.rachaMaxima == this.rachaMaxima &&
          other.totalCompletados == this.totalCompletados &&
          other.color == this.color &&
          other.usuarioId == this.usuarioId &&
          other.creadoEn == this.creadoEn &&
          other.actualizadoEn == this.actualizadoEn &&
          other.pendienteSync == this.pendienteSync);
}

class HabitsCompanion extends UpdateCompanion<Habit> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String> icono;
  final Value<int> categoria;
  final Value<int> frecuencia;
  final Value<int> metaSemanal;
  final Value<bool> completadoHoy;
  final Value<int> rachaActual;
  final Value<int> rachaMaxima;
  final Value<int> totalCompletados;
  final Value<String> color;
  final Value<String> usuarioId;
  final Value<DateTime> creadoEn;
  final Value<DateTime> actualizadoEn;
  final Value<bool> pendienteSync;
  final Value<int> rowid;
  const HabitsCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.icono = const Value.absent(),
    this.categoria = const Value.absent(),
    this.frecuencia = const Value.absent(),
    this.metaSemanal = const Value.absent(),
    this.completadoHoy = const Value.absent(),
    this.rachaActual = const Value.absent(),
    this.rachaMaxima = const Value.absent(),
    this.totalCompletados = const Value.absent(),
    this.color = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitsCompanion.insert({
    required String id,
    required String nombre,
    this.icono = const Value.absent(),
    this.categoria = const Value.absent(),
    this.frecuencia = const Value.absent(),
    this.metaSemanal = const Value.absent(),
    this.completadoHoy = const Value.absent(),
    this.rachaActual = const Value.absent(),
    this.rachaMaxima = const Value.absent(),
    this.totalCompletados = const Value.absent(),
    this.color = const Value.absent(),
    required String usuarioId,
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre),
       usuarioId = Value(usuarioId);
  static Insertable<Habit> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? icono,
    Expression<int>? categoria,
    Expression<int>? frecuencia,
    Expression<int>? metaSemanal,
    Expression<bool>? completadoHoy,
    Expression<int>? rachaActual,
    Expression<int>? rachaMaxima,
    Expression<int>? totalCompletados,
    Expression<String>? color,
    Expression<String>? usuarioId,
    Expression<DateTime>? creadoEn,
    Expression<DateTime>? actualizadoEn,
    Expression<bool>? pendienteSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (icono != null) 'icono': icono,
      if (categoria != null) 'categoria': categoria,
      if (frecuencia != null) 'frecuencia': frecuencia,
      if (metaSemanal != null) 'meta_semanal': metaSemanal,
      if (completadoHoy != null) 'completado_hoy': completadoHoy,
      if (rachaActual != null) 'racha_actual': rachaActual,
      if (rachaMaxima != null) 'racha_maxima': rachaMaxima,
      if (totalCompletados != null) 'total_completados': totalCompletados,
      if (color != null) 'color': color,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
      if (pendienteSync != null) 'pendiente_sync': pendienteSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitsCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<String>? icono,
    Value<int>? categoria,
    Value<int>? frecuencia,
    Value<int>? metaSemanal,
    Value<bool>? completadoHoy,
    Value<int>? rachaActual,
    Value<int>? rachaMaxima,
    Value<int>? totalCompletados,
    Value<String>? color,
    Value<String>? usuarioId,
    Value<DateTime>? creadoEn,
    Value<DateTime>? actualizadoEn,
    Value<bool>? pendienteSync,
    Value<int>? rowid,
  }) {
    return HabitsCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      icono: icono ?? this.icono,
      categoria: categoria ?? this.categoria,
      frecuencia: frecuencia ?? this.frecuencia,
      metaSemanal: metaSemanal ?? this.metaSemanal,
      completadoHoy: completadoHoy ?? this.completadoHoy,
      rachaActual: rachaActual ?? this.rachaActual,
      rachaMaxima: rachaMaxima ?? this.rachaMaxima,
      totalCompletados: totalCompletados ?? this.totalCompletados,
      color: color ?? this.color,
      usuarioId: usuarioId ?? this.usuarioId,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      pendienteSync: pendienteSync ?? this.pendienteSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (icono.present) {
      map['icono'] = Variable<String>(icono.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<int>(categoria.value);
    }
    if (frecuencia.present) {
      map['frecuencia'] = Variable<int>(frecuencia.value);
    }
    if (metaSemanal.present) {
      map['meta_semanal'] = Variable<int>(metaSemanal.value);
    }
    if (completadoHoy.present) {
      map['completado_hoy'] = Variable<bool>(completadoHoy.value);
    }
    if (rachaActual.present) {
      map['racha_actual'] = Variable<int>(rachaActual.value);
    }
    if (rachaMaxima.present) {
      map['racha_maxima'] = Variable<int>(rachaMaxima.value);
    }
    if (totalCompletados.present) {
      map['total_completados'] = Variable<int>(totalCompletados.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    if (pendienteSync.present) {
      map['pendiente_sync'] = Variable<bool>(pendienteSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('icono: $icono, ')
          ..write('categoria: $categoria, ')
          ..write('frecuencia: $frecuencia, ')
          ..write('metaSemanal: $metaSemanal, ')
          ..write('completadoHoy: $completadoHoy, ')
          ..write('rachaActual: $rachaActual, ')
          ..write('rachaMaxima: $rachaMaxima, ')
          ..write('totalCompletados: $totalCompletados, ')
          ..write('color: $color, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('pendienteSync: $pendienteSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitCompletionsTable extends HabitCompletions
    with TableInfo<$HabitCompletionsTable, HabitCompletion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitCompletionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pendienteSyncMeta = const VerificationMeta(
    'pendienteSync',
  );
  @override
  late final GeneratedColumn<bool> pendienteSync = GeneratedColumn<bool>(
    'pendiente_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pendiente_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    habitId,
    usuarioId,
    fecha,
    pendienteSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_completions';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitCompletion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('pendiente_sync')) {
      context.handle(
        _pendienteSyncMeta,
        pendienteSync.isAcceptableOrUnknown(
          data['pendiente_sync']!,
          _pendienteSyncMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitCompletion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitCompletion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habit_id'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usuario_id'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      pendienteSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pendiente_sync'],
      )!,
    );
  }

  @override
  $HabitCompletionsTable createAlias(String alias) {
    return $HabitCompletionsTable(attachedDatabase, alias);
  }
}

class HabitCompletion extends DataClass implements Insertable<HabitCompletion> {
  final String id;
  final String habitId;
  final String usuarioId;

  /// Solo se guarda la fecha (año-mes-día), sin hora
  final DateTime fecha;
  final bool pendienteSync;
  const HabitCompletion({
    required this.id,
    required this.habitId,
    required this.usuarioId,
    required this.fecha,
    required this.pendienteSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['habit_id'] = Variable<String>(habitId);
    map['usuario_id'] = Variable<String>(usuarioId);
    map['fecha'] = Variable<DateTime>(fecha);
    map['pendiente_sync'] = Variable<bool>(pendienteSync);
    return map;
  }

  HabitCompletionsCompanion toCompanion(bool nullToAbsent) {
    return HabitCompletionsCompanion(
      id: Value(id),
      habitId: Value(habitId),
      usuarioId: Value(usuarioId),
      fecha: Value(fecha),
      pendienteSync: Value(pendienteSync),
    );
  }

  factory HabitCompletion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitCompletion(
      id: serializer.fromJson<String>(json['id']),
      habitId: serializer.fromJson<String>(json['habitId']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      pendienteSync: serializer.fromJson<bool>(json['pendienteSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'habitId': serializer.toJson<String>(habitId),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'fecha': serializer.toJson<DateTime>(fecha),
      'pendienteSync': serializer.toJson<bool>(pendienteSync),
    };
  }

  HabitCompletion copyWith({
    String? id,
    String? habitId,
    String? usuarioId,
    DateTime? fecha,
    bool? pendienteSync,
  }) => HabitCompletion(
    id: id ?? this.id,
    habitId: habitId ?? this.habitId,
    usuarioId: usuarioId ?? this.usuarioId,
    fecha: fecha ?? this.fecha,
    pendienteSync: pendienteSync ?? this.pendienteSync,
  );
  HabitCompletion copyWithCompanion(HabitCompletionsCompanion data) {
    return HabitCompletion(
      id: data.id.present ? data.id.value : this.id,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      pendienteSync: data.pendienteSync.present
          ? data.pendienteSync.value
          : this.pendienteSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitCompletion(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('fecha: $fecha, ')
          ..write('pendienteSync: $pendienteSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, habitId, usuarioId, fecha, pendienteSync);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitCompletion &&
          other.id == this.id &&
          other.habitId == this.habitId &&
          other.usuarioId == this.usuarioId &&
          other.fecha == this.fecha &&
          other.pendienteSync == this.pendienteSync);
}

class HabitCompletionsCompanion extends UpdateCompanion<HabitCompletion> {
  final Value<String> id;
  final Value<String> habitId;
  final Value<String> usuarioId;
  final Value<DateTime> fecha;
  final Value<bool> pendienteSync;
  final Value<int> rowid;
  const HabitCompletionsCompanion({
    this.id = const Value.absent(),
    this.habitId = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.fecha = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitCompletionsCompanion.insert({
    required String id,
    required String habitId,
    required String usuarioId,
    required DateTime fecha,
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       habitId = Value(habitId),
       usuarioId = Value(usuarioId),
       fecha = Value(fecha);
  static Insertable<HabitCompletion> custom({
    Expression<String>? id,
    Expression<String>? habitId,
    Expression<String>? usuarioId,
    Expression<DateTime>? fecha,
    Expression<bool>? pendienteSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitId != null) 'habit_id': habitId,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (fecha != null) 'fecha': fecha,
      if (pendienteSync != null) 'pendiente_sync': pendienteSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitCompletionsCompanion copyWith({
    Value<String>? id,
    Value<String>? habitId,
    Value<String>? usuarioId,
    Value<DateTime>? fecha,
    Value<bool>? pendienteSync,
    Value<int>? rowid,
  }) {
    return HabitCompletionsCompanion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      usuarioId: usuarioId ?? this.usuarioId,
      fecha: fecha ?? this.fecha,
      pendienteSync: pendienteSync ?? this.pendienteSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (pendienteSync.present) {
      map['pendiente_sync'] = Variable<bool>(pendienteSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitCompletionsCompanion(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('fecha: $fecha, ')
          ..write('pendienteSync: $pendienteSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncTombstonesTable extends SyncTombstones
    with TableInfo<$SyncTombstonesTable, SyncTombstone> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncTombstonesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _filaIdMeta = const VerificationMeta('filaId');
  @override
  late final GeneratedColumn<String> filaId = GeneratedColumn<String>(
    'fila_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tablaMeta = const VerificationMeta('tabla');
  @override
  late final GeneratedColumn<String> tabla = GeneratedColumn<String>(
    'tabla',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _borradoEnMeta = const VerificationMeta(
    'borradoEn',
  );
  @override
  late final GeneratedColumn<DateTime> borradoEn = GeneratedColumn<DateTime>(
    'borrado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [filaId, tabla, usuarioId, borradoEn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_tombstones';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncTombstone> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('fila_id')) {
      context.handle(
        _filaIdMeta,
        filaId.isAcceptableOrUnknown(data['fila_id']!, _filaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_filaIdMeta);
    }
    if (data.containsKey('tabla')) {
      context.handle(
        _tablaMeta,
        tabla.isAcceptableOrUnknown(data['tabla']!, _tablaMeta),
      );
    } else if (isInserting) {
      context.missing(_tablaMeta);
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('borrado_en')) {
      context.handle(
        _borradoEnMeta,
        borradoEn.isAcceptableOrUnknown(data['borrado_en']!, _borradoEnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {filaId, tabla};
  @override
  SyncTombstone map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncTombstone(
      filaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fila_id'],
      )!,
      tabla: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tabla'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usuario_id'],
      )!,
      borradoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}borrado_en'],
      )!,
    );
  }

  @override
  $SyncTombstonesTable createAlias(String alias) {
    return $SyncTombstonesTable(attachedDatabase, alias);
  }
}

class SyncTombstone extends DataClass implements Insertable<SyncTombstone> {
  /// id de la fila borrada (mismo UUID que tenía en su tabla)
  final String filaId;

  /// nombre lógico de la tabla: 'habits' o 'habit_completions'
  final String tabla;
  final String usuarioId;
  final DateTime borradoEn;
  const SyncTombstone({
    required this.filaId,
    required this.tabla,
    required this.usuarioId,
    required this.borradoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['fila_id'] = Variable<String>(filaId);
    map['tabla'] = Variable<String>(tabla);
    map['usuario_id'] = Variable<String>(usuarioId);
    map['borrado_en'] = Variable<DateTime>(borradoEn);
    return map;
  }

  SyncTombstonesCompanion toCompanion(bool nullToAbsent) {
    return SyncTombstonesCompanion(
      filaId: Value(filaId),
      tabla: Value(tabla),
      usuarioId: Value(usuarioId),
      borradoEn: Value(borradoEn),
    );
  }

  factory SyncTombstone.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncTombstone(
      filaId: serializer.fromJson<String>(json['filaId']),
      tabla: serializer.fromJson<String>(json['tabla']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      borradoEn: serializer.fromJson<DateTime>(json['borradoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'filaId': serializer.toJson<String>(filaId),
      'tabla': serializer.toJson<String>(tabla),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'borradoEn': serializer.toJson<DateTime>(borradoEn),
    };
  }

  SyncTombstone copyWith({
    String? filaId,
    String? tabla,
    String? usuarioId,
    DateTime? borradoEn,
  }) => SyncTombstone(
    filaId: filaId ?? this.filaId,
    tabla: tabla ?? this.tabla,
    usuarioId: usuarioId ?? this.usuarioId,
    borradoEn: borradoEn ?? this.borradoEn,
  );
  SyncTombstone copyWithCompanion(SyncTombstonesCompanion data) {
    return SyncTombstone(
      filaId: data.filaId.present ? data.filaId.value : this.filaId,
      tabla: data.tabla.present ? data.tabla.value : this.tabla,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      borradoEn: data.borradoEn.present ? data.borradoEn.value : this.borradoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncTombstone(')
          ..write('filaId: $filaId, ')
          ..write('tabla: $tabla, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('borradoEn: $borradoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(filaId, tabla, usuarioId, borradoEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncTombstone &&
          other.filaId == this.filaId &&
          other.tabla == this.tabla &&
          other.usuarioId == this.usuarioId &&
          other.borradoEn == this.borradoEn);
}

class SyncTombstonesCompanion extends UpdateCompanion<SyncTombstone> {
  final Value<String> filaId;
  final Value<String> tabla;
  final Value<String> usuarioId;
  final Value<DateTime> borradoEn;
  final Value<int> rowid;
  const SyncTombstonesCompanion({
    this.filaId = const Value.absent(),
    this.tabla = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.borradoEn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncTombstonesCompanion.insert({
    required String filaId,
    required String tabla,
    required String usuarioId,
    this.borradoEn = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : filaId = Value(filaId),
       tabla = Value(tabla),
       usuarioId = Value(usuarioId);
  static Insertable<SyncTombstone> custom({
    Expression<String>? filaId,
    Expression<String>? tabla,
    Expression<String>? usuarioId,
    Expression<DateTime>? borradoEn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (filaId != null) 'fila_id': filaId,
      if (tabla != null) 'tabla': tabla,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (borradoEn != null) 'borrado_en': borradoEn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncTombstonesCompanion copyWith({
    Value<String>? filaId,
    Value<String>? tabla,
    Value<String>? usuarioId,
    Value<DateTime>? borradoEn,
    Value<int>? rowid,
  }) {
    return SyncTombstonesCompanion(
      filaId: filaId ?? this.filaId,
      tabla: tabla ?? this.tabla,
      usuarioId: usuarioId ?? this.usuarioId,
      borradoEn: borradoEn ?? this.borradoEn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (filaId.present) {
      map['fila_id'] = Variable<String>(filaId.value);
    }
    if (tabla.present) {
      map['tabla'] = Variable<String>(tabla.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (borradoEn.present) {
      map['borrado_en'] = Variable<DateTime>(borradoEn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncTombstonesCompanion(')
          ..write('filaId: $filaId, ')
          ..write('tabla: $tabla, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('borradoEn: $borradoEn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, Note> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  @override
  late final GeneratedColumn<String> titulo = GeneratedColumn<String>(
    'titulo',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contenidoMeta = const VerificationMeta(
    'contenido',
  );
  @override
  late final GeneratedColumn<String> contenido = GeneratedColumn<String>(
    'contenido',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _categoriaMeta = const VerificationMeta(
    'categoria',
  );
  @override
  late final GeneratedColumn<int> categoria = GeneratedColumn<int>(
    'categoria',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#FFF9C4'),
  );
  static const VerificationMeta _esFijadaMeta = const VerificationMeta(
    'esFijada',
  );
  @override
  late final GeneratedColumn<bool> esFijada = GeneratedColumn<bool>(
    'es_fijada',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_fijada" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _esChecklistMeta = const VerificationMeta(
    'esChecklist',
  );
  @override
  late final GeneratedColumn<bool> esChecklist = GeneratedColumn<bool>(
    'es_checklist',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_checklist" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _itemsJsonMeta = const VerificationMeta(
    'itemsJson',
  );
  @override
  late final GeneratedColumn<String> itemsJson = GeneratedColumn<String>(
    'items_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creadaEnMeta = const VerificationMeta(
    'creadaEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadaEn = GeneratedColumn<DateTime>(
    'creada_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _actualizadaEnMeta = const VerificationMeta(
    'actualizadaEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadaEn =
      GeneratedColumn<DateTime>(
        'actualizada_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _pendienteSyncMeta = const VerificationMeta(
    'pendienteSync',
  );
  @override
  late final GeneratedColumn<bool> pendienteSync = GeneratedColumn<bool>(
    'pendiente_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pendiente_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    titulo,
    contenido,
    categoria,
    color,
    esFijada,
    esChecklist,
    itemsJson,
    usuarioId,
    creadaEn,
    actualizadaEn,
    tags,
    actualizadoEn,
    pendienteSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Note> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('titulo')) {
      context.handle(
        _tituloMeta,
        titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta),
      );
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('contenido')) {
      context.handle(
        _contenidoMeta,
        contenido.isAcceptableOrUnknown(data['contenido']!, _contenidoMeta),
      );
    }
    if (data.containsKey('categoria')) {
      context.handle(
        _categoriaMeta,
        categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('es_fijada')) {
      context.handle(
        _esFijadaMeta,
        esFijada.isAcceptableOrUnknown(data['es_fijada']!, _esFijadaMeta),
      );
    }
    if (data.containsKey('es_checklist')) {
      context.handle(
        _esChecklistMeta,
        esChecklist.isAcceptableOrUnknown(
          data['es_checklist']!,
          _esChecklistMeta,
        ),
      );
    }
    if (data.containsKey('items_json')) {
      context.handle(
        _itemsJsonMeta,
        itemsJson.isAcceptableOrUnknown(data['items_json']!, _itemsJsonMeta),
      );
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('creada_en')) {
      context.handle(
        _creadaEnMeta,
        creadaEn.isAcceptableOrUnknown(data['creada_en']!, _creadaEnMeta),
      );
    }
    if (data.containsKey('actualizada_en')) {
      context.handle(
        _actualizadaEnMeta,
        actualizadaEn.isAcceptableOrUnknown(
          data['actualizada_en']!,
          _actualizadaEnMeta,
        ),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    if (data.containsKey('pendiente_sync')) {
      context.handle(
        _pendienteSyncMeta,
        pendienteSync.isAcceptableOrUnknown(
          data['pendiente_sync']!,
          _pendienteSyncMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Note map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Note(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      titulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titulo'],
      )!,
      contenido: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contenido'],
      )!,
      categoria: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}categoria'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      esFijada: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_fijada'],
      )!,
      esChecklist: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_checklist'],
      )!,
      itemsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}items_json'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usuario_id'],
      )!,
      creadaEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creada_en'],
      )!,
      actualizadaEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizada_en'],
      )!,
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
      pendienteSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pendiente_sync'],
      )!,
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class Note extends DataClass implements Insertable<Note> {
  final String id;
  final String titulo;
  final String contenido;
  final int categoria;
  final String color;
  final bool esFijada;
  final bool esChecklist;
  final String itemsJson;
  final String usuarioId;
  final DateTime creadaEn;
  final DateTime actualizadaEn;
  final String tags;
  final DateTime actualizadoEn;
  final bool pendienteSync;
  const Note({
    required this.id,
    required this.titulo,
    required this.contenido,
    required this.categoria,
    required this.color,
    required this.esFijada,
    required this.esChecklist,
    required this.itemsJson,
    required this.usuarioId,
    required this.creadaEn,
    required this.actualizadaEn,
    required this.tags,
    required this.actualizadoEn,
    required this.pendienteSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['titulo'] = Variable<String>(titulo);
    map['contenido'] = Variable<String>(contenido);
    map['categoria'] = Variable<int>(categoria);
    map['color'] = Variable<String>(color);
    map['es_fijada'] = Variable<bool>(esFijada);
    map['es_checklist'] = Variable<bool>(esChecklist);
    map['items_json'] = Variable<String>(itemsJson);
    map['usuario_id'] = Variable<String>(usuarioId);
    map['creada_en'] = Variable<DateTime>(creadaEn);
    map['actualizada_en'] = Variable<DateTime>(actualizadaEn);
    map['tags'] = Variable<String>(tags);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    map['pendiente_sync'] = Variable<bool>(pendienteSync);
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      titulo: Value(titulo),
      contenido: Value(contenido),
      categoria: Value(categoria),
      color: Value(color),
      esFijada: Value(esFijada),
      esChecklist: Value(esChecklist),
      itemsJson: Value(itemsJson),
      usuarioId: Value(usuarioId),
      creadaEn: Value(creadaEn),
      actualizadaEn: Value(actualizadaEn),
      tags: Value(tags),
      actualizadoEn: Value(actualizadoEn),
      pendienteSync: Value(pendienteSync),
    );
  }

  factory Note.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Note(
      id: serializer.fromJson<String>(json['id']),
      titulo: serializer.fromJson<String>(json['titulo']),
      contenido: serializer.fromJson<String>(json['contenido']),
      categoria: serializer.fromJson<int>(json['categoria']),
      color: serializer.fromJson<String>(json['color']),
      esFijada: serializer.fromJson<bool>(json['esFijada']),
      esChecklist: serializer.fromJson<bool>(json['esChecklist']),
      itemsJson: serializer.fromJson<String>(json['itemsJson']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      creadaEn: serializer.fromJson<DateTime>(json['creadaEn']),
      actualizadaEn: serializer.fromJson<DateTime>(json['actualizadaEn']),
      tags: serializer.fromJson<String>(json['tags']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
      pendienteSync: serializer.fromJson<bool>(json['pendienteSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'titulo': serializer.toJson<String>(titulo),
      'contenido': serializer.toJson<String>(contenido),
      'categoria': serializer.toJson<int>(categoria),
      'color': serializer.toJson<String>(color),
      'esFijada': serializer.toJson<bool>(esFijada),
      'esChecklist': serializer.toJson<bool>(esChecklist),
      'itemsJson': serializer.toJson<String>(itemsJson),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'creadaEn': serializer.toJson<DateTime>(creadaEn),
      'actualizadaEn': serializer.toJson<DateTime>(actualizadaEn),
      'tags': serializer.toJson<String>(tags),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
      'pendienteSync': serializer.toJson<bool>(pendienteSync),
    };
  }

  Note copyWith({
    String? id,
    String? titulo,
    String? contenido,
    int? categoria,
    String? color,
    bool? esFijada,
    bool? esChecklist,
    String? itemsJson,
    String? usuarioId,
    DateTime? creadaEn,
    DateTime? actualizadaEn,
    String? tags,
    DateTime? actualizadoEn,
    bool? pendienteSync,
  }) => Note(
    id: id ?? this.id,
    titulo: titulo ?? this.titulo,
    contenido: contenido ?? this.contenido,
    categoria: categoria ?? this.categoria,
    color: color ?? this.color,
    esFijada: esFijada ?? this.esFijada,
    esChecklist: esChecklist ?? this.esChecklist,
    itemsJson: itemsJson ?? this.itemsJson,
    usuarioId: usuarioId ?? this.usuarioId,
    creadaEn: creadaEn ?? this.creadaEn,
    actualizadaEn: actualizadaEn ?? this.actualizadaEn,
    tags: tags ?? this.tags,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    pendienteSync: pendienteSync ?? this.pendienteSync,
  );
  Note copyWithCompanion(NotesCompanion data) {
    return Note(
      id: data.id.present ? data.id.value : this.id,
      titulo: data.titulo.present ? data.titulo.value : this.titulo,
      contenido: data.contenido.present ? data.contenido.value : this.contenido,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      color: data.color.present ? data.color.value : this.color,
      esFijada: data.esFijada.present ? data.esFijada.value : this.esFijada,
      esChecklist: data.esChecklist.present
          ? data.esChecklist.value
          : this.esChecklist,
      itemsJson: data.itemsJson.present ? data.itemsJson.value : this.itemsJson,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      creadaEn: data.creadaEn.present ? data.creadaEn.value : this.creadaEn,
      actualizadaEn: data.actualizadaEn.present
          ? data.actualizadaEn.value
          : this.actualizadaEn,
      tags: data.tags.present ? data.tags.value : this.tags,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
      pendienteSync: data.pendienteSync.present
          ? data.pendienteSync.value
          : this.pendienteSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Note(')
          ..write('id: $id, ')
          ..write('titulo: $titulo, ')
          ..write('contenido: $contenido, ')
          ..write('categoria: $categoria, ')
          ..write('color: $color, ')
          ..write('esFijada: $esFijada, ')
          ..write('esChecklist: $esChecklist, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('creadaEn: $creadaEn, ')
          ..write('actualizadaEn: $actualizadaEn, ')
          ..write('tags: $tags, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('pendienteSync: $pendienteSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    titulo,
    contenido,
    categoria,
    color,
    esFijada,
    esChecklist,
    itemsJson,
    usuarioId,
    creadaEn,
    actualizadaEn,
    tags,
    actualizadoEn,
    pendienteSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Note &&
          other.id == this.id &&
          other.titulo == this.titulo &&
          other.contenido == this.contenido &&
          other.categoria == this.categoria &&
          other.color == this.color &&
          other.esFijada == this.esFijada &&
          other.esChecklist == this.esChecklist &&
          other.itemsJson == this.itemsJson &&
          other.usuarioId == this.usuarioId &&
          other.creadaEn == this.creadaEn &&
          other.actualizadaEn == this.actualizadaEn &&
          other.tags == this.tags &&
          other.actualizadoEn == this.actualizadoEn &&
          other.pendienteSync == this.pendienteSync);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<String> id;
  final Value<String> titulo;
  final Value<String> contenido;
  final Value<int> categoria;
  final Value<String> color;
  final Value<bool> esFijada;
  final Value<bool> esChecklist;
  final Value<String> itemsJson;
  final Value<String> usuarioId;
  final Value<DateTime> creadaEn;
  final Value<DateTime> actualizadaEn;
  final Value<String> tags;
  final Value<DateTime> actualizadoEn;
  final Value<bool> pendienteSync;
  final Value<int> rowid;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.titulo = const Value.absent(),
    this.contenido = const Value.absent(),
    this.categoria = const Value.absent(),
    this.color = const Value.absent(),
    this.esFijada = const Value.absent(),
    this.esChecklist = const Value.absent(),
    this.itemsJson = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.creadaEn = const Value.absent(),
    this.actualizadaEn = const Value.absent(),
    this.tags = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotesCompanion.insert({
    required String id,
    required String titulo,
    this.contenido = const Value.absent(),
    this.categoria = const Value.absent(),
    this.color = const Value.absent(),
    this.esFijada = const Value.absent(),
    this.esChecklist = const Value.absent(),
    this.itemsJson = const Value.absent(),
    required String usuarioId,
    this.creadaEn = const Value.absent(),
    this.actualizadaEn = const Value.absent(),
    this.tags = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       titulo = Value(titulo),
       usuarioId = Value(usuarioId);
  static Insertable<Note> custom({
    Expression<String>? id,
    Expression<String>? titulo,
    Expression<String>? contenido,
    Expression<int>? categoria,
    Expression<String>? color,
    Expression<bool>? esFijada,
    Expression<bool>? esChecklist,
    Expression<String>? itemsJson,
    Expression<String>? usuarioId,
    Expression<DateTime>? creadaEn,
    Expression<DateTime>? actualizadaEn,
    Expression<String>? tags,
    Expression<DateTime>? actualizadoEn,
    Expression<bool>? pendienteSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (titulo != null) 'titulo': titulo,
      if (contenido != null) 'contenido': contenido,
      if (categoria != null) 'categoria': categoria,
      if (color != null) 'color': color,
      if (esFijada != null) 'es_fijada': esFijada,
      if (esChecklist != null) 'es_checklist': esChecklist,
      if (itemsJson != null) 'items_json': itemsJson,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (creadaEn != null) 'creada_en': creadaEn,
      if (actualizadaEn != null) 'actualizada_en': actualizadaEn,
      if (tags != null) 'tags': tags,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
      if (pendienteSync != null) 'pendiente_sync': pendienteSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotesCompanion copyWith({
    Value<String>? id,
    Value<String>? titulo,
    Value<String>? contenido,
    Value<int>? categoria,
    Value<String>? color,
    Value<bool>? esFijada,
    Value<bool>? esChecklist,
    Value<String>? itemsJson,
    Value<String>? usuarioId,
    Value<DateTime>? creadaEn,
    Value<DateTime>? actualizadaEn,
    Value<String>? tags,
    Value<DateTime>? actualizadoEn,
    Value<bool>? pendienteSync,
    Value<int>? rowid,
  }) {
    return NotesCompanion(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      contenido: contenido ?? this.contenido,
      categoria: categoria ?? this.categoria,
      color: color ?? this.color,
      esFijada: esFijada ?? this.esFijada,
      esChecklist: esChecklist ?? this.esChecklist,
      itemsJson: itemsJson ?? this.itemsJson,
      usuarioId: usuarioId ?? this.usuarioId,
      creadaEn: creadaEn ?? this.creadaEn,
      actualizadaEn: actualizadaEn ?? this.actualizadaEn,
      tags: tags ?? this.tags,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      pendienteSync: pendienteSync ?? this.pendienteSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (contenido.present) {
      map['contenido'] = Variable<String>(contenido.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<int>(categoria.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (esFijada.present) {
      map['es_fijada'] = Variable<bool>(esFijada.value);
    }
    if (esChecklist.present) {
      map['es_checklist'] = Variable<bool>(esChecklist.value);
    }
    if (itemsJson.present) {
      map['items_json'] = Variable<String>(itemsJson.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (creadaEn.present) {
      map['creada_en'] = Variable<DateTime>(creadaEn.value);
    }
    if (actualizadaEn.present) {
      map['actualizada_en'] = Variable<DateTime>(actualizadaEn.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    if (pendienteSync.present) {
      map['pendiente_sync'] = Variable<bool>(pendienteSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('titulo: $titulo, ')
          ..write('contenido: $contenido, ')
          ..write('categoria: $categoria, ')
          ..write('color: $color, ')
          ..write('esFijada: $esFijada, ')
          ..write('esChecklist: $esChecklist, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('creadaEn: $creadaEn, ')
          ..write('actualizadaEn: $actualizadaEn, ')
          ..write('tags: $tags, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('pendienteSync: $pendienteSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NoteDraftsTable extends NoteDrafts
    with TableInfo<$NoteDraftsTable, NoteDraft> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoteDraftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  @override
  late final GeneratedColumn<String> titulo = GeneratedColumn<String>(
    'titulo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _contenidoMeta = const VerificationMeta(
    'contenido',
  );
  @override
  late final GeneratedColumn<String> contenido = GeneratedColumn<String>(
    'contenido',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _itemsJsonMeta = const VerificationMeta(
    'itemsJson',
  );
  @override
  late final GeneratedColumn<String> itemsJson = GeneratedColumn<String>(
    'items_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _categoriaMeta = const VerificationMeta(
    'categoria',
  );
  @override
  late final GeneratedColumn<int> categoria = GeneratedColumn<int>(
    'categoria',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#FFF9C4'),
  );
  static const VerificationMeta _esFijadaMeta = const VerificationMeta(
    'esFijada',
  );
  @override
  late final GeneratedColumn<bool> esFijada = GeneratedColumn<bool>(
    'es_fijada',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_fijada" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _esChecklistMeta = const VerificationMeta(
    'esChecklist',
  );
  @override
  late final GeneratedColumn<bool> esChecklist = GeneratedColumn<bool>(
    'es_checklist',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_checklist" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    usuarioId,
    titulo,
    contenido,
    tags,
    itemsJson,
    categoria,
    color,
    esFijada,
    esChecklist,
    actualizadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'note_drafts';
  @override
  VerificationContext validateIntegrity(
    Insertable<NoteDraft> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('titulo')) {
      context.handle(
        _tituloMeta,
        titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta),
      );
    }
    if (data.containsKey('contenido')) {
      context.handle(
        _contenidoMeta,
        contenido.isAcceptableOrUnknown(data['contenido']!, _contenidoMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('items_json')) {
      context.handle(
        _itemsJsonMeta,
        itemsJson.isAcceptableOrUnknown(data['items_json']!, _itemsJsonMeta),
      );
    }
    if (data.containsKey('categoria')) {
      context.handle(
        _categoriaMeta,
        categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('es_fijada')) {
      context.handle(
        _esFijadaMeta,
        esFijada.isAcceptableOrUnknown(data['es_fijada']!, _esFijadaMeta),
      );
    }
    if (data.containsKey('es_checklist')) {
      context.handle(
        _esChecklistMeta,
        esChecklist.isAcceptableOrUnknown(
          data['es_checklist']!,
          _esChecklistMeta,
        ),
      );
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, usuarioId};
  @override
  NoteDraft map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteDraft(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usuario_id'],
      )!,
      titulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titulo'],
      )!,
      contenido: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contenido'],
      )!,
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      itemsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}items_json'],
      )!,
      categoria: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}categoria'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      esFijada: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_fijada'],
      )!,
      esChecklist: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_checklist'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
    );
  }

  @override
  $NoteDraftsTable createAlias(String alias) {
    return $NoteDraftsTable(attachedDatabase, alias);
  }
}

class NoteDraft extends DataClass implements Insertable<NoteDraft> {
  /// Id de la nota que se está editando; para una nota nueva, la palabra
  /// `nueva` (solo puede haber un borrador de nota nueva a la vez por usuario).
  final String id;
  final String usuarioId;
  final String titulo;
  final String contenido;
  final String tags;

  /// Elementos de la lista de tareas, en el mismo formato que usa `notes`.
  final String itemsJson;
  final int categoria;
  final String color;
  final bool esFijada;
  final bool esChecklist;
  final DateTime actualizadoEn;
  const NoteDraft({
    required this.id,
    required this.usuarioId,
    required this.titulo,
    required this.contenido,
    required this.tags,
    required this.itemsJson,
    required this.categoria,
    required this.color,
    required this.esFijada,
    required this.esChecklist,
    required this.actualizadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['usuario_id'] = Variable<String>(usuarioId);
    map['titulo'] = Variable<String>(titulo);
    map['contenido'] = Variable<String>(contenido);
    map['tags'] = Variable<String>(tags);
    map['items_json'] = Variable<String>(itemsJson);
    map['categoria'] = Variable<int>(categoria);
    map['color'] = Variable<String>(color);
    map['es_fijada'] = Variable<bool>(esFijada);
    map['es_checklist'] = Variable<bool>(esChecklist);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    return map;
  }

  NoteDraftsCompanion toCompanion(bool nullToAbsent) {
    return NoteDraftsCompanion(
      id: Value(id),
      usuarioId: Value(usuarioId),
      titulo: Value(titulo),
      contenido: Value(contenido),
      tags: Value(tags),
      itemsJson: Value(itemsJson),
      categoria: Value(categoria),
      color: Value(color),
      esFijada: Value(esFijada),
      esChecklist: Value(esChecklist),
      actualizadoEn: Value(actualizadoEn),
    );
  }

  factory NoteDraft.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteDraft(
      id: serializer.fromJson<String>(json['id']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      titulo: serializer.fromJson<String>(json['titulo']),
      contenido: serializer.fromJson<String>(json['contenido']),
      tags: serializer.fromJson<String>(json['tags']),
      itemsJson: serializer.fromJson<String>(json['itemsJson']),
      categoria: serializer.fromJson<int>(json['categoria']),
      color: serializer.fromJson<String>(json['color']),
      esFijada: serializer.fromJson<bool>(json['esFijada']),
      esChecklist: serializer.fromJson<bool>(json['esChecklist']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'titulo': serializer.toJson<String>(titulo),
      'contenido': serializer.toJson<String>(contenido),
      'tags': serializer.toJson<String>(tags),
      'itemsJson': serializer.toJson<String>(itemsJson),
      'categoria': serializer.toJson<int>(categoria),
      'color': serializer.toJson<String>(color),
      'esFijada': serializer.toJson<bool>(esFijada),
      'esChecklist': serializer.toJson<bool>(esChecklist),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
    };
  }

  NoteDraft copyWith({
    String? id,
    String? usuarioId,
    String? titulo,
    String? contenido,
    String? tags,
    String? itemsJson,
    int? categoria,
    String? color,
    bool? esFijada,
    bool? esChecklist,
    DateTime? actualizadoEn,
  }) => NoteDraft(
    id: id ?? this.id,
    usuarioId: usuarioId ?? this.usuarioId,
    titulo: titulo ?? this.titulo,
    contenido: contenido ?? this.contenido,
    tags: tags ?? this.tags,
    itemsJson: itemsJson ?? this.itemsJson,
    categoria: categoria ?? this.categoria,
    color: color ?? this.color,
    esFijada: esFijada ?? this.esFijada,
    esChecklist: esChecklist ?? this.esChecklist,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
  );
  NoteDraft copyWithCompanion(NoteDraftsCompanion data) {
    return NoteDraft(
      id: data.id.present ? data.id.value : this.id,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      titulo: data.titulo.present ? data.titulo.value : this.titulo,
      contenido: data.contenido.present ? data.contenido.value : this.contenido,
      tags: data.tags.present ? data.tags.value : this.tags,
      itemsJson: data.itemsJson.present ? data.itemsJson.value : this.itemsJson,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      color: data.color.present ? data.color.value : this.color,
      esFijada: data.esFijada.present ? data.esFijada.value : this.esFijada,
      esChecklist: data.esChecklist.present
          ? data.esChecklist.value
          : this.esChecklist,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteDraft(')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('titulo: $titulo, ')
          ..write('contenido: $contenido, ')
          ..write('tags: $tags, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('categoria: $categoria, ')
          ..write('color: $color, ')
          ..write('esFijada: $esFijada, ')
          ..write('esChecklist: $esChecklist, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    usuarioId,
    titulo,
    contenido,
    tags,
    itemsJson,
    categoria,
    color,
    esFijada,
    esChecklist,
    actualizadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteDraft &&
          other.id == this.id &&
          other.usuarioId == this.usuarioId &&
          other.titulo == this.titulo &&
          other.contenido == this.contenido &&
          other.tags == this.tags &&
          other.itemsJson == this.itemsJson &&
          other.categoria == this.categoria &&
          other.color == this.color &&
          other.esFijada == this.esFijada &&
          other.esChecklist == this.esChecklist &&
          other.actualizadoEn == this.actualizadoEn);
}

class NoteDraftsCompanion extends UpdateCompanion<NoteDraft> {
  final Value<String> id;
  final Value<String> usuarioId;
  final Value<String> titulo;
  final Value<String> contenido;
  final Value<String> tags;
  final Value<String> itemsJson;
  final Value<int> categoria;
  final Value<String> color;
  final Value<bool> esFijada;
  final Value<bool> esChecklist;
  final Value<DateTime> actualizadoEn;
  final Value<int> rowid;
  const NoteDraftsCompanion({
    this.id = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.titulo = const Value.absent(),
    this.contenido = const Value.absent(),
    this.tags = const Value.absent(),
    this.itemsJson = const Value.absent(),
    this.categoria = const Value.absent(),
    this.color = const Value.absent(),
    this.esFijada = const Value.absent(),
    this.esChecklist = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NoteDraftsCompanion.insert({
    required String id,
    required String usuarioId,
    this.titulo = const Value.absent(),
    this.contenido = const Value.absent(),
    this.tags = const Value.absent(),
    this.itemsJson = const Value.absent(),
    this.categoria = const Value.absent(),
    this.color = const Value.absent(),
    this.esFijada = const Value.absent(),
    this.esChecklist = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       usuarioId = Value(usuarioId);
  static Insertable<NoteDraft> custom({
    Expression<String>? id,
    Expression<String>? usuarioId,
    Expression<String>? titulo,
    Expression<String>? contenido,
    Expression<String>? tags,
    Expression<String>? itemsJson,
    Expression<int>? categoria,
    Expression<String>? color,
    Expression<bool>? esFijada,
    Expression<bool>? esChecklist,
    Expression<DateTime>? actualizadoEn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (titulo != null) 'titulo': titulo,
      if (contenido != null) 'contenido': contenido,
      if (tags != null) 'tags': tags,
      if (itemsJson != null) 'items_json': itemsJson,
      if (categoria != null) 'categoria': categoria,
      if (color != null) 'color': color,
      if (esFijada != null) 'es_fijada': esFijada,
      if (esChecklist != null) 'es_checklist': esChecklist,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NoteDraftsCompanion copyWith({
    Value<String>? id,
    Value<String>? usuarioId,
    Value<String>? titulo,
    Value<String>? contenido,
    Value<String>? tags,
    Value<String>? itemsJson,
    Value<int>? categoria,
    Value<String>? color,
    Value<bool>? esFijada,
    Value<bool>? esChecklist,
    Value<DateTime>? actualizadoEn,
    Value<int>? rowid,
  }) {
    return NoteDraftsCompanion(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      titulo: titulo ?? this.titulo,
      contenido: contenido ?? this.contenido,
      tags: tags ?? this.tags,
      itemsJson: itemsJson ?? this.itemsJson,
      categoria: categoria ?? this.categoria,
      color: color ?? this.color,
      esFijada: esFijada ?? this.esFijada,
      esChecklist: esChecklist ?? this.esChecklist,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (contenido.present) {
      map['contenido'] = Variable<String>(contenido.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (itemsJson.present) {
      map['items_json'] = Variable<String>(itemsJson.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<int>(categoria.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (esFijada.present) {
      map['es_fijada'] = Variable<bool>(esFijada.value);
    }
    if (esChecklist.present) {
      map['es_checklist'] = Variable<bool>(esChecklist.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoteDraftsCompanion(')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('titulo: $titulo, ')
          ..write('contenido: $contenido, ')
          ..write('tags: $tags, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('categoria: $categoria, ')
          ..write('color: $color, ')
          ..write('esFijada: $esFijada, ')
          ..write('esChecklist: $esChecklist, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _nombresMeta = const VerificationMeta(
    'nombres',
  );
  @override
  late final GeneratedColumn<String> nombres = GeneratedColumn<String>(
    'nombres',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _apellidosMeta = const VerificationMeta(
    'apellidos',
  );
  @override
  late final GeneratedColumn<String> apellidos = GeneratedColumn<String>(
    'apellidos',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bioMeta = const VerificationMeta('bio');
  @override
  late final GeneratedColumn<String> bio = GeneratedColumn<String>(
    'bio',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fechaNacimientoMeta = const VerificationMeta(
    'fechaNacimiento',
  );
  @override
  late final GeneratedColumn<DateTime> fechaNacimiento =
      GeneratedColumn<DateTime>(
        'fecha_nacimiento',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _zonaHorariaMeta = const VerificationMeta(
    'zonaHoraria',
  );
  @override
  late final GeneratedColumn<String> zonaHoraria = GeneratedColumn<String>(
    'zona_horaria',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _visibilidadMeta = const VerificationMeta(
    'visibilidad',
  );
  @override
  late final GeneratedColumn<String> visibilidad = GeneratedColumn<String>(
    'visibilidad',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('amigos'),
  );
  static const VerificationMeta _avatarUrlMeta = const VerificationMeta(
    'avatarUrl',
  );
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
    'avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avatarBytesMeta = const VerificationMeta(
    'avatarBytes',
  );
  @override
  late final GeneratedColumn<Uint8List> avatarBytes =
      GeneratedColumn<Uint8List>(
        'avatar_bytes',
        aliasedName,
        true,
        type: DriftSqlType.blob,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _avatarPendienteMeta = const VerificationMeta(
    'avatarPendiente',
  );
  @override
  late final GeneratedColumn<bool> avatarPendiente = GeneratedColumn<bool>(
    'avatar_pendiente',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("avatar_pendiente" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _pendienteSyncMeta = const VerificationMeta(
    'pendienteSync',
  );
  @override
  late final GeneratedColumn<bool> pendienteSync = GeneratedColumn<bool>(
    'pendiente_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pendiente_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    email,
    nombre,
    nombres,
    apellidos,
    bio,
    fechaNacimiento,
    telefono,
    zonaHoraria,
    visibilidad,
    avatarUrl,
    avatarBytes,
    avatarPendiente,
    actualizadoEn,
    pendienteSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Profile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    }
    if (data.containsKey('nombres')) {
      context.handle(
        _nombresMeta,
        nombres.isAcceptableOrUnknown(data['nombres']!, _nombresMeta),
      );
    }
    if (data.containsKey('apellidos')) {
      context.handle(
        _apellidosMeta,
        apellidos.isAcceptableOrUnknown(data['apellidos']!, _apellidosMeta),
      );
    }
    if (data.containsKey('bio')) {
      context.handle(
        _bioMeta,
        bio.isAcceptableOrUnknown(data['bio']!, _bioMeta),
      );
    }
    if (data.containsKey('fecha_nacimiento')) {
      context.handle(
        _fechaNacimientoMeta,
        fechaNacimiento.isAcceptableOrUnknown(
          data['fecha_nacimiento']!,
          _fechaNacimientoMeta,
        ),
      );
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    }
    if (data.containsKey('zona_horaria')) {
      context.handle(
        _zonaHorariaMeta,
        zonaHoraria.isAcceptableOrUnknown(
          data['zona_horaria']!,
          _zonaHorariaMeta,
        ),
      );
    }
    if (data.containsKey('visibilidad')) {
      context.handle(
        _visibilidadMeta,
        visibilidad.isAcceptableOrUnknown(
          data['visibilidad']!,
          _visibilidadMeta,
        ),
      );
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
        _avatarUrlMeta,
        avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta),
      );
    }
    if (data.containsKey('avatar_bytes')) {
      context.handle(
        _avatarBytesMeta,
        avatarBytes.isAcceptableOrUnknown(
          data['avatar_bytes']!,
          _avatarBytesMeta,
        ),
      );
    }
    if (data.containsKey('avatar_pendiente')) {
      context.handle(
        _avatarPendienteMeta,
        avatarPendiente.isAcceptableOrUnknown(
          data['avatar_pendiente']!,
          _avatarPendienteMeta,
        ),
      );
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    if (data.containsKey('pendiente_sync')) {
      context.handle(
        _pendienteSyncMeta,
        pendienteSync.isAcceptableOrUnknown(
          data['pendiente_sync']!,
          _pendienteSyncMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      nombres: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombres'],
      ),
      apellidos: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}apellidos'],
      ),
      bio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bio'],
      ),
      fechaNacimiento: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_nacimiento'],
      ),
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      ),
      zonaHoraria: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zona_horaria'],
      ),
      visibilidad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visibilidad'],
      )!,
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      ),
      avatarBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}avatar_bytes'],
      ),
      avatarPendiente: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}avatar_pendiente'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
      pendienteSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pendiente_sync'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class Profile extends DataClass implements Insertable<Profile> {
  /// = `auth.uid()`. No hay `usuario_id`: esta columna hace ese papel.
  final String id;
  final String email;

  /// Nombre para mostrar. Es lo que ven los demás en amigos, ranking y grupos.
  /// Se compone como `nombres apellidos`.
  final String nombre;
  final String? nombres;
  final String? apellidos;
  final String? bio;
  final DateTime? fechaNacimiento;
  final String? telefono;
  final String? zonaHoraria;

  /// `todos` | `amigos` | `nadie`. Quién puede encontrarte.
  final String visibilidad;

  /// URL pública del avatar en Storage, con `?v=` para invalidar la caché.
  final String? avatarUrl;

  /// Bytes del avatar cacheados en el dispositivo. Es lo que hace que la foto
  /// se vea al instante al elegirla, sobreviva a un reinicio y funcione sin
  /// red. No se sube: al servidor va la URL, no el binario. Sí entra en la
  /// copia de seguridad (en base64).
  final Uint8List? avatarBytes;

  /// Hay bytes elegidos que aún no se han podido subir (sin red al elegirlos).
  /// El siguiente ciclo de sincronización reintenta la subida.
  final bool avatarPendiente;
  final DateTime actualizadoEn;
  final bool pendienteSync;
  const Profile({
    required this.id,
    required this.email,
    required this.nombre,
    this.nombres,
    this.apellidos,
    this.bio,
    this.fechaNacimiento,
    this.telefono,
    this.zonaHoraria,
    required this.visibilidad,
    this.avatarUrl,
    this.avatarBytes,
    required this.avatarPendiente,
    required this.actualizadoEn,
    required this.pendienteSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['email'] = Variable<String>(email);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || nombres != null) {
      map['nombres'] = Variable<String>(nombres);
    }
    if (!nullToAbsent || apellidos != null) {
      map['apellidos'] = Variable<String>(apellidos);
    }
    if (!nullToAbsent || bio != null) {
      map['bio'] = Variable<String>(bio);
    }
    if (!nullToAbsent || fechaNacimiento != null) {
      map['fecha_nacimiento'] = Variable<DateTime>(fechaNacimiento);
    }
    if (!nullToAbsent || telefono != null) {
      map['telefono'] = Variable<String>(telefono);
    }
    if (!nullToAbsent || zonaHoraria != null) {
      map['zona_horaria'] = Variable<String>(zonaHoraria);
    }
    map['visibilidad'] = Variable<String>(visibilidad);
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    if (!nullToAbsent || avatarBytes != null) {
      map['avatar_bytes'] = Variable<Uint8List>(avatarBytes);
    }
    map['avatar_pendiente'] = Variable<bool>(avatarPendiente);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    map['pendiente_sync'] = Variable<bool>(pendienteSync);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      email: Value(email),
      nombre: Value(nombre),
      nombres: nombres == null && nullToAbsent
          ? const Value.absent()
          : Value(nombres),
      apellidos: apellidos == null && nullToAbsent
          ? const Value.absent()
          : Value(apellidos),
      bio: bio == null && nullToAbsent ? const Value.absent() : Value(bio),
      fechaNacimiento: fechaNacimiento == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaNacimiento),
      telefono: telefono == null && nullToAbsent
          ? const Value.absent()
          : Value(telefono),
      zonaHoraria: zonaHoraria == null && nullToAbsent
          ? const Value.absent()
          : Value(zonaHoraria),
      visibilidad: Value(visibilidad),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      avatarBytes: avatarBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarBytes),
      avatarPendiente: Value(avatarPendiente),
      actualizadoEn: Value(actualizadoEn),
      pendienteSync: Value(pendienteSync),
    );
  }

  factory Profile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      nombre: serializer.fromJson<String>(json['nombre']),
      nombres: serializer.fromJson<String?>(json['nombres']),
      apellidos: serializer.fromJson<String?>(json['apellidos']),
      bio: serializer.fromJson<String?>(json['bio']),
      fechaNacimiento: serializer.fromJson<DateTime?>(json['fechaNacimiento']),
      telefono: serializer.fromJson<String?>(json['telefono']),
      zonaHoraria: serializer.fromJson<String?>(json['zonaHoraria']),
      visibilidad: serializer.fromJson<String>(json['visibilidad']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      avatarBytes: serializer.fromJson<Uint8List?>(json['avatarBytes']),
      avatarPendiente: serializer.fromJson<bool>(json['avatarPendiente']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
      pendienteSync: serializer.fromJson<bool>(json['pendienteSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String>(email),
      'nombre': serializer.toJson<String>(nombre),
      'nombres': serializer.toJson<String?>(nombres),
      'apellidos': serializer.toJson<String?>(apellidos),
      'bio': serializer.toJson<String?>(bio),
      'fechaNacimiento': serializer.toJson<DateTime?>(fechaNacimiento),
      'telefono': serializer.toJson<String?>(telefono),
      'zonaHoraria': serializer.toJson<String?>(zonaHoraria),
      'visibilidad': serializer.toJson<String>(visibilidad),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'avatarBytes': serializer.toJson<Uint8List?>(avatarBytes),
      'avatarPendiente': serializer.toJson<bool>(avatarPendiente),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
      'pendienteSync': serializer.toJson<bool>(pendienteSync),
    };
  }

  Profile copyWith({
    String? id,
    String? email,
    String? nombre,
    Value<String?> nombres = const Value.absent(),
    Value<String?> apellidos = const Value.absent(),
    Value<String?> bio = const Value.absent(),
    Value<DateTime?> fechaNacimiento = const Value.absent(),
    Value<String?> telefono = const Value.absent(),
    Value<String?> zonaHoraria = const Value.absent(),
    String? visibilidad,
    Value<String?> avatarUrl = const Value.absent(),
    Value<Uint8List?> avatarBytes = const Value.absent(),
    bool? avatarPendiente,
    DateTime? actualizadoEn,
    bool? pendienteSync,
  }) => Profile(
    id: id ?? this.id,
    email: email ?? this.email,
    nombre: nombre ?? this.nombre,
    nombres: nombres.present ? nombres.value : this.nombres,
    apellidos: apellidos.present ? apellidos.value : this.apellidos,
    bio: bio.present ? bio.value : this.bio,
    fechaNacimiento: fechaNacimiento.present
        ? fechaNacimiento.value
        : this.fechaNacimiento,
    telefono: telefono.present ? telefono.value : this.telefono,
    zonaHoraria: zonaHoraria.present ? zonaHoraria.value : this.zonaHoraria,
    visibilidad: visibilidad ?? this.visibilidad,
    avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
    avatarBytes: avatarBytes.present ? avatarBytes.value : this.avatarBytes,
    avatarPendiente: avatarPendiente ?? this.avatarPendiente,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    pendienteSync: pendienteSync ?? this.pendienteSync,
  );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      nombres: data.nombres.present ? data.nombres.value : this.nombres,
      apellidos: data.apellidos.present ? data.apellidos.value : this.apellidos,
      bio: data.bio.present ? data.bio.value : this.bio,
      fechaNacimiento: data.fechaNacimiento.present
          ? data.fechaNacimiento.value
          : this.fechaNacimiento,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      zonaHoraria: data.zonaHoraria.present
          ? data.zonaHoraria.value
          : this.zonaHoraria,
      visibilidad: data.visibilidad.present
          ? data.visibilidad.value
          : this.visibilidad,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      avatarBytes: data.avatarBytes.present
          ? data.avatarBytes.value
          : this.avatarBytes,
      avatarPendiente: data.avatarPendiente.present
          ? data.avatarPendiente.value
          : this.avatarPendiente,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
      pendienteSync: data.pendienteSync.present
          ? data.pendienteSync.value
          : this.pendienteSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('nombre: $nombre, ')
          ..write('nombres: $nombres, ')
          ..write('apellidos: $apellidos, ')
          ..write('bio: $bio, ')
          ..write('fechaNacimiento: $fechaNacimiento, ')
          ..write('telefono: $telefono, ')
          ..write('zonaHoraria: $zonaHoraria, ')
          ..write('visibilidad: $visibilidad, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('avatarBytes: $avatarBytes, ')
          ..write('avatarPendiente: $avatarPendiente, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('pendienteSync: $pendienteSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    email,
    nombre,
    nombres,
    apellidos,
    bio,
    fechaNacimiento,
    telefono,
    zonaHoraria,
    visibilidad,
    avatarUrl,
    $driftBlobEquality.hash(avatarBytes),
    avatarPendiente,
    actualizadoEn,
    pendienteSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.email == this.email &&
          other.nombre == this.nombre &&
          other.nombres == this.nombres &&
          other.apellidos == this.apellidos &&
          other.bio == this.bio &&
          other.fechaNacimiento == this.fechaNacimiento &&
          other.telefono == this.telefono &&
          other.zonaHoraria == this.zonaHoraria &&
          other.visibilidad == this.visibilidad &&
          other.avatarUrl == this.avatarUrl &&
          $driftBlobEquality.equals(other.avatarBytes, this.avatarBytes) &&
          other.avatarPendiente == this.avatarPendiente &&
          other.actualizadoEn == this.actualizadoEn &&
          other.pendienteSync == this.pendienteSync);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<String> id;
  final Value<String> email;
  final Value<String> nombre;
  final Value<String?> nombres;
  final Value<String?> apellidos;
  final Value<String?> bio;
  final Value<DateTime?> fechaNacimiento;
  final Value<String?> telefono;
  final Value<String?> zonaHoraria;
  final Value<String> visibilidad;
  final Value<String?> avatarUrl;
  final Value<Uint8List?> avatarBytes;
  final Value<bool> avatarPendiente;
  final Value<DateTime> actualizadoEn;
  final Value<bool> pendienteSync;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.nombre = const Value.absent(),
    this.nombres = const Value.absent(),
    this.apellidos = const Value.absent(),
    this.bio = const Value.absent(),
    this.fechaNacimiento = const Value.absent(),
    this.telefono = const Value.absent(),
    this.zonaHoraria = const Value.absent(),
    this.visibilidad = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.avatarBytes = const Value.absent(),
    this.avatarPendiente = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    required String id,
    this.email = const Value.absent(),
    this.nombre = const Value.absent(),
    this.nombres = const Value.absent(),
    this.apellidos = const Value.absent(),
    this.bio = const Value.absent(),
    this.fechaNacimiento = const Value.absent(),
    this.telefono = const Value.absent(),
    this.zonaHoraria = const Value.absent(),
    this.visibilidad = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.avatarBytes = const Value.absent(),
    this.avatarPendiente = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.pendienteSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<Profile> custom({
    Expression<String>? id,
    Expression<String>? email,
    Expression<String>? nombre,
    Expression<String>? nombres,
    Expression<String>? apellidos,
    Expression<String>? bio,
    Expression<DateTime>? fechaNacimiento,
    Expression<String>? telefono,
    Expression<String>? zonaHoraria,
    Expression<String>? visibilidad,
    Expression<String>? avatarUrl,
    Expression<Uint8List>? avatarBytes,
    Expression<bool>? avatarPendiente,
    Expression<DateTime>? actualizadoEn,
    Expression<bool>? pendienteSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (nombre != null) 'nombre': nombre,
      if (nombres != null) 'nombres': nombres,
      if (apellidos != null) 'apellidos': apellidos,
      if (bio != null) 'bio': bio,
      if (fechaNacimiento != null) 'fecha_nacimiento': fechaNacimiento,
      if (telefono != null) 'telefono': telefono,
      if (zonaHoraria != null) 'zona_horaria': zonaHoraria,
      if (visibilidad != null) 'visibilidad': visibilidad,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (avatarBytes != null) 'avatar_bytes': avatarBytes,
      if (avatarPendiente != null) 'avatar_pendiente': avatarPendiente,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
      if (pendienteSync != null) 'pendiente_sync': pendienteSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? email,
    Value<String>? nombre,
    Value<String?>? nombres,
    Value<String?>? apellidos,
    Value<String?>? bio,
    Value<DateTime?>? fechaNacimiento,
    Value<String?>? telefono,
    Value<String?>? zonaHoraria,
    Value<String>? visibilidad,
    Value<String?>? avatarUrl,
    Value<Uint8List?>? avatarBytes,
    Value<bool>? avatarPendiente,
    Value<DateTime>? actualizadoEn,
    Value<bool>? pendienteSync,
    Value<int>? rowid,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      nombre: nombre ?? this.nombre,
      nombres: nombres ?? this.nombres,
      apellidos: apellidos ?? this.apellidos,
      bio: bio ?? this.bio,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      telefono: telefono ?? this.telefono,
      zonaHoraria: zonaHoraria ?? this.zonaHoraria,
      visibilidad: visibilidad ?? this.visibilidad,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarBytes: avatarBytes ?? this.avatarBytes,
      avatarPendiente: avatarPendiente ?? this.avatarPendiente,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      pendienteSync: pendienteSync ?? this.pendienteSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (nombres.present) {
      map['nombres'] = Variable<String>(nombres.value);
    }
    if (apellidos.present) {
      map['apellidos'] = Variable<String>(apellidos.value);
    }
    if (bio.present) {
      map['bio'] = Variable<String>(bio.value);
    }
    if (fechaNacimiento.present) {
      map['fecha_nacimiento'] = Variable<DateTime>(fechaNacimiento.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (zonaHoraria.present) {
      map['zona_horaria'] = Variable<String>(zonaHoraria.value);
    }
    if (visibilidad.present) {
      map['visibilidad'] = Variable<String>(visibilidad.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (avatarBytes.present) {
      map['avatar_bytes'] = Variable<Uint8List>(avatarBytes.value);
    }
    if (avatarPendiente.present) {
      map['avatar_pendiente'] = Variable<bool>(avatarPendiente.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    if (pendienteSync.present) {
      map['pendiente_sync'] = Variable<bool>(pendienteSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('nombre: $nombre, ')
          ..write('nombres: $nombres, ')
          ..write('apellidos: $apellidos, ')
          ..write('bio: $bio, ')
          ..write('fechaNacimiento: $fechaNacimiento, ')
          ..write('telefono: $telefono, ')
          ..write('zonaHoraria: $zonaHoraria, ')
          ..write('visibilidad: $visibilidad, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('avatarBytes: $avatarBytes, ')
          ..write('avatarPendiente: $avatarPendiente, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('pendienteSync: $pendienteSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RoutinesTable routines = $RoutinesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $SavingsGoalsTable savingsGoals = $SavingsGoalsTable(this);
  late final $DebtsTable debts = $DebtsTable(this);
  late final $RecurringExpensesTable recurringExpenses =
      $RecurringExpensesTable(this);
  late final $EventsTable events = $EventsTable(this);
  late final $HabitsTable habits = $HabitsTable(this);
  late final $HabitCompletionsTable habitCompletions = $HabitCompletionsTable(
    this,
  );
  late final $SyncTombstonesTable syncTombstones = $SyncTombstonesTable(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $NoteDraftsTable noteDrafts = $NoteDraftsTable(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    routines,
    transactions,
    budgets,
    savingsGoals,
    debts,
    recurringExpenses,
    events,
    habits,
    habitCompletions,
    syncTombstones,
    notes,
    noteDrafts,
    profiles,
  ];
}

typedef $$RoutinesTableCreateCompanionBuilder =
    RoutinesCompanion Function({
      required String id,
      required String nombre,
      Value<String> icono,
      required int periodo,
      Value<String> hora,
      Value<bool> completadaHoy,
      Value<int> rachaActual,
      Value<int> orden,
      required String usuarioId,
      Value<DateTime> creadaEn,
      Value<DateTime> actualizadoEn,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });
typedef $$RoutinesTableUpdateCompanionBuilder =
    RoutinesCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<String> icono,
      Value<int> periodo,
      Value<String> hora,
      Value<bool> completadaHoy,
      Value<int> rachaActual,
      Value<int> orden,
      Value<String> usuarioId,
      Value<DateTime> creadaEn,
      Value<DateTime> actualizadoEn,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });

class $$RoutinesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icono => $composableBuilder(
    column: $table.icono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get periodo => $composableBuilder(
    column: $table.periodo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hora => $composableBuilder(
    column: $table.hora,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completadaHoy => $composableBuilder(
    column: $table.completadaHoy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rachaActual => $composableBuilder(
    column: $table.rachaActual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orden => $composableBuilder(
    column: $table.orden,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadaEn => $composableBuilder(
    column: $table.creadaEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RoutinesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icono => $composableBuilder(
    column: $table.icono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get periodo => $composableBuilder(
    column: $table.periodo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hora => $composableBuilder(
    column: $table.hora,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completadaHoy => $composableBuilder(
    column: $table.completadaHoy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rachaActual => $composableBuilder(
    column: $table.rachaActual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orden => $composableBuilder(
    column: $table.orden,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadaEn => $composableBuilder(
    column: $table.creadaEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoutinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get icono =>
      $composableBuilder(column: $table.icono, builder: (column) => column);

  GeneratedColumn<int> get periodo =>
      $composableBuilder(column: $table.periodo, builder: (column) => column);

  GeneratedColumn<String> get hora =>
      $composableBuilder(column: $table.hora, builder: (column) => column);

  GeneratedColumn<bool> get completadaHoy => $composableBuilder(
    column: $table.completadaHoy,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rachaActual => $composableBuilder(
    column: $table.rachaActual,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orden =>
      $composableBuilder(column: $table.orden, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<DateTime> get creadaEn =>
      $composableBuilder(column: $table.creadaEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => column,
  );
}

class $$RoutinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutinesTable,
          Routine,
          $$RoutinesTableFilterComposer,
          $$RoutinesTableOrderingComposer,
          $$RoutinesTableAnnotationComposer,
          $$RoutinesTableCreateCompanionBuilder,
          $$RoutinesTableUpdateCompanionBuilder,
          (Routine, BaseReferences<_$AppDatabase, $RoutinesTable, Routine>),
          Routine,
          PrefetchHooks Function()
        > {
  $$RoutinesTableTableManager(_$AppDatabase db, $RoutinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> icono = const Value.absent(),
                Value<int> periodo = const Value.absent(),
                Value<String> hora = const Value.absent(),
                Value<bool> completadaHoy = const Value.absent(),
                Value<int> rachaActual = const Value.absent(),
                Value<int> orden = const Value.absent(),
                Value<String> usuarioId = const Value.absent(),
                Value<DateTime> creadaEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutinesCompanion(
                id: id,
                nombre: nombre,
                icono: icono,
                periodo: periodo,
                hora: hora,
                completadaHoy: completadaHoy,
                rachaActual: rachaActual,
                orden: orden,
                usuarioId: usuarioId,
                creadaEn: creadaEn,
                actualizadoEn: actualizadoEn,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                Value<String> icono = const Value.absent(),
                required int periodo,
                Value<String> hora = const Value.absent(),
                Value<bool> completadaHoy = const Value.absent(),
                Value<int> rachaActual = const Value.absent(),
                Value<int> orden = const Value.absent(),
                required String usuarioId,
                Value<DateTime> creadaEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutinesCompanion.insert(
                id: id,
                nombre: nombre,
                icono: icono,
                periodo: periodo,
                hora: hora,
                completadaHoy: completadaHoy,
                rachaActual: rachaActual,
                orden: orden,
                usuarioId: usuarioId,
                creadaEn: creadaEn,
                actualizadoEn: actualizadoEn,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RoutinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutinesTable,
      Routine,
      $$RoutinesTableFilterComposer,
      $$RoutinesTableOrderingComposer,
      $$RoutinesTableAnnotationComposer,
      $$RoutinesTableCreateCompanionBuilder,
      $$RoutinesTableUpdateCompanionBuilder,
      (Routine, BaseReferences<_$AppDatabase, $RoutinesTable, Routine>),
      Routine,
      PrefetchHooks Function()
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      required String id,
      required String tipo,
      required double monto,
      required String descripcion,
      required String categoria,
      required String categoriaEmoji,
      required DateTime fecha,
      Value<String?> notas,
      Value<String?> imagenPath,
      required String usuarioId,
      required DateTime creadaEn,
      Value<DateTime> actualizadoEn,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<String> id,
      Value<String> tipo,
      Value<double> monto,
      Value<String> descripcion,
      Value<String> categoria,
      Value<String> categoriaEmoji,
      Value<DateTime> fecha,
      Value<String?> notas,
      Value<String?> imagenPath,
      Value<String> usuarioId,
      Value<DateTime> creadaEn,
      Value<DateTime> actualizadoEn,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get monto => $composableBuilder(
    column: $table.monto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoriaEmoji => $composableBuilder(
    column: $table.categoriaEmoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagenPath => $composableBuilder(
    column: $table.imagenPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadaEn => $composableBuilder(
    column: $table.creadaEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get monto => $composableBuilder(
    column: $table.monto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoriaEmoji => $composableBuilder(
    column: $table.categoriaEmoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagenPath => $composableBuilder(
    column: $table.imagenPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadaEn => $composableBuilder(
    column: $table.creadaEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<double> get monto =>
      $composableBuilder(column: $table.monto, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<String> get categoriaEmoji => $composableBuilder(
    column: $table.categoriaEmoji,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get notas =>
      $composableBuilder(column: $table.notas, builder: (column) => column);

  GeneratedColumn<String> get imagenPath => $composableBuilder(
    column: $table.imagenPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<DateTime> get creadaEn =>
      $composableBuilder(column: $table.creadaEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => column,
  );
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          Transaction,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (
            Transaction,
            BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>,
          ),
          Transaction,
          PrefetchHooks Function()
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<double> monto = const Value.absent(),
                Value<String> descripcion = const Value.absent(),
                Value<String> categoria = const Value.absent(),
                Value<String> categoriaEmoji = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<String?> notas = const Value.absent(),
                Value<String?> imagenPath = const Value.absent(),
                Value<String> usuarioId = const Value.absent(),
                Value<DateTime> creadaEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                tipo: tipo,
                monto: monto,
                descripcion: descripcion,
                categoria: categoria,
                categoriaEmoji: categoriaEmoji,
                fecha: fecha,
                notas: notas,
                imagenPath: imagenPath,
                usuarioId: usuarioId,
                creadaEn: creadaEn,
                actualizadoEn: actualizadoEn,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tipo,
                required double monto,
                required String descripcion,
                required String categoria,
                required String categoriaEmoji,
                required DateTime fecha,
                Value<String?> notas = const Value.absent(),
                Value<String?> imagenPath = const Value.absent(),
                required String usuarioId,
                required DateTime creadaEn,
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                tipo: tipo,
                monto: monto,
                descripcion: descripcion,
                categoria: categoria,
                categoriaEmoji: categoriaEmoji,
                fecha: fecha,
                notas: notas,
                imagenPath: imagenPath,
                usuarioId: usuarioId,
                creadaEn: creadaEn,
                actualizadoEn: actualizadoEn,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      Transaction,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (
        Transaction,
        BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>,
      ),
      Transaction,
      PrefetchHooks Function()
    >;
typedef $$BudgetsTableCreateCompanionBuilder =
    BudgetsCompanion Function({
      required String id,
      required String categoria,
      required double limite,
      required int mes,
      required int anio,
      required String usuarioId,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });
typedef $$BudgetsTableUpdateCompanionBuilder =
    BudgetsCompanion Function({
      Value<String> id,
      Value<String> categoria,
      Value<double> limite,
      Value<int> mes,
      Value<int> anio,
      Value<String> usuarioId,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });

class $$BudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get limite => $composableBuilder(
    column: $table.limite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mes => $composableBuilder(
    column: $table.mes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get anio => $composableBuilder(
    column: $table.anio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get limite => $composableBuilder(
    column: $table.limite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mes => $composableBuilder(
    column: $table.mes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get anio => $composableBuilder(
    column: $table.anio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<double> get limite =>
      $composableBuilder(column: $table.limite, builder: (column) => column);

  GeneratedColumn<int> get mes =>
      $composableBuilder(column: $table.mes, builder: (column) => column);

  GeneratedColumn<int> get anio =>
      $composableBuilder(column: $table.anio, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => column,
  );
}

class $$BudgetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetsTable,
          Budget,
          $$BudgetsTableFilterComposer,
          $$BudgetsTableOrderingComposer,
          $$BudgetsTableAnnotationComposer,
          $$BudgetsTableCreateCompanionBuilder,
          $$BudgetsTableUpdateCompanionBuilder,
          (Budget, BaseReferences<_$AppDatabase, $BudgetsTable, Budget>),
          Budget,
          PrefetchHooks Function()
        > {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> categoria = const Value.absent(),
                Value<double> limite = const Value.absent(),
                Value<int> mes = const Value.absent(),
                Value<int> anio = const Value.absent(),
                Value<String> usuarioId = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetsCompanion(
                id: id,
                categoria: categoria,
                limite: limite,
                mes: mes,
                anio: anio,
                usuarioId: usuarioId,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String categoria,
                required double limite,
                required int mes,
                required int anio,
                required String usuarioId,
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetsCompanion.insert(
                id: id,
                categoria: categoria,
                limite: limite,
                mes: mes,
                anio: anio,
                usuarioId: usuarioId,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetsTable,
      Budget,
      $$BudgetsTableFilterComposer,
      $$BudgetsTableOrderingComposer,
      $$BudgetsTableAnnotationComposer,
      $$BudgetsTableCreateCompanionBuilder,
      $$BudgetsTableUpdateCompanionBuilder,
      (Budget, BaseReferences<_$AppDatabase, $BudgetsTable, Budget>),
      Budget,
      PrefetchHooks Function()
    >;
typedef $$SavingsGoalsTableCreateCompanionBuilder =
    SavingsGoalsCompanion Function({
      required String id,
      required String nombre,
      Value<String> emoji,
      required double montoMeta,
      Value<double> montoActual,
      Value<DateTime?> fechaMeta,
      Value<String> color,
      required String usuarioId,
      required DateTime creadoEn,
      Value<DateTime> actualizadoEn,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });
typedef $$SavingsGoalsTableUpdateCompanionBuilder =
    SavingsGoalsCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<String> emoji,
      Value<double> montoMeta,
      Value<double> montoActual,
      Value<DateTime?> fechaMeta,
      Value<String> color,
      Value<String> usuarioId,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });

class $$SavingsGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get montoMeta => $composableBuilder(
    column: $table.montoMeta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get montoActual => $composableBuilder(
    column: $table.montoActual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaMeta => $composableBuilder(
    column: $table.fechaMeta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavingsGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get montoMeta => $composableBuilder(
    column: $table.montoMeta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get montoActual => $composableBuilder(
    column: $table.montoActual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaMeta => $composableBuilder(
    column: $table.fechaMeta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavingsGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<double> get montoMeta =>
      $composableBuilder(column: $table.montoMeta, builder: (column) => column);

  GeneratedColumn<double> get montoActual => $composableBuilder(
    column: $table.montoActual,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaMeta =>
      $composableBuilder(column: $table.fechaMeta, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => column,
  );
}

class $$SavingsGoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavingsGoalsTable,
          SavingsGoal,
          $$SavingsGoalsTableFilterComposer,
          $$SavingsGoalsTableOrderingComposer,
          $$SavingsGoalsTableAnnotationComposer,
          $$SavingsGoalsTableCreateCompanionBuilder,
          $$SavingsGoalsTableUpdateCompanionBuilder,
          (
            SavingsGoal,
            BaseReferences<_$AppDatabase, $SavingsGoalsTable, SavingsGoal>,
          ),
          SavingsGoal,
          PrefetchHooks Function()
        > {
  $$SavingsGoalsTableTableManager(_$AppDatabase db, $SavingsGoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavingsGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> emoji = const Value.absent(),
                Value<double> montoMeta = const Value.absent(),
                Value<double> montoActual = const Value.absent(),
                Value<DateTime?> fechaMeta = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String> usuarioId = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavingsGoalsCompanion(
                id: id,
                nombre: nombre,
                emoji: emoji,
                montoMeta: montoMeta,
                montoActual: montoActual,
                fechaMeta: fechaMeta,
                color: color,
                usuarioId: usuarioId,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                Value<String> emoji = const Value.absent(),
                required double montoMeta,
                Value<double> montoActual = const Value.absent(),
                Value<DateTime?> fechaMeta = const Value.absent(),
                Value<String> color = const Value.absent(),
                required String usuarioId,
                required DateTime creadoEn,
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavingsGoalsCompanion.insert(
                id: id,
                nombre: nombre,
                emoji: emoji,
                montoMeta: montoMeta,
                montoActual: montoActual,
                fechaMeta: fechaMeta,
                color: color,
                usuarioId: usuarioId,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavingsGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavingsGoalsTable,
      SavingsGoal,
      $$SavingsGoalsTableFilterComposer,
      $$SavingsGoalsTableOrderingComposer,
      $$SavingsGoalsTableAnnotationComposer,
      $$SavingsGoalsTableCreateCompanionBuilder,
      $$SavingsGoalsTableUpdateCompanionBuilder,
      (
        SavingsGoal,
        BaseReferences<_$AppDatabase, $SavingsGoalsTable, SavingsGoal>,
      ),
      SavingsGoal,
      PrefetchHooks Function()
    >;
typedef $$DebtsTableCreateCompanionBuilder =
    DebtsCompanion Function({
      required String id,
      required String nombre,
      Value<String> concepto,
      required double monto,
      required int tipo,
      Value<bool> pagado,
      required DateTime fecha,
      required String usuarioId,
      required DateTime creadoEn,
      Value<DateTime> actualizadoEn,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });
typedef $$DebtsTableUpdateCompanionBuilder =
    DebtsCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<String> concepto,
      Value<double> monto,
      Value<int> tipo,
      Value<bool> pagado,
      Value<DateTime> fecha,
      Value<String> usuarioId,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });

class $$DebtsTableFilterComposer extends Composer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get concepto => $composableBuilder(
    column: $table.concepto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get monto => $composableBuilder(
    column: $table.monto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pagado => $composableBuilder(
    column: $table.pagado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DebtsTableOrderingComposer
    extends Composer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get concepto => $composableBuilder(
    column: $table.concepto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get monto => $composableBuilder(
    column: $table.monto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pagado => $composableBuilder(
    column: $table.pagado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DebtsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get concepto =>
      $composableBuilder(column: $table.concepto, builder: (column) => column);

  GeneratedColumn<double> get monto =>
      $composableBuilder(column: $table.monto, builder: (column) => column);

  GeneratedColumn<int> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<bool> get pagado =>
      $composableBuilder(column: $table.pagado, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => column,
  );
}

class $$DebtsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DebtsTable,
          Debt,
          $$DebtsTableFilterComposer,
          $$DebtsTableOrderingComposer,
          $$DebtsTableAnnotationComposer,
          $$DebtsTableCreateCompanionBuilder,
          $$DebtsTableUpdateCompanionBuilder,
          (Debt, BaseReferences<_$AppDatabase, $DebtsTable, Debt>),
          Debt,
          PrefetchHooks Function()
        > {
  $$DebtsTableTableManager(_$AppDatabase db, $DebtsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DebtsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DebtsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DebtsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> concepto = const Value.absent(),
                Value<double> monto = const Value.absent(),
                Value<int> tipo = const Value.absent(),
                Value<bool> pagado = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<String> usuarioId = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DebtsCompanion(
                id: id,
                nombre: nombre,
                concepto: concepto,
                monto: monto,
                tipo: tipo,
                pagado: pagado,
                fecha: fecha,
                usuarioId: usuarioId,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                Value<String> concepto = const Value.absent(),
                required double monto,
                required int tipo,
                Value<bool> pagado = const Value.absent(),
                required DateTime fecha,
                required String usuarioId,
                required DateTime creadoEn,
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DebtsCompanion.insert(
                id: id,
                nombre: nombre,
                concepto: concepto,
                monto: monto,
                tipo: tipo,
                pagado: pagado,
                fecha: fecha,
                usuarioId: usuarioId,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DebtsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DebtsTable,
      Debt,
      $$DebtsTableFilterComposer,
      $$DebtsTableOrderingComposer,
      $$DebtsTableAnnotationComposer,
      $$DebtsTableCreateCompanionBuilder,
      $$DebtsTableUpdateCompanionBuilder,
      (Debt, BaseReferences<_$AppDatabase, $DebtsTable, Debt>),
      Debt,
      PrefetchHooks Function()
    >;
typedef $$RecurringExpensesTableCreateCompanionBuilder =
    RecurringExpensesCompanion Function({
      required String id,
      required String nombre,
      required String categoria,
      Value<String> categoriaEmoji,
      required double monto,
      Value<int> frecuencia,
      Value<int> diaDelMes,
      Value<bool> activo,
      required String usuarioId,
      required DateTime creadoEn,
      Value<DateTime> actualizadoEn,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });
typedef $$RecurringExpensesTableUpdateCompanionBuilder =
    RecurringExpensesCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<String> categoria,
      Value<String> categoriaEmoji,
      Value<double> monto,
      Value<int> frecuencia,
      Value<int> diaDelMes,
      Value<bool> activo,
      Value<String> usuarioId,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });

class $$RecurringExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringExpensesTable> {
  $$RecurringExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoriaEmoji => $composableBuilder(
    column: $table.categoriaEmoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get monto => $composableBuilder(
    column: $table.monto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get frecuencia => $composableBuilder(
    column: $table.frecuencia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diaDelMes => $composableBuilder(
    column: $table.diaDelMes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecurringExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringExpensesTable> {
  $$RecurringExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoriaEmoji => $composableBuilder(
    column: $table.categoriaEmoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get monto => $composableBuilder(
    column: $table.monto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get frecuencia => $composableBuilder(
    column: $table.frecuencia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diaDelMes => $composableBuilder(
    column: $table.diaDelMes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecurringExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringExpensesTable> {
  $$RecurringExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<String> get categoriaEmoji => $composableBuilder(
    column: $table.categoriaEmoji,
    builder: (column) => column,
  );

  GeneratedColumn<double> get monto =>
      $composableBuilder(column: $table.monto, builder: (column) => column);

  GeneratedColumn<int> get frecuencia => $composableBuilder(
    column: $table.frecuencia,
    builder: (column) => column,
  );

  GeneratedColumn<int> get diaDelMes =>
      $composableBuilder(column: $table.diaDelMes, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => column,
  );
}

class $$RecurringExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecurringExpensesTable,
          RecurringExpense,
          $$RecurringExpensesTableFilterComposer,
          $$RecurringExpensesTableOrderingComposer,
          $$RecurringExpensesTableAnnotationComposer,
          $$RecurringExpensesTableCreateCompanionBuilder,
          $$RecurringExpensesTableUpdateCompanionBuilder,
          (
            RecurringExpense,
            BaseReferences<
              _$AppDatabase,
              $RecurringExpensesTable,
              RecurringExpense
            >,
          ),
          RecurringExpense,
          PrefetchHooks Function()
        > {
  $$RecurringExpensesTableTableManager(
    _$AppDatabase db,
    $RecurringExpensesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurringExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurringExpensesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> categoria = const Value.absent(),
                Value<String> categoriaEmoji = const Value.absent(),
                Value<double> monto = const Value.absent(),
                Value<int> frecuencia = const Value.absent(),
                Value<int> diaDelMes = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<String> usuarioId = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecurringExpensesCompanion(
                id: id,
                nombre: nombre,
                categoria: categoria,
                categoriaEmoji: categoriaEmoji,
                monto: monto,
                frecuencia: frecuencia,
                diaDelMes: diaDelMes,
                activo: activo,
                usuarioId: usuarioId,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                required String categoria,
                Value<String> categoriaEmoji = const Value.absent(),
                required double monto,
                Value<int> frecuencia = const Value.absent(),
                Value<int> diaDelMes = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                required String usuarioId,
                required DateTime creadoEn,
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecurringExpensesCompanion.insert(
                id: id,
                nombre: nombre,
                categoria: categoria,
                categoriaEmoji: categoriaEmoji,
                monto: monto,
                frecuencia: frecuencia,
                diaDelMes: diaDelMes,
                activo: activo,
                usuarioId: usuarioId,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecurringExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecurringExpensesTable,
      RecurringExpense,
      $$RecurringExpensesTableFilterComposer,
      $$RecurringExpensesTableOrderingComposer,
      $$RecurringExpensesTableAnnotationComposer,
      $$RecurringExpensesTableCreateCompanionBuilder,
      $$RecurringExpensesTableUpdateCompanionBuilder,
      (
        RecurringExpense,
        BaseReferences<
          _$AppDatabase,
          $RecurringExpensesTable,
          RecurringExpense
        >,
      ),
      RecurringExpense,
      PrefetchHooks Function()
    >;
typedef $$EventsTableCreateCompanionBuilder =
    EventsCompanion Function({
      required String id,
      required String titulo,
      Value<String?> descripcion,
      required DateTime fecha,
      Value<String?> hora,
      Value<int> duracionMinutos,
      Value<bool> todoElDia,
      Value<bool> completado,
      Value<String> color,
      Value<String> tipo,
      required String usuarioId,
      required DateTime creadoEn,
      Value<DateTime> actualizadoEn,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });
typedef $$EventsTableUpdateCompanionBuilder =
    EventsCompanion Function({
      Value<String> id,
      Value<String> titulo,
      Value<String?> descripcion,
      Value<DateTime> fecha,
      Value<String?> hora,
      Value<int> duracionMinutos,
      Value<bool> todoElDia,
      Value<bool> completado,
      Value<String> color,
      Value<String> tipo,
      Value<String> usuarioId,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });

class $$EventsTableFilterComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hora => $composableBuilder(
    column: $table.hora,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duracionMinutos => $composableBuilder(
    column: $table.duracionMinutos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get todoElDia => $composableBuilder(
    column: $table.todoElDia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completado => $composableBuilder(
    column: $table.completado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EventsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hora => $composableBuilder(
    column: $table.hora,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duracionMinutos => $composableBuilder(
    column: $table.duracionMinutos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get todoElDia => $composableBuilder(
    column: $table.todoElDia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completado => $composableBuilder(
    column: $table.completado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get titulo =>
      $composableBuilder(column: $table.titulo, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get hora =>
      $composableBuilder(column: $table.hora, builder: (column) => column);

  GeneratedColumn<int> get duracionMinutos => $composableBuilder(
    column: $table.duracionMinutos,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get todoElDia =>
      $composableBuilder(column: $table.todoElDia, builder: (column) => column);

  GeneratedColumn<bool> get completado => $composableBuilder(
    column: $table.completado,
    builder: (column) => column,
  );

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => column,
  );
}

class $$EventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventsTable,
          Event,
          $$EventsTableFilterComposer,
          $$EventsTableOrderingComposer,
          $$EventsTableAnnotationComposer,
          $$EventsTableCreateCompanionBuilder,
          $$EventsTableUpdateCompanionBuilder,
          (Event, BaseReferences<_$AppDatabase, $EventsTable, Event>),
          Event,
          PrefetchHooks Function()
        > {
  $$EventsTableTableManager(_$AppDatabase db, $EventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> titulo = const Value.absent(),
                Value<String?> descripcion = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<String?> hora = const Value.absent(),
                Value<int> duracionMinutos = const Value.absent(),
                Value<bool> todoElDia = const Value.absent(),
                Value<bool> completado = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String> usuarioId = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventsCompanion(
                id: id,
                titulo: titulo,
                descripcion: descripcion,
                fecha: fecha,
                hora: hora,
                duracionMinutos: duracionMinutos,
                todoElDia: todoElDia,
                completado: completado,
                color: color,
                tipo: tipo,
                usuarioId: usuarioId,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String titulo,
                Value<String?> descripcion = const Value.absent(),
                required DateTime fecha,
                Value<String?> hora = const Value.absent(),
                Value<int> duracionMinutos = const Value.absent(),
                Value<bool> todoElDia = const Value.absent(),
                Value<bool> completado = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                required String usuarioId,
                required DateTime creadoEn,
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventsCompanion.insert(
                id: id,
                titulo: titulo,
                descripcion: descripcion,
                fecha: fecha,
                hora: hora,
                duracionMinutos: duracionMinutos,
                todoElDia: todoElDia,
                completado: completado,
                color: color,
                tipo: tipo,
                usuarioId: usuarioId,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventsTable,
      Event,
      $$EventsTableFilterComposer,
      $$EventsTableOrderingComposer,
      $$EventsTableAnnotationComposer,
      $$EventsTableCreateCompanionBuilder,
      $$EventsTableUpdateCompanionBuilder,
      (Event, BaseReferences<_$AppDatabase, $EventsTable, Event>),
      Event,
      PrefetchHooks Function()
    >;
typedef $$HabitsTableCreateCompanionBuilder =
    HabitsCompanion Function({
      required String id,
      required String nombre,
      Value<String> icono,
      Value<int> categoria,
      Value<int> frecuencia,
      Value<int> metaSemanal,
      Value<bool> completadoHoy,
      Value<int> rachaActual,
      Value<int> rachaMaxima,
      Value<int> totalCompletados,
      Value<String> color,
      required String usuarioId,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });
typedef $$HabitsTableUpdateCompanionBuilder =
    HabitsCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<String> icono,
      Value<int> categoria,
      Value<int> frecuencia,
      Value<int> metaSemanal,
      Value<bool> completadoHoy,
      Value<int> rachaActual,
      Value<int> rachaMaxima,
      Value<int> totalCompletados,
      Value<String> color,
      Value<String> usuarioId,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });

class $$HabitsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icono => $composableBuilder(
    column: $table.icono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get frecuencia => $composableBuilder(
    column: $table.frecuencia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get metaSemanal => $composableBuilder(
    column: $table.metaSemanal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completadoHoy => $composableBuilder(
    column: $table.completadoHoy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rachaActual => $composableBuilder(
    column: $table.rachaActual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rachaMaxima => $composableBuilder(
    column: $table.rachaMaxima,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCompletados => $composableBuilder(
    column: $table.totalCompletados,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HabitsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icono => $composableBuilder(
    column: $table.icono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get frecuencia => $composableBuilder(
    column: $table.frecuencia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get metaSemanal => $composableBuilder(
    column: $table.metaSemanal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completadoHoy => $composableBuilder(
    column: $table.completadoHoy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rachaActual => $composableBuilder(
    column: $table.rachaActual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rachaMaxima => $composableBuilder(
    column: $table.rachaMaxima,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCompletados => $composableBuilder(
    column: $table.totalCompletados,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get icono =>
      $composableBuilder(column: $table.icono, builder: (column) => column);

  GeneratedColumn<int> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<int> get frecuencia => $composableBuilder(
    column: $table.frecuencia,
    builder: (column) => column,
  );

  GeneratedColumn<int> get metaSemanal => $composableBuilder(
    column: $table.metaSemanal,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get completadoHoy => $composableBuilder(
    column: $table.completadoHoy,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rachaActual => $composableBuilder(
    column: $table.rachaActual,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rachaMaxima => $composableBuilder(
    column: $table.rachaMaxima,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalCompletados => $composableBuilder(
    column: $table.totalCompletados,
    builder: (column) => column,
  );

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => column,
  );
}

class $$HabitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitsTable,
          Habit,
          $$HabitsTableFilterComposer,
          $$HabitsTableOrderingComposer,
          $$HabitsTableAnnotationComposer,
          $$HabitsTableCreateCompanionBuilder,
          $$HabitsTableUpdateCompanionBuilder,
          (Habit, BaseReferences<_$AppDatabase, $HabitsTable, Habit>),
          Habit,
          PrefetchHooks Function()
        > {
  $$HabitsTableTableManager(_$AppDatabase db, $HabitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> icono = const Value.absent(),
                Value<int> categoria = const Value.absent(),
                Value<int> frecuencia = const Value.absent(),
                Value<int> metaSemanal = const Value.absent(),
                Value<bool> completadoHoy = const Value.absent(),
                Value<int> rachaActual = const Value.absent(),
                Value<int> rachaMaxima = const Value.absent(),
                Value<int> totalCompletados = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String> usuarioId = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitsCompanion(
                id: id,
                nombre: nombre,
                icono: icono,
                categoria: categoria,
                frecuencia: frecuencia,
                metaSemanal: metaSemanal,
                completadoHoy: completadoHoy,
                rachaActual: rachaActual,
                rachaMaxima: rachaMaxima,
                totalCompletados: totalCompletados,
                color: color,
                usuarioId: usuarioId,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                Value<String> icono = const Value.absent(),
                Value<int> categoria = const Value.absent(),
                Value<int> frecuencia = const Value.absent(),
                Value<int> metaSemanal = const Value.absent(),
                Value<bool> completadoHoy = const Value.absent(),
                Value<int> rachaActual = const Value.absent(),
                Value<int> rachaMaxima = const Value.absent(),
                Value<int> totalCompletados = const Value.absent(),
                Value<String> color = const Value.absent(),
                required String usuarioId,
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitsCompanion.insert(
                id: id,
                nombre: nombre,
                icono: icono,
                categoria: categoria,
                frecuencia: frecuencia,
                metaSemanal: metaSemanal,
                completadoHoy: completadoHoy,
                rachaActual: rachaActual,
                rachaMaxima: rachaMaxima,
                totalCompletados: totalCompletados,
                color: color,
                usuarioId: usuarioId,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HabitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitsTable,
      Habit,
      $$HabitsTableFilterComposer,
      $$HabitsTableOrderingComposer,
      $$HabitsTableAnnotationComposer,
      $$HabitsTableCreateCompanionBuilder,
      $$HabitsTableUpdateCompanionBuilder,
      (Habit, BaseReferences<_$AppDatabase, $HabitsTable, Habit>),
      Habit,
      PrefetchHooks Function()
    >;
typedef $$HabitCompletionsTableCreateCompanionBuilder =
    HabitCompletionsCompanion Function({
      required String id,
      required String habitId,
      required String usuarioId,
      required DateTime fecha,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });
typedef $$HabitCompletionsTableUpdateCompanionBuilder =
    HabitCompletionsCompanion Function({
      Value<String> id,
      Value<String> habitId,
      Value<String> usuarioId,
      Value<DateTime> fecha,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });

class $$HabitCompletionsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitCompletionsTable> {
  $$HabitCompletionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get habitId => $composableBuilder(
    column: $table.habitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HabitCompletionsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitCompletionsTable> {
  $$HabitCompletionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get habitId => $composableBuilder(
    column: $table.habitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitCompletionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitCompletionsTable> {
  $$HabitCompletionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get habitId =>
      $composableBuilder(column: $table.habitId, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => column,
  );
}

class $$HabitCompletionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitCompletionsTable,
          HabitCompletion,
          $$HabitCompletionsTableFilterComposer,
          $$HabitCompletionsTableOrderingComposer,
          $$HabitCompletionsTableAnnotationComposer,
          $$HabitCompletionsTableCreateCompanionBuilder,
          $$HabitCompletionsTableUpdateCompanionBuilder,
          (
            HabitCompletion,
            BaseReferences<
              _$AppDatabase,
              $HabitCompletionsTable,
              HabitCompletion
            >,
          ),
          HabitCompletion,
          PrefetchHooks Function()
        > {
  $$HabitCompletionsTableTableManager(
    _$AppDatabase db,
    $HabitCompletionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitCompletionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitCompletionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitCompletionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> habitId = const Value.absent(),
                Value<String> usuarioId = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitCompletionsCompanion(
                id: id,
                habitId: habitId,
                usuarioId: usuarioId,
                fecha: fecha,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String habitId,
                required String usuarioId,
                required DateTime fecha,
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitCompletionsCompanion.insert(
                id: id,
                habitId: habitId,
                usuarioId: usuarioId,
                fecha: fecha,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HabitCompletionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitCompletionsTable,
      HabitCompletion,
      $$HabitCompletionsTableFilterComposer,
      $$HabitCompletionsTableOrderingComposer,
      $$HabitCompletionsTableAnnotationComposer,
      $$HabitCompletionsTableCreateCompanionBuilder,
      $$HabitCompletionsTableUpdateCompanionBuilder,
      (
        HabitCompletion,
        BaseReferences<_$AppDatabase, $HabitCompletionsTable, HabitCompletion>,
      ),
      HabitCompletion,
      PrefetchHooks Function()
    >;
typedef $$SyncTombstonesTableCreateCompanionBuilder =
    SyncTombstonesCompanion Function({
      required String filaId,
      required String tabla,
      required String usuarioId,
      Value<DateTime> borradoEn,
      Value<int> rowid,
    });
typedef $$SyncTombstonesTableUpdateCompanionBuilder =
    SyncTombstonesCompanion Function({
      Value<String> filaId,
      Value<String> tabla,
      Value<String> usuarioId,
      Value<DateTime> borradoEn,
      Value<int> rowid,
    });

class $$SyncTombstonesTableFilterComposer
    extends Composer<_$AppDatabase, $SyncTombstonesTable> {
  $$SyncTombstonesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get filaId => $composableBuilder(
    column: $table.filaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tabla => $composableBuilder(
    column: $table.tabla,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get borradoEn => $composableBuilder(
    column: $table.borradoEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncTombstonesTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncTombstonesTable> {
  $$SyncTombstonesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get filaId => $composableBuilder(
    column: $table.filaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tabla => $composableBuilder(
    column: $table.tabla,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get borradoEn => $composableBuilder(
    column: $table.borradoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncTombstonesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncTombstonesTable> {
  $$SyncTombstonesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get filaId =>
      $composableBuilder(column: $table.filaId, builder: (column) => column);

  GeneratedColumn<String> get tabla =>
      $composableBuilder(column: $table.tabla, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<DateTime> get borradoEn =>
      $composableBuilder(column: $table.borradoEn, builder: (column) => column);
}

class $$SyncTombstonesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncTombstonesTable,
          SyncTombstone,
          $$SyncTombstonesTableFilterComposer,
          $$SyncTombstonesTableOrderingComposer,
          $$SyncTombstonesTableAnnotationComposer,
          $$SyncTombstonesTableCreateCompanionBuilder,
          $$SyncTombstonesTableUpdateCompanionBuilder,
          (
            SyncTombstone,
            BaseReferences<_$AppDatabase, $SyncTombstonesTable, SyncTombstone>,
          ),
          SyncTombstone,
          PrefetchHooks Function()
        > {
  $$SyncTombstonesTableTableManager(
    _$AppDatabase db,
    $SyncTombstonesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncTombstonesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncTombstonesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncTombstonesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> filaId = const Value.absent(),
                Value<String> tabla = const Value.absent(),
                Value<String> usuarioId = const Value.absent(),
                Value<DateTime> borradoEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncTombstonesCompanion(
                filaId: filaId,
                tabla: tabla,
                usuarioId: usuarioId,
                borradoEn: borradoEn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String filaId,
                required String tabla,
                required String usuarioId,
                Value<DateTime> borradoEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncTombstonesCompanion.insert(
                filaId: filaId,
                tabla: tabla,
                usuarioId: usuarioId,
                borradoEn: borradoEn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncTombstonesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncTombstonesTable,
      SyncTombstone,
      $$SyncTombstonesTableFilterComposer,
      $$SyncTombstonesTableOrderingComposer,
      $$SyncTombstonesTableAnnotationComposer,
      $$SyncTombstonesTableCreateCompanionBuilder,
      $$SyncTombstonesTableUpdateCompanionBuilder,
      (
        SyncTombstone,
        BaseReferences<_$AppDatabase, $SyncTombstonesTable, SyncTombstone>,
      ),
      SyncTombstone,
      PrefetchHooks Function()
    >;
typedef $$NotesTableCreateCompanionBuilder =
    NotesCompanion Function({
      required String id,
      required String titulo,
      Value<String> contenido,
      Value<int> categoria,
      Value<String> color,
      Value<bool> esFijada,
      Value<bool> esChecklist,
      Value<String> itemsJson,
      required String usuarioId,
      Value<DateTime> creadaEn,
      Value<DateTime> actualizadaEn,
      Value<String> tags,
      Value<DateTime> actualizadoEn,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });
typedef $$NotesTableUpdateCompanionBuilder =
    NotesCompanion Function({
      Value<String> id,
      Value<String> titulo,
      Value<String> contenido,
      Value<int> categoria,
      Value<String> color,
      Value<bool> esFijada,
      Value<bool> esChecklist,
      Value<String> itemsJson,
      Value<String> usuarioId,
      Value<DateTime> creadaEn,
      Value<DateTime> actualizadaEn,
      Value<String> tags,
      Value<DateTime> actualizadoEn,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contenido => $composableBuilder(
    column: $table.contenido,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esFijada => $composableBuilder(
    column: $table.esFijada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esChecklist => $composableBuilder(
    column: $table.esChecklist,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadaEn => $composableBuilder(
    column: $table.creadaEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadaEn => $composableBuilder(
    column: $table.actualizadaEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contenido => $composableBuilder(
    column: $table.contenido,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esFijada => $composableBuilder(
    column: $table.esFijada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esChecklist => $composableBuilder(
    column: $table.esChecklist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadaEn => $composableBuilder(
    column: $table.creadaEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadaEn => $composableBuilder(
    column: $table.actualizadaEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get titulo =>
      $composableBuilder(column: $table.titulo, builder: (column) => column);

  GeneratedColumn<String> get contenido =>
      $composableBuilder(column: $table.contenido, builder: (column) => column);

  GeneratedColumn<int> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get esFijada =>
      $composableBuilder(column: $table.esFijada, builder: (column) => column);

  GeneratedColumn<bool> get esChecklist => $composableBuilder(
    column: $table.esChecklist,
    builder: (column) => column,
  );

  GeneratedColumn<String> get itemsJson =>
      $composableBuilder(column: $table.itemsJson, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<DateTime> get creadaEn =>
      $composableBuilder(column: $table.creadaEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadaEn => $composableBuilder(
    column: $table.actualizadaEn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => column,
  );
}

class $$NotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotesTable,
          Note,
          $$NotesTableFilterComposer,
          $$NotesTableOrderingComposer,
          $$NotesTableAnnotationComposer,
          $$NotesTableCreateCompanionBuilder,
          $$NotesTableUpdateCompanionBuilder,
          (Note, BaseReferences<_$AppDatabase, $NotesTable, Note>),
          Note,
          PrefetchHooks Function()
        > {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> titulo = const Value.absent(),
                Value<String> contenido = const Value.absent(),
                Value<int> categoria = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<bool> esFijada = const Value.absent(),
                Value<bool> esChecklist = const Value.absent(),
                Value<String> itemsJson = const Value.absent(),
                Value<String> usuarioId = const Value.absent(),
                Value<DateTime> creadaEn = const Value.absent(),
                Value<DateTime> actualizadaEn = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotesCompanion(
                id: id,
                titulo: titulo,
                contenido: contenido,
                categoria: categoria,
                color: color,
                esFijada: esFijada,
                esChecklist: esChecklist,
                itemsJson: itemsJson,
                usuarioId: usuarioId,
                creadaEn: creadaEn,
                actualizadaEn: actualizadaEn,
                tags: tags,
                actualizadoEn: actualizadoEn,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String titulo,
                Value<String> contenido = const Value.absent(),
                Value<int> categoria = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<bool> esFijada = const Value.absent(),
                Value<bool> esChecklist = const Value.absent(),
                Value<String> itemsJson = const Value.absent(),
                required String usuarioId,
                Value<DateTime> creadaEn = const Value.absent(),
                Value<DateTime> actualizadaEn = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotesCompanion.insert(
                id: id,
                titulo: titulo,
                contenido: contenido,
                categoria: categoria,
                color: color,
                esFijada: esFijada,
                esChecklist: esChecklist,
                itemsJson: itemsJson,
                usuarioId: usuarioId,
                creadaEn: creadaEn,
                actualizadaEn: actualizadaEn,
                tags: tags,
                actualizadoEn: actualizadoEn,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotesTable,
      Note,
      $$NotesTableFilterComposer,
      $$NotesTableOrderingComposer,
      $$NotesTableAnnotationComposer,
      $$NotesTableCreateCompanionBuilder,
      $$NotesTableUpdateCompanionBuilder,
      (Note, BaseReferences<_$AppDatabase, $NotesTable, Note>),
      Note,
      PrefetchHooks Function()
    >;
typedef $$NoteDraftsTableCreateCompanionBuilder =
    NoteDraftsCompanion Function({
      required String id,
      required String usuarioId,
      Value<String> titulo,
      Value<String> contenido,
      Value<String> tags,
      Value<String> itemsJson,
      Value<int> categoria,
      Value<String> color,
      Value<bool> esFijada,
      Value<bool> esChecklist,
      Value<DateTime> actualizadoEn,
      Value<int> rowid,
    });
typedef $$NoteDraftsTableUpdateCompanionBuilder =
    NoteDraftsCompanion Function({
      Value<String> id,
      Value<String> usuarioId,
      Value<String> titulo,
      Value<String> contenido,
      Value<String> tags,
      Value<String> itemsJson,
      Value<int> categoria,
      Value<String> color,
      Value<bool> esFijada,
      Value<bool> esChecklist,
      Value<DateTime> actualizadoEn,
      Value<int> rowid,
    });

class $$NoteDraftsTableFilterComposer
    extends Composer<_$AppDatabase, $NoteDraftsTable> {
  $$NoteDraftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contenido => $composableBuilder(
    column: $table.contenido,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esFijada => $composableBuilder(
    column: $table.esFijada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esChecklist => $composableBuilder(
    column: $table.esChecklist,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NoteDraftsTableOrderingComposer
    extends Composer<_$AppDatabase, $NoteDraftsTable> {
  $$NoteDraftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contenido => $composableBuilder(
    column: $table.contenido,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esFijada => $composableBuilder(
    column: $table.esFijada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esChecklist => $composableBuilder(
    column: $table.esChecklist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NoteDraftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NoteDraftsTable> {
  $$NoteDraftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<String> get titulo =>
      $composableBuilder(column: $table.titulo, builder: (column) => column);

  GeneratedColumn<String> get contenido =>
      $composableBuilder(column: $table.contenido, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get itemsJson =>
      $composableBuilder(column: $table.itemsJson, builder: (column) => column);

  GeneratedColumn<int> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get esFijada =>
      $composableBuilder(column: $table.esFijada, builder: (column) => column);

  GeneratedColumn<bool> get esChecklist => $composableBuilder(
    column: $table.esChecklist,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );
}

class $$NoteDraftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NoteDraftsTable,
          NoteDraft,
          $$NoteDraftsTableFilterComposer,
          $$NoteDraftsTableOrderingComposer,
          $$NoteDraftsTableAnnotationComposer,
          $$NoteDraftsTableCreateCompanionBuilder,
          $$NoteDraftsTableUpdateCompanionBuilder,
          (
            NoteDraft,
            BaseReferences<_$AppDatabase, $NoteDraftsTable, NoteDraft>,
          ),
          NoteDraft,
          PrefetchHooks Function()
        > {
  $$NoteDraftsTableTableManager(_$AppDatabase db, $NoteDraftsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NoteDraftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NoteDraftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NoteDraftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> usuarioId = const Value.absent(),
                Value<String> titulo = const Value.absent(),
                Value<String> contenido = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<String> itemsJson = const Value.absent(),
                Value<int> categoria = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<bool> esFijada = const Value.absent(),
                Value<bool> esChecklist = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NoteDraftsCompanion(
                id: id,
                usuarioId: usuarioId,
                titulo: titulo,
                contenido: contenido,
                tags: tags,
                itemsJson: itemsJson,
                categoria: categoria,
                color: color,
                esFijada: esFijada,
                esChecklist: esChecklist,
                actualizadoEn: actualizadoEn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String usuarioId,
                Value<String> titulo = const Value.absent(),
                Value<String> contenido = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<String> itemsJson = const Value.absent(),
                Value<int> categoria = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<bool> esFijada = const Value.absent(),
                Value<bool> esChecklist = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NoteDraftsCompanion.insert(
                id: id,
                usuarioId: usuarioId,
                titulo: titulo,
                contenido: contenido,
                tags: tags,
                itemsJson: itemsJson,
                categoria: categoria,
                color: color,
                esFijada: esFijada,
                esChecklist: esChecklist,
                actualizadoEn: actualizadoEn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NoteDraftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NoteDraftsTable,
      NoteDraft,
      $$NoteDraftsTableFilterComposer,
      $$NoteDraftsTableOrderingComposer,
      $$NoteDraftsTableAnnotationComposer,
      $$NoteDraftsTableCreateCompanionBuilder,
      $$NoteDraftsTableUpdateCompanionBuilder,
      (NoteDraft, BaseReferences<_$AppDatabase, $NoteDraftsTable, NoteDraft>),
      NoteDraft,
      PrefetchHooks Function()
    >;
typedef $$ProfilesTableCreateCompanionBuilder =
    ProfilesCompanion Function({
      required String id,
      Value<String> email,
      Value<String> nombre,
      Value<String?> nombres,
      Value<String?> apellidos,
      Value<String?> bio,
      Value<DateTime?> fechaNacimiento,
      Value<String?> telefono,
      Value<String?> zonaHoraria,
      Value<String> visibilidad,
      Value<String?> avatarUrl,
      Value<Uint8List?> avatarBytes,
      Value<bool> avatarPendiente,
      Value<DateTime> actualizadoEn,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });
typedef $$ProfilesTableUpdateCompanionBuilder =
    ProfilesCompanion Function({
      Value<String> id,
      Value<String> email,
      Value<String> nombre,
      Value<String?> nombres,
      Value<String?> apellidos,
      Value<String?> bio,
      Value<DateTime?> fechaNacimiento,
      Value<String?> telefono,
      Value<String?> zonaHoraria,
      Value<String> visibilidad,
      Value<String?> avatarUrl,
      Value<Uint8List?> avatarBytes,
      Value<bool> avatarPendiente,
      Value<DateTime> actualizadoEn,
      Value<bool> pendienteSync,
      Value<int> rowid,
    });

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombres => $composableBuilder(
    column: $table.nombres,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get apellidos => $composableBuilder(
    column: $table.apellidos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaNacimiento => $composableBuilder(
    column: $table.fechaNacimiento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get zonaHoraria => $composableBuilder(
    column: $table.zonaHoraria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get visibilidad => $composableBuilder(
    column: $table.visibilidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get avatarBytes => $composableBuilder(
    column: $table.avatarBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get avatarPendiente => $composableBuilder(
    column: $table.avatarPendiente,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombres => $composableBuilder(
    column: $table.nombres,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get apellidos => $composableBuilder(
    column: $table.apellidos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaNacimiento => $composableBuilder(
    column: $table.fechaNacimiento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get zonaHoraria => $composableBuilder(
    column: $table.zonaHoraria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visibilidad => $composableBuilder(
    column: $table.visibilidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get avatarBytes => $composableBuilder(
    column: $table.avatarBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get avatarPendiente => $composableBuilder(
    column: $table.avatarPendiente,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get nombres =>
      $composableBuilder(column: $table.nombres, builder: (column) => column);

  GeneratedColumn<String> get apellidos =>
      $composableBuilder(column: $table.apellidos, builder: (column) => column);

  GeneratedColumn<String> get bio =>
      $composableBuilder(column: $table.bio, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaNacimiento => $composableBuilder(
    column: $table.fechaNacimiento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get zonaHoraria => $composableBuilder(
    column: $table.zonaHoraria,
    builder: (column) => column,
  );

  GeneratedColumn<String> get visibilidad => $composableBuilder(
    column: $table.visibilidad,
    builder: (column) => column,
  );

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<Uint8List> get avatarBytes => $composableBuilder(
    column: $table.avatarBytes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get avatarPendiente => $composableBuilder(
    column: $table.avatarPendiente,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pendienteSync => $composableBuilder(
    column: $table.pendienteSync,
    builder: (column) => column,
  );
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          Profile,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
          Profile,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> nombres = const Value.absent(),
                Value<String?> apellidos = const Value.absent(),
                Value<String?> bio = const Value.absent(),
                Value<DateTime?> fechaNacimiento = const Value.absent(),
                Value<String?> telefono = const Value.absent(),
                Value<String?> zonaHoraria = const Value.absent(),
                Value<String> visibilidad = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<Uint8List?> avatarBytes = const Value.absent(),
                Value<bool> avatarPendiente = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                email: email,
                nombre: nombre,
                nombres: nombres,
                apellidos: apellidos,
                bio: bio,
                fechaNacimiento: fechaNacimiento,
                telefono: telefono,
                zonaHoraria: zonaHoraria,
                visibilidad: visibilidad,
                avatarUrl: avatarUrl,
                avatarBytes: avatarBytes,
                avatarPendiente: avatarPendiente,
                actualizadoEn: actualizadoEn,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> email = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> nombres = const Value.absent(),
                Value<String?> apellidos = const Value.absent(),
                Value<String?> bio = const Value.absent(),
                Value<DateTime?> fechaNacimiento = const Value.absent(),
                Value<String?> telefono = const Value.absent(),
                Value<String?> zonaHoraria = const Value.absent(),
                Value<String> visibilidad = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<Uint8List?> avatarBytes = const Value.absent(),
                Value<bool> avatarPendiente = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<bool> pendienteSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                email: email,
                nombre: nombre,
                nombres: nombres,
                apellidos: apellidos,
                bio: bio,
                fechaNacimiento: fechaNacimiento,
                telefono: telefono,
                zonaHoraria: zonaHoraria,
                visibilidad: visibilidad,
                avatarUrl: avatarUrl,
                avatarBytes: avatarBytes,
                avatarPendiente: avatarPendiente,
                actualizadoEn: actualizadoEn,
                pendienteSync: pendienteSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      Profile,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
      Profile,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RoutinesTableTableManager get routines =>
      $$RoutinesTableTableManager(_db, _db.routines);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$SavingsGoalsTableTableManager get savingsGoals =>
      $$SavingsGoalsTableTableManager(_db, _db.savingsGoals);
  $$DebtsTableTableManager get debts =>
      $$DebtsTableTableManager(_db, _db.debts);
  $$RecurringExpensesTableTableManager get recurringExpenses =>
      $$RecurringExpensesTableTableManager(_db, _db.recurringExpenses);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db, _db.habits);
  $$HabitCompletionsTableTableManager get habitCompletions =>
      $$HabitCompletionsTableTableManager(_db, _db.habitCompletions);
  $$SyncTombstonesTableTableManager get syncTombstones =>
      $$SyncTombstonesTableTableManager(_db, _db.syncTombstones);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$NoteDraftsTableTableManager get noteDrafts =>
      $$NoteDraftsTableTableManager(_db, _db.noteDrafts);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
}
