import 'package:flutter/material.dart';

/// Paleta de colores de Glint — modo claro y oscuro
abstract class AppColors {
  // ── Modo Claro ─────────────────────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface    = Color(0xFFEDF2F7);
  static const Color lightBrand      = Color(0xFF0D9488); // Deep Teal
  static const Color lightAccent     = Color(0xFF81C784); // Verde suave
  static const Color lightCta        = Color(0xFF8A4AF3); // Violeta CTA
  static const Color lightAlert      = Color(0xFFFF8A65); // Naranja alerta
  static const Color lightText       = Color(0xFF1A202C); // Texto principal
  static const Color lightTextMuted  = Color(0xFF718096); // Texto secundario
  static const Color lightDivider    = Color(0xFFE2E8F0);
  static const Color lightError      = Color(0xFFE53E3E);
  static const Color lightSuccess    = Color(0xFF38A169);

  // ── Modo Oscuro ────────────────────────────────────────────────────────────
  static const Color darkBackground  = Color(0xFF0F172A);
  static const Color darkSurface     = Color(0xFF1E293B); // Tarjetas
  static const Color darkBrand       = Color(0xFF2DD4BF); // Teal brillante
  static const Color darkAccent      = Color(0xFFA78BFA); // Lavanda
  static const Color darkCta         = Color(0xFFF59E0B); // Ámbar CTA
  static const Color darkAlert       = Color(0xFFFB923C); // Naranja oscuro
  static const Color darkText        = Color(0xFFF1F5F9); // Texto principal
  static const Color darkTextMuted   = Color(0xFF94A3B8); // Texto secundario
  static const Color darkDivider     = Color(0xFF334155);
  static const Color darkError       = Color(0xFFF87171);
  static const Color darkSuccess     = Color(0xFF34D399);

  // ── Colores de dominio (independientes del tema) ───────────────────────────
  static const Color domainRoutines      = Color(0xFF6366F1); // Índigo — rutinas
  static const Color domainHabits        = Color(0xFF10B981); // Esmeralda — hábitos
  static const Color domainFinance       = Color(0xFFF59E0B); // Ámbar — finanzas
  static const Color domainAgenda        = Color(0xFF3B82F6); // Azul — agenda
  static const Color domainMeditation    = Color(0xFF8B5CF6); // Violeta — meditación
  static const Color domainGamification  = Color(0xFFEC4899); // Rosa — gamificación

  // ── Gradientes de marca ────────────────────────────────────────────────────
  static const LinearGradient brandGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D9488), Color(0xFF8A4AF3)],
  );

  static const LinearGradient brandGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2DD4BF), Color(0xFFA78BFA)],
  );
}
