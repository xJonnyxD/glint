# Glint — Auditoría de seguridad · Dominio: Protección de datos / PII / Cifrado (FASE 6)

> Alcance leído: `security/00-scope.md`. Sin modificar código ni ejecutar exploits.
> Método: revisión estática (Read/Grep/Glob) del cliente Flutter y de `deploy/`.

## Resumen (5 líneas)

- Se auditaron cifrado en tránsito (tramo interno), cifrado en reposo (cliente y servidor), hashing de contraseñas, PII en logs, exposición de PII entre usuarios y backups/retención.
- **Lo que está bien**: la contraseña NUNCA se hashea ni se almacena en el código — solo se entrega a GoTrue (bcrypt); no hay PII (email/tokens/montos) en logs; `profiles` está bien protegido por RLS y las búsquedas de perfil están acotadas.
- **Hallazgos**: 0 CRÍTICO · 1 ALTO · 3 MEDIO · 3 BAJO.
- El riesgo dominante es el **cifrado en reposo del cliente**: Drift/SQLite, Hive y `shared_preferences` guardan finanzas, deudas, notas y montos **en claro**; la biometría es solo un cerrojo de UI.
- Riesgos secundarios: JWT/credenciales viajan en HTTP plano en el tramo interno, `ranking_amigos` filtra emails innecesariamente, backups/exportaciones salen sin cifrar y no existe borrado de cuenta.

---

## Conteo por severidad

| Severidad | Nº |
|---|---|
| CRÍTICO | 0 |
| ALTO | 1 |
| MEDIO | 3 |
| BAJO | 3 |

---

## Hallazgos

### [D-01] ALTO — Base de datos local del cliente sin cifrar (Drift/SQLite + Hive + SharedPreferences) [CONFIRMADO]

**Evidencia**
- `lib/shared/database/connection/connection_native.dart:14` — `NativeDatabase(file, logStatements: false)` abre el SQLite **sin clave** (no hay SQLCipher / `setup`/`PRAGMA key`).
- `lib/shared/database/connection/connection_web.dart:13-17` — `WasmDatabase.open(...)` persiste en **OPFS/IndexedDB sin cifrado**.
- `lib/features/habits/data/habit_reminder_service.dart:14-15` — `Hive.openBox(_boxName)` sin `encryptionCipher` (`HiveAesCipher`). `lib/main.dart:76` `Hive.initFlutter()` sin cifrado.
- `lib/shared/services/biometric_service.dart:26-44` — `local_auth` solo decide si se muestra una pantalla; **no deriva ninguna clave ni cifra nada**. La preferencia se guarda en `shared_preferences` en claro (`glint_biometric_enabled`).

**Datos expuestos**: en las tablas Drift (`app_database.dart:18-30`) viven `transactions`, `budgets`, `debts`, `savings_goals`, `recurring_expenses`, `notes`, `events`, `habits` — es decir montos, ingresos/gastos, deudas, metas de ahorro y notas personales, todo en texto plano.

**Vector / impacto**
- **Android**: dispositivo rooteado, backup ADB del sandbox de la app, o extracción del `.db` desde `getApplicationDocumentsDirectory()` → lectura total de las finanzas del usuario. El bloqueo biométrico se salta simplemente accediendo al archivo, no a la UI.
- **Web (`/app/`)**: cualquiera con acceso al perfil del navegador o al almacén OPFS/IndexedDB del origen `glint.yanes.xyz` lee la BD sin autenticarse. Máquina compartida/kiosco = fuga.
- CVSS orientativo: **ALTO** por la sensibilidad (datos financieros) aunque requiere acceso físico/local al dispositivo.

**Fix**
- Drift nativo: cifrar con SQLCipher (`sqlcipher_flutter_libs` + `NativeDatabase`/`PRAGMA key`), con la clave guardada en `flutter_secure_storage` (Keystore/Keychain) y desbloqueada por biometría real.
- Hive: `Hive.openBox(name, encryptionCipher: HiveAesCipher(clave))` con la clave en almacenamiento seguro.
- Ligar la biometría a la derivación/desbloqueo de la clave, no solo a mostrar la pantalla.
- Web: el cifrado en reposo del navegador es limitado; minimizar qué datos sensibles se persisten en OPFS o aceptar el riesgo documentándolo.

---

### [D-02] MEDIO — Tramo interno en HTTP plano: JWT y credenciales sin TLS entre borde y contenedores [CONFIRMADO]

**Evidencia**
- `deploy/docker-compose.yml:5` (comentario) — «Cloudflare termina TLS y enruta glint.yanes.xyz -> localhost:80 -> Traefik».
- `deploy/glint-api.conf:4` — `listen 80;` y `proxy_pass http://auth:9999/` (`:9`), `proxy_pass http://rest:3000/` (`:18`), `proxy_pass http://realtime:4000/socket/` (`:35`): todo **HTTP/WS plano**.
- El `X-Forwarded-Proto https` que se fija (`glint-api.conf:12,22,41`) es solo una cabecera informativa; **no cifra** el transporte.

**Qué viaja en claro en ese tramo**: el `POST /auth/v1/token` lleva **email + contraseña** en el cuerpo; el resto de PostgREST/Realtime lleva el **JWT** (`Authorization: Bearer`) y la `apikey`. Todo en claro entre `cloudflared` → Traefik → nginx → GoTrue/PostgREST/Realtime.

**Vector / impacto**
- El tramo Cloudflare↔origen sí está protegido por el túnel de Cloudflare (cloudflared abre una conexión saliente cifrada), así que **no** hay exposición directa a internet.
- El riesgo real es **intra-host / movimiento lateral**: un contenedor comprometido en la misma red Docker (`glint-internal`/`traefik-public`), o alguien con acceso a la LAN `192.168.1.9` / al host, puede esnifar credenciales y JWTs y suplantar sesiones. Con `GOTRUE_JWT_EXP=3600` un JWT robado sirve hasta 1 h (más el refresh token).
- Severidad **MEDIO**: depende de que el modelo de confianza sea «un solo host de confianza». Si el host aloja otros servicios/tenants, sube.

**Fix**
- Si el host es de confianza y single-tenant, es un riesgo aceptable → **documentarlo** explícitamente.
- Endurecimiento: segregar la red Docker para que solo `api`/`web` toquen `traefik-public`; considerar mTLS o TLS interno si conviven otros tenants; restringir el acceso de red al host.

---

### [D-03] MEDIO — `ranking_amigos()` filtra el email de los amigos sin necesidad [CONFIRMADO]

**Evidencia**
- `deploy/db-init/11-gamificacion.sql:30-48` — `ranking_amigos()` devuelve `(id, nombre, email, xp, es_yo)`. El ranking (gamificación) solo necesita **nombre + xp**; el `email` es PII innecesaria que se envía al cliente de cada amigo.

**Vector / impacto**: cualquier usuario autenticado que llame a la RPC (o inspeccione la respuesta de red del ranking) obtiene los correos de todos sus amigos aceptados, aunque la UI no los muestre. Minimización de datos incumplida. **MEDIO** por ser exposición sistemática de PII entre usuarios normales vía `SECURITY DEFINER` (salta RLS).

**Fix**: quitar `email` de la firma y del `select` de `ranking_amigos()` (la UI de ranking no lo usa).

---

### [D-04] MEDIO — `buscar_perfil()` permite enumeración de cuentas y devuelve email [CONFIRMADO]

**Evidencia**
- `deploy/db-init/06-grupos.sql:331-347` — `buscar_perfil(p_texto)` (`SECURITY DEFINER`) busca por **email exacto** o **código de amigo** y devuelve `(id, nombre, email, codigo_amigo, avatar_url)`.

**Vector / impacto**
- Como responde solo con coincidencia exacta de email, funciona como **oráculo de existencia de cuenta**: un autenticado puede confirmar si `victima@dominio.com` está registrada en Glint (y obtener su nombre y avatar). Combinado con registro abierto + `GOTRUE_MAILER_AUTOCONFIRM=true` (scope §2), facilita enumeración dirigida.
- Devolver el `email` en el resultado es redundante cuando la búsqueda fue por email (el llamante ya lo tiene) y expone el correo cuando la búsqueda fue por código.
- Severidad **MEDIO**: es la vía prevista para invitar, pero filtra existencia + PII a cualquier autenticado. Está bien acotada (`limit 5`, coincidencia exacta, `revoke ... from anon`).

**Fix**: al buscar por código de amigo, no devolver el email (basta id/nombre/avatar). Considerar rate-limiting de la RPC para dificultar el barrido de correos. Aceptar el trade-off documentándolo si la usabilidad manda.

---

### [D-05] BAJO — `mis_amigos()` y `solicitudes_amistad()` devuelven email de otros usuarios [CONFIRMADO]

**Evidencia**
- `deploy/db-init/08-amigos.sql:104-119` (`mis_amigos`) y `:122-135` (`solicitudes_amistad`) devuelven `email` de los perfiles ajenos (amigos aceptados / solicitantes).

**Vector / impacto**: PII (correo) de otros usuarios entregada a usuarios normales vía `SECURITY DEFINER`. Más justificable que D-03 (relación consentida: son amigos/solicitantes), pero sigue siendo dato que quizá la UI no requiere (con nombre + código_amigo basta para identificar). **BAJO**.

**Fix**: revisar si la UI de amigos/solicitudes muestra el correo; si no, quitarlo del `select`.

---

### [D-06] BAJO — Backups y exportaciones salen en claro vía `share_plus`, sin cifrado ni re-autenticación [CONFIRMADO]

**Evidencia**
- `lib/shared/services/backup_service.dart:71-88` — `exportar()` vuelca **toda** la BD del usuario (finanzas, deudas, notas, montos) a un JSON en texto plano en `getTemporaryDirectory()` y lo entrega a `Share.shareXFiles(...)`. No hay cifrado, contraseña, ni biometría previa. El `.json` **queda en el directorio temporal** tras compartir (no se borra).
- `lib/shared/services/export_service.dart:118-139` (CSV) y `:298-304` (PDF) — mismo patrón: archivo en claro compartido; el CSV se escribe en el directorio temporal sin limpieza.

**Vector / impacto**: el usuario puede enviar el archivo a un destino inseguro (WhatsApp/correo/Drive); además el archivo temporal persiste en almacenamiento local sin cifrar (se suma a D-01). Es una acción **iniciada por el usuario**, de ahí **BAJO**.

**Fix**: ofrecer backup cifrado/protegido con contraseña; borrar el archivo temporal tras compartir; exigir biometría real antes de exportar el respaldo completo.

---

### [D-07] BAJO — Sin borrado de cuenta ni política de retención (derecho al olvido) [CONFIRMADO]

**Evidencia**
- No existe RPC ni flujo de **eliminación de cuenta** (grep de `eliminar/borrar cuenta`, `delete account`, `retención` no arroja funcionalidad; solo menciones en `CHANGELOG.md` y CI). `deploy/db-init/03-admin.sql:174-187` hace *backfill* que retiene todos los perfiles; no hay borrado ni caducidad.
- `public.profiles` guarda `email` y `nombre` (`03-admin.sql:18-26`) de forma indefinida; los datos personales del usuario permanecen sin mecanismo de purga.

**Vector / impacto**: incumplimiento de minimización/retención y del derecho de supresión (GDPR/leyes locales). Sin impacto de confidencialidad inmediato → **BAJO**, pero relevante para cumplimiento.

**Fix**: RPC `eliminar_mi_cuenta()` (`SECURITY DEFINER`) que borre el perfil y los datos del usuario en cascada y elimine el usuario de `auth.users` (o vía Admin API de GoTrue con `service_role`); definir política de retención.

---

## Lo que está BIEN (controles correctos)

- **Hashing de contraseñas correcto** [CONFIRMADO]: no hay hashing ni almacenamiento propio de contraseñas en el código. `lib/features/auth/presentation/auth_cubit.dart:69,98,156` solo entrega la contraseña a GoTrue (`signInWithPassword`, `signUp`, `resetPasswordForEmail`); GoTrue la maneja con bcrypt. El grep de `bcrypt/hash/sha/encrypt` en `lib/` no encontró criptografía casera de credenciales.
- **Sin PII en logs** [CONFIRMADO]: todos los `debugPrint` (`main.dart:105`, `sync_manager.dart:185,231,237`, `generic_sync_engine.dart:50,68`, `presence_service.dart:60`, `connection_web.dart:20`) emiten mensajes genéricos o el objeto de excepción `$e` — **no** vuelcan email, nombre, tokens ni montos. No hay `print()`/`console.log` con PII.
- **`profiles` no se expone en masa a usuarios normales** [CONFIRMADO]: RLS `03-admin.sql:152-155` restringe el SELECT a la fila propia o a admins; las vistas `admin_*` usan `security_invoker = true` (`03-admin.sql:170-172`) para heredar ese RLS. El acceso a perfiles ajenos pasa por RPCs acotadas.
- **`codigo_amigo`** (`06-grupos.sql:20-49`) es un diseño acertado para invitar sin exponer el correo (aunque las RPCs D-03/D-04/D-05 luego sí devuelven el email — ahí está la brecha).
- **Escritura de PII propia bien contenida**: `registrar_actividad`/`actualizar_xp` derivan el id del JWT (`auth.uid()`), no de parámetros, evitando que un usuario escriba en la fila de otro.
