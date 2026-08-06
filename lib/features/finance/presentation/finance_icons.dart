import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:glint/features/finance/domain/transaction_entity.dart';

/// Iconos vectoriales de las categorías de finanzas (capa de UI; el dominio no
/// depende de Flutter).
///
/// Las transacciones guardan el EMOJI de la categoría en `categoriaEmoji` (y ese
/// campo se sincroniza), así que no lo cambiamos: [iconoDeCategoriaEmoji] mapea
/// el emoji guardado → icono para pintarlo. Al crear/editar se sigue guardando el
/// emoji del enum (ver [CategoriaGastoIconos.emoji]), de modo que no hay cambios
/// de esquema ni de datos.

const IconData _fallbackCategoria = Symbols.category_rounded;

IconData iconoGasto(CategoriaGasto c) {
  switch (c) {
    case CategoriaGasto.alimentacion:    return Symbols.restaurant_rounded;
    case CategoriaGasto.transporte:      return Symbols.directions_car_rounded;
    case CategoriaGasto.salud:           return Symbols.medical_services_rounded;
    case CategoriaGasto.educacion:       return Symbols.school_rounded;
    case CategoriaGasto.entretenimiento: return Symbols.sports_esports_rounded;
    case CategoriaGasto.hogar:           return Symbols.home_rounded;
    case CategoriaGasto.ropa:            return Symbols.checkroom_rounded;
    case CategoriaGasto.servicios:       return Symbols.lightbulb_rounded;
    case CategoriaGasto.ahorros:         return Symbols.savings_rounded;
    case CategoriaGasto.otro:            return Symbols.category_rounded;
  }
}

IconData iconoIngreso(CategoriaIngreso c) {
  switch (c) {
    case CategoriaIngreso.salario:   return Symbols.work_rounded;
    case CategoriaIngreso.freelance: return Symbols.laptop_mac_rounded;
    case CategoriaIngreso.negocio:   return Symbols.storefront_rounded;
    case CategoriaIngreso.inversion: return Symbols.trending_up_rounded;
    case CategoriaIngreso.regalo:    return Symbols.card_giftcard_rounded;
    case CategoriaIngreso.otro:      return Symbols.payments_rounded;
  }
}

/// Emoji guardado (dato legacy) → icono, para pintar transacciones existentes.
IconData iconoDeCategoriaEmoji(String emoji) =>
    _mapaEmojiIcono[emoji] ?? _fallbackCategoria;

const Map<String, IconData> _mapaEmojiIcono = {
  // Gastos
  '🍔': Symbols.restaurant_rounded,
  '🚗': Symbols.directions_car_rounded,
  '💊': Symbols.medical_services_rounded,
  '📚': Symbols.school_rounded,
  '🎮': Symbols.sports_esports_rounded,
  '🏠': Symbols.home_rounded,
  '👕': Symbols.checkroom_rounded,
  '💡': Symbols.lightbulb_rounded,
  '💰': Symbols.savings_rounded,
  '📦': Symbols.category_rounded,
  // Ingresos
  '💼': Symbols.work_rounded,
  '💻': Symbols.laptop_mac_rounded,
  '🏪': Symbols.storefront_rounded,
  '📈': Symbols.trending_up_rounded,
  '🎁': Symbols.card_giftcard_rounded,
  '💵': Symbols.payments_rounded,
  // Recurrentes
  '🎬': Symbols.movie_rounded,
  '🎵': Symbols.music_note_rounded,
};
