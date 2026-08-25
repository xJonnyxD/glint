import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter/material.dart';

import 'package:glint/core/theme/app_colors.dart';
import '../group_colors.dart';

/// Avatar circular con las iniciales de una persona y un color estable derivado
/// de su identidad (misma persona → mismo color siempre). Da a los grupos ese
/// aire "con caras" en vez de listas planas.
class MemberAvatar extends StatelessWidget {
  final String nombre;
  final String? seed; // id u otra clave estable; si es null usa el nombre
  final double radio;
  final bool esVirtual;

  const MemberAvatar({
    super.key,
    required this.nombre,
    this.seed,
    this.radio = 18,
    this.esVirtual = false,
  });

  @override
  Widget build(BuildContext context) {
    final base = colorParaClave(seed ?? nombre);
    final fondo = Theme.of(context).colorScheme.surface;
    // El color de identidad, ajustado para que las iniciales se lean sobre él.
    final onColor = AppColors.legibleSobre(Colors.white, base, minimo: 3);

    return Container(
      width: radio * 2,
      height: radio * 2,
      decoration: BoxDecoration(
        color: base,
        shape: BoxShape.circle,
        border: Border.all(color: fondo, width: 2),
      ),
      alignment: Alignment.center,
      child: esVirtual
          ? Icon(Symbols.person_rounded, size: radio, color: onColor)
          : Text(
              _iniciales(nombre),
              style: TextStyle(
                color: onColor,
                fontWeight: FontWeight.bold,
                fontSize: radio * 0.8,
              ),
            ),
    );
  }

  static String _iniciales(String nombre) {
    final partes = nombre.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (partes.isEmpty) return '?';
    if (partes.length == 1) {
      return partes.first.characters.first.toUpperCase();
    }
    return (partes.first.characters.first + partes.last.characters.first)
        .toUpperCase();
  }
}

/// Color estable a partir de una clave (id/nombre), tomado de la paleta de
/// grupos. Determinista: la misma clave devuelve siempre el mismo color.
Color colorParaClave(String clave) {
  var h = 0;
  for (final code in clave.codeUnits) {
    h = (h * 31 + code) & 0x7fffffff;
  }
  return colorDesdeHex(grupoColores[h % grupoColores.length]);
}

/// Pila de avatares solapados (ej. "quiénes participan en este gasto"), con un
/// "+N" al final si hay más de [maximo].
class AvatarStack extends StatelessWidget {
  final List<({String nombre, String seed, bool virtual})> personas;
  final double radio;
  final int maximo;

  const AvatarStack({
    super.key,
    required this.personas,
    this.radio = 12,
    this.maximo = 4,
  });

  @override
  Widget build(BuildContext context) {
    final visibles = personas.take(maximo).toList();
    final resto = personas.length - visibles.length;
    final solape = radio * 1.15;
    final ancho = visibles.isEmpty
        ? 0.0
        : radio * 2 + (visibles.length - 1) * solape + (resto > 0 ? solape : 0);

    return SizedBox(
      height: radio * 2,
      width: ancho + (resto > 0 ? radio * 2 : 0),
      child: Stack(
        children: [
          for (var i = 0; i < visibles.length; i++)
            Positioned(
              left: i * solape,
              child: MemberAvatar(
                nombre: visibles[i].nombre,
                seed: visibles[i].seed,
                esVirtual: visibles[i].virtual,
                radio: radio,
              ),
            ),
          if (resto > 0)
            Positioned(
              left: visibles.length * solape,
              child: Container(
                width: radio * 2,
                height: radio * 2,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '+$resto',
                  style: TextStyle(
                    fontSize: radio * 0.75,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
