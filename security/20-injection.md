# Glint — Auditoría de seguridad: Inyección y XSS (dominio 20)

> Alcance: `security/00-scope.md`. Solo análisis estático (Read/Grep/Glob). No se
> ejecutaron exploits ni consultas contra la BD.
> Fecha: 2026-07-27.

## Resumen ejecutivo

El dominio de **inyección y XSS está, en lo esencial, bien defendido**. El motor
de sync interpola nombres de tabla/columna que son **constantes del desarrollador**
(no datos de usuario) y los valores siempre viajan por *placeholders* `?`. El SQL
del servidor usa `format(... %I ...)` sobre **arrays literales**. El panel de admin
**escapa** con `esc()` los tres campos controlables por el usuario (`email`,
`nombre`, `plataforma`). `jsonDecode` en Dart no es un vector de deserialización
insegura.

Hallazgos por severidad: **CRÍTICO 0 · ALTO 0 · MEDIO 0 · BAJO 2** (+ 2 notas
informativas). Ningún hallazgo explotable desde internet.

---

## 1. SQL injection — motor de sync cliente (Drift/SQLite)

### 1.1 `[CONFIRMADO — SEGURO]` Interpolación de `$nombre`/`$t` en app_database.dart

`lib/shared/database/app_database.dart:100-168` construye ALTER/CREATE TRIGGER/
UPDATE con interpolación directa del nombre de tabla (`$tabla`, `$t`):

- `_agregarColumnasSync` (líneas 100-122): `ALTER TABLE $tabla ...`, `SELECT ... pragma_table_info('$tabla')`.
- `_crearInfraestructuraSync` (líneas 132-163): `CREATE TRIGGER ... ON $t`, e inserta el literal `'$t'` en la tabla de tumbas.
- `marcarSyncActivo` (línea 168): `UPDATE sync_estado SET activo = ${activo ? 1 : 0}` — interpola un `bool` a `0/1`.

**Análisis:** el único valor interpolado es `t`, que **siempre** proviene de la
constante `tablasSincronizables` (líneas 43-52): una lista fija de 8 literales
(`'transactions'`, `'budgets'`, …) escrita en el código. No hay ninguna ruta por la
que datos de un usuario alcancen esa interpolación. El `bool` de `marcarSyncActivo`
se normaliza a `0/1`. **No explotable.**

### 1.2 `[CONFIRMADO — SEGURO]` `customStatement`/`customSelect` con `$nombre` e `IN ($ph)` en generic_sync_engine.dart

`lib/shared/services/generic_sync_engine.dart`:

- `$nombre` en `SELECT/UPDATE/DELETE/INSERT` (líneas 92, 105, 154, 205, 272-273): `nombre` viene **exclusivamente** del mapa `_tablas` (líneas 29-38), otra estructura de 8 claves constantes; `sincronizarTablas` descarta cualquier nombre que no esté en el mapa (`if (tabla == null) continue`, línea 64).
- `IN ($ph)` (líneas 104-106 y 204-208): `$ph` es una tira de `?` generada con `List.filled(ids.length, '?').join(',')` — **no** interpola valores; los `ids`/`aBorrar` van como *bound parameters* (`ids` en línea 106, `aBorrar` en línea 207). El número de placeholders es un `int`. **No inyectable.**
- Nombres de columna en `_aplicarLocal` (líneas 259-275) y `_aJson` (281-297): provienen de `tabla.$columns` (metadatos del esquema Drift generado), no de datos remotos. Los valores del servidor (`remote[col.name]`) van como *bound args*. El `id` remoto se usa solo como parámetro. **No explotable.**

**Nota (defensa en profundidad):** aunque hoy es seguro porque los nombres son
constantes, el patrón de interpolar identificadores es frágil. Si en el futuro se
añade una tabla cuyo nombre derive de datos externos, se convertiría en inyección.
Recomendación: centralizar y validar los nombres contra una *allowlist* explícita
en el punto de interpolación (barato, ya casi lo son).

---

## 2. SQL injection — servidor (PL/pgSQL `format()`/`execute`)

### 2.1 `[CONFIRMADO — SEGURO]` `execute format(... %I ...)` sobre arrays literales

Todos los `execute` dinámicos del servidor corren en bloques `DO $$` **en tiempo de
despliegue** (superusuario), iterando arrays de literales escritos a mano:

- `deploy/db-init/05-sync-tables.sql:146-162`: `foreach t in array array['transactions',…]` → `format('... public.%I …', t)` para grant/RLS/policy. Usa **`%I`** (identificador citado). Los nombres son literales.
- `deploy/db-init/12-optimizacion.sql:15-25`: mismo array literal; `format('create index ... %I on public.%I ...')` con `%I`. Además envuelto en `to_regclass(...) is not null`.
- `deploy/db-init/10-realtime-personal.sql:30-32` y `06-grupos.sql:419-425`: `format('alter publication ... public.%I', t)` / `replica identity full` — `%I`, arrays literales.
- `08-amigos.sql:145-146`, `11-gamificacion.sql:55-56`, `13-admin-mejoras.sql:109-110`: `format('... public.%s ...', f)` con **`%s`** (sin citar), pero `f` recorre arrays de **firmas de función literales** (`'actualizar_xp(integer)'`, `'admin_metricas()'`, …). El `%s` aquí es correcto porque una firma con paréntesis no es un identificador simple; el valor es constante, no hay entrada de usuario.

**No hay ningún `execute`/`format` que reciba parámetros de una función RPC ni datos
de usuario.** Los RPC `SECURITY DEFINER` que sí toman parámetros (`buscar_perfil`,
`definir_admin`, `aceptar_invitacion`, `actualizar_xp`, `admin_top_xp`, …) están
escritos como SQL/PLpgSQL **estático con parámetros** (`$1`, nombres de parámetro),
sin `EXECUTE` de cadenas construidas. En PL/pgSQL eso no es inyectable. **Seguro.**

---

## 3. XSS almacenado — panel de administración (`landing/admin/index.html`)

Contexto real: un usuario registrado puede escribir su propio `nombre` y
`plataforma` (`deploy/db-init/04-seguridad-roles.sql:23` — `grant update (nombre,
plataforma) on public.profiles to authenticated`), y su `email`. Esos valores los
lee el admin vía `admin_lista_usuarios()` / `admin_top_xp()` y se pintan con
`innerHTML`. Es el vector clásico de XSS almacenado hacia el panel privilegiado.

### 3.1 `[CONFIRMADO — SEGURO]` Los campos controlables por el usuario se escapan

`esc()` (líneas 290-291) escapa `& < > " '` — cubre contexto de texto HTML y de
atributo entrecomillado. Se aplica a **todos** los sinks con datos de usuario:

- `pintarUsuarios` (líneas 430-453): `esc(u.email)`, `esc(u.nombre)`, `esc(u.plataforma)`, y el atributo `data-email="${esc(u.email)}"`. ✔
- `pintarTopXp` (líneas 402-408): `esc(f.nombre)`, `esc(f.email)`. ✔
- El resto de valores en esas plantillas son numéricos (`num()`, `?? 0`) o fechas formateadas (`fmtFecha`, `fmtRelativo`), no interpolables como HTML activo.

Se revisaron **todos** los sinks `innerHTML` del archivo (líneas 368, 388, 402, 413,
430); no hay `document.write` ni `insertAdjacentHTML`. **Un `nombre`/`email`/
`plataforma` con `<script>` o `<img onerror>` queda neutralizado.** El panel está
correctamente defendido contra XSS almacenado.

### 3.2 `[BAJO]` `pintarGrafica` interpola `f.dia`/`f.altas` en `title=""` sin `esc()`

`landing/admin/index.html:413-415`:
```js
`<div class="col" ... title="${f.dia}: ${f.altas} alta(s)"></div>`
```
`f.dia` y `f.altas` provienen de la vista `admin_altas_por_dia` (una fecha
`date_trunc` y un `count`), **generados por el servidor, no por el usuario**. Hoy no
es explotable (una fecha ISO y un entero no contienen `"` ni `<`). Es una
inconsistencia de estilo respecto al resto del archivo, no un fallo real.
**CVSS: BAJO / informativo.**
**Fix:** por consistencia, `title="${esc(f.dia)}: ${num(f.altas)} alta(s)"`.

### 3.3 `[CONFIRMADO — SEGURO]` `resumen`/`uso` interpolan solo etiquetas fijas

`pintarResumen` (368-372) y `pintarUso` (388-393) interpolan etiquetas y emojis
**hardcodeados** y valores numéricos (`num()`, anchos calculados). Sin datos de
usuario. Seguro.

### 3.4 `[CONFIRMADO — SEGURO]` Landing pública (`landing/index.html`)

Archivo **100 % estático**: no tiene `<script>`, ni sinks `innerHTML`, ni datos
dinámicos. Sin superficie de XSS.

---

## 4. Command injection / path traversal — scripts de deploy

Nota de contexto de confianza: estos scripts se ejecutan **manualmente por el
operador** en su equipo/servidor, con argumentos que él mismo elige. No están
expuestos a internet ni reciben datos de usuarios de la app. Por eso las
severidades son bajas (segundo orden), pero se documentan.

### 4.1 `[BAJO]` `crear_admin.sh` — `$EMAIL` sin sanear en SQL y JSON

`deploy/crear_admin.sh` toma `EMAIL="$1"` (línea 14) y lo interpola sin escapar:

- En JSON de curl: `-d "{\"email\":\"$EMAIL\",…}"` (línea 41, 60).
- **En SQL vía `docker exec psql`**: `where email = '$EMAIL'` (líneas 51, 78, 81, 85).

Un email como `x' or '1'='1` o `x'; update public.profiles set es_admin=true; --`
inyectaría SQL. También, al no usar `--` como terminador de opciones, un argumento
que empiece por `-` se interpretaría como *flag*. **Vector:** el operador pega/teclea
un email de origen no confiable (p. ej. copiado de un ticket). **Impacto real:**
limitado — requiere que el operador ejecute el script con entrada maliciosa; no hay
ruta desde la app. **CVSS: BAJO.**
**Fix:** pasar el email como parámetro en vez de interpolarlo:
`psql -v email="$EMAIL" ... "select ... where email = :'email'"` (o `--set`), y
construir el JSON con `jq -n --arg email "$EMAIL" '{email:$email,…}'`. Añadir `--`
antes de `"$EMAIL"` en usos de curl/psql donde aplique.

### 4.2 `[CONFIRMADO — SEGURO]` `compilar_apk_docker.sh`

`deploy/compilar_apk_docker.sh` interpola `$IMAGEN`, `$URL`, `$ANON` (líneas 17-22,
37-50) en `ssh … bash -s` y `docker run … bash -c`. Todos provienen de variables de
entorno con *defaults* o de `~/glint/.env` (grep de `ANON_KEY`) — controlados por el
operador, no por usuarios. El `ANON_KEY` es un JWT (base64url, sin metacaracteres de
shell). Sin entrada no confiable. Seguro en su modelo de amenaza.

### 4.3 `[CONFIRMADO — SEGURO]` `armar_sitio.dart`

`deploy/armar_sitio.dart`:
- `copiarDir` / `_reemplazarBloque` (líneas 20-32, 170-180): operan sobre rutas
  locales fijas (`build/web`, `landing/`) y el `substring` de rutas no recibe
  entrada externa. No hay *path traversal* de origen no confiable.
- `_copiarPanelAdmin` (137-159): `html.replaceAll('__ANON_KEY__', anon)` con
  `GLINT_ANON_KEY` (JWT). Si por error contuviera `</script>` rompería el HTML, pero
  el valor es una clave controlada, no entrada de usuario. Los bloques que sustituye
  (`$mb`, `$fecha`) derivan del tamaño/mtime del APK. Sin inyección explotable.

---

## 5. Deserialización insegura (`jsonDecode`)

### 5.1 `[CONFIRMADO — SEGURO / informativo]` `jsonDecode` en Dart no ejecuta código

`jsonDecode`/`json.decode` se usa en `lib/shared/services/backup_service.dart:74,104`,
`lib/shared/services/xp_service.dart:155` (historial XP desde `shared_preferences`) y
el campo `items_json` de las notas-checklist (`app_database.g.dart`). En Dart,
`jsonDecode` solo produce `Map`/`List`/primitivos: **no instancia tipos arbitrarios
ni ejecuta código** (a diferencia de `pickle` de Python o la deserialización nativa de
Java). No es un vector de RCE ni de *object injection*.

Riesgos residuales, **no de seguridad-crítica**:
- JSON malformado o con tipos inesperados provoca excepciones/`CastError`
  (`as Map<String, dynamic>`), a lo sumo un fallo/DoS local del propio usuario sobre
  sus propios datos. Conviene envolver en `try/catch` donde se lea contenido que pudo
  venir de otro dispositivo vía sync (defensa en robustez, no en seguridad).
- El `items_json` y demás valores, al re-sincronizarse, viajan como *bound params*
  (sección 1.2) y en Flutter se renderizan como texto (no DOM HTML), por lo que no
  hay XSS al mostrarlos. **Sin hallazgo.**

---

## Conclusión

En el dominio de **inyección y XSS** no se encontró ningún fallo explotable desde
la superficie expuesta a internet. Las dos rutas que en otros proyectos suelen ser
críticas —interpolación de identificadores en el sync SQL, y XSS almacenado del
`nombre`/`email`/`plataforma` de un usuario hacia el panel de admin— están mitigadas
correctamente (constantes del dev + `esc()` en los tres campos). Los dos hallazgos
BAJO son de segundo orden (script de operador y un `title=""` sin escapar con datos
no controlables por el usuario).
