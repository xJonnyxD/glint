import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:glint/features/habits/presentation/habit_state.dart';

// ── Definición de logros ──────────────────────────────────────────────────────

class Logro {
  final String id;
  final String titulo;
  final String descripcion;
  final String emoji;
  final Color color;

  const Logro({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.emoji,
    required this.color,
  });
}

const List<Logro> todosLosLogros = [
  Logro(
    id: 'primer_habito',
    titulo: 'Primer Paso',
    descripcion: 'Completaste tu primer hábito',
    emoji: '🌱',
    color: Color(0xFF43A047),
  ),
  Logro(
    id: 'racha_7',
    titulo: 'Racha de Fuego',
    descripcion: '7 días seguidos completando un hábito',
    emoji: '🔥',
    color: Color(0xFFE53935),
  ),
  Logro(
    id: 'racha_30',
    titulo: 'Imparable',
    descripcion: '30 días seguidos completando un hábito',
    emoji: '💎',
    color: Color(0xFF1E88E5),
  ),
  Logro(
    id: 'racha_100',
    titulo: 'Leyenda',
    descripcion: '100 días seguidos completando un hábito',
    emoji: '👑',
    color: Color(0xFFFDD835),
  ),
  Logro(
    id: 'total_50',
    titulo: 'Consistente',
    descripcion: '50 completados en total',
    emoji: '⭐',
    color: Color(0xFFFB8C00),
  ),
  Logro(
    id: 'total_100',
    titulo: 'Centenario',
    descripcion: '100 completados en total',
    emoji: '🏆',
    color: Color(0xFF8E24AA),
  ),
  Logro(
    id: 'cinco_habitos',
    titulo: 'Multitarea',
    descripcion: 'Tienes 5 hábitos activos',
    emoji: '🎯',
    color: Color(0xFF00897B),
  ),
  Logro(
    id: 'dia_perfecto',
    titulo: 'Día Perfecto',
    descripcion: 'Completaste TODOS tus hábitos en un día',
    emoji: '🌟',
    color: Color(0xFFFFD600),
  ),
];

// ── Servicio ──────────────────────────────────────────────────────────────────

class AchievementService {
  static const _key = 'glint_logros_desbloqueados';

  /// Devuelve los IDs de logros ya desbloqueados
  static Future<Set<String>> obtenerDesbloqueados() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key)?.toSet() ?? {};
  }

  /// Revisa qué logros nuevos se deben desbloquear y los guarda.
  /// Devuelve la lista de logros RECIÉN desbloqueados (para mostrar notificación).
  static Future<List<Logro>> verificarYDesbloquear(
      HabitLoaded state) async {
    final desbloqueados = await obtenerDesbloqueados();
    final nuevos = <Logro>[];

    void revisar(String id, bool condicion) {
      if (condicion && !desbloqueados.contains(id)) {
        desbloqueados.add(id);
        nuevos.add(todosLosLogros.firstWhere((l) => l.id == id));
      }
    }

    final maxRacha = state.habitos.isEmpty
        ? 0
        : state.habitos.map((h) => h.rachaActual).reduce((a, b) => a > b ? a : b);
    final maxRachaMaxima = state.habitos.isEmpty
        ? 0
        : state.habitos.map((h) => h.rachaMaxima).reduce((a, b) => a > b ? a : b);

    revisar('primer_habito',  state.totalHistorico >= 1);
    revisar('racha_7',        maxRacha >= 7 || maxRachaMaxima >= 7);
    revisar('racha_30',       maxRacha >= 30 || maxRachaMaxima >= 30);
    revisar('racha_100',      maxRacha >= 100 || maxRachaMaxima >= 100);
    revisar('total_50',       state.totalHistorico >= 50);
    revisar('total_100',      state.totalHistorico >= 100);
    revisar('cinco_habitos',  state.habitos.length >= 5);
    revisar('dia_perfecto',
        state.habitos.isNotEmpty && state.completadosHoy == state.total);

    if (nuevos.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_key, desbloqueados.toList());
    }

    return nuevos;
  }

  /// Muestra una notificación estilo banner cuando se desbloquea un logro
  static void mostrarLogro(BuildContext context, Logro logro) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(logro.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('¡Logro desbloqueado!',
                      style: TextStyle(
                          color: logro.color,
                          fontWeight: FontWeight.w700,
                          fontSize: 13)),
                  Text(logro.titulo,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15)),
                  Text(logro.descripcion,
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
