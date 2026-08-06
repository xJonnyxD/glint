import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:glint/shared/services/achievement_service.dart';
import 'package:glint/shared/services/xp_service.dart';

// ─── Estado ────────────────────────────────────────────────────────────────

class GamificationState extends Equatable {
  final int xpTotal;
  final String nivel;
  final IconData iconoNivel;
  final int xpParaSiguiente;
  final double progreso;
  final List<Map<String, dynamic>> historial;
  final List<String> logrosDesbloqueados;
  final List<RankingEntry> ranking;

  const GamificationState({
    required this.xpTotal,
    required this.nivel,
    required this.iconoNivel,
    required this.xpParaSiguiente,
    required this.progreso,
    required this.historial,
    required this.logrosDesbloqueados,
    this.ranking = const [],
  });

  static GamificationState initial() => const GamificationState(
    xpTotal: 0,
    nivel: 'Principiante',
    iconoNivel: Symbols.eco_rounded,
    xpParaSiguiente: 500,
    progreso: 0.0,
    historial: [],
    logrosDesbloqueados: [],
    ranking: [],
  );

  GamificationState copyWith({
    int? xpTotal,
    String? nivel,
    IconData? iconoNivel,
    int? xpParaSiguiente,
    double? progreso,
    List<Map<String, dynamic>>? historial,
    List<String>? logrosDesbloqueados,
    List<RankingEntry>? ranking,
  }) => GamificationState(
    xpTotal: xpTotal ?? this.xpTotal,
    nivel: nivel ?? this.nivel,
    iconoNivel: iconoNivel ?? this.iconoNivel,
    xpParaSiguiente: xpParaSiguiente ?? this.xpParaSiguiente,
    progreso: progreso ?? this.progreso,
    historial: historial ?? this.historial,
    logrosDesbloqueados: logrosDesbloqueados ?? this.logrosDesbloqueados,
    ranking: ranking ?? this.ranking,
  );

  @override
  List<Object?> get props =>
      [xpTotal, nivel, xpParaSiguiente, progreso, logrosDesbloqueados, ranking];
}

// ─── Cubit ─────────────────────────────────────────────────────────────────

class GamificationCubit extends Cubit<GamificationState> {
  GamificationCubit() : super(GamificationState.initial()) {
    cargar();
  }

  Future<void> cargar() async {
    try {
      final xp = await XpService.getXP();
      final historial = await XpService.getHistorial();
      // Logros desbloqueados del usuario activo (clave por-usuario correcta).
      final logros = (await AchievementService.obtenerDesbloqueados()).toList();
      emit(state.copyWith(
        xpTotal: xp,
        nivel: XpService.getNombreNivel(xp),
        iconoNivel: XpService.getIconoNivel(xp),
        xpParaSiguiente: XpService.xpParaSiguienteNivel(xp),
        progreso: XpService.progresEnNivel(xp),
        historial: historial,
        logrosDesbloqueados: logros,
      ));

      // Empujar el XP al servidor y cargar el ranking entre amigos (en vivo,
      // sin bloquear el resto de la pantalla).
      await XpService.sincronizarXP();
      final ranking = await XpService.obtenerRanking();
      emit(state.copyWith(ranking: ranking));
    } catch (_) {
      // Si algo falla, mantener el estado sin crashear.
    }
  }

  Future<void> recargar() => cargar();
}
