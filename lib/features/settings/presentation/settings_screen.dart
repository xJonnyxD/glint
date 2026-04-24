import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:glint/core/constants/app_constants.dart';
import 'package:glint/core/theme/theme_cubit.dart';
import 'package:glint/shared/services/notification_service.dart';

/// Pantalla de Configuración real de Glint
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ── Notificaciones ─────────────────────────────────────────────────────────
  bool _notifsRutinas  = false;
  bool _notifsHabitos  = false;
  bool _notifsAgenda   = false;
  bool _notifsPermiso  = false;
  String _horaRutinas  = '07:00';
  String _horaHabitos  = '18:00';

  // ── Keys de preferencias ───────────────────────────────────────────────────
  static const _kNotifRutinas  = 'glint_notif_rutinas';
  static const _kNotifHabitos  = 'glint_notif_habitos';
  static const _kNotifAgenda   = 'glint_notif_agenda';
  static const _kHoraRutinas   = 'glint_hora_rutinas';
  static const _kHoraHabitos   = 'glint_hora_habitos';

  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarPreferencias();
  }

  Future<void> _cargarPreferencias() async {
    final prefs   = await SharedPreferences.getInstance();
    final permiso = await NotificationService.estaHabilitado();
    if (mounted) {
      setState(() {
        _notifsPermiso = permiso;
        _notifsRutinas = prefs.getBool(_kNotifRutinas) ?? false;
        _notifsHabitos = prefs.getBool(_kNotifHabitos) ?? false;
        _notifsAgenda  = prefs.getBool(_kNotifAgenda)  ?? false;
        _horaRutinas   = prefs.getString(_kHoraRutinas) ?? '07:00';
        _horaHabitos   = prefs.getString(_kHoraHabitos) ?? '18:00';
        _cargando = false;
      });
    }
  }

  Future<void> _toggleRutinas(bool valor) async {
    if (valor && !_notifsPermiso) {
      final concedido = await NotificationService.solicitarPermiso();
      if (!concedido || !mounted) return;
      setState(() => _notifsPermiso = true);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNotifRutinas, valor);
    if (valor) {
      await NotificationService.programarRecordatorioRutinas(
        hora: _horaRutinas,
        totalRutinas: 0,
      );
    } else {
      await NotificationService.cancelarRecordatorioRutinas();
    }
    if (mounted) setState(() => _notifsRutinas = valor);
  }

  Future<void> _toggleHabitos(bool valor) async {
    if (valor && !_notifsPermiso) {
      final concedido = await NotificationService.solicitarPermiso();
      if (!concedido || !mounted) return;
      setState(() => _notifsPermiso = true);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNotifHabitos, valor);
    if (valor) {
      await NotificationService.programarRecordatorioHabitos(hora: _horaHabitos);
    } else {
      await NotificationService.cancelarRecordatorioHabitos();
    }
    if (mounted) setState(() => _notifsHabitos = valor);
  }

  Future<void> _toggleAgenda(bool valor) async {
    if (valor && !_notifsPermiso) {
      final concedido = await NotificationService.solicitarPermiso();
      if (!concedido || !mounted) return;
      setState(() => _notifsPermiso = true);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNotifAgenda, valor);
    if (mounted) setState(() => _notifsAgenda = valor);
  }

  Future<void> _cambiarHoraRutinas() async {
    final partes = _horaRutinas.split(':');
    final inicial = TimeOfDay(
      hour:   int.tryParse(partes[0]) ?? 7,
      minute: int.tryParse(partes[1]) ?? 0,
    );
    final picked = await showTimePicker(
      context: context,
      initialTime: inicial,
      helpText: 'Hora del recordatorio de rutinas',
    );
    if (picked == null || !mounted) return;
    final nueva = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    final prefs  = await SharedPreferences.getInstance();
    await prefs.setString(_kHoraRutinas, nueva);
    setState(() => _horaRutinas = nueva);
    if (_notifsRutinas) {
      await NotificationService.programarRecordatorioRutinas(
        hora: nueva,
        totalRutinas: 0,
      );
    }
  }

  Future<void> _cambiarHoraHabitos() async {
    final partes = _horaHabitos.split(':');
    final inicial = TimeOfDay(
      hour:   int.tryParse(partes[0]) ?? 18,
      minute: int.tryParse(partes[1]) ?? 0,
    );
    final picked = await showTimePicker(
      context: context,
      initialTime: inicial,
      helpText: 'Hora del recordatorio de hábitos',
    );
    if (picked == null || !mounted) return;
    final nueva = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    final prefs  = await SharedPreferences.getInstance();
    await prefs.setString(_kHoraHabitos, nueva);
    setState(() => _horaHabitos = nueva);
    if (_notifsHabitos) {
      await NotificationService.programarRecordatorioHabitos(hora: nueva);
    }
  }

  Future<void> _borrarDatosLocales() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Borrar datos locales?'),
        content: const Text(
          'Se eliminarán todas las preferencias guardadas en este dispositivo '
          '(tema, foto de perfil, estado). Los datos en la nube no se ven afectados.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Borrar'),
          ),
        ],
      ),
    );
    if (confirmar != true || !mounted) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await NotificationService.cancelarTodas();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Datos locales eliminados'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      // Recargar preferencias
      _cargarPreferencias();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final themeState  = context.watch<ThemeCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // ── SECCIÓN: APARIENCIA ──────────────────────────────────────
                _SectionHeader(title: 'Apariencia'),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.brightness_6_outlined,
                                  color: colorScheme.primary, size: 20),
                              const SizedBox(width: 8),
                              Text('Tema',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w700)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SegmentedButton<ThemeMode>(
                            segments: const [
                              ButtonSegment(
                                  value: ThemeMode.light,
                                  label: Text('Claro'),
                                  icon: Icon(Icons.light_mode_outlined)),
                              ButtonSegment(
                                  value: ThemeMode.system,
                                  label: Text('Auto'),
                                  icon: Icon(Icons.brightness_auto_outlined)),
                              ButtonSegment(
                                  value: ThemeMode.dark,
                                  label: Text('Oscuro'),
                                  icon: Icon(Icons.dark_mode_outlined)),
                            ],
                            selected: {themeState.modo},
                            onSelectionChanged: (sel) =>
                                context.read<ThemeCubit>().cambiarModo(sel.first),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Color de acento
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.palette_outlined,
                                  color: colorScheme.primary, size: 20),
                              const SizedBox(width: 8),
                              Text('Color de la app',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w700)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: coloresAcento.map((c) {
                              final hex      = c['hex']!;
                              final nombre   = c['nombre']!;
                              final color    = _hexToColor(hex);
                              final selected = hex == themeState.colorAcento;
                              return GestureDetector(
                                onTap: () =>
                                    context.read<ThemeCubit>().cambiarColor(hex),
                                child: Tooltip(
                                  message: nombre,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: selected
                                            ? colorScheme.onSurface
                                            : Colors.transparent,
                                        width: 3,
                                      ),
                                    ),
                                    child: selected
                                        ? const Icon(Icons.check,
                                            color: Colors.white, size: 18)
                                        : null,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── SECCIÓN: NOTIFICACIONES ──────────────────────────────────
                _SectionHeader(title: 'Notificaciones'),

                if (!_notifsPermiso)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Card(
                      color: colorScheme.errorContainer,
                      child: ListTile(
                        leading: Icon(Icons.notifications_off_outlined,
                            color: colorScheme.error),
                        title: Text('Notificaciones desactivadas',
                            style: TextStyle(color: colorScheme.error,
                                fontWeight: FontWeight.w600)),
                        subtitle: const Text(
                            'Activa una notificación para que el sistema solicite permiso'),
                      ),
                    ),
                  ),

                // Rutinas
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Card(
                    child: Column(
                      children: [
                        SwitchListTile(
                          secondary: Icon(Icons.wb_sunny_outlined,
                              color: colorScheme.primary),
                          title: const Text('Rutinas diarias'),
                          subtitle: Text('Recordatorio a las $_horaRutinas'),
                          value: _notifsRutinas,
                          onChanged: _toggleRutinas,
                        ),
                        if (_notifsRutinas)
                          ListTile(
                            leading: const Icon(Icons.access_time_outlined),
                            title: const Text('Cambiar hora'),
                            trailing: Text(
                              _horaRutinas,
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onTap: _cambiarHoraRutinas,
                          ),
                      ],
                    ),
                  ),
                ),

                // Hábitos
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Card(
                    child: Column(
                      children: [
                        SwitchListTile(
                          secondary: Icon(Icons.favorite_outline,
                              color: Colors.pinkAccent),
                          title: const Text('Hábitos'),
                          subtitle: Text('Recordatorio a las $_horaHabitos'),
                          value: _notifsHabitos,
                          onChanged: _toggleHabitos,
                        ),
                        if (_notifsHabitos)
                          ListTile(
                            leading: const Icon(Icons.access_time_outlined),
                            title: const Text('Cambiar hora'),
                            trailing: Text(
                              _horaHabitos,
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onTap: _cambiarHoraHabitos,
                          ),
                      ],
                    ),
                  ),
                ),

                // Agenda
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Card(
                    child: SwitchListTile(
                      secondary: Icon(Icons.calendar_today_outlined,
                          color: Colors.green.shade600),
                      title: const Text('Agenda'),
                      subtitle: const Text('Recordatorio 30 min antes de cada evento'),
                      value: _notifsAgenda,
                      onChanged: _toggleAgenda,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── SECCIÓN: DATOS Y PRIVACIDAD ──────────────────────────────
                _SectionHeader(title: 'Datos y privacidad'),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.storage_outlined,
                              color: colorScheme.primary),
                          title: const Text('Almacenamiento'),
                          subtitle: const Text(
                              'Tus datos se guardan localmente en este dispositivo'),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: Icon(Icons.delete_outline,
                              color: colorScheme.error),
                          title: Text('Borrar datos locales',
                              style: TextStyle(color: colorScheme.error)),
                          subtitle: const Text(
                              'Elimina preferencias y caché local (no afecta datos en la nube)'),
                          onTap: _borrarDatosLocales,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── SECCIÓN: ACERCA DE ───────────────────────────────────────
                _SectionHeader(title: 'Acerca de Glint'),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.info_outline,
                              color: colorScheme.primary),
                          title: const Text('Versión'),
                          subtitle: Text(AppConstants.appVersion),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: Icon(Icons.location_on_outlined,
                              color: colorScheme.primary),
                          title: const Text('Región'),
                          subtitle: const Text('El Salvador 🇸🇻'),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: Icon(Icons.attach_money,
                              color: colorScheme.primary),
                          title: const Text('Moneda'),
                          subtitle: const Text('USD — Dólar estadounidense'),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
    );
  }

  Color _hexToColor(String hex) {
    try {
      return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
    } catch (_) {
      return const Color(0xFF6750A4);
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 0, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
