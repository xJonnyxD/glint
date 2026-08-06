# Glint

Aplicación de productividad personal que reúne hábitos, finanzas, notas, agenda,
rutinas y gastos compartidos en un solo sitio, en lugar de repartirlos entre
media docena de apps que no se hablan entre sí.

Funciona sin conexión y sincroniza cuando vuelve la red. Los datos se guardan en
el dispositivo y en un servidor propio, no en el de un tercero.

[![Flutter](https://img.shields.io/badge/Flutter-3.44-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Licencia](https://img.shields.io/badge/licencia-MIT-green)](LICENSE)

**Disponible en** [glint.yanes.xyz](https://glint.yanes.xyz) — desde el
navegador o descargando el APK de Android.

---

## Qué hace

| Módulo | Para qué sirve |
|---|---|
| **Hábitos** | Hábitos diarios o semanales, con rachas y mapa de calor del progreso |
| **Finanzas** | Ingresos y gastos por categoría, presupuestos, metas de ahorro, deudas y gastos recurrentes |
| **Agenda** | Calendario con vistas de día, semana y mes sobre una rejilla horaria, con recordatorios |
| **Notas** | Notas y listas de tareas, con etiquetas, colores y autoguardado |
| **Rutinas** | Secuencias de pasos para la mañana, la tarde o la noche |
| **Gastos compartidos** | Grupos con amigos, reparto de gastos y liquidación con los mínimos pagos |
| **Logros** | Experiencia, niveles y logros por mantener la constancia |

---

## Cómo está hecho

**Local primero.** Toda escritura va antes a una base SQLite del dispositivo y
solo después al servidor. La app funciona igual sin cobertura; lo pendiente se
sube cuando vuelve la conexión.

**Servidor propio.** PostgreSQL con seguridad a nivel de fila: cada cuenta solo
puede leer y escribir lo suyo, y eso lo garantiza la base de datos, no el
cliente. Las operaciones sensibles (puntuaciones, códigos de invitación,
membresías) se resuelven en el servidor justamente para que nadie pueda
falsearlas desde fuera.

**En vivo.** Los cambios llegan al resto de dispositivos por websocket, sin
esperar al siguiente sondeo.

### Estructura

```
lib/
├── core/          Tema, iconos, constantes, navegación
├── features/      Un módulo por área funcional
│   └── <modulo>/
│       ├── domain/         Entidades, sin dependencias de framework
│       ├── data/           Tablas y repositorios
│       └── presentation/   Pantallas, cubits y estado
└── shared/        Base de datos, sincronización, servicios y widgets comunes
```

Cada módulo sigue el mismo camino: *entidad → tabla → repositorio → cubit →
pantalla*. La gestión de estado usa `flutter_bloc`; la base local, `drift`; y las
dependencias se resuelven con `get_it`.

### Principales dependencias

| | |
|---|---|
| Estado | `flutter_bloc` |
| Base de datos local | `drift` sobre SQLite |
| Servidor | `supabase_flutter` (autoalojado) |
| Navegación | `go_router` |
| Biometría | `local_auth` |
| Notificaciones | `awesome_notifications` |

---

## Puesta en marcha

Requiere **Flutter 3.44** o superior (Dart 3.11).

```bash
git clone https://github.com/xJonnyxD/glint.git
cd glint
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

El último paso genera el código de la base de datos; sin él la compilación
falla.

Para arrancar hace falta indicar contra qué servidor va la app:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://tu-servidor \
  --dart-define=SUPABASE_ANON_KEY=tu-clave
```

Levantar tu propio servidor está documentado en [`deploy/README.md`](deploy/README.md):
un `docker compose` con PostgreSQL, autenticación, API y websockets, más las
migraciones de `deploy/db-init/`.

### Compilar

```bash
# Android
flutter build apk --release --split-per-abi \
  --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...

# Web
flutter build web --wasm --release --base-href=/app/ --no-web-resources-cdn \
  --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
```

---

## Desarrollo

```bash
flutter analyze                      # análisis estático
flutter test                         # pruebas
dart run tool/auditar_contraste.dart # contraste de la paleta (WCAG 2.1 AA)
```

Las tres deben pasar antes de dar un cambio por bueno.

La auditoría de contraste no es decorativa: comprueba que cada combinación de
texto y fondo de la paleta llega al mínimo legible, y ha cazado más de un color
que sobre el papel parecía correcto. Si cambias un color, ejecútala.

Hay más detalle en [`DEVELOPMENT.md`](DEVELOPMENT.md) y las convenciones de
contribución en [`CONTRIBUTING.md`](CONTRIBUTING.md).

---

## Privacidad

Los datos son de quien los escribe. No hay anuncios, ni rastreadores, ni venta
de datos a terceros. La instancia pública corre en un servidor doméstico; quien
prefiera el suyo tiene el stack completo en `deploy/`.

Los fallos de seguridad se reportan como se explica en [`SECURITY.md`](SECURITY.md).

---

## Licencia

MIT. Ver [`LICENSE`](LICENSE).
