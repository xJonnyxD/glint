import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import 'package:glint/features/groups/domain/expense_split_entity.dart';
import 'package:glint/features/groups/domain/group_detail.dart';
import 'package:glint/features/groups/domain/group_entity.dart';
import 'package:glint/features/groups/domain/member_entity.dart';
import 'package:glint/features/groups/domain/shared_expense_entity.dart';

/// Un perfil encontrado al buscar a quién invitar (resultado de la RPC
/// `buscar_perfil`).
class PerfilBusqueda {
  final String id;
  final String nombre;
  final String email;
  final String? codigoAmigo;
  final String? avatarUrl;
  const PerfilBusqueda({
    required this.id,
    required this.nombre,
    required this.email,
    required this.codigoAmigo,
    required this.avatarUrl,
  });
}

/// Una solicitud de amistad recibida (con el perfil de quien la envió).
class SolicitudAmistad {
  final String id;
  final PerfilBusqueda perfil;
  const SolicitudAmistad({required this.id, required this.perfil});
}

/// Acceso a los datos de gastos compartidos. A diferencia del resto de Glint,
/// habla DIRECTO con Supabase (no con Drift ni el GenericSyncEngine): los
/// grupos son compartidos entre varios usuarios, así que la fuente de verdad
/// es el servidor y los cambios llegan en vivo por Realtime.
class GroupRepository {
  final SupabaseClient _supabase;
  static const _uuid = Uuid();

  /// Recibe los cambios al instante por websocket (Supabase Realtime). Se
  /// controla en tiempo de compilación con `--dart-define=GLINT_REALTIME=true`
  /// (así el build de producción, que sí tiene el contenedor `glint-realtime`,
  /// va en vivo, y el dev local sin Realtime queda limpio). Cuando está en
  /// `false`, la frescura la da el sondeo periódico de [_pollInterval] — el
  /// mismo enfoque del SyncManager del resto de Glint. El sondeo se mantiene
  /// como red de seguridad incluso con Realtime activo.
  static bool habilitarRealtime =
      const bool.fromEnvironment('GLINT_REALTIME', defaultValue: false);

  /// Cada cuánto se vuelve a leer el grupo mientras la pantalla está abierta,
  /// para reflejar lo que cambian otros miembros sin Realtime.
  static const Duration _pollInterval = Duration(seconds: 10);

  GroupRepository(this._supabase);

  // ── Lectura en vivo ────────────────────────────────────────────────────────

  /// Los grupos donde el usuario es miembro, en vivo. Reacciona a altas/bajas
  /// de grupos y de membresías.
  Stream<List<GroupEntity>> watchMisGrupos(String usuarioId) {
    return _streamConRealtime<List<GroupEntity>>(
      canalId: 'mis-grupos-$usuarioId',
      tablas: const ['grupos', 'grupo_miembros'],
      fetch: () => _fetchMisGrupos(usuarioId),
    );
  }

  /// El detalle de un grupo (miembros + gastos + saldos), en vivo. Reacciona a
  /// cambios en miembros, gastos y partes de ESE grupo.
  Stream<GroupDetail> watchDetalle(String grupoId) {
    return _streamConRealtime<GroupDetail>(
      canalId: 'grupo-$grupoId',
      tablas: const ['grupos', 'grupo_miembros', 'grupo_gastos', 'gasto_partes'],
      filtroGrupoId: grupoId,
      fetch: () => _fetchDetalle(grupoId),
    );
  }

  // ── Escritura: grupos ────────────────────────────────────────────────────

  /// Crea un grupo y mete al creador como primer miembro (rol 'dueno').
  /// Devuelve el id del grupo.
  Future<String> crearGrupo({
    required String nombre,
    required String usuarioId,
    required String nombreCreador,
    String moneda = 'USD',
    String color = '#6750A4',
    String emoji = '👥',
  }) async {
    final grupoId = _uuid.v4();
    await _supabase.from('grupos').insert({
      'id': grupoId,
      'nombre': nombre,
      'moneda': moneda,
      'color': color,
      'emoji': emoji,
      'creado_por': usuarioId,
    });
    await _supabase.from('grupo_miembros').insert({
      'id': _uuid.v4(),
      'grupo_id': grupoId,
      'user_id': usuarioId,
      'nombre': nombreCreador,
      'rol': 'dueno',
      'activo': true,
    });
    return grupoId;
  }

  Future<void> renombrarGrupo(String grupoId, String nombre) async {
    await _supabase.from('grupos').update({'nombre': nombre}).eq('id', grupoId);
  }

  Future<void> eliminarGrupo(String grupoId) async {
    // Las FK con ON DELETE CASCADE se llevan miembros, gastos y partes.
    await _supabase.from('grupos').delete().eq('id', grupoId);
  }

  // ── Escritura: miembros ──────────────────────────────────────────────────

  /// Agrega una persona sin cuenta ("miembro virtual").
  Future<void> agregarMiembroVirtual(String grupoId, String nombre) async {
    await _supabase.from('grupo_miembros').insert({
      'id': _uuid.v4(),
      'grupo_id': grupoId,
      'user_id': null,
      'nombre': nombre,
      'rol': 'miembro',
      'activo': true,
    });
  }

  /// Agrega directamente a un usuario real (por ejemplo, tras encontrarlo con
  /// [buscarPerfil]). Queda ligado por su `user_id`.
  Future<void> agregarMiembroReal({
    required String grupoId,
    required String userId,
    required String nombre,
    String? avatarUrl,
  }) async {
    await _supabase.from('grupo_miembros').insert({
      'id': _uuid.v4(),
      'grupo_id': grupoId,
      'user_id': userId,
      'nombre': nombre,
      'avatar_url': avatarUrl,
      'rol': 'miembro',
      'activo': true,
    });
  }

  Future<void> eliminarMiembro(String miembroId) async {
    await _supabase.from('grupo_miembros').delete().eq('id', miembroId);
  }

  // ── Escritura: gastos ──────────────────────────────────────────────────────

  /// Crea un gasto con sus partes (para quién y cuánto).
  Future<void> crearGasto({
    required String grupoId,
    required String descripcion,
    required double monto,
    required String pagadoPor,
    required DateTime fecha,
    required Map<String, double> partes, // miembroId → monto que le toca
    required String usuarioId,
    String categoria = '🧾',
    String moneda = 'USD',
  }) async {
    final gastoId = _uuid.v4();
    await _supabase.from('grupo_gastos').insert({
      'id': gastoId,
      'grupo_id': grupoId,
      'descripcion': descripcion,
      'monto': monto,
      'moneda': moneda,
      'pagado_por': pagadoPor,
      'fecha': fecha.toIso8601String(),
      'tipo': 'gasto',
      'categoria': categoria,
      'creado_por': usuarioId,
    });

    final filasPartes = [
      for (final e in partes.entries)
        {
          'id': _uuid.v4(),
          'gasto_id': gastoId,
          'miembro_id': e.key,
          'monto': e.value,
        },
    ];
    if (filasPartes.isNotEmpty) {
      await _supabase.from('gasto_partes').insert(filasPartes);
    }
  }

  /// Registra un pago directo de un miembro a otro (para saldar deudas).
  Future<void> crearTransferencia({
    required String grupoId,
    required String deMiembroId,
    required String aMiembroId,
    required double monto,
    required String usuarioId,
    String moneda = 'USD',
  }) async {
    await _supabase.from('grupo_gastos').insert({
      'id': _uuid.v4(),
      'grupo_id': grupoId,
      'descripcion': 'Pago de deudas',
      'monto': monto,
      'moneda': moneda,
      'pagado_por': deMiembroId,
      'transferido_a': aMiembroId,
      'fecha': DateTime.now().toIso8601String(),
      'tipo': 'transferencia',
      'creado_por': usuarioId,
    });
  }

  /// Edita un gasto existente y reemplaza sus partes.
  Future<void> editarGasto({
    required String gastoId,
    required String descripcion,
    required double monto,
    required String pagadoPor,
    required DateTime fecha,
    required Map<String, double> partes,
    String categoria = '🧾',
    String moneda = 'USD',
  }) async {
    await _supabase.from('grupo_gastos').update({
      'descripcion': descripcion,
      'monto': monto,
      'pagado_por': pagadoPor,
      'fecha': fecha.toIso8601String(),
      'categoria': categoria,
      'moneda': moneda,
    }).eq('id', gastoId);

    // Reemplazar las partes (borrar e insertar las nuevas).
    await _supabase.from('gasto_partes').delete().eq('gasto_id', gastoId);
    final filas = [
      for (final e in partes.entries)
        {
          'id': _uuid.v4(),
          'gasto_id': gastoId,
          'miembro_id': e.key,
          'monto': e.value,
        },
    ];
    if (filas.isNotEmpty) {
      await _supabase.from('gasto_partes').insert(filas);
    }
  }

  Future<void> eliminarGasto(String gastoId) async {
    // gasto_partes cae por ON DELETE CASCADE.
    await _supabase.from('grupo_gastos').delete().eq('id', gastoId);
  }

  // ── Capa social: buscar e invitar ──────────────────────────────────────────

  /// Busca a alguien por correo exacto o código de amigo (RPC `buscar_perfil`).
  Future<List<PerfilBusqueda>> buscarPerfil(String texto) async {
    final res = await _supabase.rpc('buscar_perfil', params: {'p_texto': texto});
    return (res as List).map((r) {
      final m = r as Map<String, dynamic>;
      return PerfilBusqueda(
        id: m['id'] as String,
        nombre: (m['nombre'] as String?) ?? '',
        email: (m['email'] as String?) ?? '',
        codigoAmigo: m['codigo_amigo'] as String?,
        avatarUrl: m['avatar_url'] as String?,
      );
    }).toList();
  }

  // ── Amigos ─────────────────────────────────────────────────────────────────

  /// Envía una solicitud de amistad (o la acepta si el otro ya te la mandó).
  Future<void> solicitarAmistad(String destinatarioId) async {
    await _supabase.rpc('solicitar_amistad', params: {'p_destinatario': destinatarioId});
  }

  /// Acepta ([aceptar] true) o rechaza una solicitud recibida.
  Future<void> responderAmistad(String id, bool aceptar) async {
    await _supabase.rpc('responder_amistad', params: {'p_id': id, 'p_aceptar': aceptar});
  }

  Future<void> eliminarAmigo(String amigoId) async {
    await _supabase.rpc('eliminar_amigo', params: {'p_amigo': amigoId});
  }

  /// Lista de amigos aceptados.
  Future<List<PerfilBusqueda>> obtenerAmigos() async {
    final res = await _supabase.rpc('mis_amigos');
    return [for (final r in (res as List)) _perfilDeJson(r as Map<String, dynamic>)];
  }

  /// Solicitudes de amistad recibidas y pendientes.
  Future<List<SolicitudAmistad>> obtenerSolicitudes() async {
    final res = await _supabase.rpc('solicitudes_amistad');
    return [
      for (final r in (res as List))
        SolicitudAmistad(
          id: (r as Map)['id'] as String,
          perfil: _perfilDeJson(r as Map<String, dynamic>),
        ),
    ];
  }

  PerfilBusqueda _perfilDeJson(Map<String, dynamic> m) => PerfilBusqueda(
        id: m['id'] as String,
        nombre: (m['nombre'] as String?) ?? '',
        email: (m['email'] as String?) ?? '',
        codigoAmigo: m['codigo_amigo'] as String?,
        avatarUrl: m['avatar_url'] as String?,
      );

  /// Crea un código de invitación para el grupo y lo devuelve. El código lo
  /// genera el SERVIDOR (aleatorio criptográfico, con expiración obligatoria)
  /// vía la RPC `crear_invitacion_grupo` — el cliente ya no lo fabrica (SEC-07).
  Future<String> crearInvitacion({
    required String grupoId,
    required String usuarioId, // ya no se usa: el servidor deriva el invitador
    Duration validez = const Duration(days: 7),
  }) async {
    final res = await _supabase.rpc('crear_invitacion_grupo',
        params: {'p_grupo_id': grupoId, 'p_dias': validez.inDays});
    return res as String;
  }

  /// Acepta una invitación por su código (RPC `aceptar_invitacion`). Devuelve
  /// el id del grupo al que se unió.
  Future<String> aceptarInvitacion(String codigo) async {
    final res =
        await _supabase.rpc('aceptar_invitacion', params: {'p_codigo': codigo});
    return res as String;
  }

  // ── Fetch (una sola foto) ────────────────────────────────────────────────

  Future<List<GroupEntity>> _fetchMisGrupos(String usuarioId) async {
    final membresias = await _supabase
        .from('grupo_miembros')
        .select('grupo_id')
        .eq('user_id', usuarioId)
        .eq('activo', true);

    final ids = [
      for (final m in (membresias as List)) (m as Map)['grupo_id'] as String,
    ];
    if (ids.isEmpty) return [];

    final filas = await _supabase
        .from('grupos')
        .select()
        .inFilter('id', ids)
        .order('creado_en', ascending: false);

    return [for (final f in (filas as List)) _grupoDeJson(f as Map<String, dynamic>)];
  }

  Future<GroupDetail> _fetchDetalle(String grupoId) async {
    final grupoRow = await _supabase
        .from('grupos')
        .select()
        .eq('id', grupoId)
        .maybeSingle();
    // Si el grupo ya no existe (borrado por otro miembro), devolvemos un
    // detalle vacío para que la UI pueda salir con gracia.
    if (grupoRow == null) {
      return GroupDetail.calcular(
        grupo: GroupEntity(
          id: grupoId,
          nombre: '',
          moneda: 'USD',
          color: '#6750A4',
          emoji: '👥',
          creadoPor: '',
          creadoEn: DateTime.now(),
        ),
        miembros: const [],
        gastos: const [],
      );
    }

    final miembrosRows = await _supabase
        .from('grupo_miembros')
        .select()
        .eq('grupo_id', grupoId)
        .eq('activo', true);
    final miembros = [
      for (final m in (miembrosRows as List)) _miembroDeJson(m as Map<String, dynamic>),
    ];

    final gastosRows = await _supabase
        .from('grupo_gastos')
        .select()
        .eq('grupo_id', grupoId)
        .order('fecha', ascending: false);
    final gastosSinPartes = [
      for (final g in (gastosRows as List)) _gastoDeJson(g as Map<String, dynamic>),
    ];

    // Traer todas las partes de esos gastos en una sola consulta.
    final gastoIds = [for (final g in gastosSinPartes) g.id];
    final partesPorGasto = <String, List<ExpenseSplitEntity>>{};
    if (gastoIds.isNotEmpty) {
      final partesRows =
          await _supabase.from('gasto_partes').select().inFilter('gasto_id', gastoIds);
      for (final p in (partesRows as List)) {
        final parte = _parteDeJson(p as Map<String, dynamic>);
        partesPorGasto.putIfAbsent(parte.gastoId, () => []).add(parte);
      }
    }

    final gastos = [
      for (final g in gastosSinPartes)
        g.copyWith(partes: partesPorGasto[g.id] ?? const []),
    ];

    return GroupDetail.calcular(
      grupo: _grupoDeJson(grupoRow),
      miembros: miembros,
      gastos: gastos,
    );
  }

  // ── Realtime genérico ──────────────────────────────────────────────────────

  /// Crea un stream que:
  ///  1. emite una foto inicial con [fetch];
  ///  2. se suscribe por Realtime a [tablas] (opcionalmente filtradas por
  ///     `grupo_id = [filtroGrupoId]`) y, ante cualquier cambio, vuelve a
  ///     hacer [fetch] (con un pequeño debounce para agrupar ráfagas, p. ej.
  ///     un gasto y sus varias partes).
  Stream<T> _streamConRealtime<T>({
    required String canalId,
    required List<String> tablas,
    required Future<T> Function() fetch,
    String? filtroGrupoId,
  }) {
    late final StreamController<T> ctrl;
    RealtimeChannel? canal;
    Timer? debounce;
    Timer? sondeo;
    var cerrado = false;
    var enVuelo = false; // evita solapar dos fetch simultáneos

    Future<void> refetch() async {
      if (enVuelo) return;
      enVuelo = true;
      try {
        final data = await fetch();
        if (!cerrado && !ctrl.isClosed) ctrl.add(data);
      } catch (e) {
        if (!cerrado && !ctrl.isClosed) ctrl.addError(e);
      } finally {
        enVuelo = false;
      }
    }

    void programarRefetch() {
      debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 250), refetch);
    }

    ctrl = StreamController<T>(
      onListen: () {
        refetch();

        // Realtime (si está desplegado): cambios al instante por websocket.
        if (habilitarRealtime) {
          canal = _supabase.channel(canalId);
          for (final t in tablas) {
            canal!.onPostgresChanges(
              event: PostgresChangeEvent.all,
              schema: 'public',
              table: t,
              // 'grupos' se filtra por su columna id; las demás por grupo_id.
              filter: filtroGrupoId == null
                  ? null
                  : PostgresChangeFilter(
                      type: PostgresChangeFilterType.eq,
                      column: t == 'grupos' ? 'id' : 'grupo_id',
                      value: filtroGrupoId,
                    ),
              callback: (_) => programarRefetch(),
            );
          }
          canal!.subscribe();
        }

        // Sondeo periódico: la frescura garantizada cuando no hay Realtime.
        sondeo = Timer.periodic(_pollInterval, (_) => refetch());
      },
      onCancel: () async {
        cerrado = true;
        debounce?.cancel();
        sondeo?.cancel();
        final c = canal;
        if (c != null) await _supabase.removeChannel(c);
      },
    );

    return ctrl.stream;
  }

  // ── Conversores JSON → entidad ─────────────────────────────────────────────

  GroupEntity _grupoDeJson(Map<String, dynamic> m) => GroupEntity(
        id: m['id'] as String,
        nombre: (m['nombre'] as String?) ?? '',
        moneda: (m['moneda'] as String?) ?? 'USD',
        color: (m['color'] as String?) ?? '#6750A4',
        emoji: (m['emoji'] as String?) ?? '👥',
        creadoPor: (m['creado_por'] as String?) ?? '',
        creadoEn: DateTime.tryParse(m['creado_en'] as String? ?? '') ??
            DateTime.now(),
      );

  MemberEntity _miembroDeJson(Map<String, dynamic> m) => MemberEntity(
        id: m['id'] as String,
        grupoId: m['grupo_id'] as String,
        userId: m['user_id'] as String?,
        nombre: (m['nombre'] as String?) ?? '',
        avatarUrl: m['avatar_url'] as String?,
        peso: (m['peso'] as num?)?.toDouble() ?? 1,
        rol: (m['rol'] as String?) ?? 'miembro',
        activo: (m['activo'] as bool?) ?? true,
      );

  SharedExpenseEntity _gastoDeJson(Map<String, dynamic> m) => SharedExpenseEntity(
        id: m['id'] as String,
        grupoId: m['grupo_id'] as String,
        descripcion: (m['descripcion'] as String?) ?? '',
        monto: (m['monto'] as num?)?.toDouble() ?? 0,
        moneda: (m['moneda'] as String?) ?? 'USD',
        pagadoPor: m['pagado_por'] as String,
        transferidoA: m['transferido_a'] as String?,
        fecha: DateTime.tryParse(m['fecha'] as String? ?? '') ?? DateTime.now(),
        tipo: (m['tipo'] as String?) == 'transferencia'
            ? TipoGasto.transferencia
            : TipoGasto.gasto,
        categoria: (m['categoria'] as String?) ?? '🧾',
        creadoPor: (m['creado_por'] as String?) ?? '',
      );

  ExpenseSplitEntity _parteDeJson(Map<String, dynamic> m) => ExpenseSplitEntity(
        id: m['id'] as String,
        gastoId: m['gasto_id'] as String,
        miembroId: m['miembro_id'] as String,
        monto: (m['monto'] as num?)?.toDouble() ?? 0,
      );

}
