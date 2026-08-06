import 'expense_split_entity.dart';

/// Tipo de movimiento en un grupo.
/// - [gasto]: alguien pagó algo que se reparte entre varios (lleva partes).
/// - [transferencia]: un pago directo de una persona a otra para saldar
///   deudas (no lleva partes; usa [SharedExpenseEntity.transferidoA]).
enum TipoGasto { gasto, transferencia }

/// Un gasto (o transferencia de pago) dentro de un grupo.
///
/// Espeja la tabla `grupo_gastos` de Supabase. Las [partes] se cargan de
/// `gasto_partes` y se adjuntan aquí para comodidad de la UI y el cálculo de
/// saldos.
class SharedExpenseEntity {
  final String id;
  final String grupoId;
  final String descripcion;
  final double monto;
  final String moneda;
  final String pagadoPor;      // id del miembro que pagó
  final String? transferidoA;  // id del miembro receptor (solo transferencias)
  final DateTime fecha;
  final TipoGasto tipo;
  final String categoria;      // emoji de categoría (solo presentación)
  final String creadoPor;      // uuid del usuario que registró el movimiento
  final List<ExpenseSplitEntity> partes;

  const SharedExpenseEntity({
    required this.id,
    required this.grupoId,
    required this.descripcion,
    required this.monto,
    required this.moneda,
    required this.pagadoPor,
    required this.transferidoA,
    required this.fecha,
    required this.tipo,
    required this.creadoPor,
    this.categoria = '🧾',
    this.partes = const [],
  });

  bool get esTransferencia => tipo == TipoGasto.transferencia;

  SharedExpenseEntity copyWith({
    String? id,
    String? grupoId,
    String? descripcion,
    double? monto,
    String? moneda,
    String? pagadoPor,
    String? transferidoA,
    DateTime? fecha,
    TipoGasto? tipo,
    String? categoria,
    String? creadoPor,
    List<ExpenseSplitEntity>? partes,
  }) {
    return SharedExpenseEntity(
      id:           id           ?? this.id,
      grupoId:      grupoId      ?? this.grupoId,
      descripcion:  descripcion  ?? this.descripcion,
      monto:        monto        ?? this.monto,
      moneda:       moneda       ?? this.moneda,
      pagadoPor:    pagadoPor    ?? this.pagadoPor,
      transferidoA: transferidoA ?? this.transferidoA,
      fecha:        fecha        ?? this.fecha,
      tipo:         tipo         ?? this.tipo,
      categoria:    categoria    ?? this.categoria,
      creadoPor:    creadoPor    ?? this.creadoPor,
      partes:       partes       ?? this.partes,
    );
  }
}
