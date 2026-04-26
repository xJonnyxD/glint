import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:glint/core/constants/app_constants.dart';
import 'package:glint/features/auth/presentation/auth_cubit.dart';
import 'package:glint/features/auth/presentation/auth_state.dart';
import 'package:glint/features/routines/presentation/routine_cubit.dart';
import 'package:glint/features/routines/presentation/routine_state.dart';
import 'package:glint/features/habits/presentation/habit_cubit.dart';
import 'package:glint/features/habits/presentation/habit_state.dart';
import 'package:glint/features/finance/presentation/finance_cubit.dart';
import 'package:glint/features/finance/presentation/finance_state.dart';
import 'package:glint/features/agenda/presentation/agenda_cubit.dart';
import 'package:glint/features/agenda/presentation/agenda_state.dart';
import 'package:glint/features/agenda/domain/event_entity.dart';
import 'package:glint/features/gamification/presentation/gamification_cubit.dart';
import 'package:glint/features/profile/data/profile_settings.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const List<String> _frases = [
    'Cada pequeño paso te acerca a la mejor versión de ti mismo.',
    'La disciplina es elegir entre lo que quieres ahora y lo que quieres siempre.',
    'No tienes que ser perfecto, solo tienes que empezar.',
    'El éxito es la suma de pequeños esfuerzos repetidos día a día.',
    'Tu única competencia eres tú mismo de ayer.',
    'Los hábitos construyen el carácter. El carácter construye el destino.',
    'Un día a la vez, una meta a la vez, una victoria a la vez.',
    'La constancia supera al talento cuando el talento no es constante.',
    'Hoy es el mejor día para comenzar lo que siempre has postergado.',
    'Cuida tu mente, tu cuerpo y tu dinero — son las bases de una vida plena.',
  ];

  String _saludo() {
    final hora = DateTime.now().hour;
    if (hora >= 5 && hora < 12) return 'Buenos días ☀️';
    if (hora >= 12 && hora < 19) return 'Buenas tardes 🌤️';
    return 'Buenas noches 🌙';
  }

  String _fechaFormateada() {
    final ahora = DateTime.now();
    // DateFormat requires locale to be registered via initializeDateFormatting
    // Using manual mapping for Spanish locale
    const diasSemana = [
      'Lunes', 'Martes', 'Miércoles', 'Jueves',
      'Viernes', 'Sábado', 'Domingo'
    ];
    const meses = [
      '', 'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    // weekday: 1=Lunes ... 7=Domingo
    final dia = diasSemana[ahora.weekday - 1];
    final mes = meses[ahora.month];
    return '$dia, ${ahora.day} de $mes';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final frase = _frases[DateTime.now().day % 10];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────────────
              _Header(
                saludo: _saludo(),
                fecha: _fechaFormateada(),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),

              const SizedBox(height: 24),

              // ── Tu día de hoy ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Tu día de hoy',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: BlocBuilder<RoutineCubit, RoutineState>(
                        buildWhen: (prev, curr) =>
                            prev.runtimeType != curr.runtimeType ||
                            (curr is RoutineLoaded &&
                                prev is RoutineLoaded &&
                                (curr.completadasHoy != prev.completadasHoy ||
                                    curr.progresoDia != prev.progresoDia)),
                        builder: (context, routineState) {
                          if (routineState is RoutineLoaded) {
                            // Racha promedio de todas las rutinas
                            final rachas = routineState.rutinas.map((r) => r.rachaActual);
                            final rachaPromedio = rachas.isEmpty
                                ? 0
                                : rachas.fold(0, (a, b) => a + b) ~/ routineState.rutinas.length;
                            return _TarjetaProgreso(
                              titulo: 'Rutinas',
                              icono: Icons.wb_sunny,
                              color: colorScheme.primary,
                              progreso: routineState.progresoDia,
                              completadas: routineState.completadasHoy,
                              total: routineState.rutinas.length,
                              rachaPromedio: rachaPromedio,
                            );
                          }
                          if (routineState is RoutineError) {
                            return _TarjetaProgreso(
                              titulo: 'Rutinas',
                              icono: Icons.wb_sunny,
                              color: colorScheme.primary,
                              progreso: 0,
                              completadas: 0,
                              total: 0,
                              rachaPromedio: 0,
                            );
                          }
                          return _SkeletonCard(height: 150);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: BlocBuilder<HabitCubit, HabitState>(
                        buildWhen: (prev, curr) =>
                            prev.runtimeType != curr.runtimeType ||
                            (curr is HabitLoaded &&
                                prev is HabitLoaded &&
                                (curr.completadosHoy != prev.completadosHoy ||
                                    curr.progresoDia != prev.progresoDia)),
                        builder: (context, habitState) {
                          if (habitState is HabitLoaded) {
                            // Racha promedio de todos los hábitos
                            final rachas = habitState.habitos.map((h) => h.rachaActual);
                            final rachaPromedio = rachas.isEmpty
                                ? 0
                                : rachas.fold(0, (a, b) => a + b) ~/ habitState.habitos.length;
                            return _TarjetaProgreso(
                              titulo: 'Hábitos',
                              icono: Icons.favorite,
                              color: Colors.pinkAccent,
                              progreso: habitState.progresoDia,
                              completadas: habitState.completadosHoy,
                              total: habitState.total,
                              rachaPromedio: rachaPromedio,
                            );
                          }
                          return _SkeletonCard(height: 150);
                        },
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.8, 0.8)),

              const SizedBox(height: 24),

              // ── Resumen financiero ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Resumen financiero',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocBuilder<FinanceCubit, FinanceState>(
                  builder: (context, financeState) {
                    if (financeState is FinanceLoaded) {
                      return _TarjetaFinanciera(state: financeState);
                    }
                    return _SkeletonCard(height: 130);
                  },
                ),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),

              const SizedBox(height: 24),

              // ── Acciones rápidas ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Acciones rápidas',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _AccionesRapidas(),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),

              const SizedBox(height: 24),

              // ── Tu progreso (XP / nivel) ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Tu progreso',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Builder(builder: (context) {
                  try {
                    return BlocBuilder<GamificationCubit, GamificationState>(
                      builder: (context, gamState) {
                        final colorScheme = Theme.of(context).colorScheme;
                        return GestureDetector(
                          onTap: () => context.push(AppRoutes.gamification),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colorScheme.primary,
                                  colorScheme.tertiary,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withValues(alpha: 0.35),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Text(gamState.emojiNivel,
                                          style: const TextStyle(fontSize: 26)),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            gamState.nivel,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 17,
                                            ),
                                          ),
                                          Text(
                                            '${gamState.xpTotal} XP acumulados',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        'Ver logros →',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                    value: gamState.progreso,
                                    minHeight: 10,
                                    backgroundColor: Colors.white.withValues(alpha: 0.25),
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  gamState.xpParaSiguiente > 0
                                      ? '${gamState.xpParaSiguiente} XP para el siguiente nivel'
                                      : '¡Nivel máximo alcanzado! 👑',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } catch (_) {
                    return const SizedBox.shrink();
                  }
                }),
              ).animate().fadeIn(delay: 420.ms).slideY(begin: 0.2),

              const SizedBox(height: 24),

              // ── Próximos eventos de Agenda ────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Próximos eventos',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocBuilder<AgendaCubit, AgendaState>(
                  builder: (context, agendaState) {
                    if (agendaState is AgendaLoaded) {
                      return _ProximosEventos(todos: agendaState.todos);
                    }
                    return _SkeletonCard(height: 80);
                  },
                ),
              ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.2),

              const SizedBox(height: 24),

              // ── Frase motivacional ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _FraseMotivacional(frase: frase),
              ).animate().fadeIn(delay: 500.ms),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Header ─────────────────────────────────────────────────────────────────────

class _Header extends StatefulWidget {
  final String saludo;
  final String fecha;

  const _Header({required this.saludo, required this.fecha});

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  String? _fotoPath;

  @override
  void initState() {
    super.initState();
    ProfileSettings.getFoto().then((p) {
      if (mounted) setState(() => _fotoPath = p);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.tertiary.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      child: BlocBuilder<AuthCubit, GlintAuthState>(
        builder: (context, authState) {
          String nombre = 'Usuario';
          String iniciales = 'U';

          if (authState is AuthAuthenticated) {
            final meta = authState.user.userMetadata;
            final nombreMeta = meta?['nombre'] as String?;
            if (nombreMeta != null && nombreMeta.isNotEmpty) {
              final primerNombre = nombreMeta.split(' ').first;
              nombre = primerNombre;
              iniciales = nombreMeta
                  .split(' ')
                  .take(2)
                  .map((p) => p.isNotEmpty ? p[0].toUpperCase() : '')
                  .join();
            } else {
              final email = authState.user.email ?? '';
              if (email.isNotEmpty) {
                iniciales = email[0].toUpperCase();
              }
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Texto de saludo
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.saludo,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          nombre,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined,
                                size: 12, color: Colors.white60),
                            const SizedBox(width: 4),
                            Text(
                              widget.fecha,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white60,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Avatar con foto o iniciales → va a perfil
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.profile),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white38, width: 2.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            backgroundImage: (_fotoPath != null && _fotoPath!.isNotEmpty)
                                ? FileImage(File(_fotoPath!))
                                : null,
                            child: (_fotoPath == null || _fotoPath!.isEmpty)
                                ? Text(
                                    iniciales,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.edit,
                                size: 10, color: colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Tira de actividad semanal ────────────────────────────────
              _RachaSemanal(),
            ],
          );
        },
      ),
    );
  }
}

// ── Tira de actividad semanal ─────────────────────────────────────────────────

class _RachaSemanal extends StatelessWidget {
  const _RachaSemanal();

  static const _dias = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitCubit, HabitState>(
      builder: (context, state) {
        // Calcular qué días de la semana hubo actividad
        final hoy = DateTime.now();
        final inicioSemana = hoy.subtract(Duration(days: hoy.weekday - 1));

        // Días activos: si el totalCompletados > 0 asumimos racha activa
        // Simplificado: marcar hoy si hay completados, días anteriores con racha
        final rachaActual = state is HabitLoaded && state.habitos.isNotEmpty
            ? state.habitos.map((h) => h.rachaActual).fold(0, (a, b) => a > b ? a : b)
            : 0;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (i) {
            final esDia = DateTime(inicioSemana.year, inicioSemana.month,
                inicioSemana.day + i);
            final esHoy = i == hoy.weekday - 1;
            final esPasado = esDia.isBefore(DateTime(hoy.year, hoy.month, hoy.day));
            final enRacha = esPasado && i >= (hoy.weekday - 1 - rachaActual) && rachaActual > 0;
            final activo = esHoy
                ? (state is HabitLoaded && state.completadosHoy > 0)
                : enRacha;

            return Column(
              children: [
                Text(
                  _dias[i],
                  style: TextStyle(
                    color: esHoy ? Colors.white : Colors.white54,
                    fontSize: 10,
                    fontWeight: esHoy ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: activo
                        ? Colors.white
                        : esHoy
                            ? Colors.white.withValues(alpha: 0.3)
                            : Colors.white.withValues(alpha: 0.12),
                    border: esHoy
                        ? Border.all(color: Colors.white70, width: 1.5)
                        : null,
                  ),
                  child: Center(
                    child: activo
                        ? Icon(Icons.check_rounded,
                            size: 14,
                            color: Theme.of(context).colorScheme.primary)
                        : esHoy
                            ? const Text('•',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16))
                            : null,
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }
}

// ── Tarjeta de progreso circular ───────────────────────────────────────────────

class _TarjetaProgreso extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final Color color;
  final double progreso;
  final int completadas;
  final int total;
  final int rachaPromedio;

  const _TarjetaProgreso({
    required this.titulo,
    required this.icono,
    required this.color,
    required this.progreso,
    required this.completadas,
    required this.total,
    required this.rachaPromedio,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final porcentaje = (progreso * 100).round();
    final enRachaFuego = completadas > 0 && rachaPromedio >= 7;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 72,
                  height: 72,
                  child: CircularProgressIndicator(
                    value: progreso,
                    strokeWidth: 6,
                    backgroundColor: colorScheme.outlineVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                Text(
                  '$porcentaje%',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Mostrar 🔥 animado si hay racha >= 7, si no el ícono normal
            if (enRachaFuego)
              const Text('🔥', style: TextStyle(fontSize: 20))
                  .animate(onComplete: (c) => c.repeat())
                  .scaleXY(begin: 1.0, end: 1.25, duration: 700.ms)
                  .then()
                  .scaleXY(begin: 1.25, end: 1.0, duration: 700.ms)
            else
              Icon(icono, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              titulo,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              '$completadas/$total',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tarjeta financiera ─────────────────────────────────────────────────────────

class _TarjetaFinanciera extends StatelessWidget {
  final FinanceLoaded state;

  const _TarjetaFinanciera({required this.state});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fmt = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    final balancePositivo = state.balance >= 0;
    final colorBalance = balancePositivo ? Colors.green.shade600 : Colors.red.shade600;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance_wallet, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Balance del mes',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => context.go(AppRoutes.finance),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Ver más'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              fmt.format(state.balance),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorBalance,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _FilaFinanciera(
                    icono: Icons.arrow_downward,
                    color: Colors.green.shade600,
                    label: 'Ingresos',
                    monto: fmt.format(state.totalIngresos),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _FilaFinanciera(
                    icono: Icons.arrow_upward,
                    color: Colors.red.shade600,
                    label: 'Gastos',
                    monto: fmt.format(state.totalGastos),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilaFinanciera extends StatelessWidget {
  final IconData icono;
  final Color color;
  final String label;
  final String monto;

  const _FilaFinanciera({
    required this.icono,
    required this.color,
    required this.label,
    required this.monto,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icono, color: color, size: 16),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              Text(
                monto,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Acciones rápidas ───────────────────────────────────────────────────────────

class _AccionesRapidas extends StatelessWidget {
  static const List<_AccionItem> _acciones = [
    _AccionItem(emoji: '☀️', label: 'Rutinas',      ruta: AppRoutes.routines,         color: Color(0xFFFFF3E0)),
    _AccionItem(emoji: '💪', label: 'Hábitos',      ruta: AppRoutes.habits,           color: Color(0xFFFCE4EC)),
    _AccionItem(emoji: '💰', label: 'Finanzas',     ruta: AppRoutes.finance,          color: Color(0xFFE8F5E9)),
    _AccionItem(emoji: '📅', label: 'Agenda',       ruta: AppRoutes.agenda,           color: Color(0xFFE3F2FD)),
    _AccionItem(emoji: '📝', label: 'Notas',        ruta: AppRoutes.notes,            color: Color(0xFFF3E5F5)),
    _AccionItem(emoji: '🧮', label: 'Calculadora',  ruta: AppRoutes.salaryCalculator, color: Color(0xFFFFF8E1)),
  ];

  const _AccionesRapidas();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.0,
      ),
      itemCount: _acciones.length,
      itemBuilder: (context, index) {
        final accion = _acciones[index];
        return _BotonaAccion(accion: accion);
      },
    );
  }
}

class _AccionItem {
  final String emoji;
  final String label;
  final String ruta;
  final Color color;

  const _AccionItem({
    required this.emoji,
    required this.label,
    required this.ruta,
    required this.color,
  });
}

class _BotonaAccion extends StatefulWidget {
  final _AccionItem accion;

  const _BotonaAccion({required this.accion});

  @override
  State<_BotonaAccion> createState() => _BotonaAccionState();
}

class _BotonaAccionState extends State<_BotonaAccion>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _escala;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.92,
      upperBound: 1.0,
      value: 1.0,
    );
    _escala = _ctrl;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _ctrl.reverse();
  void _onTapUp(_) => _ctrl.forward();
  void _onTapCancel() => _ctrl.forward();

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _escala,
      child: Material(
        color: widget.accion.color,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => context.go(widget.accion.ruta),
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          splashColor: Colors.black.withValues(alpha: 0.05),
          highlightColor: Colors.black.withValues(alpha: 0.03),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.accion.emoji,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.accion.label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        fontSize: 11,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Frase motivacional ─────────────────────────────────────────────────────────

class _FraseMotivacional extends StatelessWidget {
  final String frase;

  const _FraseMotivacional({required this.frase});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '💬',
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                frase,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: colorScheme.onSecondaryContainer,
                      height: 1.4,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Skeleton loading ───────────────────────────────────────────────────────────

// ── Próximos eventos ───────────────────────────────────────────────────────────

class _ProximosEventos extends StatelessWidget {
  final List<EventEntity> todos;
  const _ProximosEventos({required this.todos});

  @override
  Widget build(BuildContext context) {
    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);

    // Filtrar eventos futuros (hoy + próximos 7 días), sin completar
    final proximos = todos.where((e) {
      final fechaEvento = DateTime(e.fecha.year, e.fecha.month, e.fecha.day);
      return !e.completado &&
          !fechaEvento.isBefore(hoy) &&
          fechaEvento.isBefore(hoy.add(const Duration(days: 8)));
    }).toList()
      ..sort((a, b) => a.fecha.compareTo(b.fecha));

    if (proximos.isEmpty) {
      return Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(Icons.event_available_outlined,
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)),
              const SizedBox(width: 12),
              Text(
                'Sin eventos próximos esta semana',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    final colorScheme = Theme.of(context).colorScheme;
    final mostrar = proximos.take(3).toList();

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          ...mostrar.map((evento) {
            final esHoy = isSameDay(evento.fecha, ahora);
            final esTarea = evento.tipo == TipoEvento.tarea;
            final colorEvento = _hexToColor(evento.color);

            return ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorEvento.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  esTarea ? Icons.check_circle_outline : Icons.event_outlined,
                  color: colorEvento,
                  size: 20,
                ),
              ),
              title: Text(
                evento.titulo,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                esHoy
                    ? 'Hoy${evento.hora != null ? " · ${evento.hora}" : ""}'
                    : '${_formatFechaCorta(evento.fecha)}${evento.hora != null ? " · ${evento.hora}" : ""}',
                style: TextStyle(
                  fontSize: 12,
                  color: esHoy ? colorScheme.primary : colorScheme.onSurfaceVariant,
                  fontWeight: esHoy ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              trailing: esHoy
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Hoy',
                        style: TextStyle(
                          fontSize: 11,
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : null,
              onTap: () => context.go(AppRoutes.agenda),
            );
          }),
          if (proximos.length > 3)
            TextButton(
              onPressed: () => context.go(AppRoutes.agenda),
              child: Text(
                'Ver ${proximos.length - 3} más en Agenda →',
                style: TextStyle(fontSize: 13, color: colorScheme.primary),
              ),
            ),
        ],
      ),
    );
  }

  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _formatFechaCorta(DateTime fecha) {
    final meses = ['ene', 'feb', 'mar', 'abr', 'may', 'jun',
                   'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
    return '${fecha.day} ${meses[fecha.month - 1]}';
  }

  Color _hexToColor(String hex) {
    try {
      return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
    } catch (_) {
      return const Color(0xFF6750A4);
    }
  }
}

// ── Skeleton card ──────────────────────────────────────────────────────────────

class _SkeletonCard extends StatelessWidget {
  final double height;

  const _SkeletonCard({required this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
