# Changelog - Glint

Todos los cambios notables en Glint se documentan en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/),
y este proyecto sigue [Versionado Semántico](https://semver.org/lang/es/).

## [0.1.6] - 2026-07-25

Ronda de auditoría profesional del código (dos auditorías: contraste/UI y
correctitud de sync). Se arreglaron los hallazgos de mayor impacto.

### 🐛 Arreglado (crítico)
- **Base de datos rota en la web** (mostraba todo vacío y crasheaba al guardar
  notas con "duplicate column name"). Causa: la migración v9→v10 usaba
  `addColumn` con un default no-constante, que SQLite rechaza en `ALTER TABLE`;
  si fallaba a media migración la base quedaba inconsistente. Ahora se añade
  cada columna con SQL crudo y default constante, y solo si falta — así las
  bases dañadas **se reparan solas** al abrir.
- **Pérdida de datos en el sync**: si el servidor devolvía una lista vacía (por
  ejemplo tras una sesión caducada), el motor interpretaba que todo se había
  borrado en el servidor y **eliminaba los datos locales del módulo**. Ahora
  nunca se infieren borrados a partir de una respuesta vacía.
- **Texto invisible en tema oscuro** al escribir notas: los campos del editor
  (título, contenido, etiquetas) y las tarjetas heredaban texto blanco sobre el
  fondo pastel claro de la nota. Ahora usan texto oscuro fijo.

### 🐛 Arreglado
- El "hecho hoy" de un hábito ya no desaparece cuando llega un sync (se conserva
  el estado local del día en vez de sobrescribirlo con el remoto).
- Al romperse la racha de un hábito, el nuevo valor ahora sí sube al servidor.
- Un fallo puntual en una tabla ya no bloquea la sincronización de las demás.
- Colores de las tarjetas de herramientas de finanzas ahora se adaptan al tema.
- El miércoles ya no sale como "X" (abreviaturas Lu, Ma, Mi, Ju, Vi, Sá, Do).

### ⚠️ Conocidos (para la próxima ronda)
- Borrado y duplicados de completaciones de hábitos entre dispositivos, y
  algunos casos límite de edición concurrente, siguen pendientes de endurecer.

## [0.1.5] - 2026-07-24

### 🐛 Arreglado (crítico)
- **Los datos de la web no aparecían en el móvil aunque se sincronizaran.** El
  motor bajaba los datos del servidor y los guardaba en la base local con SQL
  crudo, pero eso NO avisa a los `.watch()` que observan las pantallas, así que
  la UI no se refrescaba hasta reiniciar la app. Ahora se notifica el cambio de
  tabla tras cada bajada (verificado con un test sobre una base real).
- **El miércoles salía "X"** en la agenda y en el mapa de calor. "X" es la
  abreviatura de España para miércoles; en El Salvador se lee como un error.
  Cambiado a abreviaturas de dos letras (Lu, Ma, Mi, Ju, Vi, Sá, Do).

### ✨ Agregado
- **Copia de seguridad completa manual** (Ajustes → Copia de seguridad):
  "Hacer copia de seguridad" vuelca TODOS tus datos a un archivo que puedes
  guardar donde quieras (Drive, correo…), y "Restaurar copia" los recupera.
  A diferencia de la exportación CSV, esta copia es restaurable de verdad
  (probado con un round-trip exportar→borrar→restaurar).

## [0.1.4] - 2026-07-23

### 💅 Presentación y tamaño
- **Pantalla de carga con marca en web**: mientras baja el WebAssembly (~11 MB),
  el usuario veía una pantalla en blanco varios segundos. Ahora ve el logo de
  Glint con un spinner (tema claro/oscuro), que se retira con un fundido cuando
  la app ya está pintada.
- **Splash nativo en el APK** (flutter_native_splash): fondo de marca y logo al
  arrancar, en vez del blanco genérico de Flutter.
- **APK ~3× más pequeño**: compilado con `--split-per-abi`, la descarga
  principal (arm64-v8a, para teléfonos modernos) pesa ~25 MB en lugar de 72.

### ⚡ Sincronización
- **Arreglado que no sincronizara al abrir la app con sesión guardada**: el
  sync solo arrancaba tras un login explícito, no al restaurar la sesión (el
  caso normal). Se centralizó en el cambio de estado de auth, así que ahora
  cubre login, registro, sesión restaurada y refresco de token.
- Intervalo de sondeo bajado de 3 min a 20 s, y sincronización inmediata al
  traer la app a primer plano. No es tiempo real de websocket, pero pasar del
  teléfono a la web se siente casi instantáneo.

### 🛠️ Operación
- Copias de seguridad diarias de la base de datos y la config, integradas en el
  sistema de backups del servidor (retención de 7 días).
- Caché del borde de Cloudflare sorteada versionando el bootstrap en cada
  despliegue, para que nunca sirva una versión vieja.
- Recuperación de contraseña por SMTP cableada en la config (falta la
  credencial del proveedor de correo).

## [0.1.3] - 2026-07-22

### ✨ Agregado
- **Sincronización extendida a finanzas, notas, agenda y rutinas** (8 tablas:
  transacciones, presupuestos, metas de ahorro, deudas, gastos recurrentes,
  notas, eventos y rutinas). Antes solo los hábitos viajaban a la nube; ahora
  todo lo demás también, con la misma cola offline, resolución de conflictos
  por última escritura y borrados propagados por tumbas.
- **Motor de sync genérico**: en lugar de duplicar la lógica por tabla, un solo
  motor sincroniza cualquier tabla a partir de los metadatos de sus columnas.
  Las tablas remotas espejan los nombres locales, así que no hay traducción.
- **Triggers de SQLite** que marcan las filas como pendientes al cambiarlas y
  dejan tumbas al borrarlas, automáticamente. Así el sync no obligó a tocar los
  ~30 métodos de escritura repartidos por los módulos. Se suprimen mientras el
  motor aplica datos remotos, para que no reboten (verificado con tests sobre
  una base de datos real).
- **Sync periódico** cada 3 minutos, además del disparo inmediato de hábitos,
  para que los cambios de los otros módulos suban sin depender de sus pantallas.
- **Borrado entre dispositivos**: una fila ya sincronizada que desaparece del
  servidor se borra también en el dispositivo.

### 🗃️ Base de datos
- Esquema local Drift v9 → v10: columnas de sync en las 8 tablas, tabla
  `sync_estado` y triggers. Migración aditiva.
- 8 tablas nuevas en Supabase con RLS por usuario.

## [0.1.2] - 2026-07-22

### ✨ Agregado
- **Sincronización bidireccional de hábitos con Supabase.** Antes la subida no
  ocurría en absoluto: los métodos existían pero nadie los llamaba, así que un
  hábito creado en el teléfono nunca salía del dispositivo. Ahora cada cambio
  (crear, editar, completar, borrar) se sube, y al iniciar sesión se baja lo
  que haya en el servidor.
  - **Cola offline**: cada fila con cambios locales se marca `pendienteSync`;
    si no hay red, se reintenta en la siguiente sincronización sin perder nada.
  - **Resolución de conflictos** por última escritura (`actualizadoEn`), aislada
    en una función pura y cubierta por tests.
  - **Borrados que viajan**: una tabla de tumbas (`syncTombstones`) permite
    aplicar el DELETE en el servidor; sin ella, borrar en un dispositivo no
    borraba en el otro.
- **Panel de administración** en `/admin/`: usuarios en línea, activos hoy y
  esta semana, altas, hábitos y completados, con listado de usuarios y gestión
  de roles.
- **Seguimiento de presencia**: la app manda un latido al abrirse y cada 2
  minutos, para que el panel sepa quién está conectado.

### 🔐 Seguridad
- **Cerrada una escalada de privilegios** en `profiles`: la política RLS
  permitía a cualquier usuario editar su propia fila incluyendo la columna
  `es_admin`, es decir, ascenderse a administrador con un PATCH. RLS controla
  filas, no columnas; se añadieron permisos por columna y una función
  `definir_admin` que valida quién llama. Verificado con la prueba que lo
  destapó.

### 🗃️ Base de datos
- Esquema local Drift v8 → v9: columnas `actualizadoEn` y `pendienteSync` en
  hábitos y completaciones, y tabla `syncTombstones`. Migración aditiva; los
  hábitos existentes se marcan como pendientes para subirse por primera vez.

## [0.1.1] - 2026-07-21

### 🐛 Arreglado
- **Rachas de hábitos**: la racha ya no se calcula sumando y restando a ciegas.
  Ahora se recalcula desde el historial de completaciones, así que **fallar un
  día sí la rompe**, y el día en curso no la penaliza hasta que termine. Los
  hábitos semanales cuentan semanas consecutivas que cumplen la meta.
- **Cambio de día**: al abrir la app se desmarca `completadoHoy` y se ajustan
  las rachas según el historial real. Antes un hábito podía quedar marcado
  como completado indefinidamente.
- **XP y logros compartidos entre cuentas**: el progreso se guardaba de forma
  global en el dispositivo, así que una segunda cuenta heredaba el XP de la
  primera. Ahora se guarda por usuario, migrando automáticamente el progreso
  existente a la primera cuenta que inicie sesión.
- **Base de datos web volátil**: se usaba almacenamiento en memoria y los datos
  se perdían al recargar. Ahora usa `WasmDatabase` sobre OPFS/IndexedDB.
- Directorios `assets/images/` y `assets/animations/` declarados en
  `pubspec.yaml` pero inexistentes.

### ✨ Agregado
- Soporte para **web**: las notificaciones y la biometría, que no existen en el
  navegador, ahora se omiten en lugar de romper el arranque.
- **Configuración por `--dart-define`** de `SUPABASE_URL` y `SUPABASE_ANON_KEY`,
  para apuntar a un backend propio sin tocar código.
- **Guía de despliegue** (`deploy/`) con el esquema SQL de la base de datos con
  RLS, configuración de Nginx e instrucciones para el servidor Ubuntu.
- **CI en GitHub Actions**: análisis, tests y compilación de web y APK.
- **Tests** de la lógica de rachas y del XP por usuario (15 casos).

### ⚡ Rendimiento
- **La web ahora compila a WebAssembly** (`flutter build web --wasm`). Lo
  impedía la importación condicional de la conexión a la base de datos, que
  usaba `dart.library.html` — una condición que no existe en dart2wasm y que
  hacía que el build arrastrara la implementación nativa con `dart:ffi`.
- **15 dependencias sin usar eliminadas** (45 paquetes en total contando las
  transitivas): `flutter_secure_storage`, `google_sign_in`, `sign_in_with_apple`,
  `sqflite`, `encrypt`, `injectable`, `freezed`, `json_serializable`,
  `googleapis`, `rxdart`, `lottie`, `cached_network_image`, `device_info_plus`,
  `package_info_plus` y sus generadores. Ninguna se importaba en `lib/`, y
  varias bloqueaban la compilación a WebAssembly.
- La conexión a la base de datos se abre en paralelo con el arranque de la UI,
  de modo que la primera consulta tras iniciar sesión no paga el costo de
  abrir SQLite (ni de descargar el WASM en web).
- Nginx sirve `sqlite3.wasm` y los assets con caché inmutable, y envía las
  cabeceras COOP/COEP que permiten a Drift usar OPFS en vez de IndexedDB.

### 🐛 Arreglado (adicional)
- `totalCompletados` se inflaba al marcar y desmarcar un hábito repetidamente:
  el contador subía pero nunca bajaba. Ahora solo cambia cuando la completación
  realmente se registra o se elimina.

---

## [0.1.0] - 2026-04-26

### ✨ Agregado
- 🔐 Autenticación con email/contraseña
- 🔐 Autenticación con Google OAuth
- 📋 Sistema completo de hábitos con racha y estadísticas
- 💰 Gestión de finanzas (ingresos, gastos, transacciones)
- 💰 Presupuestos por categoría
- 💰 Metas de ahorro
- 💰 Gestión de deudas
- 💰 Gastos recurrentes
- 📝 Notas con colores y etiquetas
- 📅 Calendario con eventos
- 🔄 Rutinas (mañana, tarde, noche)
- 🎮 Sistema de XP y niveles
- 🎮 Logros desbloqueables
- 💾 Base de datos local con Drift (SQLite)
- 🌓 Soporte para modo oscuro/claro
- 🌍 Localización en español (El Salvador)
- 📱 Interfaz responsiva

### 🔧 Técnico
- Flutter 3.22 + Dart 3.4
- Arquitetura Clean con BLoC/Cubit
- Drift ORM para persistencia local
- Supabase Auth para autenticación
- GetIt para inyección de dependencias
- Go Router para navegación

### 📝 Documentación
- README.md detallado
- CONTRIBUTING.md para contribuyentes
- DEVELOPMENT.md para desarrolladores
- GitHub Issue & PR templates
- Inline code documentation

---

## Plan de Futuro

### 🚧 Próximas Versiones

#### v0.2.0 - Sincronización Cloud (En progreso)
- [ ] Sincronización de hábitos con Supabase
- [ ] Sincronización de transacciones
- [ ] Sincronización de notas
- [ ] Sincronización de eventos
- [ ] Sincronización de rutinas
- [ ] Resolución de conflictos
- [ ] Indicadores de estado de sync

#### v0.3.0 - Gamificación Completa
- [ ] Completar sistema de logros
- [ ] Leaderboards
- [ ] Desafíos semanales
- [ ] Badges especiales
- [ ] Historial de XP

#### v0.4.0 - Mejoras de UI/UX
- [ ] Animaciones pulidas
- [ ] Transiciones mejoradas
- [ ] Gestos y haptics
- [ ] Temas personalizables
- [ ] Widgets personalizados

#### v0.5.0 - Analytics y Reportes
- [ ] Reportes detallados
- [ ] Gráficos de progreso
- [ ] Exportación de datos (CSV, PDF)
- [ ] Análisis de patrones
- [ ] Predicciones

#### v1.0.0 - Release Público
- [ ] Play Store
- [ ] App Store
- [ ] Sitio web
- [ ] Documentación pública

---

## Convenciones de Commits

Usamos emojis para categorizar commits:

- 🎨 `:art:` - Cambios en estilos/UI
- ⚡ `:zap:` - Mejoras de performance
- 🔧 `:wrench:` - Cambios en configuración
- 📚 `:books:` - Documentación
- ✨ `:sparkles:` - Nueva característica
- 🐛 `:bug:` - Arreglo de bug
- 🔐 `:lock:` - Seguridad
- ♻️ `:recycle:` - Refactoring
- 📱 `:iphone:` - Cambios de mobile
- 🧪 `:test_tube:` - Tests
- 🚀 `:rocket:` - Deployment

### Ejemplo
```
✨ feat: agregar sistema de XP en hábitos
🐛 fix: error al sincronizar datos
📚 docs: actualizar guía de contribución
```

---

## Versionado

- **MAJOR**: Cambios incompatibles (breaking changes)
- **MINOR**: Nuevas características compatibles
- **PATCH**: Arreglos de bugs

Formato: `v{MAJOR}.{MINOR}.{PATCH}`

---

Última actualización: **26 de Abril, 2026**
