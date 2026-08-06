# 🚀 Despliegue de Glint en yanessv (192.168.1.9)

El servidor ya tiene una arquitectura montada y Glint se integra en ella:

```
Internet → Cloudflare (TLS) → Cloudflare Tunnel → localhost:80 → Traefik → contenedores
```

No hay Nginx en el host ni certbot: **Cloudflare termina TLS** y Traefik reparte
por dominio usando el archivo `~/docker/traefik/dynamic.yml`. Glint sigue el
mismo patrón que los stacks `vet` y `stjacks`.

Los contenedores de Glint:

| Contenedor   | Qué hace                                              |
|--------------|-------------------------------------------------------|
| `glint-db`   | PostgreSQL 16 — los datos                             |
| `glint-auth` | GoTrue — login, registro, sesiones                    |
| `glint-rest` | PostgREST — es lo que usa `supabase_flutter`          |
| `glint-api`  | Gateway que expone `/auth/v1` y `/rest/v1`            |
| `glint-web`  | Sirve el build web de Flutter                         |

---

## 1. Copiar el stack al servidor

```bash
rsync -avz deploy/ jonny@192.168.1.9:~/glint/
```

## 2. Generar los secretos

En el servidor, dentro de `~/glint/`:

```bash
cd ~/glint
POSTGRES_PASSWORD=$(openssl rand -hex 24)
JWT_SECRET=$(openssl rand -hex 32)
printf 'POSTGRES_PASSWORD=%s\nJWT_SECRET=%s\n' "$POSTGRES_PASSWORD" "$JWT_SECRET" > .env
chmod 600 .env
```

Faltan `ANON_KEY` y `SERVICE_ROLE_KEY`: son JWT firmados con `JWT_SECRET`, con
los payloads `{"role":"anon","iss":"supabase"}` y `{"role":"service_role",...}`.
Se generan en <https://supabase.com/docs/guides/self-hosting#api-keys> pegando
el `JWT_SECRET`, o con cualquier librería JWT. Añádelos al `.env`.

> La `ANON_KEY` es pública por diseño: viaja dentro de la app. Lo que protege
> los datos es RLS. La `SERVICE_ROLE_KEY` **nunca** debe compilarse en la app.

## 3. Levantar el stack

```bash
cd ~/glint && docker compose up -d
docker compose ps
```

Cuando añadas tablas nuevas (p. ej. al aplicar `db-init/05-sync-tables.sql` a
una base ya existente), **PostgREST no las verá hasta recargar su caché de
esquema** — devuelve 404 hasta entonces:

```bash
docker exec glint-db psql -U postgres -d postgres -c "NOTIFY pgrst, 'reload schema';"
docker restart glint-rest
```

En el primer arranque, `db-init/` crea los roles de Supabase, las tablas de
Glint y las políticas RLS. Para comprobarlo:

```bash
docker exec glint-db psql -U postgres -d postgres -c '\dt public.*'
```

## 4. Publicar el dominio

Son dos archivos de infraestructura **compartida con las otras 5 apps**, así que
conviene revisarlos antes de guardar.

**a) Traefik** — añadir a `~/docker/traefik/dynamic.yml`:

```yaml
# dentro de http.routers:
    glint-api:
      rule: "Host(`glint.yanes.xyz`) && (PathPrefix(`/auth/v1`) || PathPrefix(`/rest/v1`))"
      entryPoints: [web]
      service: glint-api

    glint-web:
      rule: "Host(`glint.yanes.xyz`)"
      entryPoints: [web]
      service: glint-web

# dentro de http.services:
    glint-api:
      loadBalancer:
        servers:
          - url: "http://glint-api:80"

    glint-web:
      loadBalancer:
        servers:
          - url: "http://glint-web:80"
```

Traefik vigila el archivo y recarga solo — **un error de sintaxis tumba el
enrutado de todas las apps**, así que conviene copiar el original antes:
`cp dynamic.yml dynamic.yml.bak-glint`.

**b) Cloudflare Tunnel** — añadir a `/etc/cloudflared/config.yml` (necesita
sudo), **antes** de la línea `- service: http_status:404`:

```yaml
  - hostname: glint.yanes.xyz
    service: http://localhost:80
```

Luego `sudo systemctl restart cloudflared`. El reinicio corta brevemente
**todos** los túneles, así que mejor hacerlo en un momento tranquilo.

**c) DNS** — crear en el panel de Cloudflare un registro CNAME
`glint` → `<id-del-túnel>.cfargotunnel.com` (proxied), o desde el servidor:

```bash
cloudflared tunnel route dns 973a9cc1-2a1e-4893-a53e-1d20899ed6a4 glint.yanes.xyz
```

---

## 5. Compilar y publicar el sitio

`glint.yanes.xyz` sirve tres cosas:

| Ruta          | Qué es                                          |
|---------------|-------------------------------------------------|
| `/`           | Web pública: información, acceso y descargas    |
| `/app/`       | La app Flutter compilada a WebAssembly          |
| `/descargas/` | El APK de Android                               |

Desde tu máquina, con las claves de tu servidor:

```bash
flutter build web --wasm --release --base-href=/app/ --no-web-resources-cdn --dart-define=SUPABASE_URL=https://glint.yanes.xyz --dart-define=SUPABASE_ANON_KEY=TU_ANON_KEY
dart run deploy/armar_sitio.dart
rsync -avz --delete build/site/ jonny@192.168.1.9:~/glint/web/
```

Los tres argumentos importan:

- `--base-href=/app/` — sin esto la app busca sus assets en la raíz y no carga.
- `--no-web-resources-cdn` — empaqueta CanvasKit y skwasm en el propio servidor
  en vez de descargarlos de `gstatic.com` en cada visita.
- `armar_sitio.dart` — junta la landing con la app en `build/site/`, y si
  todavía no hay APK compilado cambia el botón de descarga por un aviso de
  "Próximamente" para que nunca lleve a un 404.

El contenedor `glint-web` monta esa carpeta como solo lectura, así que el
despliegue se ve al instante — no hace falta reiniciar nada.

El build genera `main.dart.wasm` y también un `main.dart.js` de respaldo: los
navegadores sin WebAssembly con GC caen automáticamente al segundo.

## 6. APK de Android

Requiere el SDK de Android y JDK 17 instalados (y aceptar las licencias de
Google del SDK). Una vez listos:

```bash
flutter build apk --release --dart-define=SUPABASE_URL=https://glint.yanes.xyz --dart-define=SUPABASE_ANON_KEY=TU_ANON_KEY
dart run deploy/armar_sitio.dart
rsync -avz --delete build/site/ jonny@192.168.1.9:~/glint/web/
```

`armar_sitio.dart` detecta el APK, lo copia a `/descargas/glint.apk` y activa
el botón de descarga en la web con su tamaño.

La alternativa sin instalar nada en local es el workflow de GitHub Actions
(`.github/workflows/ci.yml`), que ya compila el APK en cada push y lo deja como
artefacto descargable.

**iOS** necesita un Mac con Xcode para compilarse y una cuenta de Apple
Developer para distribuirse; por eso la web lo anuncia como "Próximamente" y
sugiere añadir la versión web a la pantalla de inicio desde Safari.

---

## 7. Recuperación de contraseña (SMTP)

El "olvidé mi contraseña" de la app llama a GoTrue, que necesita un servidor
SMTP para enviar el correo. El `docker-compose.yml` ya lee los datos SMTP de
`~/glint/.env`; solo falta rellenarlos con tu proveedor de correo.

Con **Resend** (que ya usas en otro stack) es lo más rápido: crea una API key
en <https://resend.com> y añade a `~/glint/.env`:

```bash
SMTP_HOST=smtp.resend.com
SMTP_PORT=587
SMTP_USER=resend
SMTP_PASS=re_tu_api_key_de_resend
SMTP_FROM=noreply@tudominio.com
```

(El dominio del `SMTP_FROM` debe estar verificado en Resend.) Luego:

```bash
cd ~/glint && docker compose up -d auth
```

Eso recrea solo el contenedor de auth (un par de segundos de corte en el
login). Mientras `SMTP_PASS` esté vacío, el registro y el login funcionan
igual; solo la recuperación no envía nada.

Para comprobarlo, en la app toca "¿Olvidaste tu contraseña?" con tu correo y
mira si llega el email (revisa spam la primera vez).

---

## ⚠️ Caché: por qué nada va marcado como `immutable`

Flutter **no pone hash de contenido** en los nombres de sus archivos: cada build
vuelve a generar `main.dart.wasm`, `flutter_bootstrap.js`, `flutter.js`, etc.
con el mismo nombre. Marcarlos `immutable` deja a los usuarios clavados para
siempre en la primera versión que cargaron — los despliegues no les llegan.

Por eso todo va con `Cache-Control: no-cache`, que no significa "no guardar"
sino "revalidar antes de usar": el navegador conserva el archivo y recibe un
304 mientras no cambie.

**Y Cloudflare lo cachea también.** Si alguna vez se sirve un archivo con
`immutable`, el borde de Cloudflare lo retiene según ese `max-age` (hasta un
año) y cambiar la cabecera en el origen no lo desaloja. Hay que purgar:

- Panel de Cloudflare → **Caching → Configuration → Purge Cache**, purgando la
  URL concreta o todo el dominio.
- Conviene además poner **Browser Cache TTL** en *Respect Existing Headers*,
  para que el `no-cache` del origen llegue de verdad al navegador en lugar de
  ser sustituido por el TTL por defecto de Cloudflare (4 horas).

Para comprobar qué está sirviendo el borde:

```bash
curl -sS -D- -o /dev/null https://glint.yanes.xyz/app/flutter_bootstrap.js | grep -iE 'cf-cache-status|age|cache-control'
```

`cf-cache-status: DYNAMIC` o `MISS` es lo esperado; un `HIT` con `Age` alto en
un archivo que acabas de desplegar significa que hay que purgar.

## Comprobaciones

**Que la API responde:**

```bash
curl -s -o /dev/null -w '%{http_code}\n' https://glint.yanes.xyz/auth/v1/health
curl -s -H "apikey: TU_ANON_KEY" https://glint.yanes.xyz/rest/v1/habits
```

Sin sesión iniciada, `/rest/v1/habits` debe devolver `[]` — no los datos de
otros usuarios. Si devuelve filas ajenas, RLS no está activo.

**Que las cabeceras COOP/COEP llegan:** abre la consola del navegador en
`https://glint.yanes.xyz` y ejecuta `crossOriginIsolated`. Debe dar `true`.
De eso depende que Drift guarde la base local en OPFS (rápido) en lugar de
IndexedDB, y también el renderer de WebAssembly.

Si da `false`, revisa que Cloudflare no esté reescribiendo las cabeceras
(desactiva Rocket Loader y la minificación automática para ese dominio).

## Probar el build de producción en local

```bash
dart run deploy/serve_local.dart 8092
```

Sirve `build/web/` con las mismas cabeceras que el contenedor `glint-web`.

## Actualizar `sqlite3.wasm` y `drift_worker.js`

Están versionados en `web/` y deben coincidir con las versiones de `pubspec.lock`.
Si actualizas `drift` o `sqlite3`:

```bash
curl -L -o web/sqlite3.wasm https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-2.9.4/sqlite3.wasm
curl -L -o web/drift_worker.js https://github.com/simolus3/drift/releases/download/drift-2.28.2/drift_worker.js
```
