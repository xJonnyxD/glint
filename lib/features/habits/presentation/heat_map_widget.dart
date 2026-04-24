import 'package:flutter/material.dart';

/// Mapa de calor al estilo GitHub — muestra los últimos 16 semanas de actividad.
/// Cada celda = 1 día. El color indica cuántos hábitos se completaron ese día.
class HabitHeatMap extends StatelessWidget {
  /// Mapa de fecha → cantidad de hábitos completados ese día
  final Map<DateTime, int> datos;

  /// Máximo de hábitos que el usuario tiene (para calcular intensidad de color)
  final int maxHabitos;

  const HabitHeatMap({
    super.key,
    required this.datos,
    required this.maxHabitos,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Generar las últimas 16 semanas (112 días), empezando el lunes más lejano
    final hoy = DateTime.now();
    final diasTotales = 112;
    final primerDia = hoy.subtract(Duration(days: diasTotales - 1));

    // Ajustar al lunes de esa semana
    final inicioSemana =
        primerDia.subtract(Duration(days: primerDia.weekday - 1));

    // Construir columnas de semanas
    final semanas = <List<DateTime?>>[];
    DateTime cursor = inicioSemana;

    while (cursor.isBefore(hoy.add(const Duration(days: 1)))) {
      final semana = <DateTime?>[];
      for (int d = 0; d < 7; d++) {
        final dia = cursor.add(Duration(days: d));
        // Solo incluir días que estén en el rango válido y no sean futuros
        if (dia.isAfter(hoy)) {
          semana.add(null);
        } else {
          semana.add(dia);
        }
      }
      semanas.add(semana);
      cursor = cursor.add(const Duration(days: 7));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Leyenda días de semana
        Row(
          children: [
            const SizedBox(width: 28), // espacio para etiquetas de mes
            ...['L', 'M', 'X', 'J', 'V', 'S', 'D'].map((d) => Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: TextStyle(
                        fontSize: 9,
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )),
          ],
        ),
        const SizedBox(height: 4),

        // Grid de semanas
        SizedBox(
          height: semanas.length * 13.0,
          child: Row(
            children: [
              // Etiquetas de mes en el lado izquierdo
              SizedBox(
                width: 26,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: semanas.asMap().entries.map((entry) {
                    final semana = entry.value;
                    final primerDiaSemana =
                        semana.firstWhere((d) => d != null, orElse: () => null);
                    // Mostrar mes solo cuando cambia
                    String label = '';
                    if (primerDiaSemana != null && primerDiaSemana.day <= 7) {
                      label = _mesCorto(primerDiaSemana.month);
                    }
                    return SizedBox(
                      height: 13,
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 8,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Celdas del heat map
              Expanded(
                child: Column(
                  children: semanas.map((semana) {
                    return SizedBox(
                      height: 13,
                      child: Row(
                        children: semana.map((dia) {
                          if (dia == null) {
                            return Expanded(child: Container());
                          }
                          final key = DateTime(dia.year, dia.month, dia.day);
                          final count = datos[key] ?? 0;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(1.5),
                              child: Tooltip(
                                message: _tooltip(dia, count),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _colorCelda(
                                      count,
                                      maxHabitos,
                                      colorScheme,
                                      isDark,
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Leyenda de intensidad
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Menos',
                style: TextStyle(
                    fontSize: 10, color: colorScheme.onSurfaceVariant)),
            const SizedBox(width: 4),
            ...List.generate(5, (i) {
              return Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: _colorPorNivel(i, colorScheme, isDark),
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
            const SizedBox(width: 4),
            Text('Más',
                style: TextStyle(
                    fontSize: 10, color: colorScheme.onSurfaceVariant)),
          ],
        ),
      ],
    );
  }

  Color _colorCelda(
      int count, int max, ColorScheme scheme, bool isDark) {
    if (count == 0) {
      return isDark
          ? const Color(0xFF2D2D2D)
          : const Color(0xFFEEEEEE);
    }
    if (max == 0) return _colorPorNivel(1, scheme, isDark);
    final ratio = count / max;
    if (ratio <= 0.25) return _colorPorNivel(1, scheme, isDark);
    if (ratio <= 0.50) return _colorPorNivel(2, scheme, isDark);
    if (ratio <= 0.75) return _colorPorNivel(3, scheme, isDark);
    return _colorPorNivel(4, scheme, isDark);
  }

  Color _colorPorNivel(int nivel, ColorScheme scheme, bool isDark) {
    // Verde degradado: de muy claro a muy oscuro
    const coloresClaro = [
      Color(0xFFEEEEEE),
      Color(0xFF9BE9A8),
      Color(0xFF40C463),
      Color(0xFF30A14E),
      Color(0xFF216E39),
    ];
    const coloresOscuro = [
      Color(0xFF2D2D2D),
      Color(0xFF0E4429),
      Color(0xFF006D32),
      Color(0xFF26A641),
      Color(0xFF39D353),
    ];
    final lista = isDark ? coloresOscuro : coloresClaro;
    return lista[nivel.clamp(0, 4)];
  }

  String _tooltip(DateTime dia, int count) {
    final fecha = '${dia.day}/${dia.month}/${dia.year}';
    if (count == 0) return '$fecha\nNingún hábito';
    if (count == 1) return '$fecha\n1 hábito completado';
    return '$fecha\n$count hábitos completados';
  }

  String _mesCorto(int mes) {
    const meses = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    return meses[mes - 1];
  }
}
