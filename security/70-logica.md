# Glint — Auditoría de seguridad: Lógica de negocio / abuso / race conditions

> Dominio: manipulación de gamificación, validación solo-cliente, flujos abusables, race conditions, fuga de info en errores.
> Método: solo lectura estática (Read/Grep). No se ejecutaron exploits contra la BD.
> Convención: `archivo:línea`, `[CONFIRMADO]`/`[SOSPECHA]`, severidad CRÍTICO/ALTO/MEDIO/BAJO.

## Resumen (5 líneas)

La barrera del backend es RLS + funciones `SECURITY DEFINER`; la RLS de propiedad (IDOR) está bien resuelta, pero **toda la lógica de negocio de "cuánto/qué valores" vive en el cliente Dart y el servidor no la revalida**. Hallazgo principal: `actualizar_xp(p_xp)` fija el XP al número que manda el cliente → cualquier usuario falsea el ranking (MEDIO), y el propio cliente ya permite farmear XP infinito con doble-toque (MEDIO). Los gastos compartidos (`grupo_gastos`/`gasto_partes`) no tienen ningún CHECK/trigger: montos negativos, partes que no suman, y `miembro_id`/`pagado_por` de otro grupo se aceptan (MEDIO). Flujos sociales (invitaciones sin binding de email, spam de solicitudes) y fuga de detalles de errores de Postgres por PostgREST son de bajo impacto (BAJO). No se hallaron fallos CRÍTICO/ALTO en este dominio, pero sí una clase sistémica: **validación de negocio ausente en el servidor.**

**Conteo por severidad:** CRÍTICO 0 · ALTO 0 · MEDIO 3 · BAJO 3

---

## MEDIO-1 · Falsificación de XP: `actualizar_xp` confía el valor del cliente `[CONFIRMADO]`

- **Ubicación:** `deploy/db-init/11-gamificacion.sql:17-27` (RPC) · `lib/shared/services/xp_service.dart:85-92` (`_pushXP`).
- **Vector concreto:** La RPC hace `update profiles set xp = greatest(coalesce(p_xp,0),0) where id = auth.uid()`. `p_xp` viene **directamente del cliente**; el único saneo es "no negativo". Un usuario autenticado, con su `anon key` y su JWT (ambos obtenibles del APK/web), hace:
  ```
  POST /rest/v1/rpc/actualizar_xp   Authorization: Bearer <jwt-propio>
  { "p_xp": 999999999 }
  ```
  y su `profiles.xp` queda en ese valor. El servidor **nunca** deriva el XP de hechos reales (hábitos/rutinas completados); es un contador que el cliente empuja a ciegas.
- **Impacto:** Falsea `ranking_amigos()` (`11-gamificacion.sql:30-48`) y la vista/RPC admin `admin_top_xp` — el ranking entre amigos, que es el núcleo de la gamificación, deja de ser confiable. Sin impacto en confidencialidad ni escalada de privilegios (la RLS por columna en `04-seguridad-roles.sql:22-23` sí impide tocar `es_admin`/`xp` por PATCH directo; el único canal de escritura de XP es esta RPC).
- **Fix (servidor autoritativo):** El XP no debe ser un valor que el cliente fije, sino algo que el servidor **calcule** de hechos que ya persisten. Opciones:
  1. Derivar el ranking de datos reales: `xp = f(count(habit_completions), rutinas, rachas)` computado en una vista/función `SECURITY DEFINER`, y **eliminar** `actualizar_xp`.
  2. Si se mantiene el contador, convertirlo en **incremental con tope y auditoría**: `actualizar_xp(p_delta)` que sume un delta pequeño acotado (p.ej. `<= 25` por llamada), con rate-limit por `(auth.uid(), minuto)` en una tabla de eventos, en vez de aceptar el total absoluto.

## MEDIO-2 · Farmeo de XP por doble-toque en el cliente `[CONFIRMADO]`

- **Ubicación:** `lib/features/habits/presentation/habit_cubit.dart:83-90` · repo `lib/features/habits/data/habit_repository.dart:33-72` · `lib/shared/services/xp_service.dart:59-79`.
- **Vector concreto:** `toggleCompletar` otorga XP con `if (completando) await XpService.agregarXP(10, ...)` **sin mirar** si la completación era nueva. El repositorio sí deduplica (`registrarCompletacion` devuelve `false` si ya existía ese día, `habit_repository.dart:201-224`), pero el cubit ignora ese resultado. Secuencia: completar (+10) → descompletar (borra la completación, **no resta XP**) → completar de nuevo (+10) … repetible sin límite sobre el mismo hábito el mismo día. El XP autoritativo vive en `SharedPreferences` (`xp_service.dart:59-79`) y se empuja al servidor con `_pushXP` (unawaited, `xp_service.dart:78`).
- **Impacto:** Inflar el XP local (y por ende el ranking del servidor) sin llamar siquiera a la RPC — al alcance de cualquier usuario con la UI normal. Refuerza MEDIO-1: aunque se endureciera la RPC, el cliente sigue siendo la fuente de verdad del XP.
- **Nota race/consistencia:** `agregarXP` (`xp_service.dart:59-79`) es un read-modify-write no atómico sobre `SharedPreferences` con `_pushXP` sin await; toques muy rápidos pueden perder incrementos o empujar totales desordenados. Es un problema de integridad menor, subsumido por el rediseño de MEDIO-1.
- **Fix:** (a) Sólo otorgar XP cuando la completación es realmente nueva: usar el `bool cambio`/retorno de `registrarCompletacion` para decidir si sumar; y restar al descompletar. (b) Estructuralmente, resolver como en MEDIO-1: que el XP lo derive el servidor de `habit_completions` (que ya son idempotentes por `(habit_id, fecha)`), no un contador de cliente.

## MEDIO-3 · Gastos compartidos sin validación en el servidor `[CONFIRMADO]`

- **Ubicación:** esquema `deploy/db-init/06-grupos.sql:113-140` (tablas `grupo_gastos`, `gasto_partes`, **sin CHECK**) · RLS `06-grupos.sql:273-284` · cliente `lib/features/groups/presentation/add_expense_screen.dart:92-131` (validación) · repo `lib/features/groups/data/group_repository.dart:164-260`.
- **Vector concreto:** La única validación de que "las partes suman el monto", "el monto es positivo" y "el reparto cuadra" está en Dart (`add_expense_screen.dart:104-105` `if ((suma - _monto).abs() > 0.01) return null`, `:114-115` para %). El servidor:
  - `grupo_gastos.monto double precision not null` — **sin** `CHECK (monto >= 0)`.
  - `gasto_partes.monto double precision not null` — **sin** CHECK, y **sin** ninguna restricción que obligue a `sum(partes) = gasto.monto`.
  - RLS `partes: miembros` (`06-grupos.sql:280-284`) sólo comprueba `es_miembro_por_gasto(gasto_id)` — que el llamante sea miembro del grupo del gasto. **No** valida que `miembro_id` pertenezca a ese grupo (la FK a `grupo_miembros` sólo exige que exista, `06-grupos.sql:135`), ni que `pagado_por` sea del grupo (`06-grupos.sql:119`).
  Un miembro malicioso hace `POST /rest/v1/gasto_partes` / `grupo_gastos` directo (Supabase-JS) con partes que no suman, montos negativos, o `miembro_id`/`pagado_por` apuntando a un miembro de **otro** grupo.
- **Impacto:** Corrompe los saldos compartidos que ven **los demás** miembros (el cálculo de deudas `GroupDetail.calcular` confía en las partes). No es sólo "su propio dato": afecta la contabilidad de terceros del grupo. Limitado a grupos donde el atacante ya es miembro (modelo de confianza), por eso MEDIO y no ALTO.
- **Fix (servidor):**
  - `alter table grupo_gastos add constraint monto_no_negativo check (monto >= 0);` y equivalente en `gasto_partes`.
  - Trigger `AFTER INSERT/UPDATE/DELETE` sobre `gasto_partes` (y validación en `grupo_gastos`) que verifique `abs(sum(partes.monto) - gasto.monto) <= 0.01` para gastos de tipo `'gasto'`, y que rechace `miembro_id`/`pagado_por` cuyo `grupo_id` no coincida con el del gasto. Idealmente mover la creación/edición del gasto a una RPC transaccional `SECURITY DEFINER` que reciba gasto+partes juntos y valide atómicamente (hoy son inserts separados, `group_repository.dart:176-200` y `:237-259`, que además pueden dejar un gasto sin partes si el segundo insert falla).

---

## BAJO-1 · Invitaciones de grupo: sin binding de email, expiración controlada por el cliente `[CONFIRMADO]`

- **Ubicación:** RPC `deploy/db-init/06-grupos.sql:352-397` (`aceptar_invitacion`) · creación `lib/features/groups/data/group_repository.dart:327-350` · generador `group_repository.dart:568-580`.
- **Análisis:** El código **sí es de un solo uso** — al aceptarse, `estado` pasa a `'aceptada'` (`06-grupos.sql:391`) y la consulta sólo acepta `estado='pendiente'` (`:370`), así que **no es reusable indefinidamente** (concern del brief descartado). Riesgos reales, menores:
  - **Sin binding de email:** `grupo_invitaciones.email` existe (`06-grupos.sql:147`) pero `aceptar_invitacion` **no lo comprueba**: cualquiera con el código se une, aunque la invitación fuera para otra persona.
  - **Expiración y código los pone el cliente:** el `INSERT` va directo a `grupo_invitaciones` (RLS permite a miembros, `06-grupos.sql:290-294`); un cliente puede fijar `expira_en = null` (sin caducidad) y un `codigo` arbitrario. El generador (`group_repository.dart:568-580`) es un PRNG casero sembrado con `microsecondsSinceEpoch` (débil/predecible), pero como el código es de un solo uso y de 8 chars sobre alfabeto de 31, no es prácticamente forzable a fuerza bruta.
- **Impacto:** Bajo — a lo sumo, un código filtrado (chat, captura) lo usa un tercero no previsto para entrar al grupo.
- **Fix:** En `aceptar_invitacion`, si `v_inv.email is not null` exigir que coincida con el email del `auth.uid()`. Generar `codigo` y `expira_en` en el servidor (dentro de una RPC `crear_invitacion` `SECURITY DEFINER`), no en el cliente, y usar `gen_random_bytes` para el código.

## BAJO-2 · Spam de solicitudes de amistad; presencia no falsificable `[CONFIRMADO]`

- **Ubicación:** `deploy/db-init/08-amigos.sql:37-69` (`solicitar_amistad`) · `03-admin.sql:83-98` (`registrar_actividad`).
- **Análisis:** El índice único `amistades (solicitante, destinatario)` (`08-amigos.sql:22-23`) impide **duplicar** una solicitud al mismo usuario, pero **no hay rate-limit** para enviar solicitudes a muchos usuarios distintos (enumerando ids vía `buscar_perfil`, aunque éste requiere email/código exacto, `06-grupos.sql:331-344`, lo que mitiga la enumeración masiva). `registrar_actividad` toma el id del JWT (`auth.uid()`, `03-admin.sql:93-96`), no de un parámetro: **no se puede falsear la presencia de otro** (correcto). `p_plataforma` sí es libre pero es cosmético.
- **Impacto:** Muy bajo (molestia/acoso por solicitudes). 
- **Fix:** Rate-limit por ventana temporal en `solicitar_amistad` (contar solicitudes de `auth.uid()` en la última hora contra un umbral).

## BAJO-3 · PostgREST expone detalles de errores de Postgres `[SOSPECHA]`

- **Ubicación:** escrituras directas a tablas (`group_repository.dart` y sync); manejo de error en `lib/shared/services/generic_sync_engine.dart:49-51`, `xp_service.dart:89-91`, `group_repository.dart:468-471`.
- **Análisis:** Las RPC plpgsql usan `raise exception` con **mensajes propios** benignos (`06-grupos.sql:364`,`375`; `04-seguridad-roles.sql:48` etc.) — no filtran internals. Pero las escrituras **directas** a tablas (p.ej. insertar `gasto_partes` con un `miembro_id`/`gasto_id` inválido → violación de FK, o `codigo` duplicado en `grupo_invitaciones` → violación de índice único) hacen que PostgREST devuelva al cliente el mensaje nativo de Postgres, que incluye **nombres de constraint, tabla y columna**. Es divulgación de estructura interna del esquema, no de datos de usuarios. En el cliente Dart los `catch` son silenciosos (no se pintan stack traces al usuario), así que la fuga es sólo a nivel de respuesta HTTP de la API, no de UI.
- **Impacto:** Bajo (recon del esquema). 
- **Fix:** Aceptable para el modelo actual; si se quiere endurecer, encapsular las escrituras sensibles en RPCs que traduzcan los errores a mensajes genéricos, o filtrar el detalle en el gateway.

---

## Nota transversal (no es un hallazgo aparte)

La causa raíz común de MEDIO-1/2/3 es la misma: **el servidor acepta como verdad los valores de negocio que decide el cliente** (XP total, montos, repartos), confiando en la validación de Dart. RLS protege *quién* toca *qué filas*, pero no *qué valores* son válidos. La corrección estructural es mover los invariantes de negocio al servidor (CHECK, triggers, RPCs transaccionales validadas, XP derivado de hechos), no sólo a la UI.

### Fuera de dominio / informativo
- Montos negativos o desmesurados en tablas **personales** (`transactions.monto`, `budgets.limite`, `savings_goals.monto_meta` — `05-sync-tables.sql:20,36,49`, sin CHECK; el límite `AppConstants.maxBudgetAmount` `app_constants.dart:59` sólo vive en Dart). Sólo afectan datos propios del usuario → impacto de seguridad nulo, es integridad de sus propios registros.
- Race conditions del motor de sync (`generic_sync_engine.dart`, `sync_manager.dart`): el guard `_sincronizando` (`sync_manager.dart:35,221`) y `_procesarRealtime` (`:154-161`) son correctos dentro del modelo mono-hilo del event loop de Dart; la resolución por última-escritura y el guard "nunca inferir borrados con 0 filas" (`generic_sync_engine.dart:190-201`) están bien pensados. No se halló doble-conteo ni pérdida de escrituras a nivel de sync (el único doble-conteo real es el de XP, MEDIO-2).
