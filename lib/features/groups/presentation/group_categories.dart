import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Categorías de gasto compartido: clave + etiqueta + icono.
///
/// La CLAVE sigue siendo el emoji porque es lo que se guarda en la columna
/// `categoria` de los gastos y se sincroniza con el servidor; cambiarla rompería
/// los datos existentes. El [icono] es solo la capa de UI: se pinta en lugar del
/// emoji. Para gastos ya guardados, usar [iconoDeCategoriaGasto].
class CategoriaGasto {
  final String emoji;
  final String etiqueta;
  final IconData icono;
  const CategoriaGasto(this.emoji, this.etiqueta, this.icono);
}

const List<CategoriaGasto> categoriasGasto = [
  CategoriaGasto('🧾', 'General',     Symbols.receipt_long_rounded),
  CategoriaGasto('🍽️', 'Comida',      Symbols.restaurant_rounded),
  CategoriaGasto('🛒', 'Súper',       Symbols.shopping_cart_rounded),
  CategoriaGasto('⛽', 'Gasolina',    Symbols.local_gas_station_rounded),
  CategoriaGasto('🚗', 'Transporte',  Symbols.directions_car_rounded),
  CategoriaGasto('🏠', 'Alojamiento', Symbols.home_rounded),
  CategoriaGasto('🎉', 'Fiesta',      Symbols.celebration_rounded),
  CategoriaGasto('🍺', 'Bebidas',     Symbols.local_bar_rounded),
  CategoriaGasto('🎬', 'Ocio',        Symbols.movie_rounded),
  CategoriaGasto('✈️', 'Viaje',       Symbols.flight_rounded),
  CategoriaGasto('💡', 'Servicios',   Symbols.lightbulb_rounded),
  CategoriaGasto('🛍️', 'Compras',     Symbols.shopping_bag_rounded),
  CategoriaGasto('🏥', 'Salud',       Symbols.local_hospital_rounded),
  CategoriaGasto('🎁', 'Regalos',     Symbols.card_giftcard_rounded),
];

/// Icono de la categoría guardada en un gasto (el dato es el emoji).
IconData iconoDeCategoriaGasto(String emoji) {
  for (final c in categoriasGasto) {
    if (c.emoji == emoji) return c.icono;
  }
  return Symbols.receipt_long_rounded;
}

/// Iconos elegibles al crear un grupo. La clave (emoji) es lo que se guarda en
/// la columna `emoji` del grupo; el icono es lo que se pinta.
const Map<String, IconData> iconosGrupo = {
  '👥': Symbols.group_rounded,
  '✈️': Symbols.flight_rounded,
  '🏠': Symbols.home_rounded,
  '🍽️': Symbols.restaurant_rounded,
  '🎉': Symbols.celebration_rounded,
  '❤️': Symbols.favorite_rounded,
  '🚗': Symbols.directions_car_rounded,
  '🏖️': Symbols.beach_access_rounded,
};

/// Icono del grupo a partir del emoji guardado.
IconData iconoDeGrupo(String emoji) =>
    iconosGrupo[emoji] ?? Symbols.group_rounded;
