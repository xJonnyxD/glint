import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Configuración de temas de Glint (Material 3)
abstract class AppTheme {
  // ── Tema Claro ─────────────────────────────────────────────────────────────
  static ThemeData get light {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary:          AppColors.lightBrand,
      onPrimary:        Colors.white,
      primaryContainer: AppColors.lightBrand.withAlpha(26),
      onPrimaryContainer: AppColors.lightBrand,
      secondary:        AppColors.lightAccent,
      onSecondary:      Colors.white,
      secondaryContainer: AppColors.lightAccent.withAlpha(26),
      onSecondaryContainer: AppColors.lightAccent,
      tertiary:         AppColors.lightCta,
      onTertiary:       Colors.white,
      error:            AppColors.lightError,
      onError:          Colors.white,
      surface:          AppColors.lightSurface,
      onSurface:        AppColors.lightText,
      surfaceContainerHighest: AppColors.lightBackground,
      outline:          AppColors.lightDivider,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      textTheme: _buildTextTheme(AppColors.lightText, AppColors.lightTextMuted),
      appBarTheme: _buildAppBarTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.lightText,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: _buildCardTheme(AppColors.lightSurface),
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme),
      outlinedButtonTheme: _buildOutlinedButtonTheme(colorScheme),
      textButtonTheme: _buildTextButtonTheme(colorScheme),
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedItemColor: AppColors.lightBrand,
        unselectedItemColor: AppColors.lightTextMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        indicatorColor: AppColors.lightBrand.withAlpha(26),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: AppColors.lightBrand);
          }
          return IconThemeData(color: AppColors.lightTextMuted);
        }),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.lightDivider,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightSurface,
        labelStyle: AppTextStyles.labelMedium.copyWith(
          color: AppColors.lightText,
        ),
        side: BorderSide(color: AppColors.lightDivider),
        shape: const StadiumBorder(),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightText,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.lightBackground,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ── Tema Oscuro ────────────────────────────────────────────────────────────
  static ThemeData get dark {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary:          AppColors.darkBrand,
      onPrimary:        AppColors.darkBackground,
      primaryContainer: AppColors.darkBrand.withAlpha(38),
      onPrimaryContainer: AppColors.darkBrand,
      secondary:        AppColors.darkAccent,
      onSecondary:      AppColors.darkBackground,
      secondaryContainer: AppColors.darkAccent.withAlpha(38),
      onSecondaryContainer: AppColors.darkAccent,
      tertiary:         AppColors.darkCta,
      onTertiary:       AppColors.darkBackground,
      error:            AppColors.darkError,
      onError:          AppColors.darkBackground,
      surface:          AppColors.darkSurface,
      onSurface:        AppColors.darkText,
      surfaceContainerHighest: AppColors.darkBackground,
      outline:          AppColors.darkDivider,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: _buildTextTheme(AppColors.darkText, AppColors.darkTextMuted),
      appBarTheme: _buildAppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkText,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: _buildCardTheme(AppColors.darkSurface),
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme),
      outlinedButtonTheme: _buildOutlinedButtonTheme(colorScheme),
      textButtonTheme: _buildTextButtonTheme(colorScheme),
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.darkBrand,
        unselectedItemColor: AppColors.darkTextMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        indicatorColor: AppColors.darkBrand.withAlpha(51),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: AppColors.darkBrand);
          }
          return IconThemeData(color: AppColors.darkTextMuted);
        }),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.darkDivider,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurface,
        labelStyle: AppTextStyles.labelMedium.copyWith(
          color: AppColors.darkText,
        ),
        side: BorderSide(color: AppColors.darkDivider),
        shape: const StadiumBorder(),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkSurface,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.darkText,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ── Helpers privados ───────────────────────────────────────────────────────

  static TextTheme _buildTextTheme(Color primary, Color muted) {
    return TextTheme(
      displayLarge:   AppTextStyles.displayLarge.copyWith(color: primary),
      displayMedium:  AppTextStyles.displayMedium.copyWith(color: primary),
      headlineLarge:  AppTextStyles.headlineLarge.copyWith(color: primary),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(color: primary),
      headlineSmall:  AppTextStyles.headlineSmall.copyWith(color: primary),
      titleLarge:     AppTextStyles.titleLarge.copyWith(color: primary),
      titleMedium:    AppTextStyles.titleMedium.copyWith(color: primary),
      titleSmall:     AppTextStyles.titleSmall.copyWith(color: muted),
      bodyLarge:      AppTextStyles.bodyLarge.copyWith(color: primary),
      bodyMedium:     AppTextStyles.bodyMedium.copyWith(color: primary),
      bodySmall:      AppTextStyles.bodySmall.copyWith(color: muted),
      labelLarge:     AppTextStyles.labelLarge.copyWith(color: primary),
      labelMedium:    AppTextStyles.labelMedium.copyWith(color: muted),
      labelSmall:     AppTextStyles.labelSmall.copyWith(color: muted),
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
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: foregroundColor,
      ),
    );
  }

  static CardThemeData _buildCardTheme(Color surfaceColor) {
    return CardThemeData(
      color: surfaceColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppTextStyles.labelLarge,
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
        textStyle: AppTextStyles.labelLarge,
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: AppTextStyles.labelLarge,
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(
    ColorScheme colorScheme,
  ) {
    return InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surface,
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
      labelStyle: AppTextStyles.bodyMedium.copyWith(
        color: colorScheme.onSurface.withAlpha(153),
      ),
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: colorScheme.onSurface.withAlpha(128),
      ),
    );
  }
}

// Extensión utilitaria para TextStyle
extension TextStyleOpacity on TextStyle {
  TextStyle withOpacity(double opacity) =>
      copyWith(color: (color ?? Colors.black).withAlpha((opacity * 255).round()));
}
