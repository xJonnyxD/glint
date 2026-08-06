import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Paleta de colores de Glint — modo claro y oscuro.
///
/// Todas las combinaciones de esta paleta cumplen WCAG 2.1 AA (4.5:1 para
/// texto, 3:1 para bordes e iconos que transmiten información). Hay una
/// auditoría automática que lo comprueba:
///
///     dart run tool/auditar_contraste.dart
///
/// Si cambias un color, ejecútala antes de dar el cambio por bueno.
abstract class AppColors {
  // ── Modo Claro ─────────────────────────────────────────────────────────────
  // Paleta "Aurora": cremas y lilas de fondo, acentos azul-lavanda-rosa.
  //
  // Los tonos de FONDO van tal cual del diseño. Los tonos que llevan TEXTO
  // ENCIMA están un punto más profundos: los originales daban 2–3,2:1 con
  // blanco, y hace falta 4,5:1 para poder leerlos. El matiz es el mismo, solo
  // baja la luminosidad (ver la tabla de cada uno).
  static const Color lightBackground = Color(0xFFFFF5EC); // Crema melocotón
  static const Color lightSurface    = Color(0xFFFFFFFF); // Blanco perla
  static const Color lightBrand      = Color(0xFF705BFF); // Lavanda  (era #8F7FFF, 3,16:1)
  static const Color lightAccent     = Color(0xFF2B6AFF); // Azul aurora (era #5B8CFF)
  static const Color lightCta        = Color(0xFFC01A76); // Rosa      (era #F59ACF, 2,02:1)
  static const Color lightAlert      = Color(0xFFA64B00); // Ámbar tostado
  static const Color lightText       = Color(0xFF3B3B4A); // Texto principal
  static const Color lightTextMuted  = Color(0xFF5F5F73); // Texto secundario
  static const Color lightDivider    = Color(0xFFE8E4FF); // Lila muy claro
  static const Color lightBorder     = Color(0xFF7C7A99); // Borde de controles
  static const Color lightError      = Color(0xFFD10021); // (era #FF6B81, 2,74:1)
  static const Color lightSuccess    = Color(0xFF1F7A4D); // Verde éxito

  // ── Tonos decorativos (sin texto encima, van tal cual del diseño) ──────────
  // Para fondos suaves, degradados, tarjetas y destellos. NO usar para texto.
  static const Color auroraLavanda   = Color(0xFFA98BFF);
  static const Color auroraRosa      = Color(0xFFF59ACF);
  static const Color auroraRosaClaro = Color(0xFFFFD1E8);
  static const Color auroraLila      = Color(0xFFE8E4FF);
  static const Color auroraDorado    = Color(0xFFFFF5B8);
  static const Color auroraAzulHielo = Color(0xFFCBE9FF);
  static const Color auroraMorado    = Color(0xFFB46CFF);

  /// Degradado de marca, para cabeceras y superficies grandes.
  static const List<Color> gradienteAurora = [
    Color(0xFFFFF5EC),
    Color(0xFFFFE3F0),
    Color(0xFFE8DFFF),
    Color(0xFFD8F2FF),
  ];

  /// Degradado del logotipo, para textos destacados.
  static const List<Color> gradienteTexto = [
    Color(0xFF4C8DFF),
    Color(0xFF8F7FFF),
    Color(0xFFF08CC8),
  ];

  /// Degradado de cabecera: el arco aurora, derivado del color de [acento].
  ///
  /// Se genera girando el tono en el círculo cromático en vez de fijar cuatro
  /// colores. Con el lavanda de la marca (#705BFF, tono 249°) sale justo el
  /// arco del diseño —azul 219° → lavanda 249° → morado 279° → rosa 309°—, y
  /// con cualquiera de los otros 17 acentos que puede elegir el usuario sale su
  /// arco análogo, en vez de un morado que contradice lo que ha escogido.
  ///
  /// Cada parada pasa por [legibleSobre] porque el texto de las cabeceras va en
  /// blanco: los pasteles de la paleta no valen aquí (sobre `auroraLavanda` el
  /// blanco da 2,68:1 y sobre `auroraRosa` 2,02:1, frente al 4,5:1 de WCAG AA),
  /// así que se oscurecen lo justo para ser legibles conservando el tono.
  static LinearGradient cabeceraDe(Color acento) {
    final hsl = HSLColor.fromColor(acento);
    Color parada(double giro) => legibleSobre(
          hsl.withHue((hsl.hue + giro) % 360).toColor(),
          Colors.white,
        );

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [parada(-30), parada(0), parada(30), parada(60)],
      stops: const [0.0, 0.35, 0.7, 1.0],
    );
  }

  // ── Modo Oscuro ────────────────────────────────────────────────────────────
  // El diseño "Aurora" es de tema claro, así que el oscuro se deriva: fondos
  // profundos con un punto violeta (no gris neutro, para que siga sintiéndose
  // de la misma familia) y los tonos aurora como acentos. Aquí el texto va en
  // OSCURO sobre los acentos claros, al revés que en el tema claro.
  static const Color darkBackground  = Color(0xFF14121F); // Noche violácea
  static const Color darkSurface     = Color(0xFF1F1B2E); // Tarjetas
  static const Color darkBrand       = Color(0xFFA98BFF); // Lavanda
  static const Color darkAccent      = Color(0xFF8FC2FF); // Azul aurora claro
  static const Color darkCta         = Color(0xFFF59ACF); // Rosa pastel
  static const Color darkAlert       = Color(0xFFFFC978); // Ámbar suave
  static const Color darkText        = Color(0xFFF4F1FF); // Texto principal
  static const Color darkTextMuted   = Color(0xFFA9A3C7); // Texto secundario
  static const Color darkDivider     = Color(0xFF332C4D); // Separador decorativo
  static const Color darkBorder      = Color(0xFF8F87B5); // Borde de controles
  static const Color darkError       = Color(0xFFFF8A9B);
  static const Color darkSuccess     = Color(0xFF5BD6A0);

  // ── Colores de dominio ─────────────────────────────────────────────────────
  // Un mismo tono no puede ser legible sobre fondo claro y sobre fondo oscuro,
  // así que cada dominio tiene su variante. Usa [dominio] para elegir la que
  // toca según el tema en vez de referenciar las constantes directamente.
  static const Color domainRoutinesLight     = Color(0xFF4338CA); // Índigo
  static const Color domainHabitsLight       = Color(0xFF047857); // Esmeralda
  static const Color domainFinanceLight      = Color(0xFF9A6100); // Ámbar
  static const Color domainAgendaLight       = Color(0xFF1D4ED8); // Azul
  static const Color domainMeditationLight   = Color(0xFF6D28D9); // Violeta
  static const Color domainGamificationLight = Color(0xFFBE185D); // Rosa

  static const Color domainRoutinesDark      = Color(0xFF818CF8);
  static const Color domainHabitsDark        = Color(0xFF10B981);
  static const Color domainFinanceDark       = Color(0xFFF59E0B);
  static const Color domainAgendaDark        = Color(0xFF60A5FA);
  static const Color domainMeditationDark    = Color(0xFFC4B5FD);
  static const Color domainGamificationDark  = Color(0xFFF472B6);

  // ── Gradientes de marca ────────────────────────────────────────────────────
  static const LinearGradient brandGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightBrand, lightCta],
  );

  static const LinearGradient brandGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkBrand, darkAccent],
  );

  // ── Utilidades de contraste ────────────────────────────────────────────────

  /// Luminancia relativa según WCAG 2.1.
  static double _luminancia(Color c) {
    double canal(double v) =>
        v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
    return 0.2126 * canal(c.r) + 0.7152 * canal(c.g) + 0.0722 * canal(c.b);
  }

  /// Razón de contraste entre dos colores (1:1 a 21:1).
  static double contraste(Color a, Color b) {
    final la = _luminancia(a), lb = _luminancia(b);
    return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
  }

  /// Devuelve [color] ajustado —aclarándolo u oscureciéndolo— hasta alcanzar
  /// al menos [minimo]:1 de contraste sobre [fondo], conservando su tono.
  ///
  /// Sirve para pintar colores de identidad (categorías, logros) sobre fondos
  /// que cambian con el tema sin que el texto quede ilegible.
  static Color legibleSobre(Color color, Color fondo, {double minimo = 4.5}) {
    if (contraste(color, fondo) >= minimo) return color;

    final hsl = HSLColor.fromColor(color);
    // Sobre fondo oscuro hay que aclarar; sobre fondo claro, oscurecer.
    final aclarar = _luminancia(fondo) < 0.5;

    var mejor = color;
    for (var paso = 1; paso <= 20; paso++) {
      final l = (aclarar ? hsl.lightness + paso * 0.05 : hsl.lightness - paso * 0.05)
          .clamp(0.0, 1.0);
      mejor = hsl.withLightness(l).toColor();
      if (contraste(mejor, fondo) >= minimo) return mejor;
      if (l == 0.0 || l == 1.0) break;
    }
    // Si ni siquiera el blanco o el negro puro bastan, devolvemos el extremo
    // que más contraste da.
    final blanco = contraste(Colors.white, fondo);
    final negro = contraste(Colors.black, fondo);
    return blanco >= negro ? Colors.white : Colors.black;
  }

  /// Color de dominio adecuado al tema actual.
  static Color dominio(Dominio d, Brightness brillo) {
    final oscuro = brillo == Brightness.dark;
    switch (d) {
      case Dominio.rutinas:
        return oscuro ? domainRoutinesDark : domainRoutinesLight;
      case Dominio.habitos:
        return oscuro ? domainHabitsDark : domainHabitsLight;
      case Dominio.finanzas:
        return oscuro ? domainFinanceDark : domainFinanceLight;
      case Dominio.agenda:
        return oscuro ? domainAgendaDark : domainAgendaLight;
      case Dominio.meditacion:
        return oscuro ? domainMeditationDark : domainMeditationLight;
      case Dominio.gamificacion:
        return oscuro ? domainGamificationDark : domainGamificationLight;
    }
  }
}

/// Áreas funcionales de la app, cada una con su color de identidad.
enum Dominio { rutinas, habitos, finanzas, agenda, meditacion, gamificacion }
