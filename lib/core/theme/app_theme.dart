import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Configuración de temas de Glint (Material 3).
///
/// - Usa [buildLight] / [buildDark] para temas dinámicos con color semilla
///   personalizado (p.ej. el acento elegido por el usuario en [ThemeCubit]).
/// - Los getters [light] / [dark] mantienen compatibilidad con el código
///   existente usando el morado predeterminado de Material 3.
abstract class AppTheme {
  // ── Color semilla por defecto (morado M3) ─────────────────────────────────
  /// Color del que nace el resto del esquema. Es el lavanda de la paleta
  /// Aurora, en su versión legible (el `#8F7FFF` del diseño no llega a 4,5:1
  /// con texto blanco encima; ver AppColors).
  static const Color _defaultSeed = Color(0xFF705BFF);

  // ── Transiciones de página ────────────────────────────────────────────────
  // Un solo builder para todas las plataformas (incluida la web, que por
  // defecto no anima al navegar), para que abrir pantallas se sienta fluido y
  // consistente en toda la app.
  static const PageTransitionsTheme _transiciones = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
      TargetPlatform.windows: ZoomPageTransitionsBuilder(),
      TargetPlatform.linux: ZoomPageTransitionsBuilder(),
      TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
    },
  );

  // ── API de compatibilidad ─────────────────────────────────────────────────
  static ThemeData get light => buildLight(_defaultSeed);
  static ThemeData get dark  => buildDark(_defaultSeed);

  // ── Constructores dinámicos ───────────────────────────────────────────────

  /// Tema claro generado a partir de [seedColor].
  static ThemeData buildLight(Color seedColor) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor:  seedColor,
      brightness: Brightness.light,
      // La variante por defecto de Material 3 (tonalSpot) desatura el color
      // semilla hasta dejarlo irreconocible: del lavanda #705BFF sacaba un
      // #5D5791 al 25 % de saturación, un malva grisáceo. De ahí que cambiar
      // la paleta "no se notara" en pantalla. `vibrant` conserva el 100 % y
      // devuelve #5530FF, que sí es el color de la marca.
      dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
      // Ancla colores de superficie/fondo a los valores originales de Glint
      // para que el cambio de acento no altere el look general de la app.
      surface:    AppColors.lightSurface,
    ).copyWith(
      surface:                    AppColors.lightSurface,
      onSurface:                  AppColors.lightText,
      onSurfaceVariant:           AppColors.lightTextMuted,
      surfaceContainerHighest:    AppColors.lightBackground,
      // `outline` es el borde de los controles (campos de texto, chips), así
      // que necesita 3:1 — no vale el divisor decorativo, que es casi
      // invisible sobre el fondo. El divisor se usa en outlineVariant.
      outline:                    AppColors.lightBorder,
      outlineVariant:             AppColors.lightDivider,
      error:                      AppColors.lightError,
      onError:                    Colors.white,
    );

    return ThemeData(
      useMaterial3:            true,
      colorScheme:             colorScheme,
      pageTransitionsTheme:    _transiciones,
      scaffoldBackgroundColor: AppColors.lightBackground,
      textTheme: _buildTextTheme(AppColors.lightText, AppColors.lightTextMuted),
      appBarTheme: _buildAppBarTheme(
        backgroundColor:  AppColors.lightBackground,
        foregroundColor:  AppColors.lightText,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme:             _buildCardTheme(AppColors.lightSurface),
      elevatedButtonTheme:   _buildElevatedButtonTheme(colorScheme),
      outlinedButtonTheme:   _buildOutlinedButtonTheme(colorScheme),
      textButtonTheme:       _buildTextButtonTheme(colorScheme),
      inputDecorationTheme:  _buildInputDecorationTheme(colorScheme),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor:     AppColors.lightSurface,
        selectedItemColor:   colorScheme.primary,
        unselectedItemColor: AppColors.lightTextMuted,
        type:      BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        indicatorColor:  colorScheme.primary.withAlpha(26),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.primary);
          }
          return IconThemeData(color: AppColors.lightTextMuted);
        }),
      ),
      dividerTheme: DividerThemeData(
        color:     AppColors.lightDivider,
        thickness: 1,
        space:     1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightSurface,
        labelStyle: gf(AppTextStyles.labelMedium).copyWith(
          color: AppColors.lightText,
        ),
        side:  BorderSide(color: AppColors.lightDivider),
        shape: const StadiumBorder(),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightText,
        contentTextStyle: gf(AppTextStyles.bodyMedium).copyWith(
          color: AppColors.lightBackground,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// Tema oscuro generado a partir de [seedColor].
  static ThemeData buildDark(Color seedColor) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor:  seedColor,
      brightness: Brightness.dark,
      dynamicSchemeVariant: DynamicSchemeVariant.vibrant, // ver buildLight
      surface:    AppColors.darkSurface,
    ).copyWith(
      surface:                 AppColors.darkSurface,
      onSurface:               AppColors.darkText,
      onSurfaceVariant:        AppColors.darkTextMuted,
      surfaceContainerHighest: AppColors.darkBackground,
      // Ver la nota del tema claro: `outline` son los bordes de controles y
      // necesitan 3:1; el divisor decorativo va en outlineVariant.
      outline:                 AppColors.darkBorder,
      outlineVariant:          AppColors.darkDivider,
      error:                   AppColors.darkError,
      onError:                 AppColors.darkBackground,
    );

    return ThemeData(
      useMaterial3:            true,
      colorScheme:             colorScheme,
      pageTransitionsTheme:    _transiciones,
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: _buildTextTheme(AppColors.darkText, AppColors.darkTextMuted),
      appBarTheme: _buildAppBarTheme(
        backgroundColor:  AppColors.darkBackground,
        foregroundColor:  AppColors.darkText,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme:            _buildCardTheme(AppColors.darkSurface),
      elevatedButtonTheme:  _buildElevatedButtonTheme(colorScheme),
      outlinedButtonTheme:  _buildOutlinedButtonTheme(colorScheme),
      textButtonTheme:      _buildTextButtonTheme(colorScheme),
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor:     AppColors.darkSurface,
        selectedItemColor:   colorScheme.primary,
        unselectedItemColor: AppColors.darkTextMuted,
        type:      BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        indicatorColor:  colorScheme.primary.withAlpha(51),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.primary);
          }
          return IconThemeData(color: AppColors.darkTextMuted);
        }),
      ),
      dividerTheme: DividerThemeData(
        color:     AppColors.darkDivider,
        thickness: 1,
        space:     1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurface,
        labelStyle: gf(AppTextStyles.labelMedium).copyWith(
          color: AppColors.darkText,
        ),
        side:  BorderSide(color: AppColors.darkDivider),
        shape: const StadiumBorder(),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkSurface,
        contentTextStyle: gf(AppTextStyles.bodyMedium).copyWith(
          color: AppColors.darkText,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ── Helpers privados ───────────────────────────────────────────────────────

  /// Aplica la tipografía de marca (Plus Jakarta Sans) a un [TextStyle],
  /// conservando tamaño, peso y espaciado. Un solo punto para cambiar la fuente.
  static TextStyle gf(TextStyle base) =>
      GoogleFonts.plusJakartaSans(textStyle: base);

  static TextTheme _buildTextTheme(Color primary, Color muted) {
    return TextTheme(
      displayLarge:   gf(AppTextStyles.displayLarge).copyWith(color: primary),
      displayMedium:  gf(AppTextStyles.displayMedium).copyWith(color: primary),
      headlineLarge:  gf(AppTextStyles.headlineLarge).copyWith(color: primary),
      headlineMedium: gf(AppTextStyles.headlineMedium).copyWith(color: primary),
      headlineSmall:  gf(AppTextStyles.headlineSmall).copyWith(color: primary),
      titleLarge:     gf(AppTextStyles.titleLarge).copyWith(color: primary),
      titleMedium:    gf(AppTextStyles.titleMedium).copyWith(color: primary),
      titleSmall:     gf(AppTextStyles.titleSmall).copyWith(color: muted),
      bodyLarge:      gf(AppTextStyles.bodyLarge).copyWith(color: primary),
      bodyMedium:     gf(AppTextStyles.bodyMedium).copyWith(color: primary),
      bodySmall:      gf(AppTextStyles.bodySmall).copyWith(color: muted),
      labelLarge:     gf(AppTextStyles.labelLarge).copyWith(color: primary),
      labelMedium:    gf(AppTextStyles.labelMedium).copyWith(color: muted),
      labelSmall:     gf(AppTextStyles.labelSmall).copyWith(color: muted),
    );
  }

  static AppBarTheme _buildAppBarTheme({
    required Color backgroundColor,
    required Color foregroundColor,
    required Color surfaceTintColor,
  }) {
    return AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      surfaceTintColor: surfaceTintColor,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: gf(AppTextStyles.titleLarge).copyWith(
        color: foregroundColor,
      ),
    );
  }

  static CardThemeData _buildCardTheme(Color surfaceColor) {
    return CardThemeData(
      color:            surfaceColor,
      elevation:        6,
      // Sombra malva en vez de negra: es lo que da el aire "aurora" en lugar
      // del gris apagado de una sombra neutra. Se mantiene suave para no
      // ensuciar los fondos claros.
      shadowColor:      const Color(0xFFA98BFF).withValues(alpha: 0.28),
      surfaceTintColor: Colors.transparent, // sin el tinte M3 que altera el color
      shape: RoundedRectangleBorder(
        // Esquinas generosas (28), como pide la identidad visual.
        borderRadius: BorderRadius.circular(28),
      ),
      clipBehavior: Clip.antiAlias,
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme(
    ColorScheme colorScheme,
  ) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: gf(AppTextStyles.labelLarge),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme(
    ColorScheme colorScheme,
  ) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.primary),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: gf(AppTextStyles.labelLarge),
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: gf(AppTextStyles.labelLarge),
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(
    ColorScheme colorScheme,
  ) {
    return InputDecorationTheme(
      filled:     true,
      fillColor:  colorScheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      // Etiquetas y placeholders con el color de texto secundario en lugar de
      // aplicar opacidad al principal: al 50–60% no llegaban ni a 4.5:1, y un
      // placeholder ilegible deja al usuario sin saber qué va en el campo.
      labelStyle: gf(AppTextStyles.bodyMedium).copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      hintStyle: gf(AppTextStyles.bodyMedium).copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}

// Extensión utilitaria para TextStyle
extension TextStyleOpacity on TextStyle {
  TextStyle withOpacity(double opacity) =>
      copyWith(color: (color ?? Colors.black).withAlpha((opacity * 255).round()));
}
