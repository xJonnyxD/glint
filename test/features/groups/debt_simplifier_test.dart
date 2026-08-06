import 'package:flutter_test/flutter_test.dart';
import 'package:glint/features/groups/domain/debt_simplifier.dart';
import 'package:glint/features/groups/domain/expense_split_entity.dart';
import 'package:glint/features/groups/domain/member_entity.dart';
import 'package:glint/features/groups/domain/shared_expense_entity.dart';

// ── Helpers para construir datos de prueba sin ruido ──────────────────────────

MemberEntity _miembro(String id, String nombre) => MemberEntity(
      id: id,
      grupoId: 'g',
      userId: null,
      nombre: nombre,
      avatarUrl: null,
      peso: 1,
      rol: 'miembro',
      activo: true,
    );

/// Un gasto que [pagador] pagó y se reparte según [partes] (id → monto).
SharedExpenseEntity _gasto(
  String id,
  String pagador,
  double monto,
  Map<String, double> partes,
) {
  return SharedExpenseEntity(
    id: id,
    grupoId: 'g',
    descripcion: id,
    monto: monto,
    moneda: 'USD',
    pagadoPor: pagador,
    transferidoA: null,
    fecha: DateTime(2026, 1, 1),
    tipo: TipoGasto.gasto,
    creadoPor: 'u',
    partes: [
      for (final e in partes.entries)
        ExpenseSplitEntity(
          id: '$id-${e.key}',
          gastoId: id,
          miembroId: e.key,
          monto: e.value,
        ),
    ],
  );
}

/// Una transferencia de pago de [de] a [a].
SharedExpenseEntity _transferencia(String id, String de, String a, double monto) {
  return SharedExpenseEntity(
    id: id,
    grupoId: 'g',
    descripcion: 'pago',
    monto: monto,
    moneda: 'USD',
    pagadoPor: de,
    transferidoA: a,
    fecha: DateTime(2026, 1, 2),
    tipo: TipoGasto.transferencia,
    creadoPor: 'u',
  );
}

double _balanceDe(List balances, String id) =>
    balances.firstWhere((b) => b.miembroId == id).balance;

void main() {
  group('calcularBalances', () {
    test('dos personas, gasto dividido a medias', () {
      final miembros = [_miembro('a', 'Ana'), _miembro('b', 'Beto')];
      final gastos = [
        _gasto('e1', 'a', 100, {'a': 50, 'b': 50}),
      ];
      final balances =
          DebtSimplifier.calcularBalances(miembros: miembros, gastos: gastos);
      expect(_balanceDe(balances, 'a'), 50);  // Ana puso 100, le tocaba 50
      expect(_balanceDe(balances, 'b'), -50); // Beto no puso, le tocaba 50
    });

    test('los balances de un grupo siempre suman ~0', () {
      final miembros = [
        _miembro('a', 'Ana'),
        _miembro('b', 'Beto'),
        _miembro('c', 'Caro'),
      ];
      final gastos = [
        _gasto('e1', 'a', 60, {'a': 20, 'b': 20, 'c': 20}),
        _gasto('e2', 'b', 30, {'a': 10, 'b': 10, 'c': 10}),
      ];
      final balances =
          DebtSimplifier.calcularBalances(miembros: miembros, gastos: gastos);
      final suma = balances.fold<double>(0, (s, b) => s + b.balance);
      expect(suma.abs() < 0.01, isTrue);
    });

    test('una transferencia salda la deuda', () {
      final miembros = [_miembro('a', 'Ana'), _miembro('b', 'Beto')];
      final gastos = [
        _gasto('e1', 'a', 100, {'a': 50, 'b': 50}), // Beto debe 50 a Ana
        _transferencia('t1', 'b', 'a', 50),         // Beto le paga 50 a Ana
      ];
      final balances =
          DebtSimplifier.calcularBalances(miembros: miembros, gastos: gastos);
      expect(_balanceDe(balances, 'a').abs() < 0.01, isTrue);
      expect(_balanceDe(balances, 'b').abs() < 0.01, isTrue);
    });
  });

  group('simplificar', () {
    test('grupo saldado → sin transferencias', () {
      final miembros = [_miembro('a', 'Ana'), _miembro('b', 'Beto')];
      final gastos = [
        _gasto('e1', 'a', 100, {'a': 50, 'b': 50}),
        _transferencia('t1', 'b', 'a', 50),
      ];
      final s = DebtSimplifier.deudasDeGrupo(miembros: miembros, gastos: gastos);
      expect(s, isEmpty);
    });

    test('tres personas, un solo pagador → dos transferencias hacia él', () {
      final miembros = [
        _miembro('a', 'Ana'),
        _miembro('b', 'Beto'),
        _miembro('c', 'Caro'),
      ];
      final gastos = [
        _gasto('e1', 'a', 60, {'a': 20, 'b': 20, 'c': 20}),
      ];
      final s = DebtSimplifier.deudasDeGrupo(miembros: miembros, gastos: gastos);
      expect(s.length, 2);
      expect(s.every((x) => x.aId == 'a'), isTrue); // todos le pagan a Ana
      final total = s.fold<double>(0, (t, x) => t + x.monto);
      expect(total, 40); // 20 + 20
    });

    test('no genera más de (n-1) transferencias', () {
      final miembros = [
        _miembro('a', 'Ana'),
        _miembro('b', 'Beto'),
        _miembro('c', 'Caro'),
        _miembro('d', 'Dani'),
      ];
      final gastos = [
        _gasto('e1', 'a', 100, {'a': 25, 'b': 25, 'c': 25, 'd': 25}),
        _gasto('e2', 'b', 40, {'a': 10, 'b': 10, 'c': 10, 'd': 10}),
      ];
      final s = DebtSimplifier.deudasDeGrupo(miembros: miembros, gastos: gastos);
      expect(s.length <= miembros.length - 1, isTrue);
    });
  });

  group('repartirEquitativo', () {
    test('divide exacto', () {
      final partes = DebtSimplifier.repartirEquitativo(100, ['a', 'b', 'c', 'd']);
      expect(partes.values.every((v) => v == 25), isTrue);
    });

    test('cuadra los céntimos del redondeo (100 / 3)', () {
      final partes = DebtSimplifier.repartirEquitativo(100, ['a', 'b', 'c']);
      final suma = partes.values.fold<double>(0, (s, v) => s + v);
      expect((suma - 100).abs() < 0.001, isTrue); // la suma es exactamente 100
      // Dos reciben 33.33 y uno absorbe el céntimo restante (33.34).
      expect(partes.values.where((v) => v == 33.34).length, 1);
      expect(partes.values.where((v) => v == 33.33).length, 2);
    });
  });
}
