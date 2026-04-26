# 🔧 Guía de Desarrollo - Glint

Información técnica detallada para desarrolladores.

## 📚 Tabla de Contenidos
1. [Setup Local](#-setup-local)
2. [Arquitectura](#-arquitectura)
3. [Gestión de Estado](#-gestión-de-estado)
4. [Base de Datos](#-base-de-datos)
5. [Autenticación](#-autenticación)
6. [Sincronización](#-sincronización)
7. [Debugging](#-debugging)

---

## 🏠 Setup Local

### Requisitos del Sistema
```bash
# Verificar versiones
flutter --version       # 3.22.0+
dart --version          # 3.4.0+
java -version           # 21+
```

### Instalación Completa
```bash
# 1. Clonar
git clone https://github.com/xJonnyxD/glint.git
cd glint

# 2. Dependencias
flutter pub get

# 3. Generar código
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Limpiar cache
flutter clean

# 5. Correr en emulador/dispositivo
flutter run
```

### Configurar Emulador
```bash
# Listar emuladores disponibles
flutter emulators

# Crear nuevo emulador (API 31+)
flutter emulators create --name pixel5

# Ejecutar
flutter emulators launch pixel5
```

---

## 🏗️ Arquitectura

### Clean Architecture

```
┌─────────────────────────────────┐
│     Presentation (UI/BLoC)      │
│  Pages, Widgets, Cubits, States │
└────────────┬────────────────────┘
             │
┌────────────▼────────────────────┐
│    Domain (Entities/UseCases)   │
│  Interfaces, Business Logic     │
└────────────┬────────────────────┘
             │
┌────────────▼────────────────────┐
│  Data (Repositories/DataSources)│
│  Local DB, Remote API           │
└─────────────────────────────────┘
```

### Flujo de Datos

```
UI (Widget)
    ↓ UserAction
Cubit (escucha cambios)
    ↓ Llamada
Repository (abstracción)
    ↓ Operación
DataSource (implementación)
    ↓ Resultado
Entity → State
    ↓ emit()
UI (actualización)
```

### Ejemplo: Crear un Hábito

```dart
// 1. Domain - Entity
class HabitEntity {
  final String id;
  final String nombre;
  final String icono;
  // ...
}

// 2. Domain - Repository Interface
abstract class HabitRepository {
  Future<void> crearHabito(HabitEntity habit);
  Stream<List<HabitEntity>> watchHabitos(String usuarioId);
}

// 3. Data - Remote DataSource
class HabitRemoteDataSource {
  Future<void> crearHabito(HabitEntity habit) async {
    await _supabase.from('habits').insert({
      'id': habit.id,
      'nombre': habit.nombre,
      // ...
    });
  }
}

// 4. Data - Repository Implementation
class HabitRepositoryImpl implements HabitRepository {
  final HabitLocalDataSource _local;
  final HabitRemoteDataSource _remote;
  
  @override
  Future<void> crearHabito(HabitEntity habit) async {
    // 1. Guardar localmente
    await _local.crearHabito(habit);
    // 2. Sincronizar remotamente (background)
    _remote.crearHabito(habit).catchError((_) {
      // Reintentar más tarde
    });
  }
}

// 5. Presentation - Cubit
class HabitCubit extends Cubit<HabitState> {
  final HabitRepository _repo;
  
  Future<void> crearHabito({required String nombre, required String icono}) async {
    final habit = HabitEntity(
      id: const Uuid().v4(),
      nombre: nombre,
      icono: icono,
      // ...
    );
    await _repo.crearHabito(habit);
  }
}

// 6. Presentation - UI
class HabitsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<HabitCubit, HabitState>(
      listener: (context, state) {
        if (state is HabitLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Hábito creado')),
          );
        }
      },
      child: BlocBuilder<HabitCubit, HabitState>(
        builder: (context, state) {
          if (state is HabitLoaded) {
            return ListView.builder(
              itemCount: state.habitos.length,
              itemBuilder: (context, index) {
                return HabitCard(habit: state.habitos[index]);
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
```

---

## 🎛️ Gestión de Estado

### BLoC vs Cubit

```dart
// Cubit (simple) - Recomendado para Glint
class HabitCubit extends Cubit<HabitState> {
  HabitCubit() : super(HabitInitial());
  
  Future<void> cargar() async {
    emit(HabitLoading());
    final habitos = await _repo.obtener();
    emit(HabitLoaded(habitos));
  }
}

// BLoC (complejo) - Usa si necesitas eventos
class HabitBloc extends Bloc<HabitEvent, HabitState> {
  HabitBloc() : super(HabitInitial()) {
    on<CargarHabitos>((event, emit) async {
      emit(HabitLoading());
      final habitos = await _repo.obtener();
      emit(HabitLoaded(habitos));
    });
  }
}
```

### Estados

```dart
abstract class HabitState {}

class HabitLoading extends HabitState {}

class HabitLoaded extends HabitState {
  final List<HabitEntity> habitos;
  HabitLoaded(this.habitos);
}

class HabitError extends HabitState {
  final String mensaje;
  HabitError(this.mensaje);
}
```

### Providers en main.dart

```dart
BlocProvider<HabitCubit>(
  create: (_) => HabitCubit(
    HabitRepository(appDatabase),
    authState.user.id,
  ),
),
```

---

## 💾 Base de Datos

### Drift (SQLite Local)

#### Crear una Tabla

```dart
// habit_table.dart
import 'package:drift/drift.dart';

class Habits extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  TextColumn get icono => text()();
  IntColumn get categoria => integer()();
  IntColumn get frecuencia => integer()();
  IntColumn get metaSemanal => integer().withDefault(const Constant(7))();
  IntColumn get completadoHoy => integer().withDefault(const Constant(0))();
  IntColumn get rachaActual => integer().withDefault(const Constant(0))();
  IntColumn get rachaMaxima => integer().withDefault(const Constant(0))();
  IntColumn get totalCompletados => integer().withDefault(const Constant(0))();
  TextColumn get color => text().withDefault(const Constant('#FF6B6B'))();
  TextColumn get usuarioId => text()();
  DateTimeColumn get creadoEn => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
  
  @override
  List<Set<Column>> get uniqueKeys => [
    {usuarioId, nombre}, // Un usuario no puede tener dos hábitos con el mismo nombre
  ];
}
```

#### Usar en Repositorio

```dart
class HabitRepository {
  final AppDatabase _db;
  
  // Crear
  Future<void> crearHabito(HabitEntity habit) async {
    await _db.into(_db.habits).insert(
      HabitsCompanion(
        id: drift.Value(habit.id),
        nombre: drift.Value(habit.nombre),
        // ...
      ),
    );
  }
  
  // Leer (Stream para reactividad)
  Stream<List<HabitEntity>> watchHabitos(String usuarioId) {
    return (_db.select(_db.habits)
          ..where((tbl) => tbl.usuarioId.equals(usuarioId)))
        .watch()
        .map((rows) => rows.map(_rowToEntity).toList());
  }
  
  // Actualizar
  Future<void> editarHabito(HabitEntity habit) async {
    await (_db.update(_db.habits)
          ..where((tbl) => tbl.id.equals(habit.id)))
        .write(HabitsCompanion(
      nombre: drift.Value(habit.nombre),
      // ...
    ));
  }
  
  // Eliminar
  Future<void> eliminarHabito(String id) async {
    await (_db.delete(_db.habits)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}
```

#### Migración de Schema

```dart
@DriftDatabase(tables: [Habits, Transactions, ...])
class AppDatabase extends _$AppDatabase {
  @override
  int get schemaVersion => 8; // Incrementar cuando cambies el schema
  
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 8) {
        // Migración a versión 8
        await m.addColumn(notes, notes.tags);
      }
    },
  );
}
```

---

## 🔐 Autenticación

### Flujo de Login

```dart
Future<void> signInWithEmail({
  required String email,
  required String password,
}) async {
  emit(AuthLoading());
  
  try {
    // 1. Autenticar con Supabase
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    
    if (response.user != null) {
      // 2. Emitir estado autenticado
      emit(AuthAuthenticated(response.user!));
      
      // 3. Iniciar sincronización de datos
      SyncManager.instance.sincronizarAlInicio(response.user!.id);
    }
  } on AuthException catch (e) {
    emit(AuthError(_traducirError(e.message)));
  }
}
```

### Persistencia de Sesión

```dart
void _checkSession() {
  final session = _supabase.auth.currentSession;
  if (session != null && session.user != null) {
    // Usuario sigue autenticado
    emit(AuthAuthenticated(session.user!));
  } else {
    emit(AuthUnauthenticated());
  }
}
```

---

## ☁️ Sincronización

### SyncManager

```dart
class SyncManager {
  static SyncManager? _instance;
  
  static void initialize({
    required SupabaseClient supabase,
    required AppDatabase db,
  }) {
    _instance = SyncManager(supabase: supabase, db: db);
  }
  
  /// Sincronizar todo al iniciar sesión
  Future<void> sincronizarAlInicio(String usuarioId) async {
    try {
      await Future.wait([
        _sincronizarHabitos(usuarioId),
        _sincronizarTransacciones(usuarioId),
        _sincronizarRutinas(usuarioId),
        // ...
      ]);
    } catch (e) {
      // No fallar la app si falla la sincronización
    }
  }
  
  /// Subir cambio específico
  Future<void> subirHabito(HabitEntity habit, String usuarioId) async {
    try {
      await _habitRemote.crearHabito(habit, usuarioId);
    } catch (e) {
      // Reintentar más tarde
      _guardarPendiente('habits', habit.toJson());
    }
  }
}
```

---

## 🐛 Debugging

### Logs Útiles

```dart
// Debug prints
print('DEBUG: Variable = $value');

// En Cubits
print('Cubit state: $state');

// Network requests
print('Request: ${_supabase}');
```

### Dev Tools

```bash
# Abre DevTools
flutter pub global activate devtools
flutter pub global run devtools

# O directamente
flutter run -d emulator-5554
# En otra terminal
dart devtools
```

### Inspeccionar Base de Datos

```bash
# Ver esquema
adb shell sqlite3 /data/data/sv.glint.app/databases/app.db ".schema"

# Exportar base de datos
adb pull /data/data/sv.glint.app/databases/app.db ~/Downloads/
```

### Hot Reload vs Hot Restart

```bash
# Hot Reload (mantiene estado)
# Presiona 'r' en la terminal

# Hot Restart (reinicia todo)
# Presiona 'R' en la terminal

# Stop
# Presiona 'q' en la terminal
```

---

## 📦 Generación de Código

### Build Runner

```bash
# Generar código (una sola vez)
flutter pub run build_runner build

# Watch mode (regenera al guardar)
flutter pub run build_runner watch

# Eliminar conflictos
flutter pub run build_runner build --delete-conflicting-outputs
```

### Archivos Generados
- `*.g.dart` - Serialización JSON (json_serializable)
- `*.freezed.dart` - Clases inmutables (freezed)
- `*.config.dart` - Inyección de dependencias (get_it)

---

## 🚀 Compilar para Production

```bash
# APK Debug (desarrollo)
flutter build apk --debug

# APK Release (producción)
flutter build apk --release

# Ver tamaño
flutter build apk --release --analyze-size

# Multiples ABIs
flutter build apk --split-per-abi
```

---

## 📊 Performance

### Optimizaciones Clave

1. **BlocSelector** en lugar de BlocBuilder
```dart
BlocSelector<HabitCubit, HabitState, List<HabitEntity>>(
  selector: (state) => state is HabitLoaded ? state.habitos : [],
  builder: (context, habitos) => ListView(children: ...),
)
```

2. **Const constructors** para widgets
```dart
const Text('Hola'); // ✅ Reutilizable
Text('Hola');       // ❌ Nueva instancia cada vez
```

3. **Lazy loading** de listas grandes
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemTile(items[index]),
)
```

---

¿Preguntas? Abre un issue o discusión en el repositorio.

**Happy coding! 🚀**
