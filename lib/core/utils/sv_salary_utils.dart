// Utilidades para calcular deducciones salariales en El Salvador.
// Basado en las tasas vigentes de ISSS, AFP e ISR (tabla DGII 2024).
//
// FUENTES:
// - ISSS: Ley del Seguro Social, Art. 29 → 3% empleado, tope base $1,000
// - AFP: Ley del Sistema de Ahorro para Pensiones → 7.25% empleado
// - ISR: Tabla de retenciones mensuales DGII El Salvador 2024

/// Resultado completo del cálculo de salario
class ResultadoSalario {
  /// Salario bruto ingresado por el usuario
  final double salarioBruto;

  /// Deducción ISSS (3% sobre base, máximo $1,000)
  final double deduccionIsss;

  /// Deducción AFP (7.25% sobre salario bruto)
  final double deduccionAfp;

  /// Base imponible para ISR = bruto - ISSS - AFP
  final double rentaImponible;

  /// Deducción ISR según tabla DGII (puede ser $0 si el salario es bajo)
  final double deduccionIsr;

  /// Salario neto que el empleado recibe = bruto - ISSS - AFP - ISR
  final double salarioNeto;

  const ResultadoSalario({
    required this.salarioBruto,
    required this.deduccionIsss,
    required this.deduccionAfp,
    required this.rentaImponible,
    required this.deduccionIsr,
    required this.salarioNeto,
  });

  /// Total de deducciones
  double get totalDeducciones => deduccionIsss + deduccionAfp + deduccionIsr;

  /// Porcentaje total descontado del salario bruto
  double get porcentajeTotalDescuento =>
      salarioBruto > 0 ? (totalDeducciones / salarioBruto) * 100 : 0;

  /// Porcentaje que representa el salario neto del bruto
  double get porcentajeNeto =>
      salarioBruto > 0 ? (salarioNeto / salarioBruto) * 100 : 0;
}

/// Clase principal con la lógica de cálculo
class SvSalaryUtils {
  // ── Tasas vigentes 2024 ────────────────────────────────────────────────────

  /// Tasa ISSS empleado: 3%
  static const double tasaIsss = 0.03;

  /// Tope de base para calcular ISSS: $1,000
  /// Si el salario supera $1,000, el ISSS se calcula solo sobre $1,000
  static const double topeBaseIsss = 1000.0;

  /// Tasa AFP empleado: 7.25%
  static const double tasaAfp = 0.0725;

  // ── Tabla ISR mensual DGII 2024 ────────────────────────────────────────────

  /// Tramo ISR 1: hasta $472.00 → exento ($0)
  static const double isrTramo1Max = 472.00;

  /// Tramo ISR 2: $472.01 – $895.24 → $17.67 + 10% sobre exceso de $472.00
  static const double isrTramo2Max = 895.24;
  static const double isrTramo2Base = 17.67;
  static const double isrTramo2Tasa = 0.10;
  static const double isrTramo2Desde = 472.00;

  /// Tramo ISR 3: $895.25 – $2,038.10 → $60.00 + 20% sobre exceso de $895.24
  static const double isrTramo3Max = 2038.10;
  static const double isrTramo3Base = 60.00;
  static const double isrTramo3Tasa = 0.20;
  static const double isrTramo3Desde = 895.24;

  /// Tramo ISR 4: más de $2,038.10 → $288.57 + 30% sobre exceso de $2,038.10
  static const double isrTramo4Base = 288.57;
  static const double isrTramo4Tasa = 0.30;
  static const double isrTramo4Desde = 2038.10;

  // ── Método principal ───────────────────────────────────────────────────────

  /// Calcula todas las deducciones y el salario neto mensual
  static ResultadoSalario calcular(double salarioBruto) {
    if (salarioBruto <= 0) {
      return const ResultadoSalario(
        salarioBruto: 0,
        deduccionIsss: 0,
        deduccionAfp: 0,
        rentaImponible: 0,
        deduccionIsr: 0,
        salarioNeto: 0,
      );
    }

    // 1. ISSS: 3% sobre el salario, pero máximo sobre $1,000
    final baseIsss = salarioBruto > topeBaseIsss ? topeBaseIsss : salarioBruto;
    final deduccionIsss = _redondear(baseIsss * tasaIsss);

    // 2. AFP: 7.25% sobre el salario bruto completo
    final deduccionAfp = _redondear(salarioBruto * tasaAfp);

    // 3. Renta imponible = bruto - ISSS - AFP
    final rentaImponible = _redondear(salarioBruto - deduccionIsss - deduccionAfp);

    // 4. ISR según tabla DGII
    final deduccionIsr = _calcularIsr(rentaImponible);

    // 5. Salario neto
    final salarioNeto = _redondear(
      salarioBruto - deduccionIsss - deduccionAfp - deduccionIsr,
    );

    return ResultadoSalario(
      salarioBruto: salarioBruto,
      deduccionIsss: deduccionIsss,
      deduccionAfp: deduccionAfp,
      rentaImponible: rentaImponible,
      deduccionIsr: deduccionIsr,
      salarioNeto: salarioNeto,
    );
  }

  /// Calcula el ISR mensual según la tabla de retenciones DGII
  static double _calcularIsr(double rentaImponible) {
    if (rentaImponible <= isrTramo1Max) {
      // Exento — no paga ISR
      return 0.0;
    } else if (rentaImponible <= isrTramo2Max) {
      // Tramo 2: $472.01 – $895.24
      return _redondear(
        isrTramo2Base + (rentaImponible - isrTramo2Desde) * isrTramo2Tasa,
      );
    } else if (rentaImponible <= isrTramo3Max) {
      // Tramo 3: $895.25 – $2,038.10
      return _redondear(
        isrTramo3Base + (rentaImponible - isrTramo3Desde) * isrTramo3Tasa,
      );
    } else {
      // Tramo 4: más de $2,038.10
      return _redondear(
        isrTramo4Base + (rentaImponible - isrTramo4Desde) * isrTramo4Tasa,
      );
    }
  }

  /// Redondea a 2 decimales (centavos)
  static double _redondear(double valor) {
    return double.parse(valor.toStringAsFixed(2));
  }

  /// Formatea un valor como moneda USD: "$1,234.56"
  static String formatearMoneda(double valor) {
    final abs = valor.abs();
    final partes = abs.toStringAsFixed(2).split('.');
    final enteros = partes[0];
    final decimales = partes[1];

    // Agregar separadores de miles
    final buffer = StringBuffer();
    for (int i = 0; i < enteros.length; i++) {
      if (i > 0 && (enteros.length - i) % 3 == 0) buffer.write(',');
      buffer.write(enteros[i]);
    }

    return '\$${buffer.toString()}.$decimales';
  }

  /// Devuelve el tramo ISR en texto legible
  static String descripcionTramoIsr(double rentaImponible) {
    if (rentaImponible <= isrTramo1Max) return 'Exento (0%)';
    if (rentaImponible <= isrTramo2Max) return 'Tramo 2 (10%)';
    if (rentaImponible <= isrTramo3Max) return 'Tramo 3 (20%)';
    return 'Tramo 4 (30%)';
  }

  /// Ejemplos de salarios comunes en El Salvador para mostrar al usuario
  static const List<Map<String, dynamic>> ejemplosSalarios = [
    {'etiqueta': 'Salario mínimo', 'monto': 365.00},
    {'etiqueta': 'Promedio \$500', 'monto': 500.00},
    {'etiqueta': 'Promedio \$800', 'monto': 800.00},
    {'etiqueta': 'Profesional \$1,200', 'monto': 1200.00},
    {'etiqueta': 'Senior \$2,000', 'monto': 2000.00},
    {'etiqueta': 'Gerencial \$3,000', 'monto': 3000.00},
  ];
}
