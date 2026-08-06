import 'dart:math' as math;

import 'balance_entity.dart';
import 'member_entity.dart';
import 'settlement_entity.dart';
import 'shared_expense_entity.dart';

/// Calcula saldos y "simplifica" las deudas de un grupo: dado quién pagó qué y
/// a quién le tocaba, produce el menor número práctico de transferencias para
/// que todos queden en paz. Es el mismo espíritu del "algoritmo ingenioso" de
/// Settle Up.
///
/// Todo es lógica pura (sin red ni base de datos) para poder testearla fácil.
abstract class DebtSimplifier {
  /// Media centésima: por debajo de esto tratamos un saldo como cero, para que
  /// el redondeo de céntimos no deje deudas fantasma de 0.00…1.
  static const double _epsilon = 0.005;

  /// Saldo neto de cada miembro:
  ///   balance = Σ(lo que pagó) − Σ(lo que le tocaba).
  /// Positivo = le deben; negativo = debe.
  ///
  /// Una transferencia se trata como un gasto cuyo único "beneficiario" es el
  /// receptor: el pagador suma su monto y el receptor lo resta.
  static List<BalanceEntity> calcularBalances({
    required List<MemberEntity> miembros,
    required List<SharedExpenseEntity> gastos,
  }) {
    final saldo = {for (final m in miembros) m.id: 0.0};
    final nombre = {for (final m in miembros) m.id: m.nombre};

    for (final g in gastos) {
      // Quien paga siempre pone el dinero.
      if (saldo.containsKey(g.pagadoPor)) {
        saldo[g.pagadoPor] = saldo[g.pagadoPor]! + g.monto;
      }

      if (g.esTransferencia) {
        final receptor = g.transferidoA;
        if (receptor != null && saldo.containsKey(receptor)) {
          saldo[receptor] = saldo[receptor]! - g.monto;
        }
      } else {
        for (final parte in g.partes) {
          if (saldo.containsKey(parte.miembroId)) {
            saldo[parte.miembroId] = saldo[parte.miembroId]! - parte.monto;
          }
        }
      }
    }

    return [
      for (final m in miembros)
        BalanceEntity(
          miembroId: m.id,
          nombre: nombre[m.id] ?? m.nombre,
          balance: _redondear(saldo[m.id] ?? 0),
        ),
    ];
  }

  /// A partir de los saldos, genera las transferencias para saldar. Empareja de
  /// forma voraz al que más debe con al que más le deben, lo que da a lo sumo
  /// (n − 1) transferencias.
  static List<SettlementEntity> simplificar(List<BalanceEntity> balances) {
    // Acreedores (les deben) y deudores (deben), como montos positivos.
    final acreedores = [
      for (final b in balances)
        if (b.balance > _epsilon)
          _Nodo(b.miembroId, b.nombre, b.balance),
    ]..sort((a, b) => b.monto.compareTo(a.monto));

    final deudores = [
      for (final b in balances)
        if (b.balance < -_epsilon)
          _Nodo(b.miembroId, b.nombre, -b.balance),
    ]..sort((a, b) => b.monto.compareTo(a.monto));

    final resultado = <SettlementEntity>[];
    var i = 0; // índice de deudores
    var j = 0; // índice de acreedores

    while (i < deudores.length && j < acreedores.length) {
      final d = deudores[i];
      final c = acreedores[j];
      final pago = _redondear(math.min(d.monto, c.monto));

      if (pago > 0) {
        resultado.add(SettlementEntity(
          deId: d.id,
          deNombre: d.nombre,
          aId: c.id,
          aNombre: c.nombre,
          monto: pago,
        ));
      }

      d.monto = _redondear(d.monto - pago);
      c.monto = _redondear(c.monto - pago);

      if (d.monto <= _epsilon) i++;
      if (c.monto <= _epsilon) j++;
    }

    return resultado;
  }

  /// Atajo: balances + simplificación en un solo paso.
  static List<SettlementEntity> deudasDeGrupo({
    required List<MemberEntity> miembros,
    required List<SharedExpenseEntity> gastos,
  }) {
    return simplificar(calcularBalances(miembros: miembros, gastos: gastos));
  }

  /// Reparte [monto] equitativamente entre [miembroIds], cuadrando los céntimos
  /// del redondeo en el primer miembro para que la suma de partes sea EXACTA.
  static Map<String, double> repartirEquitativo(
    double monto,
    List<String> miembroIds,
  ) {
    if (miembroIds.isEmpty) return {};
    final n = miembroIds.length;
    final base = _redondear(monto / n);
    final partes = {for (final id in miembroIds) id: base};
    final sobrante = _redondear(monto - base * n);
    if (sobrante != 0) {
      partes[miembroIds.first] = _redondear(partes[miembroIds.first]! + sobrante);
    }
    return partes;
  }

  static double _redondear(double v) => (v * 100).round() / 100;
}

/// Nodo mutable auxiliar para el emparejamiento voraz.
class _Nodo {
  final String id;
  final String nombre;
  double monto;
  _Nodo(this.id, this.nombre, this.monto);
}
