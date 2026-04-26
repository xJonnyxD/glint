import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:glint/core/utils/sv_salary_utils.dart';

/// Pantalla de Calculadora de Salario para El Salvador 🇸🇻
/// Calcula deducciones de ISSS (3%), AFP (7.25%) e ISR (tabla DGII 2024)
class SalaryCalculatorScreen extends StatefulWidget {
  const SalaryCalculatorScreen({super.key});

  @override
  State<SalaryCalculatorScreen> createState() => _SalaryCalculatorScreenState();
}

class _SalaryCalculatorScreenState extends State<SalaryCalculatorScreen> {
  final _salarioCtrl = TextEditingController();
  ResultadoSalario? _resultado;
  bool _mostrarDetalle = false;

  @override
  void dispose() {
    _salarioCtrl.dispose();
    super.dispose();
  }

  void _calcular() {
    final texto = _salarioCtrl.text.replaceAll(',', '').trim();
    final valor = double.tryParse(texto);

    if (valor == null || valor <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa un salario válido mayor a \$0'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _resultado = SvSalaryUtils.calcular(valor);
      _mostrarDetalle = true;
    });

    // Quitar el teclado
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Row(
          children: [
            Text('🇸🇻', style: TextStyle(fontSize: 20)),
            SizedBox(width: 8),
            Text(
              'Calculadora Salarial',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Descripción ───────────────────────────────────────────────
            _TarjetaInfo(),
            const SizedBox(height: 20),

            // ── Input de salario ──────────────────────────────────────────
            _InputSalario(
              controller: _salarioCtrl,
              onCalcular: _calcular,
            ),
            const SizedBox(height: 12),

            // ── Chips de ejemplos rápidos ─────────────────────────────────
            _EjemplosRapidos(
              onSeleccionar: (monto) {
                _salarioCtrl.text = monto.toStringAsFixed(2);
                _calcular();
              },
            ),
            const SizedBox(height: 24),

            // ── Resultado ─────────────────────────────────────────────────
            if (_resultado != null) ...[
              _ResultadoPrincipal(resultado: _resultado!),
              const SizedBox(height: 16),

              // Toggle detalle
              Center(
                child: TextButton.icon(
                  onPressed: () =>
                      setState(() => _mostrarDetalle = !_mostrarDetalle),
                  icon: Icon(
                    _mostrarDetalle
                        ? Icons.expand_less
                        : Icons.expand_more,
                  ),
                  label: Text(
                    _mostrarDetalle ? 'Ocultar detalle' : 'Ver detalle',
                  ),
                ),
              ),

              if (_mostrarDetalle) ...[
                const SizedBox(height: 8),
                _DetalleCompleto(resultado: _resultado!),
                const SizedBox(height: 16),
                _GraficaPastel(resultado: _resultado!),
                const SizedBox(height: 16),
                _NotasLegales(),
              ],
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ── Tarjeta de información ────────────────────────────────────────────────────

class _TarjetaInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withAlpha(20),
            colorScheme.primary.withAlpha(10),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withAlpha(60),
        ),
      ),
      child: Row(
        children: [
          const Text('💡', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Calcula tu salario neto',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Basado en las tasas vigentes para empleados en El Salvador: ISSS 3%, AFP 7.25%, ISR según tabla DGII 2024.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withAlpha(160),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Input de salario ──────────────────────────────────────────────────────────

class _InputSalario extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onCalcular;

  const _InputSalario({
    required this.controller,
    required this.onCalcular,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Salario bruto mensual',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
                ],
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => onCalcular(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: Text(
                      '\$',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(),
                  hintText: '0.00',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 18),
                ),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: onCalcular,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text(
                'Calcular',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Ejemplos rápidos ──────────────────────────────────────────────────────────

class _EjemplosRapidos extends StatelessWidget {
  final void Function(double monto) onSeleccionar;

  const _EjemplosRapidos({required this.onSeleccionar});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ejemplos rápidos',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: SvSalaryUtils.ejemplosSalarios.map((ej) {
            return ActionChip(
              label: Text(ej['etiqueta'] as String),
              onPressed: () => onSeleccionar(ej['monto'] as double),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ── Resultado principal ───────────────────────────────────────────────────────

class _ResultadoPrincipal extends StatelessWidget {
  final ResultadoSalario resultado;

  const _ResultadoPrincipal({required this.resultado});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primary.withAlpha(200),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withAlpha(80),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Tu salario neto mensual',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            SvSalaryUtils.formatearMoneda(resultado.salarioNeto),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: Colors.white24,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ResumenItem(
                etiqueta: 'Salario bruto',
                valor: SvSalaryUtils.formatearMoneda(resultado.salarioBruto),
                icono: '💼',
              ),
              _ResumenItem(
                etiqueta: 'Total descuentos',
                valor: SvSalaryUtils.formatearMoneda(
                    resultado.totalDeducciones),
                icono: '📉',
                valorColor: Colors.redAccent.shade100,
              ),
              _ResumenItem(
                etiqueta: 'Porcentaje neto',
                valor:
                    '${resultado.porcentajeNeto.toStringAsFixed(1)}%',
                icono: '📊',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResumenItem extends StatelessWidget {
  final String etiqueta;
  final String valor;
  final String icono;
  final Color? valorColor;

  const _ResumenItem({
    required this.etiqueta,
    required this.valor,
    required this.icono,
    this.valorColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icono, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 4),
        Text(
          valor,
          style: TextStyle(
            color: valorColor ?? Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        Text(
          etiqueta,
          style: const TextStyle(color: Colors.white60, fontSize: 11),
        ),
      ],
    );
  }
}

// ── Detalle completo de deducciones ──────────────────────────────────────────

class _DetalleCompleto extends StatelessWidget {
  final ResultadoSalario resultado;

  const _DetalleCompleto({required this.resultado});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(60),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Encabezado
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                const Text('📋', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text(
                  'Desglose de deducciones',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),

          // Filas de deducciones
          _FilaDeduccion(
            emoji: '🏥',
            titulo: 'ISSS',
            subtitulo:
                '3% sobre base (máx. \$1,000) → tope: \$30.00',
            monto: resultado.deduccionIsss,
            colorFondo: const Color(0xFF4CAF50).withAlpha(20),
          ),
          _FilaDeduccion(
            emoji: '👴',
            titulo: 'AFP (Pensiones)',
            subtitulo: '7.25% sobre salario bruto',
            monto: resultado.deduccionAfp,
            colorFondo: const Color(0xFF2196F3).withAlpha(20),
          ),
          _FilaDeduccion(
            emoji: '🏛️',
            titulo: 'ISR (Renta)',
            subtitulo:
                'Tabla DGII • ${SvSalaryUtils.descripcionTramoIsr(resultado.rentaImponible)}',
            monto: resultado.deduccionIsr,
            colorFondo: const Color(0xFFFF9800).withAlpha(20),
            esIsr: true,
            rentaImponible: resultado.rentaImponible,
          ),

          // Separador
          const Divider(height: 1, indent: 20, endIndent: 20),

          // Fila de total
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Salario neto',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      Text(
                        'Lo que recibes en tu bolsillo',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color:
                                  colorScheme.onSurface.withAlpha(130),
                            ),
                      ),
                    ],
                  ),
                ),
                Text(
                  SvSalaryUtils.formatearMoneda(resultado.salarioNeto),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilaDeduccion extends StatelessWidget {
  final String emoji;
  final String titulo;
  final String subtitulo;
  final double monto;
  final Color colorFondo;
  final bool esIsr;
  final double rentaImponible;

  const _FilaDeduccion({
    required this.emoji,
    required this.titulo,
    required this.subtitulo,
    required this.monto,
    required this.colorFondo,
    this.esIsr = false,
    this.rentaImponible = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorFondo,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  subtitulo,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withAlpha(130),
                      ),
                ),
                // Para ISR, mostrar la base imponible
                if (esIsr && monto > 0)
                  Text(
                    'Base imponible: ${SvSalaryUtils.formatearMoneda(rentaImponible)}',
                    style:
                        Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withAlpha(110),
                              fontStyle: FontStyle.italic,
                            ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '- ${SvSalaryUtils.formatearMoneda(monto)}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: monto > 0
                          ? colorScheme.error
                          : colorScheme.onSurface.withAlpha(100),
                    ),
              ),
              if (monto == 0)
                Text(
                  'Exento',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: const Color(0xFF4CAF50),
                        fontWeight: FontWeight.w600,
                      ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Gráfica de pastel visual ──────────────────────────────────────────────────

class _GraficaPastel extends StatelessWidget {
  final ResultadoSalario resultado;

  const _GraficaPastel({required this.resultado});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bruto = resultado.salarioBruto;

    final pNeto = resultado.porcentajeNeto;
    final pIsss = bruto > 0 ? (resultado.deduccionIsss / bruto) * 100 : 0;
    final pAfp = bruto > 0 ? (resultado.deduccionAfp / bruto) * 100 : 0;
    final pIsr = bruto > 0 ? (resultado.deduccionIsr / bruto) * 100 : 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(60),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📊', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                'Distribución del salario',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Barra de progreso visual
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 24,
              child: Row(
                children: [
                  // Neto (verde)
                  Flexible(
                    flex: pNeto.round(),
                    child: Container(color: const Color(0xFF4CAF50)),
                  ),
                  // ISSS (azul)
                  Flexible(
                    flex: pIsss.round(),
                    child: Container(color: const Color(0xFF2196F3)),
                  ),
                  // AFP (naranja)
                  Flexible(
                    flex: pAfp.round(),
                    child: Container(color: const Color(0xFFFF9800)),
                  ),
                  // ISR (rojo)
                  if (pIsr > 0)
                    Flexible(
                      flex: pIsr.round(),
                      child: Container(color: const Color(0xFFF44336)),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Leyenda
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _LeyendaItem(
                color: const Color(0xFF4CAF50),
                etiqueta: 'Neto',
                porcentaje: pNeto,
              ),
              _LeyendaItem(
                color: const Color(0xFF2196F3),
                etiqueta: 'ISSS',
                porcentaje: pIsss.toDouble(),
              ),
              _LeyendaItem(
                color: const Color(0xFFFF9800),
                etiqueta: 'AFP',
                porcentaje: pAfp.toDouble(),
              ),
              if (pIsr > 0)
                _LeyendaItem(
                  color: const Color(0xFFF44336),
                  etiqueta: 'ISR',
                  porcentaje: pIsr.toDouble(),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LeyendaItem extends StatelessWidget {
  final Color color;
  final String etiqueta;
  final double porcentaje;

  const _LeyendaItem({
    required this.color,
    required this.etiqueta,
    required this.porcentaje,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$etiqueta ${porcentaje.toStringAsFixed(1)}%',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

// ── Notas legales ─────────────────────────────────────────────────────────────

class _NotasLegales extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(50),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.outline.withAlpha(60),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: colorScheme.onSurface.withAlpha(150),
              ),
              const SizedBox(width: 6),
              Text(
                'Notas importantes',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface.withAlpha(150),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...[
            '• ISSS: 3% del salario, base máxima \$1,000 (máx. descuento \$30/mes)',
            '• AFP: 7.25% del salario bruto (Crecer o Confía)',
            '• ISR: Calculado según tabla de retenciones DGII 2024',
            '• No incluye horas extras, bonos ni deducciones familiares',
            '• Este cálculo es orientativo. Para casos especiales, consulta a un contador',
          ].map(
            (nota) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                nota,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withAlpha(140),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
