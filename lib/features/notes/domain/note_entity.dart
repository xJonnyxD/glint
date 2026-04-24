// Entidad de Nota en el dominio de la app
class NoteEntity {
  final String id;
  final String titulo;
  final String contenido;
  final CategoriaNote categoria;
  final String color; // hex color e.g. "#FFEB3B"
  final bool esFijada; // pinned at top
  final bool esChecklist; // note is a checklist
  final List<ChecklistItem> items; // checklist items if esChecklist
  final String usuarioId;
  final DateTime creadaEn;
  final DateTime actualizadaEn;

  const NoteEntity({
    required this.id,
    required this.titulo,
    required this.contenido,
    required this.categoria,
    required this.color,
    required this.esFijada,
    required this.esChecklist,
    required this.items,
    required this.usuarioId,
    required this.creadaEn,
    required this.actualizadaEn,
  });

  NoteEntity copyWith({
    String? id,
    String? titulo,
    String? contenido,
    CategoriaNote? categoria,
    String? color,
    bool? esFijada,
    bool? esChecklist,
    List<ChecklistItem>? items,
    String? usuarioId,
    DateTime? creadaEn,
    DateTime? actualizadaEn,
  }) {
    return NoteEntity(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      contenido: contenido ?? this.contenido,
      categoria: categoria ?? this.categoria,
      color: color ?? this.color,
      esFijada: esFijada ?? this.esFijada,
      esChecklist: esChecklist ?? this.esChecklist,
      items: items ?? this.items,
      usuarioId: usuarioId ?? this.usuarioId,
      creadaEn: creadaEn ?? this.creadaEn,
      actualizadaEn: actualizadaEn ?? this.actualizadaEn,
    );
  }
}

// Item de una nota tipo checklist
class ChecklistItem {
  final String texto;
  final bool completado;

  const ChecklistItem({required this.texto, required this.completado});

  ChecklistItem copyWith({String? texto, bool? completado}) =>
      ChecklistItem(texto: texto ?? this.texto, completado: completado ?? this.completado);

  // Serialización para guardar en DB como JSON string
  Map<String, dynamic> toMap() => {'texto': texto, 'completado': completado};
  factory ChecklistItem.fromMap(Map<String, dynamic> m) =>
      ChecklistItem(texto: m['texto'] as String, completado: m['completado'] as bool);
}

enum CategoriaNote {
  personal,
  trabajo,
  ideas,
  recetas,
  compras,
  salud,
  otro,
}

extension CategoriaNotaX on CategoriaNote {
  String get nombre {
    switch (this) {
      case CategoriaNote.personal:
        return 'Personal';
      case CategoriaNote.trabajo:
        return 'Trabajo';
      case CategoriaNote.ideas:
        return 'Ideas';
      case CategoriaNote.recetas:
        return 'Recetas';
      case CategoriaNote.compras:
        return 'Compras';
      case CategoriaNote.salud:
        return 'Salud';
      case CategoriaNote.otro:
        return 'Otro';
    }
  }

  String get emoji {
    switch (this) {
      case CategoriaNote.personal:
        return '👤';
      case CategoriaNote.trabajo:
        return '💼';
      case CategoriaNote.ideas:
        return '💡';
      case CategoriaNote.recetas:
        return '🍳';
      case CategoriaNote.compras:
        return '🛒';
      case CategoriaNote.salud:
        return '❤️';
      case CategoriaNote.otro:
        return '📝';
    }
  }
}

// Colores disponibles para las notas (estilo Google Keep)
const List<Map<String, String>> coloresNota = [
  {'nombre': 'Amarillo', 'hex': '#FFF9C4'},
  {'nombre': 'Verde', 'hex': '#C8E6C9'},
  {'nombre': 'Azul', 'hex': '#BBDEFB'},
  {'nombre': 'Rosa', 'hex': '#F8BBD9'},
  {'nombre': 'Naranja', 'hex': '#FFE0B2'},
  {'nombre': 'Morado', 'hex': '#E1BEE7'},
  {'nombre': 'Rojo', 'hex': '#FFCDD2'},
  {'nombre': 'Cyan', 'hex': '#B2EBF2'},
  {'nombre': 'Gris', 'hex': '#F5F5F5'},
];
