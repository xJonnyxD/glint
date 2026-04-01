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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RoutinesTable routines = $RoutinesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $EventsTable events = $EventsTable(this);
  late final $HabitsTable habits = $HabitsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    routines,
    transactions,
    events,
    habits,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RoutinesTableTableManager get routines =>
      $$RoutinesTableTableManager(_db, _db.routines);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db, _db.habits);
}
