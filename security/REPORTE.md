# Glint — Reporte consolidado de auditoría de seguridad

_Auditoría autorizada, sin ejecutar exploits contra sistemas en vivo ni contra la BD real. Basada en lectura de código (7 dominios). Detalle por dominio en `security/10-authn-authz.md`, `20-injection.md`, `30-secrets.md`, `40-deps.md`, `50-infra.md`, `60-datos.md`, `70-logica.md`._

## 1. Resumen ejecutivo

Glint es una app Flutter (web + Android) sobre un backend Supabase self-hosted (Postgres, GoTrue, PostgREST, Realtime) detrás de Cloudflare + Traefik. **No se encontró ningún fallo crítico ni forma directa de tomar el control del servidor o de todas las cuentas.** El núcleo está bien hecho: el aislamiento de datos personales por usuario (RLS) es correcto —sin fugas entre usuarios en hábitos, finanzas, notas, etc.—, la escalada a administrador está bien cerrada, las contraseñas las gestiona GoTrue (bcrypt) y no hay secretos reales en el repositorio ni en el historial de git.

Los riesgos reales se concentran en tres frentes: **(1) configuración del borde web** —faltan cabeceras de seguridad (CSP, anti-clickjacking, HSTS) y no hay límite de intentos de login, lo que abre la puerta a robo de sesión de admin vía XSS, clickjacking y fuerza bruta; **(2) la capa social/grupos** (lo más nuevo) —códigos de invitación predecibles, y reglas de negocio (XP, saldos de gastos compartidos, membresía) que el servidor acepta a ciegas del cliente, permitiendo trampas y corrupción de datos que ven otros; **(3) componentes desactualizados** —GoTrue tiene un CVE de toma de cuenta por correo. También la base de datos local del dispositivo va sin cifrar. Nada de esto compromete al servidor entero, pero varios son "parchear hoy". El plan de abajo prioriza por impacto × facilidad de explotación.

**Conteo:** 🔴 CRÍTICO 0 · 🟠 ALTO 8 · 🟡 MEDIO 14 · 🔵 BAJO 10.

## 2. Tabla de hallazgos

| ID | Sev | Archivo:línea | Descripción | Estado |
|----|-----|---------------|-------------|--------|
| SEC-01 | 🟠 ALTO | `deploy/glint-web.conf`; `landing/admin/index.html:268,307,545` | Sin **Content-Security-Policy** en ningún sitio + el panel `/admin/` guarda `access_token`+`refresh_token` en `localStorage`: cualquier XSS = robo de sesión de administrador. | CONFIRMADO · Pendiente |
| SEC-02 | 🟠 ALTO | `deploy/glint-api.conf:8-13`; Traefik | **Sin rate limiting** en `/auth/v1/token` ni RPCs → fuerza bruta de login, enumeración de usuarios, abuso de `buscar_perfil`. Agravado por signup abierto. | CONFIRMADO · Pendiente |
| SEC-03 | 🟠 ALTO | `deploy/glint-web.conf` | Sin **X-Frame-Options** / `frame-ancestors` → clickjacking del login admin y del botón "Hacer admin". | CONFIRMADO · Pendiente |
| SEC-04 | 🟠 ALTO | `deploy/docker-compose.yml:106-107` | **Realtime se conecta como superusuario `postgres`** → radio de explosión máximo si esa imagen de terceros se compromete. | CONFIRMADO · Pendiente |
| SEC-05 | 🟠 ALTO | `deploy/docker-compose.yml:31` | **GoTrue `v2.158.1`** vulnerable a envenenamiento de enlace de email (GHSA-3529-5m8x-rpv3, CVSS 7.3) → toma de cuenta vía `X-Forwarded-Host`. | CONFIRMADO · Pendiente |
| SEC-06 | 🟠 ALTO | `.../database/connection/connection_native.dart:14`, `connection_web.dart:13`; `habit_reminder_service.dart:14` | **BD local sin cifrar** (Drift/SQLite, OPFS web, Hive, shared_prefs). Finanzas/deudas/notas en claro; biometría es solo cerrojo de UI. Impacto: dispositivo perdido/rooteado, navegador compartido. | CONFIRMADO · Pendiente |
| SEC-07 | 🟠 ALTO | `.../groups/data/group_repository.dart:568-580`; `deploy/db-init/06-grupos.sql:352` | **Código de invitación a grupos predecible**: PRNG no criptográfico sembrado con `microsecondsSinceEpoch`; `aceptar_invitacion` lo canjea como bearer sin rate-limit → acceso a datos financieros de grupos ajenos. | CONFIRMADO · Pendiente |
| SEC-08 | 🟡 MEDIO | `lib/core/constants/app_constants.dart:16-24` | **Anon key + URL cloud hardcodeadas** por defecto (proyecto `glenycnniedmxwadilfd`, JWT válido ~10 años). Pública por diseño, pero apunta a un backend cloud distinto; builds sin `--dart-define` usan ese backend; no rotable sin recompilar. | CONFIRMADO · Pendiente |
| SEC-09 | 🟡 MEDIO | `deploy/db-init/11-gamificacion.sql:17-27`; `xp_service.dart:85-92` | **Falsificación de XP**: `actualizar_xp(p_xp)` fija `profiles.xp` al valor del cliente → falsea `ranking_amigos`/`admin_top_xp`. | CONFIRMADO · Pendiente |
| SEC-10 | 🟡 MEDIO | `.../habits/presentation/habit_cubit.dart:83-90` | **Farmeo de XP**: `toggleCompletar` da +10 XP en cada "completar" sin mirar si es nuevo → completar/descompletar en bucle = XP infinito. | CONFIRMADO · Pendiente |
| SEC-11 | 🟡 MEDIO | `deploy/db-init/06-grupos.sql:113-140,273-284`; `add_expense_screen.dart` | **Gastos compartidos sin validación server-side**: no hay CHECK; "partes suman el monto", monto positivo y pertenencia de miembros solo se validan en Dart → un miembro corrompe saldos ajenos con inserts directos. | CONFIRMADO · Pendiente |
| SEC-12 | 🟡 MEDIO | `deploy/db-init/06-grupos.sql:352` | `aceptar_invitacion` **ignora el `email` invitado** y admite `expira_en` nulo (invitación eterna). | CONFIRMADO · Pendiente |
| SEC-13 | 🟡 MEDIO | `deploy/docker-compose.yml` (`GOTRUE_MAILER_AUTOCONFIRM=true`, `DISABLE_SIGNUP=false`) | **Registro abierto + correo autoconfirmado** → cuentas con emails no verificados; el email es identificador de confianza en la capa social → impersonación. | CONFIRMADO · Pendiente |
| SEC-14 | 🟡 MEDIO | `deploy/db-init/06-grupos.sql:256-270` | Políticas de `grupo_miembros` permiten insertar **`user_id` arbitrario** (forced membership: meter a otro en un grupo). | CONFIRMADO · Pendiente |
| SEC-15 | 🟡 MEDIO | `deploy/docker-compose.yml` (PostgREST/GoTrue) | **CORS probablemente permisivo** (defaults) → cualquier origen puede llamar a la API con el token de la víctima. | SOSPECHA · Pendiente |
| SEC-16 | 🟡 MEDIO | `deploy/db-init/02-schema.sql:57-58` | `alter default privileges ... grant all on tables to anon` → **cualquier tabla nueva nace accesible a `anon`** si olvidas RLS (inseguro por defecto). | CONFIRMADO · Pendiente |
| SEC-17 | 🟡 MEDIO | `deploy/glint-web.conf` | **Sin HSTS** (Strict-Transport-Security). | CONFIRMADO · Pendiente |
| SEC-18 | 🟡 MEDIO | roles Postgres | `supabase_auth_admin` con `SUPERUSER` (más privilegio del necesario). | SOSPECHA · Pendiente |
| SEC-19 | 🟡 MEDIO | Traefik / Cloudflare | **`/admin/` expuesto a todo internet** sin WAF ni allowlist de IP/Cloudflare Access. | CONFIRMADO · Pendiente |
| SEC-20 | 🟡 MEDIO | `deploy/glint-api.conf` | **Tramo interno HTTP plano** (Cloudflare→Traefik→contenedores): email+password y JWT en claro dentro del host. Riesgo lateral/intra-host. | CONFIRMADO · Pendiente |
| SEC-21 | 🟡 MEDIO | `deploy/db-init/11-gamificacion.sql:31,37`; `06-grupos.sql:331` | `ranking_amigos`/`buscar_perfil` **devuelven email** innecesariamente + oráculo de existencia de cuenta. | CONFIRMADO · Pendiente |
| SEC-22 | 🟡 MEDIO | `deploy/docker-compose.yml:10` | `postgres:16-alpine` (tag flotante sin digest) + posible **CVE-2025-1094** (SQLi en `psql`, <16.7); relevante por la admin vía `docker exec psql`. | SOSPECHA · Pendiente |
| SEC-23 | 🟡 MEDIO | `deploy/docker-compose.yml:95` | `supabase/realtime:v2.30.23` desactualizado (deuda de parches en servicio expuesto por WebSocket). | SOSPECHA · Pendiente |
| SEC-24 | 🔵 BAJO | `deploy/db-init/08-amigos.sql` | `mis_amigos`/`solicitudes_amistad` también devuelven email. | CONFIRMADO · Pendiente |
| SEC-25 | 🔵 BAJO | `.../services/backup_service.dart:71`; `export_service.dart` | Backup/export vuelcan todo en claro vía `share_plus`, sin cifrar ni limpiar temporal. | CONFIRMADO · Pendiente |
| SEC-26 | 🔵 BAJO | (ausencia) | No hay **borrado de cuenta** ni política de retención (derecho al olvido / GDPR). | CONFIRMADO · Pendiente |
| SEC-27 | 🔵 BAJO | `deploy/crear_admin.sh:24` | Password de admin como argumento posicional (queda en history/`ps`) + email/password interpolados sin escapar en SQL (SQLi de operador, no de la app). | CONFIRMADO · Pendiente |
| SEC-28 | 🔵 BAJO | `deploy/db-init/08-amigos.sql` | Spam de solicitudes de amistad sin rate-limit. | CONFIRMADO · Pendiente |
| SEC-29 | 🔵 BAJO | PostgREST | Errores de escritura directa **filtran nombres de constraints/columnas**. | CONFIRMADO · Pendiente |
| SEC-30 | 🔵 BAJO | `landing/admin/index.html` (`pintarGrafica`) | `title="…"` sin `esc()` (dato no controlable por usuarios → riesgo teórico). | CONFIRMADO · Pendiente |
| SEC-31 | 🔵 BAJO | `deploy/db-init/06-grupos.sql` (`generar_codigo_amigo`) | `codigo_amigo` usa `random()` (no criptográfico). | CONFIRMADO · Pendiente |
| SEC-32 | 🔵 BAJO | `pubspec.lock:601`; imágenes | Hive `2.2.3` sin mantenimiento; tags de imagen flotantes sin digest; PostgREST `v12.2.0` dated. | CONFIRMADO · Pendiente |
| SEC-33 | 🔵 BAJO | `.github/workflows/ci.yml` | Si faltan los secrets de Actions, los artefactos se compilan con el backend cloud por defecto (SEC-08). | SOSPECHA · Pendiente |

## 3. Mapeo OWASP

### OWASP Top 10 (2021)
- **A01 Broken Access Control** → SEC-07, SEC-11, SEC-14, SEC-09/10. _(datos personales: sin fallos — RLS correcto)._
- **A02 Cryptographic Failures** → SEC-06 (reposo local), SEC-20 (tránsito interno).
- **A03 Injection** → mayormente limpio; SEC-27 (SQLi de operador, bajo).
- **A04 Insecure Design** → SEC-11, SEC-13, SEC-16.
- **A05 Security Misconfiguration** → SEC-01, SEC-03, SEC-04, SEC-15, SEC-17, SEC-18, SEC-19.
- **A06 Vulnerable & Outdated Components** → SEC-05, SEC-22, SEC-23, SEC-32.
- **A07 Identification & Auth Failures** → SEC-02, SEC-05, SEC-13.
- **A08 Software & Data Integrity** → SEC-05, SEC-33.
- **A09 Logging & Monitoring Failures** → sin logging/alerting centralizado (nota, no hallazgo puntual).
- **A10 SSRF** → N/A.

### OWASP API Security Top 10 (2023)
- **API1 BOLA** → SEC-07, SEC-14 _(tablas personales: correctas)._
- **API2 Broken Authentication** → SEC-02, SEC-05, SEC-13.
- **API3 BOPLA (property level / mass assignment)** → SEC-09 (XP), SEC-11 (partes), SEC-14 (`user_id`).
- **API4 Unrestricted Resource Consumption** → SEC-02, SEC-28.
- **API5 BFLA** → correcto (admin gateado por `es_admin()`; `definir_admin` valida).
- **API6 Unrestricted Access to Sensitive Business Flows** → SEC-07, SEC-09/10 (farmeo/trampa).
- **API3/Excessive Data Exposure** → SEC-21, SEC-24.
- **API8 Security Misconfiguration** → SEC-01/03/15/17.

## 4. Plan de remediación (priorizado por impacto × facilidad de explotación)

### 🔴 Parchear HOY (alto impacto, explotación fácil, fix rápido)
1. **SEC-05** — Subir GoTrue a **v2.185.0+** (cierra el CVE de toma de cuenta y el de OIDC de una vez). _1 línea en compose + recreate._
2. **SEC-01 + SEC-03 + SEC-17** — Añadir **CSP**, **X-Frame-Options/frame-ancestors** y **HSTS** en `glint-web.conf`. _Pocas líneas de `add_header`._
3. **SEC-02** — **Rate limiting** en `/auth/v1/token` (nginx `limit_req_zone`) + en RPCs sensibles.
4. **SEC-07** — Generar el **código de invitación en el servidor** con `gen_random_uuid()` (no PRNG del cliente) + expiración obligatoria.
5. **SEC-09** — Bloquear `actualizar_xp` de valores arbitrarios (derivar XP en servidor, o delta acotado + rate-limit). ⚠️ _Cambia contrato de RPC — te aviso antes._
6. **SEC-14** — Corregir política `insert` de `grupo_miembros` para prohibir `user_id` que no sea `auth.uid()` (salvo virtuales/creador).

### 🟡 Esta semana
7. **SEC-11** — Validación server-side de gastos: `CHECK (monto > 0)` + trigger que valide suma de partes y pertenencia. ⚠️ _Posible cambio de contrato._
8. **SEC-10** — XP solo al completar **nuevo** (usar el `bool` de `registrarCompletacion`).
9. **SEC-04 + SEC-18** — Rol de BD **dedicado y sin superusuario** para Realtime; bajar privilegios de `supabase_auth_admin`.
10. **SEC-15** — Restringir **CORS** de PostgREST/GoTrue a `https://glint.yanes.xyz`.
11. **SEC-08** — Rotar/quitar la anon key hardcodeada; hacer `--dart-define` obligatorio (fallar el build si falta).
12. **SEC-19** — Proteger `/admin/` (Cloudflare Access / allowlist de IP).
13. **SEC-21 + SEC-24** — Dejar de devolver email en `ranking_amigos`/`mis_amigos` (solo nombre + XP).
14. **SEC-12/SEC-13** — Binding de email en invitaciones; evaluar verificación de correo.

### 🟢 Deuda técnica (planificar)
- **SEC-06** — Cifrado en reposo local (SQLCipher para Drift, `HiveAesCipher`) con clave en el keystore/biometría.
- **SEC-16** — Endurecer `default privileges` (no `grant all to anon` por defecto).
- **SEC-20** — TLS/mTLS interno entre contenedores (o aceptar y documentar).
- **SEC-22/23/32** — Cadencia de actualización de imágenes + fijar por digest.
- **SEC-25** — Cifrar/expirar backups exportados; **SEC-26** — borrado de cuenta (GDPR).
- **SEC-27/29/30/31/33** — Higiene: `crear_admin.sh`, mensajes de error, `esc()` en `title`, `codigo_amigo` cripto, guardas de CI.
- **A09** — Logging/alerting centralizado (fallos de login, cambios de rol).

## 4bis. Remediación aplicada (FASE 3)

Cada fix en su commit `fix(security): SEC-XX`, con verificación (prueba
transaccional con ROLLBACK para SQL, curl/headers para infra, analyze+tests
para cliente). Desplegado en producción.

| ID | Fix | Verificación | Commit |
|----|-----|--------------|--------|
| SEC-01/03/17 | CSP + X-Frame-Options + HSTS en `glint-web.conf` | curl muestra cabeceras; panel sin violaciones CSP | `2052169` |
| SEC-09 | `actualizar_xp` solo incrementos, cap +2000/llamada | 999999999 desde 50 → 2050 | `bf502d1` |
| SEC-14 | `grupo_miembros`: solo self/virtual/amigo (helper `es_amigo`) | extraño BLOQUEADO, amigo PERMITIDO | `e9c643f` |
| SEC-07/12 | Código de invitación server-side (gen_random_uuid) + expiración; insert directo bloqueado | código aleatorio 10, expira no nulo, insert directo BLOQUEADO | `333e0ef` |
| SEC-21/11 | `ranking_amigos` sin email; CHECK monto≥0 en gastos | ranking sin email; monto negativo RECHAZADO | `ce9eef1` |
| SEC-10 | XP de hábito solo 1ª vez del día (reja prefs) | analyze limpio, 45/45 tests | `d571f10` |
| SEC-05 | GoTrue → v2.185.0 (cierra CVE toma de cuenta) | /auth/v1/health y /settings → 200 | `5bc0482` |
| SEC-02 | Rate limit 30r/min en `/auth/v1` (IP real de Cloudflare) | 40 req → 21×200 + 19×429 | `5226869` |
| SEC-15 | CORS de PostgREST restringido a nuestro origen | Origin evil.com sin ACAO; API 200 | `0a4777b` |

**Pendiente (a coordinar por riesgo / cambio de contrato):**
- **SEC-04** — Rol de BD dedicado sin superusuario para Realtime (requiere crear rol + reconfigurar el contenedor; riesgo de cortar Realtime).
- **SEC-08** — Rotar/quitar la anon key cloud por defecto en `app_constants.dart` (recompilación; producción ya usa `--dart-define`).
- **SEC-11 (resto)** — Validación transaccional de "partes suman el monto" y pertenencia de miembros (RPC → cambia el contrato del cliente `crearGasto`; te aviso antes).
- **SEC-13** — Verificación de correo (`GOTRUE_MAILER_AUTOCONFIRM`); cambia el flujo de registro.
- **SEC-19** — Proteger `/admin/` con Cloudflare Access / allowlist de IP (config en tu panel).
- **SEC-18** — Bajar privilegios de `supabase_auth_admin`.
- Deuda: cifrado en reposo local (SEC-06), TLS interno (SEC-20), borrado de cuenta (SEC-26), higiene varios (SEC-24/25/27/29/30/31/33), actualización de imágenes (SEC-22/23/32).

## 5. Lo que está bien (verificado)
- RLS de tablas personales sin IDOR/BOLA; identidad derivada de `auth.uid()`, no de parámetros.
- Escalada a `es_admin` cerrada por permisos-por-columna (`04-seguridad-roles.sql`) + `definir_admin` con guarda.
- Todas las funciones `SECURITY DEFINER` fijan `search_path`; vistas/funciones admin gateadas por `es_admin()`.
- SQLi cliente y servidor no explotables (`%I`, placeholders `?`); XSS del panel mitigado por `esc()`.
- Sin secretos reales en repo ni en git history; `.gitignore` correcto; contraseñas solo a GoTrue (bcrypt); sin PII/tokens en logs.
- `glint-db` no expone el 5432; `authenticator` `NOINHERIT`; sync sin race conditions.
