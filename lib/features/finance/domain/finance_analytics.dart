import 'transaction_entity.dart';

/// Cálculos de análisis financiero a partir de las transacciones. Lógica pura
/// (sin UI ni base de datos) para poder reutilizarla y testearla.

/// Resumen de un mes: ingresos, gastos y balance neto.
class ResumenMensual {
  final DateTime mes; // primer día del mes
  final double ingresos;
  final double gastos;
  const ResumenMensual({
    required this.mes,
    required this.ingresos,
    required this.gastos,
  });
  double get balance => ingresos - gastos;
}

/// Gasto agrupado por categoría (para el "top categorías").
class GastoCategoria {
  final String categoria;
  final String emoji;
  final double total;
  const GastoCategoria(
      {required this.categoria, required this.emoji, required this.total});
}

abstract class FinanceAnalytics {
  /// Resumen de los últimos [meses] meses (del más antiguo al actual),
  /// incluyendo meses sin movimientos (en cero) para que el gráfico sea continuo.
  static List<ResumenMensual> resumenPorMes(
    List<TransactionEntity> txs,
    int meses,
  ) {
    final ahora = DateTime.now();
    final resultado = <ResumenMensual>[];
    for (var i = meses - 1; i >= 0; i--) {
      final ref = DateTime(ahora.year, ahora.month - i, 1);
      final finMes = DateTime(ref.year, ref.month + 1, 1);
      var ingresos = 0.0;
      var gastos = 0.0;
      for (final t in txs) {
        if (!t.fecha.isBefore(ref) && t.fecha.isBefore(finMes)) {
          if (t.esIngreso) {
            ingresos += t.monto;
          } else {
            gastos += t.monto;
          }
        }
      }
      resultado.add(ResumenMensual(mes: ref, ingresos: ingresos, gastos: gastos));
    }
    return resultado;
  }

  /// Gastos agrupados por categoría (todas las [txs] que sean gasto),
  /// ordenados de mayor a menor.
  static List<GastoCategoria> topCategorias(List<TransactionEntity> txs) {
    final acum = <String, double>{};
    final emojis = <String, String>{};
    for (final t in txs.where((t) => t.esGasto)) {
      acum[t.categoria] = (acum[t.categoria] ?? 0) + t.monto;
      emojis[t.categoria] = t.categoriaEmoji;
    }
    final lista = [
      for (final e in acum.entries)
        GastoCategoria(
            categoria: e.key, emoji: emojis[e.key] ?? '📦', total: e.value),
    ]..sort((a, b) => b.total.compareTo(a.total));
    return lista;
  }

  static double totalIngresos(List<TransactionEntity> txs) =>
      txs.where((t) => t.esIngreso).fold(0.0, (s, t) => s + t.monto);

  static double totalGastos(List<TransactionEntity> txs) =>
      txs.where((t) => t.esGasto).fold(0.0, (s, t) => s + t.monto);
}
