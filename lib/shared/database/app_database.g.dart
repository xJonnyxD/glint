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
          ..write('creadaEn: $creadaEn')
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
          other.creadaEn == this.creadaEn);
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
          ..write('creadaEn: $creadaEn')
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
          other.creadaEn == this.creadaEn);
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoria,
    limite,
    mes,
    anio,
    usuarioId,
    creadoEn,
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
  const Budget({
    required this.id,
    required this.categoria,
    required this.limite,
    required this.mes,
    required this.anio,
    required this.usuarioId,
    required this.creadoEn,
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
  }) => Budget(
    id: id ?? this.id,
    categoria: categoria ?? this.categoria,
    limite: limite ?? this.limite,
    mes: mes ?? this.mes,
    anio: anio ?? this.anio,
    usuarioId: usuarioId ?? this.usuarioId,
    creadoEn: creadoEn ?? this.creadoEn,
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
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, categoria, limite, mes, anio, usuarioId, creadoEn);
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
          other.creadoEn == this.creadoEn);
}

class BudgetsCompanion extends UpdateCompanion<Budget> {
  final Value<String> id;
  final Value<String> categoria;
  final Value<double> limite;
  final Value<int> mes;
  final Value<int> anio;
  final Value<String> usuarioId;
  final Value<DateTime> creadoEn;
  final Value<int> rowid;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.categoria = const Value.absent(),
    this.limite = const Value.absent(),
    this.mes = const Value.absent(),
    this.anio = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.creadoEn = const Value.absent(),
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
          ..write('creadoEn: $creadoEn')
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
          other.creadoEn == this.creadoEn);
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
          ..write('creadoEn: $creadoEn')
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
          other.creadoEn == this.creadoEn);
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
          ..write('creadoEn: $creadoEn')
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
          other.creadoEn == this.creadoEn);
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    titulo,
    descripcion,
    fecha,
    hora,
    todoElDia,
    completado,
    color,
    tipo,
    usuarioId,
    creadoEn,
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
  final bool todoElDia;
  final bool completado;
  final String color;
  final String tipo;
  final String usuarioId;
  final DateTime creadoEn;
  const Event({
    required this.id,
    required this.titulo,
    this.descripcion,
    required this.fecha,
    this.hora,
    required this.todoElDia,
    required this.completado,
    required this.color,
    required this.tipo,
    required this.usuarioId,
    required this.creadoEn,
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
    map['todo_el_dia'] = Variable<bool>(todoElDia);
    map['completado'] = Variable<bool>(completado);
    map['color'] = Variable<String>(color);
    map['tipo'] = Variable<String>(tipo);
    map['usuario_id'] = Variable<String>(usuarioId);
    map['creado_en'] = Variable<DateTime>(creadoEn);
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
      todoElDia: Value(todoElDia),
      completado: Value(completado),
      color: Value(color),
      tipo: Value(tipo),
      usuarioId: Value(usuarioId),
      creadoEn: Value(creadoEn),
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
      todoElDia: serializer.fromJson<bool>(json['todoElDia']),
      completado: serializer.fromJson<bool>(json['completado']),
      color: serializer.fromJson<String>(json['color']),
      tipo: serializer.fromJson<String>(json['tipo']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
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
      'todoElDia': serializer.toJson<bool>(todoElDia),
      'completado': serializer.toJson<bool>(completado),
      'color': serializer.toJson<String>(color),
      'tipo': serializer.toJson<String>(tipo),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
    };
  }

  Event copyWith({
    String? id,
    String? titulo,
    Value<String?> descripcion = const Value.absent(),
    DateTime? fecha,
    Value<String?> hora = const Value.absent(),
    bool? todoElDia,
    bool? completado,
    String? color,
    String? tipo,
    String? usuarioId,
    DateTime? creadoEn,
  }) => Event(
    id: id ?? this.id,
    titulo: titulo ?? this.titulo,
    descripcion: descripcion.present ? descripcion.value : this.descripcion,
    fecha: fecha ?? this.fecha,
    hora: hora.present ? hora.value : this.hora,
    todoElDia: todoElDia ?? this.todoElDia,
    completado: completado ?? this.completado,
    color: color ?? this.color,
    tipo: tipo ?? this.tipo,
    usuarioId: usuarioId ?? this.usuarioId,
    creadoEn: creadoEn ?? this.creadoEn,
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
      todoElDia: data.todoElDia.present ? data.todoElDia.value : this.todoElDia,
      completado: data.completado.present
          ? data.completado.value
          : this.completado,
      color: data.color.present ? data.color.value : this.color,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
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
          ..write('todoElDia: $todoElDia, ')
          ..write('completado: $completado, ')
          ..write('color: $color, ')
          ..write('tipo: $tipo, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('creadoEn: $creadoEn')
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
    todoElDia,
    completado,
    color,
    tipo,
    usuarioId,
    creadoEn,
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
          other.todoElDia == this.todoElDia &&
          other.completado == this.completado &&
          other.color == this.color &&
          other.tipo == this.tipo &&
          other.usuarioId == this.usuarioId &&
          other.creadoEn == this.creadoEn);
}

class EventsCompanion extends UpdateCompanion<Event> {
  final Value<String> id;
  final Value<String> titulo;
  final Value<String?> descripcion;
  final Value<DateTime> fecha;
  final Value<String?> hora;
  final Value<bool> todoElDia;
  final Value<bool> completado;
  final Value<String> color;
  final Value<String> tipo;
  final Value<String> usuarioId;
  final Value<DateTime> creadoEn;
  final Value<int> rowid;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.titulo = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.fecha = const Value.absent(),
    this.hora = const Value.absent(),
    this.todoElDia = const Value.absent(),
    this.completado = const Value.absent(),
    this.color = const Value.absent(),
    this.tipo = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventsCompanion.insert({
    required String id,
    required String titulo,
    this.descripcion = const Value.absent(),
    required DateTime fecha,
    this.hora = const Value.absent(),
    this.todoElDia = const Value.absent(),
    this.completado = const Value.absent(),
    this.color = const Value.absent(),
    this.tipo = const Value.absent(),
    required String usuarioId,
    required DateTime creadoEn,
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
    Expression<bool>? todoElDia,
    Expression<bool>? completado,
    Expression<String>? color,
    Expression<String>? tipo,
    Expression<String>? usuarioId,
    Expression<DateTime>? creadoEn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (titulo != null) 'titulo': titulo,
      if (descripcion != null) 'descripcion': descripcion,
      if (fecha != null) 'fecha': fecha,
      if (hora != null) 'hora': hora,
      if (todoElDia != null) 'todo_el_dia': todoElDia,
      if (completado != null) 'completado': completado,
      if (color != null) 'color': color,
      if (tipo != null) 'tipo': tipo,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventsCompanion copyWith({
    Value<String>? id,
    Value<String>? titulo,
    Value<String?>? descripcion,
    Value<DateTime>? fecha,
    Value<String?>? hora,
    Value<bool>? todoElDia,
    Value<bool>? completado,
    Value<String>? color,
    Value<String>? tipo,
    Value<String>? usuarioId,
    Value<DateTime>? creadoEn,
    Value<int>? rowid,
  }) {
    return EventsCompanion(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      fecha: fecha ?? this.fecha,
      hora: hora ?? this.hora,
      todoElDia: todoElDia ?? this.todoElDia,
      completado: completado ?? this.completado,
      color: color ?? this.color,
      tipo: tipo ?? this.tipo,
      usuarioId: usuarioId ?? this.usuarioId,
      creadoEn: creadoEn ?? this.creadoEn,
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
          ..write('todoElDia: $todoElDia, ')
          ..write('completado: $completado, ')
          ..write('color: $color, ')
          ..write('tipo: $tipo, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('creadoEn: $creadoEn, ')
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
          ..write('creadoEn: $creadoEn')
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
          other.creadoEn == this.creadoEn);
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
  @override
  List<GeneratedColumn> get $columns => [id, habitId, usuarioId, fecha];
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
  const HabitCompletion({
    required this.id,
    required this.habitId,
    required this.usuarioId,
    required this.fecha,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['habit_id'] = Variable<String>(habitId);
    map['usuario_id'] = Variable<String>(usuarioId);
    map['fecha'] = Variable<DateTime>(fecha);
    return map;
  }

  HabitCompletionsCompanion toCompanion(bool nullToAbsent) {
    return HabitCompletionsCompanion(
      id: Value(id),
      habitId: Value(habitId),
      usuarioId: Value(usuarioId),
      fecha: Value(fecha),
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
    };
  }

  HabitCompletion copyWith({
    String? id,
    String? habitId,
    String? usuarioId,
    DateTime? fecha,
  }) => HabitCompletion(
    id: id ?? this.id,
    habitId: habitId ?? this.habitId,
    usuarioId: usuarioId ?? this.usuarioId,
    fecha: fecha ?? this.fecha,
  );
  HabitCompletion copyWithCompanion(HabitCompletionsCompanion data) {
    return HabitCompletion(
      id: data.id.present ? data.id.value : this.id,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitCompletion(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, habitId, usuarioId, fecha);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitCompletion &&
          other.id == this.id &&
          other.habitId == this.habitId &&
          other.usuarioId == this.usuarioId &&
          other.fecha == this.fecha);
}

class HabitCompletionsCompanion extends UpdateCompanion<HabitCompletion> {
  final Value<String> id;
  final Value<String> habitId;
  final Value<String> usuarioId;
  final Value<DateTime> fecha;
  final Value<int> rowid;
  const HabitCompletionsCompanion({
    this.id = const Value.absent(),
    this.habitId = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.fecha = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitCompletionsCompanion.insert({
    required String id,
    required String habitId,
    required String usuarioId,
    required DateTime fecha,
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
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitId != null) 'habit_id': habitId,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (fecha != null) 'fecha': fecha,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitCompletionsCompanion copyWith({
    Value<String>? id,
    Value<String>? habitId,
    Value<String>? usuarioId,
    Value<DateTime>? fecha,
    Value<int>? rowid,
  }) {
    return HabitCompletionsCompanion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      usuarioId: usuarioId ?? this.usuarioId,
      fecha: fecha ?? this.fecha,
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
          ..write('actualizadaEn: $actualizadaEn')
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
          other.actualizadaEn == this.actualizadaEn);
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
  late final $NotesTable notes = $NotesTable(this);
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
    notes,
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
                Value<int> rowid = const Value.absent(),
              }) => BudgetsCompanion(
                id: id,
                categoria: categoria,
                limite: limite,
                mes: mes,
                anio: anio,
                usuarioId: usuarioId,
                creadoEn: creadoEn,
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
                Value<int> rowid = const Value.absent(),
              }) => BudgetsCompanion.insert(
                id: id,
                categoria: categoria,
                limite: limite,
                mes: mes,
                anio: anio,
                usuarioId: usuarioId,
                creadoEn: creadoEn,
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
      Value<bool> todoElDia,
      Value<bool> completado,
      Value<String> color,
      Value<String> tipo,
      required String usuarioId,
      required DateTime creadoEn,
      Value<int> rowid,
    });
typedef $$EventsTableUpdateCompanionBuilder =
    EventsCompanion Function({
      Value<String> id,
      Value<String> titulo,
      Value<String?> descripcion,
      Value<DateTime> fecha,
      Value<String?> hora,
      Value<bool> todoElDia,
      Value<bool> completado,
      Value<String> color,
      Value<String> tipo,
      Value<String> usuarioId,
      Value<DateTime> creadoEn,
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
                Value<bool> todoElDia = const Value.absent(),
                Value<bool> completado = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String> usuarioId = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventsCompanion(
                id: id,
                titulo: titulo,
                descripcion: descripcion,
                fecha: fecha,
                hora: hora,
                todoElDia: todoElDia,
                completado: completado,
                color: color,
                tipo: tipo,
                usuarioId: usuarioId,
                creadoEn: creadoEn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String titulo,
                Value<String?> descripcion = const Value.absent(),
                required DateTime fecha,
                Value<String?> hora = const Value.absent(),
                Value<bool> todoElDia = const Value.absent(),
                Value<bool> completado = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                required String usuarioId,
                required DateTime creadoEn,
                Value<int> rowid = const Value.absent(),
              }) => EventsCompanion.insert(
                id: id,
                titulo: titulo,
                descripcion: descripcion,
                fecha: fecha,
                hora: hora,
                todoElDia: todoElDia,
                completado: completado,
                color: color,
                tipo: tipo,
                usuarioId: usuarioId,
                creadoEn: creadoEn,
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
      Value<int> rowid,
    });
typedef $$HabitCompletionsTableUpdateCompanionBuilder =
    HabitCompletionsCompanion Function({
      Value<String> id,
      Value<String> habitId,
      Value<String> usuarioId,
      Value<DateTime> fecha,
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
                Value<int> rowid = const Value.absent(),
              }) => HabitCompletionsCompanion(
                id: id,
                habitId: habitId,
                usuarioId: usuarioId,
                fecha: fecha,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String habitId,
                required String usuarioId,
                required DateTime fecha,
                Value<int> rowid = const Value.absent(),
              }) => HabitCompletionsCompanion.insert(
                id: id,
                habitId: habitId,
                usuarioId: usuarioId,
                fecha: fecha,
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
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
}
