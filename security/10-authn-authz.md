# Glint — Auditoría de Autenticación y Autorización (FASE 10)

> Dominio: **AuthN / AuthZ** (RLS, funciones `SECURITY DEFINER`, escalada a admin, JWT/sesión, invitaciones/códigos).
> Alcance y stack: ver `security/00-scope.md`. Solo lectura de código; sin exploits en vivo.
> Convención: `[CONFIRMADO]` = leí el código vulnerable; `[SOSPECHA]` = inferencia sin poder verificar en runtime.

## Resumen ejecutivo

El modelo de aislamiento **personal** (tablas de `05-sync-tables.sql`, `habits`, etc.) está **bien construido**: cada tabla tiene RLS `auth.uid() = usuario_id` para `all` con `using` + `with check`. No encontré IDOR/BOLA para leer datos personales de otro usuario. La **escalada a admin por columna `es_admin`** está **correctamente cerrada** en `04-seguridad-roles.sql` (revocación de `UPDATE` global + grant por columna). Las funciones `SECURITY DEFINER` administrativas (`admin_metricas`, `admin_lista_usuarios`, `admin_top_xp`, `definir_admin`) validan `es_admin()` correctamente.

Los hallazgos se concentran en la **capa social/grupos** (más nueva): el código de invitación es **predecible** (PRNG no criptográfico sembrado con el reloj), la RPC que lo canjea lo trata como bearer token sin rate-limit ni verificación del destinatario, y las políticas de `grupo_miembros` permiten escribir `user_id` arbitrario. Además, GoTrue está en autoconfirmación con signup abierto.

---

## Hallazgos por severidad

### [ALTO] H-01 — Código de invitación a grupo predecible (PRNG no criptográfico basado en el reloj) `[CONFIRMADO]`

- **Dónde:** `lib/features/groups/data/group_repository.dart:568-580` (`_generarCodigoInvitacion`), canjeado por `deploy/db-init/06-grupos.sql:352-397` (`aceptar_invitacion`).
- **Qué:** el código de 8 caracteres se deriva **únicamente** de `DateTime.now().microsecondsSinceEpoch` pasado por una mezcla aritmética casera (`x = (x ~/ len) + (x * 31 + i)`). No usa CSPRNG (`Random.secure()`), ni siquiera `Random()`. Toda la entropía real del código es el timestamp de creación.
- **Vector concreto para este sistema:**
  1. `grupo_invitaciones` tiene RLS `for all using es_miembro_grupo(grupo_id)` (`06-grupos.sql:290-294`): un no-miembro **no puede** listar códigos por REST. El **único** camino de canje es la RPC `aceptar_invitacion(p_codigo)`, así que la fortaleza del código es la barrera exclusiva.
  2. El algoritmo es reproducible offline. Si el atacante conoce/estima la ventana temporal en que la víctima generó el enlace (p. ej. "me pasaron el link hacia las 15:40 de hoy"), enumera candidatos de `microsecondsSinceEpoch` en esa ventana, calcula los códigos con el mismo algoritmo y los prueba contra `aceptar_invitacion`. Una ventana de 1 s = 10⁶ candidatos; de 1 min ≈ 6·10⁷.
  3. `aceptar_invitacion` **no tiene rate-limit ni contador de intentos** a nivel BD; PostgREST expone la RPC a cualquier `authenticated`.
- **Impacto:** unirse como **miembro real** a un grupo ajeno ⇒ lectura y **escritura** de todos los gastos compartidos (montos, descripciones, quién debe a quién), alta/baja de miembros y de gastos (`grupo_gastos`/`gasto_partes` son `for all` para miembros). Exposición de datos financieros de terceros.
- **Fix:** generar el código con CSPRNG y suficiente entropía:
  - Cliente: `Random.secure()` y ≥ 12 caracteres del alfabeto (o mejor, no generar el código en el cliente).
  - **Preferible:** mover la generación al servidor, reusando `public.generar_codigo_amigo()` de `06-grupos.sql:30-49` pero sustituyendo `random()` por `gen_random_bytes()` (pgcrypto ya está instalado, `01-roles.sh:7`), y crear la invitación vía una RPC `SECURITY DEFINER` que devuelva el código, en lugar del `insert` directo desde el cliente.

> Nota de honestidad: el fuerza-bruta puramente online del espacio 31⁸ (≈ 8,5·10¹¹) **no** es práctico; lo que eleva esto a ALTO es la **predecibilidad temporal** del código combinada con la ausencia de rate-limit y con que el código es la única barrera. Si se discrepa del escenario de estimación temporal, degrádese a MEDIO — el fix es el mismo y trivial.

---

### [MEDIO] H-02 — `aceptar_invitacion` trata el código como bearer token: ignora el `email` invitado y admite expiración nula `[CONFIRMADO]`

- **Dónde:** `deploy/db-init/06-grupos.sql:352-394`.
- **Qué:**
  - La tabla `grupo_invitaciones` tiene columna `email` (`06-grupos.sql:147`) pero `aceptar_invitacion` **nunca la compara** con el usuario que canjea. Cualquiera que presente el código entra, sin importar a quién iba dirigida la invitación.
  - `expira_en` es nullable y la función acepta `expira_en is null` como "no vence" (`06-grupos.sql:371`). Hoy el cliente siempre pone 7 días (`group_repository.dart:339`), pero un `insert` directo por REST (permitido a cualquier miembro por la RLS `invitaciones: miembros`) puede crear invitaciones **sin caducidad**.
- **Vector/Impacto:** si un código se filtra (link reenviado, historial, `Referer`, captura), es canjeable por cualquier cuenta hasta que alguien lo acepte (pasa a `estado='aceptada'`, un solo uso). Amplifica H-01.
- **Fix:** (a) si `v_inv.email is not null`, exigir que coincida con el email del `auth.uid()`; (b) forzar `expira_en not null` con default (`now() + interval '7 days'`) y rechazar en la RPC las que no traigan expiración; (c) considerar invalidar el código tras N intentos fallidos del mismo llamante.

---

### [MEDIO] H-03 — GoTrue: autoconfirmación de correo + signup abierto (impersonación por email en la capa social) `[CONFIRMADO]`

- **Dónde:** `deploy/docker-compose.yml:45,56` (`GOTRUE_DISABLE_SIGNUP=false`, `GOTRUE_MAILER_AUTOCONFIRM=true`).
- **Qué:** cualquiera se registra con **cualquier** dirección de correo sin demostrar que es suya y queda con sesión activa de inmediato. No hay política de contraseñas configurada (GoTrue por defecto exige solo 6 caracteres; ver también `auth_cubit.dart:223`), ni rate-limit explícito de signup/login declarado.
- **Vector/Impacto para este sistema:** el correo es un identificador **de confianza** en toda la capa social — `buscar_perfil` (`06-grupos.sql:331`) localiza usuarios por email exacto y `definir_admin` (`04-seguridad-roles.sql:38`) opera **por email**. Un atacante puede:
  - Registrar el email de una persona real antes que ella (squatting) y aparecer como esa persona en búsquedas/solicitudes de amistad.
  - Crear cuentas masivas (spam de solicitudes de amistad vía `solicitar_amistad`, inflar métricas, abusar de `actualizar_xp`).
- **Impacto sobre admin:** limitado — `definir_admin` requiere que el llamante ya sea admin, así que autoconfirm **no** da escalada directa. El riesgo es de suplantación/PII y abuso, no de privilegios.
- **Fix:** si el producto lo permite, poner `GOTRUE_MAILER_AUTOCONFIRM=false` y verificar correo (ya hay SMTP previsto en el compose). Configurar `GOTRUE_PASSWORD_MIN_LENGTH` y rate-limits (`GOTRUE_RATE_LIMIT_*`). Documentar el trade-off si se decide mantener autoconfirm.

---

### [MEDIO] H-04 — `grupo_miembros`: las políticas permiten escribir `user_id`/`rol` arbitrarios (forced membership) `[CONFIRMADO]`

- **Dónde:** `deploy/db-init/06-grupos.sql:256-270` (políticas `miembros: agregar` / `miembros: editar`).
- **Qué:** el `with check` solo verifica `es_miembro_grupo(grupo_id) OR es_creador_grupo(grupo_id)`; **no** restringe el valor de `user_id`. Un miembro del grupo puede insertar una fila con el `user_id` de **cualquier** víctima (obtenido por `buscar_perfil`), o cambiar el `user_id`/`rol` de filas existentes.
- **Vector/Impacto:** el atacante (miembro de su propio grupo) inserta a la víctima como miembro real ⇒ el grupo aparece en `watchMisGrupos` de la víctima (`grupo_miembros` filtra por `user_id`), forzándola a ver contenido no solicitado (acoso/spam, posible contenido ofensivo en nombres de grupo/gastos). No permite **leer** datos de la víctima. `rol` no participa en autorización (solo `es_creador_grupo` gobierna el `delete` de grupo), así que **no hay escalada** dentro del grupo.
- **Nota:** un no-miembro **no** puede auto-insertarse (el `check` exige ser ya miembro/creador de ese grupo), así que esto **no** es un IDOR de auto-unión.
- **Fix:** en el `with check` de insert/update de miembros reales, exigir que `user_id` sea el propio (`user_id = auth.uid()`) salvo miembros virtuales (`user_id is null`); o canalizar el alta de miembros reales por una RPC que valide consentimiento (invitación aceptada).

---

### [BAJO] H-05 — `actualizar_xp` confía en el XP enviado por el cliente `[CONFIRMADO]`

- **Dónde:** `deploy/db-init/11-gamificacion.sql:17-27`.
- **Qué:** `update profiles set xp = greatest(coalesce(p_xp,0),0) where id = auth.uid()`. El valor lo fija el cliente sin tope ni verificación de progreso real.
- **Impacto:** manipulación del ranking (`ranking_amigos`, `admin_top_xp`). Integridad de gamificación, no frontera de seguridad.
- **Fix:** calcular XP en servidor a partir de eventos verificables, o al menos acotar el incremento por llamada/tiempo.

### [BAJO] H-06 — Fuga de correos de otros usuarios en las RPC sociales `[CONFIRMADO]`

- **Dónde:** `buscar_perfil` (`06-grupos.sql:331-344`), `mis_amigos` (`08-amigos.sql:104-119`), `solicitudes_amistad` (`08-amigos.sql:122-135`), `ranking_amigos` (`11-gamificacion.sql:30-48`).
- **Qué:** todas devuelven `email` de terceros. `buscar_perfil` requiere match exacto de email o `codigo_amigo` (funciona como oráculo de existencia y devuelve `id`+`codigo_amigo`); las otras exponen el email de amigos/solicitantes.
- **Impacto:** PII (correo) accesible dentro de la relación de amistad y como confirmación de registro por email exacto. Bajo, pero evitable.
- **Fix:** devolver solo `nombre`/`avatar_url`/`codigo_amigo` a la UI y omitir `email` salvo que sea imprescindible.

### [BAJO] H-07 — `alter default privileges ... grant all to anon, authenticated` (footgun para tablas futuras) `[CONFIRMADO]`

- **Dónde:** `deploy/db-init/02-schema.sql:57-58`.
- **Qué:** cualquier tabla creada después en `public` por el rol `postgres` recibe automáticamente `grant all` a `anon`/`authenticated`. Si una migración futura crea una tabla y **olvida** `enable row level security`, queda world-readable/writable.
- **Estado actual:** todas las tablas auditadas activan RLS, así que hoy no hay exposición. Es riesgo latente.
- **Fix:** no confiar en default privileges como red; añadir a la checklist de despliegue "toda tabla nueva ⇒ `enable row level security` + política". Opcional: `alter table ... force row level security`.

### [BAJO/INFO] H-08 — Sesión del panel admin en `localStorage`; anon key cloud por defecto `[CONFIRMADO]`

- **Dónde:** `landing/admin/index.html:268,307,545` (guarda `access_token`+`refresh_token` en `localStorage`); `lib/core/constants/app_constants.dart:16-24` (URL/anon key cloud por defecto, `exp` 2090).
- **Qué:** tokens en `localStorage` son robables ante un XSS en el panel; el panel **sí** escapa los valores de usuario con `esc()` (`index.html:290-291,406,435`), lo que mitiga el XSS almacenado desde datos de la tabla. La anon key hardcodeada es pública por diseño; el detalle de que apunta a una instancia cloud real es competencia del agente de secretos (ver `00-scope.md:48`).
- **Fix:** mantener el escapado; considerar CSP estricta en `glint-web.conf` para el panel; delegar la anon key a `--dart-define` sin default cloud (agente-secrets).

### [BAJO/SOSPECHA] H-09 — `codigo_amigo` generado con `random()` no criptográfico `[SOSPECHA]`

- **Dónde:** `deploy/db-init/06-grupos.sql:30-49` (`generar_codigo_amigo`).
- **Qué:** usa `random()` (PRNG de Postgres, no criptográfico) para un código de 8 chars del alfabeto de 31 (≈ 8,5·10¹¹). El código no es un token de sesión, pero conocerlo permite `buscar_perfil` ⇒ obtener `email`+`id` de esa persona.
- **Impacto:** enumeración teórica de perfiles/correos; poco práctica online por el tamaño del espacio. No verifiqué distribución real de `random()` en runtime, de ahí `[SOSPECHA]`.
- **Fix:** `gen_random_bytes()` (pgcrypto) para el `codigo_amigo`.

### [BAJO/SOSPECHA] H-10 — Realtime depende de que la RLS se aplique al `postgres_changes` `[SOSPECHA]`

- **Dónde:** `deploy/db-init/06-grupos.sql:405-428` y `10-realtime-personal.sql`; cliente `group_repository.dart:485-504`.
- **Qué:** las tablas compartidas y personales se publican en `supabase_realtime` con `replica identity full`. Si el tenant de Realtime **no** tuviera forzado el chequeo RLS por-suscripción, un `authenticated` podría suscribirse a un `grupo_id` ajeno y recibir eventos de sus gastos. `00-scope.md:37` afirma que va "gated por RLS"; no pude verificar la configuración del tenant en runtime.
- **Fix/Verificación:** confirmar que Realtime v2.30.23 aplica RLS a `postgres_changes` para el tenant sembrado (`SEED_SELF_HOST`), y que la política de `grupo_gastos`/`gasto_partes` cubre la suscripción. `replica identity full` implica que el "old record" viaja completo en DELETE: comprobar que Realtime lo filtra por RLS antes de emitirlo.

---

## Qué revisé / qué está bien

- **RLS de datos personales (`02-schema.sql`, `05-sync-tables.sql`):** correcto. `habits`, `habit_completions`, `transactions`, `budgets`, `savings_goals`, `debts`, `recurring_expenses`, `notes`, `events`, `routines` tienen RLS `for all to authenticated using/with check (auth.uid() = user_id|usuario_id)`. **No hay IDOR/BOLA** para leer/escribir filas de otro usuario. `device_tokens` (`09-push.sql:31-34`) igual de aislado.
- **Escalada a admin — CERRADA correctamente:** `04-seguridad-roles.sql:22-23` revoca `UPDATE` global sobre `profiles` y concede solo `update (nombre, plataforma)`; `es_admin`, `email`, `id`, `creado_en` quedan fuera del alcance de `authenticated`. Verifiqué que **no** existe otra vía: `crear_perfil_al_registrarse` inserta con `es_admin` default `false` y no lee ese campo del `raw_user_meta_data`; `definir_admin` exige `es_admin()` del llamante y protege al último admin. Buen diseño.
- **Funciones `SECURITY DEFINER`:** todas fijan `set search_path = public` (evita hijack de search_path) y derivan la identidad de `auth.uid()`, no de parámetros: `registrar_actividad`, `actualizar_xp`, `solicitar_amistad`, `responder_amistad`, `eliminar_amigo`, `es_miembro_grupo`, `es_creador_grupo`, `es_miembro_por_gasto`. `responder_amistad` y `eliminar_amigo` acotan por `destinatario/solicitante = auth.uid()` (sin IDOR). Las admin (`admin_metricas`, `admin_lista_usuarios`, `admin_top_xp`) usan `where public.es_admin()` ⇒ un no-admin recibe **cero filas** (patrón correcto).
- **Vistas admin (`admin_resumen`, `admin_usuarios`, `admin_altas_por_dia`):** `security_invoker = true` (`03-admin.sql:170-172`) y `revoke insert/update/delete` (`04:74-76`); heredan la RLS de `profiles` del consultante. Correcto.
- **Membresía de grupos (lecturas):** `grupos`, `grupo_gastos`, `gasto_partes`, `grupo_invitaciones` aíslan por `es_miembro_grupo`/`es_miembro_por_gasto`. Verifiqué que un miembro de A **no** puede insertar gastos/partes en un grupo B (el `with check` evalúa la membresía del `grupo_id`/gasto destino). `anon` no tiene acceso a `profiles` (`04:81`).
- **Roles PostgREST (`01-roles.sh`):** `authenticator` es `NOINHERIT`; `anon`/`authenticated` `NOLOGIN`; `service_role` `BYPASSRLS`. `auth.uid()`/`auth.role()` leen los claims del JWT correctamente. Correcto.
- **JWT:** exp 1h con refresh (`docker-compose.yml:49`), secreto por `.env`. El panel refresca vía `refresh_token` (`index.html:297-309`). Sin observaciones más allá de H-08.

---

### Conteo por severidad
- **CRÍTICO:** 0
- **ALTO:** 1 (H-01)
- **MEDIO:** 3 (H-02, H-03, H-04)
- **BAJO/INFO:** 6 (H-05..H-10)
