import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Catálogo central de iconos de Glint (Material Symbols).
///
/// Sustituye a los emojis de "chrome" (navegación, acciones, encabezados). Un
/// solo lugar para cambiar el set de iconos y mantener coherencia visual entre
/// pantallas. Para los iconos elegibles por el usuario (hábitos/rutinas), ver
/// [habit_icons.dart].
abstract class AppIcons {
  // ── Navegación principal ────────────────────────────────────────────────
  static const IconData home        = Symbols.home_rounded;
  static const IconData routines    = Symbols.wb_sunny_rounded;
  static const IconData habits      = Symbols.task_alt_rounded;
  static const IconData finance     = Symbols.account_balance_wallet_rounded;
  static const IconData agenda      = Symbols.calendar_month_rounded;
  static const IconData notes       = Symbols.sticky_note_2_rounded;
  static const IconData profile     = Symbols.person_rounded;
  static const IconData gamification = Symbols.trophy_rounded;
  static const IconData settings    = Symbols.settings_rounded;

  // ── Acciones ────────────────────────────────────────────────────────────
  static const IconData add       = Symbols.add_rounded;
  static const IconData edit      = Symbols.edit_rounded;
  static const IconData delete    = Symbols.delete_rounded;
  static const IconData save      = Symbols.check_rounded;
  static const IconData close     = Symbols.close_rounded;
  static const IconData back      = Symbols.arrow_back_rounded;
  static const IconData forward   = Symbols.arrow_forward_rounded;
  static const IconData more      = Symbols.more_vert_rounded;
  static const IconData search    = Symbols.search_rounded;
  static const IconData filter    = Symbols.filter_list_rounded;
  static const IconData share     = Symbols.ios_share_rounded;
  static const IconData download  = Symbols.download_rounded;
  static const IconData refresh   = Symbols.refresh_rounded;
  static const IconData check     = Symbols.check_circle_rounded;
  static const IconData uncheck   = Symbols.radio_button_unchecked_rounded;
  static const IconData copy      = Symbols.content_copy_rounded;
  static const IconData visible   = Symbols.visibility_rounded;
  static const IconData hidden    = Symbols.visibility_off_rounded;
  static const IconData calendar  = Symbols.calendar_today_rounded;
  static const IconData clock     = Symbols.schedule_rounded;
  static const IconData pin       = Symbols.push_pin_rounded;
  static const IconData tag       = Symbols.label_rounded;
  static const IconData quote     = Symbols.format_quote_rounded;
  static const IconData event     = Symbols.event_rounded;
  static const IconData eventDone = Symbols.event_available_rounded;
  static const IconData sun       = Symbols.wb_sunny_rounded;
  static const IconData moon      = Symbols.bedtime_rounded;
  static const IconData crown     = Symbols.workspace_premium_rounded;

  // ── Estado / feedback ───────────────────────────────────────────────────
  static const IconData success   = Symbols.check_circle_rounded;
  static const IconData error     = Symbols.error_rounded;
  static const IconData warning   = Symbols.warning_rounded;
  static const IconData info      = Symbols.info_rounded;
  static const IconData empty     = Symbols.inbox_rounded;
  static const IconData offline   = Symbols.cloud_off_rounded;
  static const IconData synced    = Symbols.cloud_done_rounded;
  static const IconData notifications = Symbols.notifications_rounded;

  // ── Métricas / gamificación ─────────────────────────────────────────────
  static const IconData streak    = Symbols.local_fire_department_rounded;
  static const IconData xp        = Symbols.bolt_rounded;
  static const IconData star      = Symbols.star_rounded;
  static const IconData trophy    = Symbols.trophy_rounded;
  static const IconData medal     = Symbols.workspace_premium_rounded;
  static const IconData target    = Symbols.target_rounded;
  static const IconData trendUp   = Symbols.trending_up_rounded;
  static const IconData trendDown = Symbols.trending_down_rounded;

  // ── Finanzas ────────────────────────────────────────────────────────────
  static const IconData money     = Symbols.payments_rounded;
  static const IconData income    = Symbols.arrow_downward_rounded;
  static const IconData expense   = Symbols.arrow_upward_rounded;
  static const IconData budget    = Symbols.pie_chart_rounded;
  static const IconData savings   = Symbols.savings_rounded;
  static const IconData debt      = Symbols.credit_card_rounded;
  static const IconData recurring = Symbols.autorenew_rounded;
  static const IconData calculator = Symbols.calculate_rounded;

  // ── Seguridad / cuenta ──────────────────────────────────────────────────
  static const IconData lock      = Symbols.lock_rounded;
  static const IconData fingerprint = Symbols.fingerprint_rounded;
  static const IconData logout    = Symbols.logout_rounded;
  static const IconData google    = Symbols.g_mobiledata_rounded;
  static const IconData email     = Symbols.mail_rounded;
  static const IconData backup    = Symbols.backup_rounded;
  static const IconData themeLight = Symbols.light_mode_rounded;
  static const IconData themeDark  = Symbols.dark_mode_rounded;
  static const IconData themeAuto  = Symbols.brightness_auto_rounded;

  // ── Perfil / cuenta (extra) ─────────────────────────────────────────────
  static const IconData camera    = Symbols.photo_camera_rounded;
  static const IconData gallery   = Symbols.photo_library_rounded;
  static const IconData phone     = Symbols.phone_rounded;
  static const IconData birthday  = Symbols.cake_rounded;
  static const IconData badge     = Symbols.badge_rounded;
  static const IconData palette   = Symbols.palette_rounded;
  static const IconData personAdd = Symbols.person_add_rounded;
  static const IconData vibration = Symbols.vibration_rounded;
  static const IconData storage   = Symbols.database_rounded;

  // ── Navegación / listas (extra) ─────────────────────────────────────────
  static const IconData chevronRight = Symbols.chevron_right_rounded;
  static const IconData chevronLeft  = Symbols.chevron_left_rounded;
}
