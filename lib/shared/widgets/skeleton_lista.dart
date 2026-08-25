import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Lista de esqueletos para estados de carga. Reemplaza al
/// `CircularProgressIndicator` con placeholders con forma de tarjeta, que dan
/// sensación de velocidad y de que el contenido "ya casi está".
class SkeletonLista extends StatelessWidget {
  final int items;
  const SkeletonLista({super.key, this.items = 6});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items,
        itemBuilder: (_, i) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: const ListTile(
            leading: CircleAvatar(radius: 22),
            title: Text('Elemento de la lista cargando'),
            subtitle: Text('Texto secundario de ejemplo'),
            trailing: Icon(Symbols.chevron_right_rounded),
          ),
        ),
      ),
    );
  }
}
