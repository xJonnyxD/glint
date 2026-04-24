import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:glint/core/constants/app_constants.dart';

/// Clave en SharedPreferences para saber si ya vio el onboarding
const String _kOnboardingVisto = 'glint_onboarding_visto';

/// Verifica si el usuario ya vio el onboarding
Future<bool> yaVioOnboarding() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_kOnboardingVisto) ?? false;
}

/// Marca el onboarding como visto
Future<void> marcarOnboardingVisto() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_kOnboardingVisto, true);
}

/// Pantalla de onboarding — se muestra solo la primera vez que el usuario abre la app.
/// Tiene 4 slides con las funcionalidades principales de Glint.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _paginaActual = 0;

  // Datos de cada slide del onboarding
  static const _slides = [
    _SlideData(
      emoji: '🌟',
      titulo: 'Bienvenido a Glint',
      descripcion:
          'Tu super-app de productividad personal. '
          'Organiza tus rutinas, hábitos, finanzas y agenda en un solo lugar.',
      colorFondo: Color(0xFF6750A4),
    ),
    _SlideData(
      emoji: '🏃',
      titulo: 'Rutinas y Hábitos',
      descripcion:
          'Construye hábitos que duran. '
          'Registra tus rutinas diarias, sigue tu racha y celebra tu progreso cada día.',
      colorFondo: Color(0xFF1E88E5),
    ),
    _SlideData(
      emoji: '💰',
      titulo: 'Control Financiero',
      descripcion:
          'Lleva tus ingresos y gastos al día. '
          'Visualiza en qué gastas más y usa la calculadora de salario para El Salvador 🇸🇻.',
      colorFondo: Color(0xFF43A047),
    ),
    _SlideData(
      emoji: '📅',
      titulo: 'Agenda Inteligente',
      descripcion:
          'Nunca olvides un evento importante. '
          'Organiza tus tareas y recibe notificaciones antes de que lleguen.',
      colorFondo: Color(0xFFE53935),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _siguiente() {
    if (_paginaActual < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _terminar();
    }
  }

  Future<void> _terminar() async {
    await marcarOnboardingVisto();
    if (mounted) context.go(AppRoutes.auth);
  }

  @override
  Widget build(BuildContext context) {
    final esUltima = _paginaActual == _slides.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          // ── Slides ────────────────────────────────────────────────────────
          PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _paginaActual = i),
            itemCount: _slides.length,
            itemBuilder: (context, i) => _SlideView(slide: _slides[i]),
          ),

          // ── Botón saltar (arriba derecha) ─────────────────────────────────
          if (!esUltima)
            Positioned(
              top: 52,
              right: 24,
              child: SafeArea(
                child: TextButton(
                  onPressed: _terminar,
                  child: const Text(
                    'Saltar',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),

          // ── Indicadores de página + botón siguiente ───────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Puntos indicadores
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _slides.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _paginaActual == i ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _paginaActual == i
                                ? Colors.white
                                : Colors.white38,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Botón siguiente / empezar
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _siguiente,
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor:
                              _slides[_paginaActual].colorFondo,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          esUltima ? '¡Empezar ahora!' : 'Siguiente',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Slide individual ──────────────────────────────────────────────────────────

class _SlideView extends StatelessWidget {
  final _SlideData slide;
  const _SlideView({required this.slide});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            slide.colorFondo,
            slide.colorFondo.withAlpha(200),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Emoji grande animado
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.5, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (context, scale, child) => Transform.scale(
                  scale: scale,
                  child: child,
                ),
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      slide.emoji,
                      style: const TextStyle(fontSize: 72),
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Título
              Text(
                slide.titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),

              // Descripción
              Text(
                slide.descripcion,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Datos de un slide ─────────────────────────────────────────────────────────

class _SlideData {
  final String emoji;
  final String titulo;
  final String descripcion;
  final Color colorFondo;

  const _SlideData({
    required this.emoji,
    required this.titulo,
    required this.descripcion,
    required this.colorFondo,
  });
}
