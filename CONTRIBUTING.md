# 🤝 Guía de Contribución a Glint

¡Gracias por tu interés en contribuir a Glint! Este documento te guiará en el proceso.

## 📋 Código de Conducta

Sé respetuoso y constructivo. Queremos una comunidad acogedora para todos.

## 🚀 Cómo Contribuir

### Reportar Bugs 🐛

1. **Verifica si el bug ya existe** en [Issues](https://github.com/xJonnyxD/glint/issues)
2. **Abre un nuevo Issue** con:
   - Título descriptivo
   - Descripción detallada
   - Pasos para reproducir
   - Resultado esperado vs actual
   - Screenshots/videos si aplica
   - Información del sistema (Flutter version, dispositivo, etc.)

### Sugerir Mejoras 💡

1. **Abre un Issue** con la etiqueta `enhancement`
2. **Describe** qué quieres cambiar y por qué
3. **Proporciona ejemplos** si es posible

### Enviar Pull Requests 📤

#### Antes de Empezar
```bash
# 1. Fork el repositorio
# 2. Clona tu fork
git clone https://github.com/tu-usuario/glint.git
cd glint

# 3. Crea una rama descriptiva
git checkout -b feature/nueva-caracteristica
# o
git checkout -b fix/descripcion-bug
```

#### Durante el Desarrollo
```bash
# Mantén tu rama actualizada
git fetch origin
git rebase origin/master

# Genera código si necesario
flutter pub run build_runner build

# Corre análisis
flutter analyze

# Prueba tu código
flutter test
```

#### Antes de hacer Push
- ✅ El código compila sin errores
- ✅ `flutter analyze` pasa
- ✅ Tests pasan (si aplica)
- ✅ Seguiste las convenciones de código
- ✅ Commits tienen mensajes claros

#### Enviar el PR
```bash
git push origin feature/nueva-caracteristica
```

**En GitHub:**
1. Crea el Pull Request
2. Completa el template de PR
3. Espera revisión

## 📝 Estándares de Código

### Convenciones Dart/Flutter
```dart
// ✅ Bueno
class UserProfile extends StatelessWidget {
  final String userName;
  
  const UserProfile({required this.userName});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(userName),
    );
  }
}

// ❌ Malo
class userProfile extends StatelessWidget {
  final String name;
  
  userProfile({required this.name});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text(name));
  }
}
```

### Estructura de Archivos
```
features/hábitos/
├── domain/
│   ├── entities/habit_entity.dart
│   └── repositories/habit_repository.dart
├── data/
│   ├── datasources/habit_local_data_source.dart
│   ├── models/habit_model.dart
│   └── repositories/habit_repository_impl.dart
└── presentation/
    ├── cubit/habit_cubit.dart
    ├── pages/habits_page.dart
    └── widgets/habit_card.dart
```

### Nombres Significativos
- Variables: `camelCase` (ej: `userName`, `totalAmount`)
- Clases: `PascalCase` (ej: `UserProfile`, `HabitRepository`)
- Funciones: `camelCase` (ej: `getUserData()`)
- Constantes: `SCREAMING_SNAKE_CASE` (ej: `MAX_RETRIES`)

### Documentación
```dart
/// Calcula el total de gastos para una categoría.
/// 
/// Parámetros:
/// - [categoryId]: ID de la categoría
/// - [month]: Mes a calcular (1-12)
/// 
/// Retorna: Total de gastos en la categoría
double calculateCategoryTotal(String categoryId, int month) {
  // implementación
}
```

## 🧪 Testing

### Ejecutar Tests
```bash
# Todos los tests
flutter test

# Un archivo específico
flutter test test/features/habits/habit_cubit_test.dart

# Con cobertura
flutter test --coverage
```

### Escribir Tests
```dart
void main() {
  group('HabitCubit', () {
    late HabitCubit habitCubit;
    late MockHabitRepository mockRepository;
    
    setUp(() {
      mockRepository = MockHabitRepository();
      habitCubit = HabitCubit(mockRepository, 'user123');
    });
    
    test('emits HabitLoaded cuando se cargan hábitos', () async {
      // arrange
      final habits = [HabitEntity(...)];
      when(mockRepository.watchHabitos('user123'))
          .thenAnswer((_) => Stream.value(habits));
      
      // act & assert
      expect(habitCubit.stream, emits(HabitLoaded(habits)));
    });
  });
}
```

## 🔄 Proceso de Revisión

1. **Revisión de Código** - Un mantenedor revisa tu PR
2. **Cambios Solicitados** - Si hay feedback, actualiza tu PR
3. **Aprobación** - Tu PR es aprobado
4. **Merge** - Tu código se integra a master

## 🎯 Áreas Prioritarias

Estos son los áreas donde podemos usar ayuda:

- [ ] 🎮 Completar Gamificación
- [ ] ☁️ Mejorar Sync con Supabase
- [ ] 🧪 Aumentar cobertura de tests
- [ ] 📱 Optimizar rendimiento
- [ ] 🌍 Internacionalización (i18n)
- [ ] 🎨 Mejorar UI/UX

## ❓ Preguntas?

- 📖 Lee la [documentación](README.md)
- 🔍 Busca issues similares
- 💬 Abre una discusión

---

**Gracias por contribuir a Glint! ✨**
