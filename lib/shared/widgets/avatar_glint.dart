import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:glint/core/theme/app_colors.dart';
import 'package:glint/features/groups/presentation/widgets/member_avatar.dart'
    show colorParaClave;

/// Avatar circular de una persona, en un único sitio para toda la app.
///
/// Resuelve en este orden:
///  1. [bytesLocales] — la foto recién elegida o la cacheada en el dispositivo.
///     Es lo que hace que se vea al instante y sin red.
///  2. [url] — el avatar en el servidor, con caché en disco.
///  3. Iniciales sobre un color estable derivado de [seed].
///
/// Usa `Image.memory` y `CachedNetworkImage` en vez de `FileImage`, que es lo
/// que antes rompía la foto de perfil en el navegador (`dart:io` no existe
/// allí).
class AvatarGlint extends StatelessWidget {
  final String? url;
  final Uint8List? bytesLocales;
  final String nombre;

  /// Clave estable para el color de las iniciales (normalmente el id).
  final String? seed;
  final double radio;

  /// Para cabeceras sobre un fondo de color, donde el color derivado no pega.
  final Color? colorFondo;
  final Color? colorTexto;

  /// Borde del color de la superficie, como en las pilas de avatares.
  final bool conBorde;

  const AvatarGlint({
    super.key,
    this.url,
    this.bytesLocales,
    required this.nombre,
    this.seed,
    this.radio = 18,
    this.colorFondo,
    this.colorTexto,
    this.conBorde = false,
  });

  @override
  Widget build(BuildContext context) {
    final base = colorFondo ?? colorParaClave(seed ?? nombre);
    final onColor =
        colorTexto ?? AppColors.legibleSobre(Colors.white, base, minimo: 3);
    final lado = radio * 2;

    return Container(
      width: lado,
      height: lado,
      decoration: BoxDecoration(
        color: base,
        shape: BoxShape.circle,
        border: conBorde
            ? Border.all(color: Theme.of(context).colorScheme.surface, width: 2)
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: _contenido(onColor, lado),
    );
  }

  Widget _contenido(Color onColor, double lado) {
    final bytes = bytesLocales;
    if (bytes != null && bytes.isNotEmpty) {
      return Image.memory(
        bytes,
        width: lado,
        height: lado,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        errorBuilder: (_, _, _) => _iniciales(onColor),
      );
    }

    final u = url;
    if (u != null && u.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: u,
        width: lado,
        height: lado,
        fit: BoxFit.cover,
        // Mientras carga se ven las iniciales, no un hueco gris.
        placeholder: (_, _) => _iniciales(onColor),
        errorWidget: (_, _, _) => _iniciales(onColor),
      );
    }

    return _iniciales(onColor);
  }

  Widget _iniciales(Color onColor) => Text(
        _calcularIniciales(nombre),
        style: TextStyle(
          color: onColor,
          fontWeight: FontWeight.bold,
          fontSize: radio * 0.8,
        ),
      );

  /// Hasta dos letras. Recorre por `runes` para no partir por la mitad un
  /// emoji o un carácter fuera del plano básico.
  static String _calcularIniciales(String nombre) {
    final partes = nombre
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (partes.isEmpty) return '?';
    String primera(String s) => String.fromCharCode(s.runes.first);
    if (partes.length == 1) return primera(partes.first).toUpperCase();
    return (primera(partes.first) + primera(partes.last)).toUpperCase();
  }
}
