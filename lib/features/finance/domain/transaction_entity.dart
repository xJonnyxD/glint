/// Tipos de transacción
enum TipoTransaccion { ingreso, gasto }

/// Categorías de gastos
enum CategoriaGasto {
  alimentacion,
  transporte,
  salud,
  educacion,
  entretenimiento,
  hogar,
  ropa,
  servicios,
  ahorros,
  otro,
}

/// Categorías de ingresos
enum CategoriaIngreso {
  salario,
  freelance,
  negocio,
  inversion,
  regalo,
  otro,
}

extension CategoriaGastoExt on CategoriaGasto {
  String get nombre {
    switch (this) {
      case CategoriaGasto.alimentacion:    return 'Alimentación';
      case CategoriaGasto.transporte:      return 'Transporte';
      case CategoriaGasto.salud:           return 'Salud';
      case CategoriaGasto.educacion:       return 'Educación';
      case CategoriaGasto.entretenimiento: return 'Entretenimiento';
      case CategoriaGasto.hogar:           return 'Hogar';
      case CategoriaGasto.ropa:            return 'Ropa';
      case CategoriaGasto.servicios:       return 'Servicios';
      case CategoriaGasto.ahorros:         return 'Ahorros';
      case CategoriaGasto.otro:            return 'Otro';
    }
  }

  String get emoji {
    switch (this) {
      case CategoriaGasto.alimentacion:    return '🍔';
      case CategoriaGasto.transporte:      return '🚗';
      case CategoriaGasto.salud:           return '💊';
      case CategoriaGasto.educacion:       return '📚';
      case CategoriaGasto.entretenimiento: return '🎮';
      case CategoriaGasto.hogar:           return '🏠';
      case CategoriaGasto.ropa:            return '👕';
      case CategoriaGasto.servicios:       return '💡';
      case CategoriaGasto.ahorros:         return '💰';
      case CategoriaGasto.otro:            return '📦';
    }
  }
}

extension CategoriaIngresoExt on CategoriaIngreso {
  String get nombre {
    switch (this) {
      case CategoriaIngreso.salario:   return 'Salario';
      case CategoriaIngreso.freelance: return 'Freelance';
      case CategoriaIngreso.negocio:   return 'Negocio';
      case CategoriaIngreso.inversion: return 'Inversión';
      case CategoriaIngreso.regalo:    return 'Regalo';
      case CategoriaIngreso.otro:      return 'Otro';
    }
  }

  String get emoji {
    switch (this) {
      case CategoriaIngreso.salario:   return '💼';
      case CategoriaIngreso.freelance: return '💻';
      case CategoriaIngreso.negocio:   return '🏪';
      case CategoriaIngreso.inversion: return '📈';
      case CategoriaIngreso.regalo:    return '🎁';
      case CategoriaIngreso.otro:      return '💵';
    }
  }
}

/// Entidad de transacción financiera
class TransactionEntity {
  final String id;
  final TipoTransaccion tipo;
  final double monto;
  final String descripcion;
  final String categoria;
  final String categoriaEmoji;
  final DateTime fecha;
  final String? notas;        // comentario libre del usuario
  final String? imagenPath;   // ruta local de foto de recibo
  final String usuarioId;
  final DateTime creadaEn;

  const TransactionEntity({
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

  bool get esIngreso => tipo == TipoTransaccion.ingreso;
  bool get esGasto   => tipo == TipoTransaccion.gasto;
}
