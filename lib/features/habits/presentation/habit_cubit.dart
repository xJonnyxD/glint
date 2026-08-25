import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:glint/core/feedback/haptica.dart';
import 'package:glint/shared/widgets/celebracion.dart';
import 'package:glint/features/habits/data/habit_repository.dart';
import 'package:glint/features/habits/data/habit_reminder_service.dart';
import 'package:glint/features/habits/domain/habit_entity.dart';
import 'package:glint/shared/services/sync_manager.dart';
import 'package:glint/shared/services/xp_service.dart';
import 'habit_state.dart';

/// HabitCubit — maneja toda la lógica de hábitos
class HabitCubit extends Cubit<HabitState> {
  final HabitRepository _repo;
  final String _usuarioId;
  StreamSubscription? _sub;

  HabitCubit(this._repo, this._usuarioId) : super(HabitLoading()) {
    _init();
  }

  /// Al abrir la app: primero ajustar día/rachas, luego escuchar cambios.
  Future<void> _init() async {
    try {
      await _repo.verificarNuevoDia(_usuarioId);
    } catch (_) {
      // Si falla el ajuste diario, igual cargamos los hábitos
    }
    cargarHabitos();
  }

  /// Expone el repositorio para que la UI pueda consultar completaciones históricas
  HabitRepository get repo => _repo;
  String get usuarioId => _usuarioId;

  bool _recordatoriosReprogramados = false;

  void cargarHabitos() {
    _sub?.cancel();
    _sub = _repo.watchHabitos(_usuarioId).listen(
      (habitos) {
        emit(HabitLoaded(habitos));
        // Reprogramar los recordatorios propios de cada hábito una sola vez
        // (no sobreviven a reinicios del dispositivo).
        if (!_recordatoriosReprogramados) {
          _recordatoriosReprogramados = true;
          HabitReminderService.reprogramarTodos(habitos);
        }
      },
      onError: (_) => emit(HabitLoaded([])),
    );
  }

  /// Crea un hábito y devuelve su id (para poder asociarle un recordatorio).
  Future<String> crearHabito({
    required String nombre,
    required String icono,
    required CategoriaHabito categoria,
    required FrecuenciaHabito frecuencia,
    int metaSemanal = 7,
  }) async {
    final id = const Uuid().v4();
    final habito = HabitEntity(
      id:              id,
      nombre:          nombre,
      icono:           icono,
      categoria:       categoria,
      frecuencia:      frecuencia,
      metaSemanal:     metaSemanal,
      completadoHoy:   false,
      rachaActual:     0,
      rachaMaxima:     0,
      totalCompletados: 0,
      color:           categoria.colorHex,
      usuarioId:       _usuarioId,
      creadoEn:        DateTime.now(),
    );
    await _repo.crearHabito(habito);
    _sincronizar();
    return id;
  }

  /// Marca o desmarca un hábito. Registra la completación en el historial.
  Future<void> toggleCompletar(HabitEntity habito) async {
    final completando = !habito.completadoHoy;
    // Al completar, un golpe de éxito; al desmarcar, solo un toque ligero.
    completando ? Haptica.exito() : Haptica.impactoLigero();
    final cambio = await _repo.toggleCompletar(habito, completando);
    // SEC-10: dar XP solo la PRIMERA vez que se completa el hábito hoy. Sin
    // esta reja, completar → descompletar → completar farmea XP infinito.
    if (completando && cambio && !await _xpYaDadoHoy(habito.id)) {
      await _marcarXpDadoHoy(habito.id);
      final subioNivel = await XpService.agregarXP(
        10,
        motivo: 'Hábito completado: ${habito.nombre}',
      );
      // Subir de nivel es un hito: se celebra por encima del hábito en sí.
      if (subioNivel) Celebracion.lanzar();
    }
    _sincronizar();
  }

  String _claveXpHoy(String habitId) {
    final n = DateTime.now();
    final f = '${n.year}${n.month.toString().padLeft(2, '0')}${n.day.toString().padLeft(2, '0')}';
    return 'glint_xp_habito_${habitId}_$f';
  }

  Future<bool> _xpYaDadoHoy(String habitId) async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_claveXpHoy(habitId)) ?? false;
  }

  Future<void> _marcarXpDadoHoy(String habitId) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_claveXpHoy(habitId), true);
  }

  Future<void> editarHabito({
    required String id,
    required String nombre,
    required String icono,
    required CategoriaHabito categoria,
    required FrecuenciaHabito frecuencia,
    required int metaSemanal,
  }) async {
    await _repo.editarHabito(
      id:          id,
      nombre:      nombre,
      icono:       icono,
      categoria:   categoria,
      frecuencia:  frecuencia,
      metaSemanal: metaSemanal,
    );
    _sincronizar();
  }

  Future<void> eliminarHabito(String id) async {
    await _repo.eliminarHabito(id);
    await HabitReminderService.quitar(id);
    _sincronizar();
  }

  /// Sube los cambios locales en segundo plano. Nunca lanza: si no hay red,
  /// quedan en la cola y se reintentan en la siguiente sincronización.
  void _sincronizar() {
    try {
      SyncManager.instance.empujarEnSegundoPlano(_usuarioId);
    } catch (_) {
      // SyncManager podría no estar inicializado en tests: se ignora.
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
