/// Audita el contraste de la paleta de Glint según WCAG 2.1.
///
///     dart run tool/auditar_contraste.dart
///
/// Umbrales: 4.5:1 para texto normal (AA) y 3.0:1 para bordes e iconos que
/// transmiten información (WCAG 1.4.11, contraste de elementos no textuales).
/// Sale con código 1 si algo falla, así que sirve tal cual en CI.
///
/// Los valores son un espejo de lib/core/theme/app_colors.dart: si cambias un
/// color allí, cámbialo aquí y vuelve a ejecutar.
library;

import 'dart:io';
import 'dart:math' as math;

// ── Paleta ──────────────────────────────────────────────────────────────────
const claros = {
  'lightBackground': 0xFFF8F9FA,
  'lightSurface': 0xFFEDF2F7,
  'lightBrand': 0xFF0F766E,
  'lightAccent': 0xFF276749,
  'lightCta': 0xFF6B46C1,
  'lightAlert': 0xFFB4530F,
  'lightText': 0xFF1A202C,
  'lightTextMuted': 0xFF4A5568,
  'lightDivider': 0xFFE2E8F0,
  'lightBorder': 0xFF64748B,
  'lightError': 0xFFC53030,
  'lightSuccess': 0xFF2A6F4B,
};

const oscuros = {
  'darkBackground': 0xFF0F172A,
  'darkSurface': 0xFF1E293B,
  'darkBrand': 0xFF2DD4BF,
  'darkAccent': 0xFFA78BFA,
  'darkCta': 0xFFF59E0B,
  'darkAlert': 0xFFFB923C,
  'darkText': 0xFFF1F5F9,
  'darkTextMuted': 0xFF94A3B8,
  'darkDivider': 0xFF334155,
  'darkBorder': 0xFF8494AC,
  'darkError': 0xFFF87171,
  'darkSuccess': 0xFF34D399,
};

/// Cada dominio tiene variante clara y oscura: un mismo tono no puede ser
/// legible sobre fondo claro y sobre fondo oscuro a la vez.
const dominioClaro = {
  'rutinas': 0xFF4338CA,
  'habitos': 0xFF047857,
  'finanzas': 0xFF9A6100,
  'agenda': 0xFF1D4ED8,
  'meditacion': 0xFF6D28D9,
  'gamificacion': 0xFFBE185D,
};

const dominioOscuro = {
  'rutinas': 0xFF818CF8,
  'habitos': 0xFF10B981,
  'finanzas': 0xFFF59E0B,
  'agenda': 0xFF60A5FA,
  'meditacion': 0xFFC4B5FD,
  'gamificacion': 0xFFF472B6,
};

/// Colores de identidad de los logros (lib/shared/services/achievement_service.dart).
/// Se pintan pasándolos por AppColors.legibleSobre, así que aquí comprobamos
/// que ese ajuste realmente los deja legibles.
const logros = [
  0xFF43A047, 0xFFE53935, 0xFF1E88E5, 0xFFFDD835,
  0xFFFB8C00, 0xFF8E24AA, 0xFF00897B, 0xFFFFD600,
];

// ── Cálculo WCAG ────────────────────────────────────────────────────────────
double _canal(int c) {
  final s = c / 255.0;
  return s <= 0.03928 ? s / 12.92 : math.pow((s + 0.055) / 1.055, 2.4).toDouble();
}

double luminancia(int argb) {
  final r = (argb >> 16) & 0xFF, g = (argb >> 8) & 0xFF, b = argb & 0xFF;
  return 0.2126 * _canal(r) + 0.7152 * _canal(g) + 0.0722 * _canal(b);
}

double contraste(int a, int b) {
  final la = luminancia(a), lb = luminancia(b);
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

// ── HSL, para replicar AppColors.legibleSobre ───────────────────────────────
List<double> _aHsl(int argb) {
  final r = ((argb >> 16) & 0xFF) / 255, g = ((argb >> 8) & 0xFF) / 255,
      b = (argb & 0xFF) / 255;
  final mx = math.max(r, math.max(g, b)), mn = math.min(r, math.min(g, b));
  final l = (mx + mn) / 2;
  if (mx == mn) return [0, 0, l];
  final d = mx - mn;
  final s = l > 0.5 ? d / (2 - mx - mn) : d / (mx + mn);
  double h;
  if (mx == r) {
    h = ((g - b) / d + (g < b ? 6 : 0)) / 6;
  } else if (mx == g) {
    h = ((b - r) / d + 2) / 6;
  } else {
    h = ((r - g) / d + 4) / 6;
  }
  return [h, s, l];
}

int _deHsl(double h, double s, double l) {
  double f(double p, double q, double t) {
    if (t < 0) t += 1;
    if (t > 1) t -= 1;
    if (t < 1 / 6) return p + (q - p) * 6 * t;
    if (t < 1 / 2) return q;
    if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
    return p;
  }
  double r, g, b;
  if (s == 0) {
    r = g = b = l;
  } else {
    final q = l < 0.5 ? l * (1 + s) : l + s - l * s;
    final p = 2 * l - q;
    r = f(p, q, h + 1 / 3);
    g = f(p, q, h);
    b = f(p, q, h - 1 / 3);
  }
  return 0xFF000000 |
      ((r * 255).round() << 16) |
      ((g * 255).round() << 8) |
      (b * 255).round();
}

/// Réplica de AppColors.legibleSobre para poder auditarla sin Flutter.
int legibleSobre(int color, int fondo, {double minimo = 4.5}) {
  if (contraste(color, fondo) >= minimo) return color;
  final hsl = _aHsl(color);
  final aclarar = luminancia(fondo) < 0.5;
  for (var paso = 1; paso <= 20; paso++) {
    final l = (aclarar ? hsl[2] + paso * 0.05 : hsl[2] - paso * 0.05).clamp(0.0, 1.0);
    final c = _deHsl(hsl[0], hsl[1], l);
    if (contraste(c, fondo) >= minimo) return c;
    if (l == 0.0 || l == 1.0) break;
  }
  return contraste(0xFFFFFFFF, fondo) >= contraste(0xFF000000, fondo)
      ? 0xFFFFFFFF
      : 0xFF000000;
}

// ── Informe ─────────────────────────────────────────────────────────────────
var fallos = 0;

void revisar(String etiqueta, int frente, int fondo, {double minimo = 4.5}) {
  final r = contraste(frente, fondo);
  final ok = r >= minimo;
  if (!ok) fallos++;
  stdout.writeln('  ${ok ? 'OK   ' : 'FALLA'} ${r.toStringAsFixed(2)}:1'
      '  (min ${minimo.toStringAsFixed(1)})  $etiqueta');
}

void seccion(String t) =>
    stdout.writeln('\n── $t ${'─' * math.max(2, 58 - t.length)}');

void main() {
  final l = claros, d = oscuros;

  seccion('TEMA CLARO — texto');
  for (final fondo in ['lightBackground', 'lightSurface']) {
    revisar('lightText sobre $fondo', l['lightText']!, l[fondo]!);
    revisar('lightTextMuted sobre $fondo', l['lightTextMuted']!, l[fondo]!);
  }

  seccion('TEMA CLARO — acentos como texto');
  for (final c in ['lightBrand', 'lightAccent', 'lightCta', 'lightAlert',
                   'lightError', 'lightSuccess']) {
    revisar('$c sobre lightBackground', l[c]!, l['lightBackground']!);
  }

  seccion('TEMA CLARO — texto blanco sobre botones de color');
  for (final c in ['lightBrand', 'lightAccent', 'lightCta', 'lightAlert',
                   'lightError', 'lightSuccess']) {
    revisar('blanco sobre $c', 0xFFFFFFFF, l[c]!);
  }

  seccion('TEMA OSCURO — texto');
  for (final fondo in ['darkBackground', 'darkSurface']) {
    revisar('darkText sobre $fondo', d['darkText']!, d[fondo]!);
    revisar('darkTextMuted sobre $fondo', d['darkTextMuted']!, d[fondo]!);
  }

  seccion('TEMA OSCURO — acentos como texto');
  for (final c in ['darkBrand', 'darkAccent', 'darkCta', 'darkAlert',
                   'darkError', 'darkSuccess']) {
    revisar('$c sobre darkBackground', d[c]!, d['darkBackground']!);
  }

  seccion('TEMA OSCURO — texto oscuro sobre botones de color');
  for (final c in ['darkBrand', 'darkAccent', 'darkCta', 'darkAlert',
                   'darkError', 'darkSuccess']) {
    revisar('darkBackground sobre $c', d['darkBackground']!, d[c]!);
  }

  seccion('COLORES DE DOMINIO');
  dominioClaro.forEach((n, c) =>
      revisar('$n (claro) sobre lightBackground', c, l['lightBackground']!));
  dominioOscuro.forEach((n, c) =>
      revisar('$n (oscuro) sobre darkBackground', c, d['darkBackground']!));

  seccion('LOGROS — tras pasar por legibleSobre');
  // En tema claro el snackbar tiene fondo oscuro (lightText) y en oscuro usa
  // darkSurface: el color del logro debe quedar legible sobre ambos.
  for (final c in logros) {
    final hex = c.toRadixString(16).substring(2).toUpperCase();
    revisar('#$hex ajustado sobre snackbar claro',
        legibleSobre(c, l['lightText']!), l['lightText']!);
    revisar('#$hex ajustado sobre snackbar oscuro',
        legibleSobre(c, d['darkSurface']!), d['darkSurface']!);
  }

  seccion('BORDES DE CONTROLES (min 3.0 — WCAG 1.4.11)');
  revisar('lightBorder sobre lightBackground', l['lightBorder']!,
      l['lightBackground']!, minimo: 3.0);
  revisar('lightBorder sobre lightSurface', l['lightBorder']!,
      l['lightSurface']!, minimo: 3.0);
  revisar('darkBorder sobre darkBackground', d['darkBorder']!,
      d['darkBackground']!, minimo: 3.0);
  revisar('darkBorder sobre darkSurface', d['darkBorder']!,
      d['darkSurface']!, minimo: 3.0);

  stdout.writeln('\n${'=' * 66}');
  stdout.writeln(fallos == 0
      ? 'Sin fallos de contraste.'
      : '$fallos combinaciones por debajo del umbral WCAG AA.');
  exit(fallos == 0 ? 0 : 1);
}
