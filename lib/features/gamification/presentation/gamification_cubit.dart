import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:glint/shared/services/xp_service.dart';

// ─── Estado ────────────────────────────────────────────────────────────────

class GamificationState extends Equatable {
  final int xpTotal;
  final String nivel;
  final String emojiNivel;
  final int xpParaSiguiente;
  final double progreso;
  final List<Map<String, dynamic>> historial;
  final List<String> logrosDesbloqueados;

  const GamificationState({
    required this.xpTotal,
    required this.nivel,
    required this.emojiNivel,
    required this.xpParaSiguiente,
    required this.progreso,
    required this.historial,
    required this.logrosDesbloqueados,
  });

  static GamificationState initial() => const GamificationState(
    xpTotal: 0,
    nivel: 'Principiante',
    emojiNivel: '🌱',
    xpParaSiguiente: 500,
    progreso: 0.0,
    historial: [],
    logrosDesbloqueados: [],
  );

  GamificationState copyWith({
    int? xpTotal,
    String? nivel,
    String? emojiNivel,
    int? xpParaSiguiente,
    double? progreso,
    List<Map<String, dynamic>>? historial,
    List<String>? logrosDesbloqueados,
  }) => GamificationState(
    xpTotal: xpTotal ?? this.xpTotal,
    nivel: nivel ?? this.nivel,
    emojiNivel: emojiNivel ?? this.emojiNivel,
    xpParaSiguiente: xpParaSiguiente ?? this.xpParaSiguiente,
    progreso: progreso ?? this.progreso,
    historial: historial ?? this.historial,
    logrosDesbloqueados: logrosDesbloqueados ?? this.logrosDesbloqueados,
  );

  @override
  List<Object?> get props => [xpTotal, nivel, xpParaSiguiente, progreso, logrosDesbloqueados];
}

// ─── Cubit ─────────────────────────────────────────────────────────────────

class GamificationCubit extends Cubit<GamificationState> {
  GamificationCubit() : super(GamificationState.initial()) {
    cargar();
  }

  Future<void> cargar() async {
    final xp = await XpService.getXP();
    final historial = await XpService.getHistorial();
    final prefs = await SharedPreferences.getInstance();
    final logros = prefs.getStringList('glint_logros_desbloqueados') ?? [];

    emit(state.copyWith(
      xpTotal: xp,
      nivel: XpService.getNombreNivel(xp),
      emojiNivel: XpService.getEmojiNivel(xp),
      xpParaSiguiente: XpService.xpParaSiguienteNivel(xp),
      progreso: XpService.progresEnNivel(xp),
      historial: historial,
      logrosDesbloqueados: logros,
    ));
  }

  Future<void> recargar() => cargar();
}
