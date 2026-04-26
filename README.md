# ✨ Glint - Tu Gestor Personal Inteligente

> Una aplicación móvil Flutter todo-en-uno para gestionar tu vida: hábitos, finanzas, tareas, notas y más.

![Flutter](https://img.shields.io/badge/Flutter-3.22-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.4-blue?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)
![Status](https://img.shields.io/badge/Status-MVP-yellow)

---

## 📋 Tabla de Contenidos

- [Características](#-características)
- [Instalación](#-instalación)
- [Arquitectura](#-arquitectura)
- [Tecnologías](#-tecnologías)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Guía de Desarrollo](#-guía-de-desarrollo)
- [Contribuciones](#-contribuciones)
- [Licencia](#-licencia)

---

## 💡 Características

### 🎯 Hábitos
- Crear y rastrear hábitos diarios/semanales/mensuales
- Visualizar rachas y progreso
- Recordatorios automáticos
- Estadísticas detalladas

### 💰 Finanzas
- Registrar ingresos y gastos
- Categorizar transacciones
- Presupuestos por categoría
- Metas de ahorro
- Gestión de deudas
- Gastos recurrentes

### 📝 Notas
- Crear notas con colores personalizados
- Fijar notas importantes
- Etiquetas y categorías
- Búsqueda rápida

### 📅 Agenda
- Calendario de eventos
- Recordatorios
- Eventos todo el día
- Sincronización con Supabase

### 🔄 Rutinas
- Crear rutinas matutinas/vespertinas/nocturnas
- Rastrear completitud
- Notificaciones automáticas

### 🎮 Gamificación
- Sistema de XP y niveles
- Logros desbloqueables
- Ranking personal

---

## 🚀 Instalación

### Requisitos Previos
```bash
✓ Flutter 3.22+
✓ Dart 3.4+
✓ Android SDK (API 31+) / iOS 12+
✓ Java JDK 21+
```

### Pasos de Instalación

1. **Clonar el repositorio**
```bash
git clone https://github.com/xJonnyxD/glint.git
cd glint
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Generar código (Drift, Freezed)**
```bash
flutter pub run build_runner build
```

4. **Configurar Supabase** (opcional, solo para sync)
```bash
# Copia las credenciales en lib/core/constants/app_constants.dart
SUPABASE_URL=tu_url
SUPABASE_ANON_KEY=tu_key
```

5. **Ejecutar en dispositivo/emulador**
```bash
flutter run
```

---

## 🏗️ Arquitectura

```
Clean Architecture + BLoC Pattern + Repository Pattern
```

### Capas

```
lib/
├── features/          # Características (Hábitos, Finanzas, etc.)
│   ├── domain/        # Entidades y casos de uso
│   ├── data/          # Repositorios y fuentes de datos
│   └── presentation/  # UI, Cubits, Estados
├── shared/            # Componentes compartidos
│   ├── database/      # Drift (SQLite local)
│   ├── services/      # Servicios (Auth, Sync, etc.)
│   ├── widgets/       # Widgets reutilizables
│   └── theme/         # Temas y estilos
├── core/              # Configuración global
│   ├── constants/     # Constantes
│   ├── theme/         # Tema de la app
│   └── extensions/    # Extensiones
└── main.dart          # Punto de entrada
```

---

## 🛠️ Tecnologías

### Frontend
- **Flutter** - Framework de UI
- **Dart** - Lenguaje de programación
- **BLoC/Cubit** - Gestión de estado
- **Go Router** - Navegación

### Backend & Persistencia
- **Supabase** - Auth + Base de datos remota
- **Drift** - ORM local (SQLite)
- **Hive** - Almacenamiento clave-valor

### Herramientas
- **Build Runner** - Generación de código
- **Freezed** - Inmutabilidad
- **GetIt** - Inyección de dependencias
- **Awesome Notifications** - Notificaciones

---

## 📂 Estructura del Proyecto

```
glint/
├── android/                      # Código nativo Android
├── ios/                          # Código nativo iOS
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   ├── extensions/
│   │   └── theme/
│   ├── features/
│   │   ├── agenda/
│   │   ├── auth/
│   │   ├── finance/
│   │   ├── gamification/
│   │   ├── habits/
│   │   ├── notes/
│   │   └── routines/
│   ├── shared/
│   │   ├── database/
│   │   ├── di/
│   │   ├── services/
│   │   ├── widgets/
│   │   └── theme/
│   └── main.dart
├── test/                         # Pruebas
├── pubspec.yaml                  # Dependencias
└── README.md
```

---

## 🔧 Guía de Desarrollo

### Agregar una Nueva Característica

1. **Crear estructura de carpetas**
```bash
lib/features/mi_feature/
├── domain/
│   ├── entities/
│   └── repositories/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
└── presentation/
    ├── cubit/
    ├── pages/
    └── widgets/
```

2. **Implementar con Clean Architecture**
   - Entity → Model → Repository → Cubit → UI

3. **Generar código**
```bash
flutter pub run build_runner build
```

### Comandos Útiles

```bash
# Análisis estático
flutter analyze

# Compilar APK
flutter build apk --debug

# Compilar para release
flutter build apk --release

# Limpiar todo
flutter clean

# Actualizar dependencias
flutter pub upgrade
```

---

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Para cambios grandes:

1. Fork el repositorio
2. Crea una rama (`git checkout -b feature/AmazingFeature`)
3. Commit los cambios (`git commit -m 'Add AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

### Estándares de Código
- Sigue las convenciones de Dart
- Mantén 80+ de cobertura de tests
- Usa nombres descriptivos
- Documenta funciones públicas

---

## 📊 Estado del Proyecto

| Módulo | Completitud | Estado |
|--------|-------------|--------|
| 🔐 Autenticación | 75% | ✅ Funcional |
| 📋 Hábitos | 85% | ✅ Funcional |
| 💰 Finanzas | 80% | ✅ Funcional |
| 📝 Notas | 80% | ✅ Funcional |
| 📅 Agenda | 70% | 🔄 Mejorando |
| 🔄 Rutinas | 75% | ✅ Funcional |
| 🎮 Gamificación | 35% | 🚧 En desarrollo |
| ☁️ Sync Supabase | 30% | 🚧 En desarrollo |

---

## 📱 Requisitos

- **Android**: API 31+ (Android 12)
- **iOS**: 12.0+
- **Almacenamiento**: ~50MB
- **RAM**: 2GB mínimo recomendado

---

## 🐛 Reporte de Bugs

Encuentra un bug? Por favor abre un [Issue](https://github.com/xJonnyxD/glint/issues) describiendo:
- Qué pasó
- Pasos para reproducir
- Resultado esperado
- Screenshots si es posible

---

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver [LICENSE](LICENSE) para más detalles.

---

## 👤 Autor

**Jonny Quintanilla**
- GitHub: [@xJonnyxD](https://github.com/xJonnyxD)
- Email: jaqyanes@gmail.com

---

## 🙏 Agradecimientos

- Flutter & Dart team por las herramientas increíbles
- Supabase por el backend gratuito
- La comunidad de Flutter

---

**Made with ❤️ in El Salvador**
