# Glint — Auditoría de seguridad: Infraestructura / Configuración (FASE 50)

> Dominio auditado: `deploy/` (nginx, docker-compose, roles de BD, scripts) + `landing/admin/index.html`.
> Solo lectura de archivos del repo. Sin exploits en vivo. Cita `archivo:línea`.

## Resumen (5 líneas)

- Se auditaron headers de seguridad (2 nginx), CORS, rate limiting, sesión del panel admin, roles/grants de BD, exposición de red y scripts/Dockerfile.
- Hallazgo transversal: **NO existe Content-Security-Policy en ningún sitio** y el panel `/admin/` guarda la sesión (incl. `refresh_token`) en `localStorage` → un solo XSS entrega la cuenta admin.
- **NO hay rate limiting** en ninguna capa del repo (nginx ni Traefik) sobre `/auth/v1/token` → fuerza bruta de login, enumeración de usuarios y abuso de RPC.
- Modelo "todo depende de RLS" amplificado por `alter default privileges ... grant all ... to anon` y por Realtime corriendo como **superusuario postgres**.
- **Conteo por severidad: CRÍTICO 0 · ALTO 4 · MEDIO 6 · BAJO 5.**

---

## ALTO

### A-01 [CONFIRMADO] Ausencia total de Content-Security-Policy (XSS sin mitigación, robo de token admin)
- **Ubicación:** `deploy/glint-web.conf:39-42, 51-53, 75-77` (ningún `add_header Content-Security-Policy`). Panel: `landing/admin/index.html` (sin `<meta http-equiv="Content-Security-Policy">`).
- **Vector:** El servidor web añade COOP, COEP, X-Content-Type-Options y Referrer-Policy, pero **no CSP**. El panel `/admin/` almacena la sesión completa en `localStorage` (`landing/admin/index.html:268,307,545,562` — clave `glint_admin_sesion`, contiene `access_token` **y** `refresh_token`). Cualquier XSS ejecutado en el origen `glint.yanes.xyz` puede leer `localStorage` y exfiltrar el token de administrador; con el `refresh_token` el atacante mantiene la sesión más allá de la expiración de 1h.
- **Impacto:** Robo de sesión de admin → ejecución de `definir_admin` (escalada), lectura de métricas y de todos los usuarios vía RPC `admin_*`. También afecta al login público y a la app WASM. Sin CSP no hay contención de scripts inyectados ni de `connect-src`/`frame-src`.
- **Atenuante parcial:** El panel escapa la salida con `esc()` (`landing/admin/index.html:290-291`) en las tablas; reduce (no elimina) el riesgo de XSS reflejado desde datos de BD. La `anon key` en `__ANON_KEY__` es pública por diseño (no es el problema).
- **Fix (config concreta):** Añadir en `glint-web.conf`, en el bloque `server` y repetido en cada `location` (nginx no hereda headers si el location declara los suyos):
  ```nginx
  add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'wasm-unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; connect-src 'self'; frame-ancestors 'none'; base-uri 'self'; object-src 'none'; form-action 'self'" always;
  ```
  Para el panel `/admin/`, mover los estilos inline a un archivo y endurecer a `style-src 'self'` (hoy usa `<style>` inline). Nota: Flutter WASM requiere `'wasm-unsafe-eval'`; validar en `/app/`.

### A-02 [CONFIRMADO] Sin rate limiting en `/auth/v1/token` (fuerza bruta, enumeración de usuarios, abuso de RPC)
- **Ubicación:** `deploy/glint-api.conf:8-13` (location `/auth/v1/` — sin `limit_req`). Traefik: `deploy/README.md:79-103` (routers `glint-api`/`glint-web` sin `middlewares:` de rate limit). No hay `limit_req_zone` en ningún `.conf`.
- **Vector:** `GOTRUE_DISABLE_SIGNUP=false` + `GOTRUE_MAILER_AUTOCONFIRM=true` (`docker-compose.yml:45,56`) = registro abierto sin verificación. Con login `grant_type=password` sin límite de intentos, un atacante puede: (a) fuerza bruta de contraseñas, (b) enumerar usuarios por diferencia de respuestas de GoTrue, (c) abusar de la RPC `buscar_perfil` (`SECURITY DEFINER`) para raspar perfiles. GoTrue trae rate limiting propio pero no está configurado aquí (no hay `GOTRUE_RATE_LIMIT_*`).
- **Impacto:** Compromiso de cuentas por credenciales débiles; enumeración masiva de la base de usuarios; abuso de recursos.
- **Fix (config concreta):** Definir zona y aplicarla en `glint-api.conf`:
  ```nginx
  limit_req_zone $binary_remote_addr zone=auth:10m rate=5r/m;
  # dentro de location /auth/v1/ :
  limit_req zone=auth burst=10 nodelay;
  limit_req_status 429;
  ```
  y/o añadir un middleware `rateLimit` de Traefik al router `glint-api`. Definir además `GOTRUE_RATE_LIMIT_HEADER`/límites de GoTrue. **Importante:** nginx ve la IP de Cloudflare/Traefik; usar `$http_cf_connecting_ip` (o `real_ip` desde Cloudflare) como clave para no limitar por una sola IP.

### A-03 [SOSPECHA] Sin X-Frame-Options / frame-ancestors → clickjacking del login admin y de la app
- **Ubicación:** `deploy/glint-web.conf` (ningún `add_header X-Frame-Options`); `landing/admin/index.html` (sin `frame-ancestors`).
- **Vector:** Sin `X-Frame-Options: DENY` ni `Content-Security-Policy: frame-ancestors 'none'`, un sitio malicioso puede embeber `/admin/` o `/` en un iframe y superponer UI (clickjacking) para engañar a un admin y ejecutar acciones (p. ej. el botón "Hacer admin" en `landing/admin/index.html:446-457`, o el login).
- **Impacto:** Ingeniería social sobre acciones sensibles del panel; captura de credenciales de login.
- **Atenuante:** COEP `require-corp` complica algo el embebido cross-origin, pero no es una defensa de clickjacking.
- **Fix:** Añadir `add_header X-Frame-Options DENY always;` en `server` y en cada `location` de `glint-web.conf`, y `frame-ancestors 'none'` en la CSP de A-01. Como mínimo aplicarlo al `location / ` que sirve `/admin/`.

### A-04 [CONFIRMADO] Realtime se conecta a Postgres como superusuario `postgres`
- **Ubicación:** `deploy/docker-compose.yml:106-107` (`DB_USER: postgres`, `DB_PASSWORD: ${POSTGRES_PASSWORD}`).
- **Vector:** El contenedor `glint-realtime` (imagen de terceros, expuesta indirectamente vía `/realtime/v1/` en `glint-api.conf:34-44`) usa la cuenta **superusuario** de la BD, con `BYPASSRLS` implícito y control total del clúster. Contrasta con `authenticator`, que es `NOINHERIT` y sin privilegios (`db-init/01-roles.sh:18`) — el diseño correcto.
- **Impacto:** Si Realtime (o su credencial en `.env`) se ve comprometido, el atacante tiene control total de PostgreSQL, saltándose todo el modelo RLS. Aumenta el radio de explosión de cualquier CVE de la imagen `supabase/realtime:v2.30.23`.
- **Fix:** Crear un rol dedicado con solo los privilegios que Realtime necesita (replicación lógica + acceso a `_realtime` + `SELECT` sobre las tablas publicadas), en lugar de `postgres`. Como mínimo, un rol con `REPLICATION` pero sin `SUPERUSER`.

---

## MEDIO

### M-01 [CONFIRMADO] Sesión del panel admin en `localStorage` (persistencia de token robable)
- **Ubicación:** `landing/admin/index.html:268,307,545,562,531`.
- **Vector:** `access_token` + `refresh_token` en `localStorage` (accesible por cualquier JS del origen). Frente a una cookie `HttpOnly`, el token queda expuesto a robo por XSS (ver A-01). La app Flutter no usa cookies (JWT en header), pero el panel es HTML/JS plano en el mismo origen.
- **Impacto:** Amplifica A-01: el `refresh_token` permite renovar sesión (`refrescar()`, línea 297-309) indefinidamente tras el robo.
- **Fix:** No hay una solución server-side directa aquí (SPA estática contra GoTrue). Mitigar con CSP estricta (A-01), considerar guardar solo en `sessionStorage`, y — idealmente — que el panel se sirva desde un subdominio aislado (`admin.glint...`) para acotar el origen de XSS. Reducir `refresh_token` de larga vida no es trivial con GoTrue.

### M-02 [SOSPECHA] CORS potencialmente permisivo en PostgREST/GoTrue
- **Ubicación:** `deploy/docker-compose.yml:73-87` (PostgREST sin `PGRST_SERVER_CORS_ALLOWED_ORIGINS`), `docker-compose.yml:30-70` (GoTrue sin variable de CORS restrictiva). `glint-api.conf` no fija `Access-Control-Allow-Origin`.
- **Vector:** PostgREST v12 responde a peticiones CORS reflejando el `Origin` (comportamiento permisivo por defecto cuando no se configura una allow-list). Cualquier web puede hacer que el navegador de un usuario logueado emita peticiones a `/rest/v1` con sus credenciales si estas viajan en headers accesibles.
- **Impacto:** Atenuado porque la autenticación es por header `Authorization`/`apikey` (no por cookie), así que un CSRF clásico no arrastra la sesión automáticamente. Aun así conviene restringir para reducir superficie de scraping cross-origin con la anon key pública.
- **Fix:** Fijar `PGRST_SERVER_CORS_ALLOWED_ORIGINS: "https://glint.yanes.xyz"` en PostgREST y una allow-list equivalente en GoTrue, o gestionar CORS explícitamente en `glint-api.conf` (responder solo al origen propio).

### M-03 [CONFIRMADO] `alter default privileges ... grant all on tables to anon` (fallo a "inseguro por defecto")
- **Ubicación:** `deploy/db-init/02-schema.sql:57-58`; refuerzo repetido con `grant all` explícito en cada tabla (`02-schema.sql:54-55`, `06-grupos.sql:214-218`, `08-amigos.sql:27`, `09-push.sql:27`, `05-sync-tables.sql:155`, `03-admin.sql:143`).
- **Vector:** El `alter default privileges` hace que **toda tabla futura** creada en `public` reciba automáticamente `grant all` para `anon` y `authenticated`. El único freno es que se acuerde de hacer `enable row level security` en cada tabla nueva. Una tabla añadida sin RLS queda world-readable/writable por `anon` (sin sesión).
- **Impacto:** Un olvido de una sola línea (`enable row level security`) expone una tabla completa a internet. El modelo entero descansa en RLS "perfecto y sin olvidos".
- **Fix:** No conceder `all` por defecto a `anon`. Preferir grants explícitos y mínimos por tabla (`select/insert/update/delete` según corresponda) y considerar `alter default privileges ... revoke` para `anon`. Añadir un chequeo de despliegue que falle si alguna tabla de `public` no tiene RLS activado.

### M-04 [SOSPECHA] Sin HSTS (Strict-Transport-Security)
- **Ubicación:** `deploy/glint-web.conf` (ningún `Strict-Transport-Security`). TLS lo termina Cloudflare (`glint-web.conf:6`, `README.md:9`).
- **Vector:** El origen habla HTTP plano; HSTS debería emitirse en el borde. Si no está activado en Cloudflare, un usuario es susceptible a downgrade/SSL-strip en el primer contacto.
- **Impacto:** MITM/downgrade en escenarios de red hostil; MEDIO tirando a BAJO porque Cloudflare fuerza HTTPS por política habitualmente.
- **Fix:** Habilitar HSTS en Cloudflare (`max-age=31536000; includeSubDomains; preload`). Alternativamente añadir `add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;` en `glint-web.conf` (Cloudflare lo propagará). Verificar que ningún subdominio necesite HTTP.

### M-05 [CONFIRMADO] `supabase_auth_admin` es SUPERUSER
- **Ubicación:** `deploy/db-init/01-roles.sh:14-15` (`CREATE USER supabase_auth_admin SUPERUSER`).
- **Vector:** GoTrue se conecta con un rol superusuario (justificado como "crea y migra su propio schema"). Igual que A-04, si GoTrue o su credencial se compromete, control total del clúster.
- **Impacto:** Radio de explosión máximo ante compromiso de GoTrue.
- **Fix:** GoTrue solo necesita `CREATEROLE` + propiedad del schema `auth` y permisos sobre él; ejecutar migraciones con superusuario una vez y luego degradar, o usar el patrón oficial de Supabase donde `supabase_auth_admin` no es superusuario global. Riesgo aceptable si se documenta, pero conviene minimizar.

### M-06 [SOSPECHA] Router Traefik `glint-web` captura `/admin/` sin protección adicional
- **Ubicación:** `deploy/README.md:88-91` (`glint-web` regla `Host(\`glint.yanes.xyz\`)` sin PathPrefix, sirve todo lo no capturado por `glint-api`, incluido `/admin/`). `landing/admin/index.html:7` marca `noindex,nofollow` pero sigue siendo público.
- **Vector:** El panel `/admin/` es accesible por cualquiera en internet; la única barrera es el login GoTrue + verificación `es_admin` en cliente (`landing/admin/index.html:518-521`) y en `definir_admin` server-side. No hay restricción de red/IP ni WAF/rate-limit específico para `/admin/`.
- **Impacto:** Superficie de ataque del panel (login brute force por A-02, clickjacking por A-03) expuesta a todo internet. La protección real de datos es RLS/`es_admin`, correcta, pero el endpoint queda abierto.
- **Fix:** Considerar restringir `/admin/` por Cloudflare Access (autenticación en el borde), allow-list de IP, o un middleware de Traefik. Como mínimo, aplicar el rate-limit de A-02 también a `/`.

---

## BAJO

### B-01 [CONFIRMADO] Falta Permissions-Policy
- `deploy/glint-web.conf` no define `Permissions-Policy`. **Fix:** `add_header Permissions-Policy "geolocation=(), camera=(), microphone=(), payment=()" always;` para reducir superficie de features del navegador.

### B-02 [CONFIRMADO] Tramo interno en HTTP plano
- `glint-api.conf:12,22,41` fuerzan `X-Forwarded-Proto https` pero Cloudflare→Traefik→contenedores viaja HTTP (`docker-compose.yml:5`, `glint-web.conf:6`). Riesgo bajo al ir por Cloudflare Tunnel sobre localhost y red Docker interna, no por LAN física. **Fix:** aceptable con Tunnel; documentar que la BD (`internal`) nunca debe cruzar a `traefik-public`.

### B-03 [CONFIRMADO] `glint-db` sin puertos publicados (positivo) — verificar que siga así
- `docker-compose.yml:9-27`: `db` solo en red `internal`, **sin** `ports:` → 5432 no expuesto al host. Correcto. Solo `glint-api` toca `traefik-public` (`:134`); `web` toca `traefik-public` (`:145`). **Riesgo:** ninguno actual; nota de regresión: no añadir `ports: 5432:5432` nunca.

### B-04 [CONFIRMADO] Contenedores nginx corren como root (proceso maestro)
- `docker-compose.yml:126-145`: `nginx:1.27-alpine` sin `user:`. El master corre como root (workers como `nginx`). **Fix:** montar config de nginx que use `user nginx;` ya viene por defecto; considerar `read_only: true` + `cap_drop: [ALL]` en los servicios `api`/`web` para hardening.

### B-05 [CONFIRMADO] `Dockerfile.builder` se queda como `USER root` sin degradar
- `deploy/Dockerfile.builder:12-18`: cambia a `USER root` y nunca vuelve a un usuario sin privilegios; descarga un tarball por HTTPS sin verificación de checksum (`:14-16`). Impacto bajo: imagen de build ejecutada manualmente en el servidor, no expuesta. **Fix:** fijar y verificar el hash SHA-256 del tarball de Flutter y ejecutar el build con un usuario no root.

---

## Notas de verificación
- `crear_admin.sh` maneja las credenciales con cuidado: `umask 077`/`chmod 600` sobre `~/glint/.admin-credenciales` y nunca imprime la contraseña (`crear_admin.sh:92-123`). Usa `SERVICE_ROLE_KEY` desde `.env` vía red `traefik-public` (`:33-41`). Correcto; sin hallazgos.
- La escalada de privilegios vía columna `es_admin` ya fue cerrada con grants por columna y `definir_admin` (`db-init/04-seguridad-roles.sql:22-71`), que valida `es_admin()` server-side. Bien resuelto; fuera de alcance de infra.
- `authenticator` es `NOINHERIT` y sin privilegios propios (`01-roles.sh:18`) — patrón correcto (contrasta con A-04/M-05).
