# Glint — Auditoría de seguridad · Dominio: Secretos y credenciales

> Fase de auditoría autorizada (ver `security/00-scope.md`). Solo lectura/estático.
> No se ejecutaron exploits contra sistemas en vivo.
> Fecha: 2026-07-27.

## Resumen ejecutivo (5 líneas)

- **CRÍTICO: 0 · ALTO: 0 · MEDIO: 1 · BAJO: 3 · INFO/buenas prácticas: 4**
- El único secreto "real" incrustado en el repo es la **anon key** por defecto en `app_constants.dart`, apuntando a un proyecto **cloud** de Supabase (`glenycnniedmxwadilfd`) — pública por diseño, pero con matices de riesgo (MEDIO).
- **No hay** `service_role`, `JWT_SECRET`, contraseñas de BD ni claves privadas en el repo, `web/`, `landing/` ni `android/`; el panel admin usa el placeholder `__ANON_KEY__` inyectado al desplegar (buena práctica).
- `.env` correctamente en `.gitignore`; **git history verificado limpio** (`git log --all -- .env` → sin resultados; ningún keystore/`google-services.json` versionado).
- Hallazgos menores (BAJO): contraseña de admin pasada como argumento CLI, sesión admin en `localStorage`, y logs con objetos de error (sin fuga de tokens confirmada).

---

## H-01 · Anon key + URL cloud hardcodeadas como valores por defecto — [CONFIRMADO] — MEDIO

**Ubicación:** `lib/core/constants/app_constants.dart:16-24`

```dart
static const String supabaseUrl = String.fromEnvironment(
  'SUPABASE_URL',
  defaultValue: 'https://glenycnniedmxwadilfd.supabase.co',   // :18
);
static const String supabaseAnonKey = String.fromEnvironment(
  'SUPABASE_ANON_KEY',
  defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3Mi...',  // :22-23
);
```

**JWT decodificado (base64url):**

| Campo   | Valor |
|---------|-------|
| header  | `{"alg":"HS256","typ":"JWT"}` |
| `iss`   | `supabase` |
| `ref`   | `glenycnniedmxwadilfd` (proyecto **cloud** `*.supabase.co`, distinto del self-hosted `glint.yanes.xyz`) |
| `role`  | `anon` |
| `iat`   | `1774972761` → **2026-03-31T15:59:21Z** |
| `exp`   | `2090548761` → **2036-03-31T03:59:21Z** (validez **~10 años**) |

Firma `HS256`: `opOPvu8LHlUhy09l_M_UpunGJdXOsdaFPFerPWTkWFs` (no verificable sin el `JWT_SECRET`; no se intenta).

**Análisis / matiz de riesgo.** Una anon key de Supabase es **pública por diseño**: siempre viaja dentro del cliente (APK/WASM) y de ella es trivial extraerla; lo que protege los datos es **RLS**. Por eso NO es "clave secreta filtrada" en sentido clásico. El riesgo real y concreto aquí es distinto:

1. **Apunta a un proyecto cloud posiblemente vivo y ajeno al stack de producción.** Producción sobreescribe con `--dart-define=SUPABASE_URL=https://glint.yanes.xyz` (README `deploy/README.md:142`, `landing/admin/index.html:248`), pero el binario compilado **sin** los `--dart-define` (p. ej. un build local, un APK de prueba, o el CI si faltan los secrets de Actions — ver abajo) pega su tráfico de `anon` contra `glenycnniedmxwadilfd.supabase.co`. Cualquiera que descompile la app y lea esta key puede hacer lo mismo: **llamar a la API de ese proyecto cloud como `anon`**.
2. **Si ese proyecto cloud tiene tablas sin RLS habilitado** (patrón muy común en proyectos Supabase abandonados/de desarrollo), hay **fuga o manipulación de datos** para cualquiera con la key → esta es la parte que eleva de INFO a MEDIO. No se puede confirmar sin tocar el proyecto vivo (fuera de alcance); queda como riesgo potencial dependiente del estado de RLS de ESE proyecto.
3. **`exp` a 10 años + no rotable sin recompilar.** Aunque se decida invalidarla, rotar una anon key incrustada exige nuevo build y redistribución; el APK antiguo seguirá presentando la key vieja hasta 2036.

**Vector:** descompilar APK / inspeccionar bundle WASM en `/app/` → extraer `defaultValue` → `curl -H "apikey: eyJ..." https://glenycnniedmxwadilfd.supabase.co/rest/v1/<tabla>`.

**Impacto:** acceso `anon` al proyecto cloud referenciado; magnitud = la de sus políticas RLS (potencial lectura/escritura si alguna tabla está sin RLS). Nulo sobre el stack self-hosted de producción (usa otra key/otro JWT_SECRET).

**Fix recomendado:**
- Eliminar el `defaultValue` real: dejar `defaultValue: ''` y hacer que la app falle rápido (assert / pantalla de error) si no se pasó `--dart-define`. Así ningún build "olvidado" apunta a un backend no deseado.
- Confirmar el estado del proyecto cloud `glenycnniedmxwadilfd`: si está vivo, verificar que **RLS esté activo en todas sus tablas** o pausar/eliminar el proyecto.
- Definir los secrets `SUPABASE_URL`/`SUPABASE_ANON_KEY` en GitHub Actions para que el CI no caiga al default (ver H-04).

---

## H-02 · Contraseña de admin como argumento posicional CLI — [CONFIRMADO] — BAJO

**Ubicación:** `deploy/crear_admin.sh:24`, uso documentado en `:4` (`./crear_admin.sh correo@ejemplo.com [contraseña]`)

El script está **bien pensado** en general: cuando genera la contraseña al azar (`openssl rand -base64 24`, `:28`) nunca la imprime, la escribe en `~/glint/.admin-credenciales` con `umask 077` + `chmod 600` (`:93-102`), y lee `SERVICE_ROLE_KEY` del `.env` (no lo hardcodea, `:21`). Buen manejo.

**Pero**, si el operador pasa la contraseña a mano como `$2`, esa contraseña queda expuesta en:
- el **historial de la shell** (`~/.bash_history`),
- la **tabla de procesos** (`ps aux` la muestra a otros usuarios del host durante la ejecución de `docker run`/`curl`).

El propio banner de `--help` invita a ese uso. Riesgo local (requiere acceso al servidor), por eso BAJO.

**Vector:** usuario local del host lee `ps`/history y recupera la contraseña del admin.
**Impacto:** compromiso de una cuenta admin (→ escalada vía panel `/admin/` y `definir_admin`).
**Fix:** eliminar el parámetro posicional de contraseña; leerla siempre por `read -s` (prompt oculto) o generarla. Documentar que no se pase por CLI.

> Nota lateral (fuera del dominio de secretos, se traslada al agente de inyección): la contraseña y el `$EMAIL` se interpolan sin escapar dentro del heredoc SQL (`crear_admin.sh:74-81`) y del JSON de `curl` (`:41`). Un email con comilla simple rompería/inyectaría SQL. Riesgo bajo por ser herramienta local del dueño, pero conviene parametrizar.

---

## H-03 · Sesión admin (incl. refresh_token) persistida en localStorage — [CONFIRMADO] — BAJO

**Ubicación:** `landing/admin/index.html:268,307,545,562` (clave `glint_admin_sesion`)

El panel guarda el objeto de sesión completo — `access_token` **y `refresh_token`** — en `localStorage` (`:307`, `:545`). Es el patrón estándar de los SPA de Supabase, pero implica que **cualquier XSS en `/admin/` roba un refresh_token de larga vida** (renovable indefinidamente vía `/auth/v1/token?grant_type=refresh_token`, `:299`), no solo un access_token de 1h.

Mitigantes presentes: el HTML escapa la salida de usuario (`esc()`, `:290`) y marca `noindex` (`:7`); no se detectó `innerHTML` con datos sin escapar. La `anon key` servida en claro en `/admin/` es aceptable (pública por diseño).

**Vector:** XSS en el panel → exfiltración de `localStorage.glint_admin_sesion`.
**Impacto:** secuestro persistente de sesión admin.
**Fix:** preferir almacenamiento en memoria o `sessionStorage`; considerar cookies `HttpOnly`/`SameSite` si GoTrue se pone tras un proxy que las emita; endurecer CSP en `glint-web.conf` (revisar en agente de headers).

---

## H-04 · CI cae al anon key/URL por defecto si faltan los secrets — [CONFIRMADO] — INFO/BAJO

**Ubicación:** `.github/workflows/ci.yml:56-60,88-92`

Los builds web y APK usan `--dart-define=SUPABASE_URL=${{ secrets.SUPABASE_URL }}` / `SUPABASE_ANON_KEY=${{ secrets.SUPABASE_ANON_KEY }}`. Si esos secrets **no están definidos** en el repo, GitHub los expande a cadena vacía y Flutter aplica el `defaultValue` de H-01 → el artefacto (`glint-web`, `glint-apk`, retención 7 días) se publica apuntando al proyecto cloud `glenycnniedmxwadilfd`. El propio comentario del workflow lo asume (`:53-55`).

**Impacto:** artefactos descargables desde Actions con backend por defecto (refuerza H-01). No expone secretos nuevos (los secrets no se imprimen).
**Fix:** definir los secrets en Settings → Secrets, o hacer el build fallar si están vacíos (ligado al fix de H-01).

---

## Verificaciones negativas (lo que se buscó y NO se encontró) — buenas prácticas

| Comprobación | Resultado |
|---|---|
| Otros JWT (`eyJ...`) en el repo | **Solo 1** (H-01). Grep en todo el árbol. [CONFIRMADO] |
| `service_role` / `SERVICE_ROLE_KEY` incrustada en `lib/`, `web/`, `landing/`, `android/` | **Ninguna**. Solo se lee de `.env` en servidor (`crear_admin.sh:21`) y de `${...}` en compose. [CONFIRMADO] |
| `JWT_SECRET`, `POSTGRES_PASSWORD`, `DB_ENC_KEY`, `SECRET_KEY_BASE` hardcodeados | **Ninguno**. `deploy/docker-compose.yml` usa exclusivamente interpolación `${VAR}` (`:16,43,50,82,85,107,110-112`); sin defaults de contraseña. [CONFIRMADO] |
| Claves privadas (`BEGIN ... PRIVATE KEY`) | **Ninguna**. [CONFIRMADO] |
| Secretos en `web/` (servido al público) y `android/` | **Ninguno** (grep de `eyJ`/`apikey`/`password`/keystore → sin coincidencias). [CONFIRMADO] |
| `.env` / keystores / `google-services.json` en git | **Nunca versionados**: `git log --all -- .env` vacío; `git ls-files` sin `.env`/`*.jks`/`*.keystore`/`google-services.json`. `.gitignore:3,52-57` los cubre. [CONFIRMADO] |
| Tokens/PII en logs (`debugPrint`/`print`/`console.log`) | **Sin fuga confirmada**: los `debugPrint` de `lib/main.dart:105`, `presence_service.dart:60`, `sync_manager.dart:185,231,237`, `generic_sync_engine.dart:50,68`, `connection_web.dart:20` imprimen solo objetos de error (`$e`) y mensajes genéricos, no tokens ni contraseñas. `auth_cubit.dart` no registra la sesión ni la contraseña. [CONFIRMADO — bajo] Nota: `debugPrint` sigue emitiendo en release; auditar que ningún `$e` de Supabase arrastre contexto sensible en el futuro. |

### Buenas prácticas destacadas
- Placeholder `__ANON_KEY__` inyectado al desplegar en vez de key hardcodeada en el panel admin (`landing/admin/index.html:268`) — correcto.
- `crear_admin.sh` no imprime contraseñas generadas y usa `chmod 600` (`:93-102,114-122`).
- `deploy/README.md:32-49` documenta generación de secretos con `openssl rand` y `chmod 600 .env`, y advierte explícitamente que **la `SERVICE_ROLE_KEY` nunca debe compilarse en la app** (`:49`).
- `docker-compose.yml` mantiene `db`/`auth`/`rest`/`realtime` en red `internal`; solo `api` y `web` tocan `traefik-public`.

---

## Tabla de hallazgos

| ID | Severidad | Estado | Ubicación | Título |
|----|-----------|--------|-----------|--------|
| H-01 | MEDIO | CONFIRMADO | `lib/core/constants/app_constants.dart:16-24` | Anon key + URL cloud como defaults incrustados |
| H-02 | BAJO | CONFIRMADO | `deploy/crear_admin.sh:24` | Contraseña admin como argumento CLI (history/ps) |
| H-03 | BAJO | CONFIRMADO | `landing/admin/index.html:307` | refresh_token de admin en localStorage (riesgo XSS) |
| H-04 | INFO/BAJO | CONFIRMADO | `.github/workflows/ci.yml:56-92` | CI cae al backend por defecto si faltan secrets |
