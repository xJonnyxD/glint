# Glint — Alcance de la auditoría de seguridad (FASE 0)

> Repositorio: `Gint/glint/`. Auditoría autorizada por el dueño del proyecto.
> Sin ejecutar exploits contra sistemas en vivo ni contra la BD real.

## 1. Stack real

| Capa | Tecnología |
|---|---|
| Cliente | **Flutter/Dart** (SDK ^3.11.4) → APK Android + Web (WebAssembly, dart2wasm) |
| Estado / arquitectura | BLoC/Cubit, GoRouter, GetIt |
| Persistencia local | **Drift** (SQLite, en web via `sqlite3.wasm`/OPFS) + **Hive** (KV) + `shared_preferences` |
| Backend | **Supabase self-hosted**: PostgreSQL 16 (`glint-db`), **GoTrue** auth (`glint-auth` v2.158.1), **PostgREST** v12.2.0 (`glint-rest`), **Realtime** (`glint-realtime` v2.30.23) |
| Gateway | nginx (`glint-api` = /auth/v1 + /rest/v1 + /realtime/v1; `glint-web` = /, /app/, /descargas/, /admin/) |
| Borde | **Traefik** (red `traefik-public`) + **Cloudflare Tunnel** (TLS lo termina Cloudflare; el origen habla HTTP plano) |
| Infra | `docker-compose` en servidor Ubuntu (`jonny@192.168.1.9`, dominio `glint.yanes.xyz`) |
| CI/CD | GitHub Actions (`.github/workflows/ci.yml`, compila APK). Despliegue manual: `flutter build` + `armar_sitio.dart` + `rsync`/`tar` a `~/glint/web/`; SQL a mano vía `docker exec psql` |

## 2. Modelo de autenticación / autorización

- **GoTrue**: email/contraseña (`GOTRUE_MAILER_AUTOCONFIRM=true`, sin verificación de correo) + OAuth Google (flujo web de Supabase). Registro abierto (`GOTRUE_DISABLE_SIGNUP=false`).
- **JWT** HS256 firmado con `JWT_SECRET`, expiración **1h** (`GOTRUE_JWT_EXP=3600`), con refresh tokens.
- **PostgREST**: rol `anon` (sin sesión) y `authenticated`. **Todas** las tablas tienen `grant all ... to anon, authenticated` → **la única barrera es RLS** (patrón Supabase). `service_role` es `NOLOGIN BYPASSRLS`.
- **Autorización**: RLS por tabla + funciones `SECURITY DEFINER` para lógica que debe saltar RLS de forma controlada.

## 3. Puntos de entrada / bordes de confianza (superficie expuesta a internet)

Todo bajo `https://glint.yanes.xyz` (Cloudflare → Traefik → contenedor):

1. **`/auth/v1/*`** → GoTrue: `token` (login, refresh), `signup`, `recover`, etc.
2. **`/rest/v1/<tabla>`** → PostgREST CRUD sobre tablas con RLS:
   - Personales (dueño por `usuario_id`/`user_id`): `habits`, `habit_completions`, `transactions`, `budgets`, `savings_goals`, `debts`, `recurring_expenses`, `notes`, `events`, `routines`.
   - Compartidas (por membresía): `grupos`, `grupo_miembros`, `grupo_gastos`, `gasto_partes`, `grupo_invitaciones`.
   - Social/otros: `profiles`, `amistades`, `device_tokens`.
   - Vistas admin: `admin_resumen`, `admin_usuarios`, `admin_altas_por_dia` (`security_invoker`).
3. **`/rest/v1/rpc/<fn>`** → RPCs. **`SECURITY DEFINER`** (saltan RLS): `buscar_perfil`, `aceptar_invitacion`, `solicitar_amistad`, `responder_amistad`, `eliminar_amigo`, `mis_amigos`, `solicitudes_amistad`, `actualizar_xp`, `ranking_amigos`, `admin_metricas`, `admin_lista_usuarios`, `admin_top_xp`, `definir_admin`, `registrar_actividad`, `es_admin`, `es_miembro_grupo`, `es_creador_grupo`, `es_miembro_por_gasto`, `notificar_gasto_nuevo`, `crear_perfil_al_registrarse`, `asignar_codigo_amigo`, `generar_codigo_amigo`.
4. **`/realtime/v1/websocket`** → Realtime (postgres_changes, gated por RLS; tenant `realtime-dev`; Host reescrito por nginx).
5. **`/`** → web pública (landing con login que llama a GoTrue).
6. **`/app/`** → app Flutter (WASM).
7. **`/descargas/glint.apk`** → APK público.
8. **`/admin/`** → **panel de administración** (SPA estática, `landing/admin/index.html`): login GoTrue + llamadas a `admin_*` RPC y `definir_admin`. La `anon key` va incrustada (`__ANON_KEY__`).

**Bordes cliente (no directamente internet):** Drift local, `local_auth` (biometría), `awesome_notifications`, `image_picker` (recibos, aún solo local), export PDF/CSV vía `share_plus`. **Storage/uploads server-side: NO desplegado** (recibos son locales). **Push worker: NO desplegado** (existe `device_tokens` + trigger `notificar_gasto_nuevo`).

## 4. Secretos

- En servidor `~/glint/.env` (NO en repo, `.gitignore` correcto): `JWT_SECRET`, `POSTGRES_PASSWORD`, `ANON_KEY`, `SERVICE_ROLE_KEY`, `DB_ENC_KEY`, `SECRET_KEY_BASE`. Verificado: `.env`/keystores/`google-services.json` **nunca** estuvieron en git.
- **En repo**: `lib/core/constants/app_constants.dart:16-24` — `SUPABASE_URL` y `SUPABASE_ANON_KEY` **por defecto** hardcodeados apuntando a una instancia **cloud** de Supabase (`ref: glenycnniedmxwadilfd`, anon JWT `exp` 2090). Producción los sobreescribe con `--dart-define`. → revisar en agente-secrets.

## 5. Prioridad de auditoría (por superficie expuesta)

1. RLS de PostgREST + correcciones `SECURITY DEFINER` (IDOR/BOLA, escalada).
2. GoTrue (registro abierto, sin verificación de correo, rate limiting).
3. Panel `/admin/` y `definir_admin` (escalada de privilegios).
4. Realtime (fuga de datos entre usuarios).
5. Headers/CORS/CSP en nginx + Cloudflare.
6. Secreto hardcodeado + dependencias con CVEs.

## 6. Archivos clave a auditar

- **RLS/SQL**: `deploy/db-init/0[1-9]-*.sql`, `1[0-3]-*.sql`.
- **Cliente auth/sesión**: `lib/features/auth/`, `lib/core/constants/app_constants.dart`, `lib/main.dart`.
- **Repos que hablan con Supabase**: `lib/features/groups/data/group_repository.dart`, `lib/shared/services/*` (sync_manager, generic_sync_engine, presence_service, xp_service, habit_remote_data_source).
- **Panel admin**: `landing/admin/index.html`.
- **Infra**: `deploy/docker-compose.yml`, `deploy/glint-api.conf`, `deploy/glint-web.conf`, `deploy/db-init/01-roles.sh`, `deploy/crear_admin.sh`.
- **Deps**: `pubspec.yaml`, `pubspec.lock`.
