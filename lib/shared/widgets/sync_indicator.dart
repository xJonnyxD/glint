import 'package:flutter/material.dart';

import 'package:glint/shared/services/sync_manager.dart';

/// Indicador compacto del estado de sincronización, pensado para una esquina
/// del header. Muestra un spinner mientras sincroniza, una nube con check
/// cuando está al día y una nube tachada si hubo error.
class SyncIndicator extends StatelessWidget {
  final Color? color;
  const SyncIndicator({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.onSurfaceVariant;
    return ValueListenableBuilder<SyncEstado>(
      valueListenable: SyncManager.estado,
      builder: (context, estado, _) {
        switch (estado) {
          case SyncEstado.sincronizando:
            return SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: c),
            );
          case SyncEstado.alDia:
            return Icon(Icons.cloud_done_outlined, size: 18, color: c);
          case SyncEstado.error:
            return Icon(Icons.cloud_off_outlined,
                size: 18, color: Theme.of(context).colorScheme.error);
          case SyncEstado.inactivo:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
