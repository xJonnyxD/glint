# Glint — Auditoría de seguridad · Dominio: Dependencias y CVEs (40-deps)

> Fecha: 2026-07-27. Alcance: `pubspec.yaml`, `pubspec.lock`, `deploy/docker-compose.yml`, `deploy/Dockerfile.builder`.
> Metodología: versiones **leídas del repo** (`[CONFIRMADO]` en cuanto a versión). Aplicabilidad de CVE marcada `[CONFIRMADO]` sólo cuando se verificó el rango afectado contra un advisory oficial; en caso contrario `[SOSPECHA]`. No se ejecutó `pub`/`flutter`/scanners.

## Resumen (conteo por severidad)

- **ALTO: 1** — GoTrue `v2.158.1` vulnerable a envenenamiento de enlace de email (GHSA-3529-5m8x-rpv3, CVSS 7.3) → subir a `v2.163.1+`.
- **MEDIO: 3** — PostgreSQL 16 tag flotante y posible CVE-2025-1094 (libpq/psql SQLi); GoTrue bypass OIDC CVE-2026-31813 (condicional a Apple/Azure, no usados); `supabase/realtime:v2.30.23` muy atrasado.
- **BAJO: 5** — Hive `2.2.3` sin mantenimiento; imágenes con tag flotante sin digest (`postgres:16-alpine`, `nginx:1.27-alpine`); SQLite nativo empaquetado (versión no verificable); Traefik `v3.3` fuera del repo; PostgREST `v12.2.0` desactualizado (sin CVE crítico conocido).
- **Estado general Dart:** la mayoría de dependencias directas están **al día** (supabase_flutter 2.12.2, drift 2.28.2, go_router 15.1.3, pdf 3.12.0, share_plus 10.1.4). El riesgo principal está en las **imágenes de contenedor fijadas a versiones antiguas** del backend Supabase, no en el cliente Flutter.

---

## Hallazgos — Imágenes de contenedor (backend)

### H-01 · GoTrue v2.158.1 — Email Link Poisoning · [CONFIRMADO] · ALTO (CVSS 7.3)
- **Ubicación:** `deploy/docker-compose.yml:31` → `image: supabase/gotrue:v2.158.1`.
- **CVE/Advisory:** GHSA-3529-5m8x-rpv3 (sin CVE asignado). Rango afectado **v2.67.1 – v2.163.0**; `v2.158.1` **está dentro del rango** (verificado contra el advisory oficial de `supabase/auth`). Parcheado en **v2.163.1**.
- **Impacto:** un atacante que manipule las cabeceras `X-Forwarded-Host` / `X-Forwarded-Proto` puede controlar la URL incrustada en los correos de autenticación (p. ej. **recuperación de contraseña**, `GOTRUE_MAILER_URLPATHS_RECOVERY=/reset` en `docker-compose.yml:67`). Al abrir el enlace, el código de seguridad se envía al servidor del atacante → **toma de cuenta**. El parche añade allowlist para `X-Forwarded-Host`.
- **Atenuante:** el envío de correos depende de SMTP (`GOTRUE_SMTP_*`, `docker-compose.yml:61-64`), que puede estar sin configurar; y detrás de Cloudflare/Traefik las cabeceras `X-Forwarded-*` deberían venir saneadas por el borde. Aun así, si Traefik/nginx reenvían la cabecera del cliente, el flujo de recuperación queda expuesto. **No** confiar en la mitigación de borde como único control.
- **Fix:** subir a `supabase/gotrue:v2.163.1` o superior (ver también H-03, que exige ≥ 2.185.0).

### H-02 · PostgreSQL `16-alpine` — tag flotante + CVE-2025-1094 (libpq/psql SQLi) · [SOSPECHA] · MEDIO
- **Ubicación:** `deploy/docker-compose.yml:10` → `image: postgres:16-alpine`.
- **Problema doble:**
  1. **Tag flotante sin digest:** `16-alpine` resuelve a la última 16.x al hacer `pull`, pero el contenedor corre `restart: unless-stopped` (`:11`), por lo que la instancia en ejecución puede quedar **rezagada** respecto al último parche si no se re-hace `pull`. No es reproducible ni auditable qué patch corre.
  2. **CVE-2025-1094** (CVSS ~8.1): inyección SQL en las funciones de escape de `libpq`/`psql`. Afecta a **todas las 16.x < 16.7**. El scope (`00-scope.md:17`) indica administración vía `docker exec psql` con SQL "a mano" → si ese SQL incorpora datos no confiables, es explotable.
- **No verificable sin ejecutar:** la versión real del binario en el contenedor no consta en el repo → `[SOSPECHA]` sobre si ya está parcheado.
- **Fix:** fijar tag a `postgres:16.7-alpine` o superior (idealmente por digest `@sha256:`) y re-`pull`.

### H-03 · GoTrue v2.158.1 — Bypass OIDC (Apple/Azure) CVE-2026-31813 · [CONFIRMADO versión] / [SOSPECHA aplicabilidad] · MEDIO (CVSS 4.8)
- **Ubicación:** `deploy/docker-compose.yml:31`.
- **CVE-2026-31813:** validación indebida de tokens OIDC cuando los proveedores **Apple o Azure** están habilitados → un atacante puede forjar tokens y secuestrar sesiones a nivel AAL1. Afecta a Auth **< 2.185.0**; `v2.158.1` está por debajo → **versión afectada**.
- **Atenuante fuerte:** el scope (`00-scope.md:21`) indica que sólo se usa **OAuth Google (flujo web de Supabase)**, no Apple ni Azure. Si esos proveedores no están configurados, **la condición de explotación no se cumple** → riesgo real bajo en la configuración actual. Se reporta porque la versión está detrás y confirma la necesidad de actualizar.
- **Fix:** subir a `supabase/gotrue:v2.185.0+` (cubre H-01 y H-03 de una vez).

### H-04 · supabase/realtime v2.30.23 — versión muy atrasada · [CONFIRMADO versión] / [SOSPECHA CVE] · MEDIO
- **Ubicación:** `deploy/docker-compose.yml:95` → `image: supabase/realtime:v2.30.23`.
- **Problema:** la rama actual de Realtime está en la serie **v2.3x–v2.4x**; `v2.30.23` acumula **decenas de releases** de correcciones (incluidas de seguridad y de fugas de datos entre tenants/canales) sin aplicar. Realtime está expuesto en `/realtime/v1/websocket` (`00-scope.md:37`) y su aislamiento depende de RLS + reescritura de Host en nginx; una regresión en versiones viejas de gating es material.
- **No verificable:** no se localizó un CVE con identificador concreto atado a `v2.30.23` sin ejecutar scanners → `[SOSPECHA]`. El riesgo es la **deuda de parches**, no un CVE puntual confirmado.
- **Fix:** actualizar a la última `supabase/realtime` estable de la serie 2.3x/2.4x tras probar la migración (`/app/bin/migrate`).

### H-05 · Imágenes con tag flotante sin fijar por digest · [CONFIRMADO] · BAJO
- **Ubicaciones:** `postgres:16-alpine` (`:10`), `nginx:1.27-alpine` (`:127` y `:138`).
- **Impacto:** `16-alpine` y `1.27-alpine` son tags móviles: la imagen puede cambiar bajo el mismo tag (bueno para parches, malo para **reproducibilidad y auditoría de supply-chain**). Positivo: **ninguna** usa `latest` (buena práctica parcial). nginx 1.27 flotante recibe parches de la rama 1.27 (p. ej. CVE-2024-7347 mp4, corregido en 1.27.1) al re-`pull`.
- **Fix:** fijar por digest `@sha256:` o al menos a patch exacto, y documentar el proceso de re-pull.

### H-06 · PostgREST v12.2.0 — desactualizado · [CONFIRMADO versión] · BAJO (informativo)
- **Ubicación:** `deploy/docker-compose.yml:74` → `image: postgrest/postgrest:v12.2.0`.
- **Nota:** existe serie 12.2.x posterior y v13. **No** se conoce CVE crítico en PostgREST 12.2.0; el riesgo es deuda de mantenimiento. Bien fijado por patch exacto.
- **Fix:** planificar subida a la última 12.2.x/13.

### H-07 · Traefik v3.3 — no presente en el repo · [SOSPECHA] · BAJO
- **Ubicación:** referenciado en `00-scope.md:15` y como red externa `traefik-public` (`docker-compose.yml:150-151`); **no** hay archivo de Traefik en el repo que fije la versión → no verificable aquí.
- **Nota:** Traefik 3.3.x ha tenido advisories (parsing de cabeceras/routing) resueltos en releases posteriores de la serie 3.3/3.4. Verificar la versión real en el servidor y mantenerla al día.
- **Fix:** confirmar versión desplegada y actualizar a la última 3.x estable.

---

## Hallazgos — Dependencias Dart/Flutter

### H-08 · Hive 2.2.3 — paquete sin mantenimiento · [CONFIRMADO] · BAJO
- **Ubicaciones:** `pubspec.yaml:32` (`hive_flutter: ^1.1.0`); `pubspec.lock:601-607` (`hive 2.2.3`), `pubspec.lock:608-615` (`hive_flutter 1.1.0`).
- **Impacto:** Hive 2.x está **efectivamente abandonado** (última release 2.2.3; el ecosistema migró a `hive_ce`/Isar). No hay CVE conocido, pero **no recibirá parches** ante fallos futuros. Se usa como KV local (`00-scope.md:12`) — riesgo acotado al dispositivo, sin superficie de red directa.
- **Fix:** evaluar migración a `hive_ce` (drop-in de la comunidad) o consolidar en Drift; a corto plazo, monitorizar.

### H-09 · SQLite nativo empaquetado (sqlite3_flutter_libs 0.5.42 / sqlite3 2.9.4) · [SOSPECHA] · BAJO
- **Ubicaciones:** `pubspec.yaml:31` (`sqlite3_flutter_libs: ^0.5.24`, resuelto **0.5.42** en `pubspec.lock:1253-1260`); `sqlite3 2.9.4` (`pubspec.lock:1245-1252`).
- **Impacto:** `sqlite3_flutter_libs` empaqueta el binario `libsqlite3` en el APK. SQLite ha tenido CVEs de corrupción de memoria (p. ej. CVE-2025-6965, corregido en 3.50.2). **No** se puede leer del lockfile qué versión exacta de la biblioteca C se empaqueta → `[SOSPECHA]`. Los datos provienen del propio usuario (BD local), así que la explotabilidad es baja.
- **Fix:** mantener `sqlite3_flutter_libs` en su última versión (empaqueta SQLite reciente) y verificar la versión de SQLite del build final.

### H-10 · awesome_notifications 0.10.1 — mantenimiento lento · [CONFIRMADO versión] · BAJO (informativo)
- **Ubicaciones:** `pubspec.yaml:64`; `pubspec.lock:92-99`.
- **Nota:** dependencia sensible (maneja intents/notificaciones en Android). Sin CVE conocido; historial de releases espaciado. Arrastra transitivamente `dart_jsonwebtoken 3.1.1` (`pubspec.lock:324-331`) — versión reciente, sin problema conocido. Mantener vigilada.

### Verificación positiva (deps directas al día)
Las siguientes dependencias sensibles a seguridad están en versiones **recientes** (sin CVE conocido pendiente):
`supabase_flutter 2.12.2` (`pubspec.lock:1317-1324`), `drift 2.28.2` (`:348-355`), `local_auth 2.3.0` (`:800-807`), `pdf 3.12.0` (`:992-999`), `share_plus 10.1.4` (`:1120-1127`), `file_picker 8.3.7` (`:404-411`), `image_picker 1.2.1` (`:664-671`), `csv 6.0.0` (`:308-315`), `crypto 3.0.7`, `pointycastle 3.9.1`, `http 1.6.0`.

---

## Recomendaciones priorizadas
1. **(ALTO)** Subir `supabase/gotrue` a **v2.185.0+** — cierra H-01 (link poisoning, 7.3) y H-03 (bypass OIDC) simultáneamente. `docker-compose.yml:31`.
2. **(MEDIO)** Fijar `postgres` a **16.7-alpine+** por digest y re-`pull` — cierra H-02. Endurecer el uso de `psql` manual con datos no confiables.
3. **(MEDIO)** Actualizar `supabase/realtime` a la última estable de la serie 2.3x/2.4x — H-04.
4. **(BAJO)** Fijar todas las imágenes por digest `@sha256:` (H-05), planificar subida de PostgREST (H-06) y confirmar/actualizar Traefik (H-07).
5. **(BAJO)** Plan de migración de Hive (H-08) y verificación de la versión de SQLite empaquetada (H-09).
