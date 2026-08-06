import 'package:flutter/material.dart';

/// Paleta de colores para los grupos (como los "colores de grupo" de Settle Up).
const List<String> grupoColores = [
  '#6750A4', // morado (primario de Glint)
  '#E8543F', // naranja
  '#1E88E5', // azul
  '#43A047', // verde
  '#F4511E', // teja
  '#8E24AA', // violeta
  '#00897B', // teal
  '#F9A825', // ámbar
];

/// Convierte un color hex (`#RRGGBB` o `#AARRGGBB`) a [Color]. Ante un valor
/// inválido, cae en el morado primario.
Color colorDesdeHex(String hex) {
  var h = hex.replaceAll('#', '').trim();
  if (h.length == 6) h = 'FF$h';
  final valor = int.tryParse(h, radix: 16);
  return valor == null ? const Color(0xFF6750A4) : Color(valor);
}
