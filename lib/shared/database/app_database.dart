import 'package:drift/drift.dart';
import 'package:glint/features/routines/data/routine_table.dart';
import 'package:glint/features/finance/data/transaction_table.dart';
import 'package:glint/features/finance/data/budget_table.dart';
import 'package:glint/features/finance/data/savings_goal_table.dart';
import 'package:glint/features/finance/data/debt_table.dart';
import 'package:glint/features/finance/data/recurring_expense_table.dart';
import 'package:glint/features/agenda/data/event_table.dart';
import 'package:glint/features/habits/data/habit_table.dart';
import 'package:glint/features/habits/data/habit_completion_table.dart';
import 'package:glint/features/notes/data/note_table.dart';
import 'package:glint/features/notes/data/note_draft_table.dart';
import 'package:glint/features/profile/data/profile_table.dart';
import 'connection/connection.dart';

// Este archivo tiene código generado — se crea con build_runner
part 'app_database.g.dart';

/// Base de datos local de Glint usando Drift (SQLite).
@DriftDatabase(tables: [
  Routines,
  Transactions,
  Budgets,
  SavingsGoals,
  Debts,
  RecurringExpenses,
  Events,
  Habits,
  HabitCompletions,
  SyncTombstones,
  Notes,
  NoteDrafts,
  Profiles,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(connect());

  /// Constructor para tests: permite inyectar una BD en memoria.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 14;

  /// Tablas que sincronizan con Supabase mediante el motor genérico
  /// (además de hábitos, que tiene su propia lógica por las rachas).
  /// El nombre es el mismo en local (SQLite) y en remoto (Postgres).
  ///
  /// `profiles` NO está aquí a propósito: su clave es `id` (= auth.uid()) y no
  /// tiene columna `usuario_id`, así que el trigger de tumbas que genera
  /// [_crearInfraestructuraSync] (`VALUES (..., OLD.usuario_id, ...)`) fallaría
  /// al crearse y dejaría la base local rota. Lleva su propio trigger, sin
  /// tumba, en [_crearTriggerPerfil], y lo sincroniza `ProfileSyncService`.
  static const List<String> tablasSincronizables = [
    'transactions',
    'budgets',
    'savings_goals',
    'debts',
    'recurring_expenses',
    'notes',
    'events',
    'routines',
  ];

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _crearInfraestructuraSync();
      await _crearTriggerPerfil();
    },
    onUpgrade: (m, from, to) async {
      if (from < 4) await m.createTable(habits);
      if (from < 5) await m.createTable(notes);
      if (from < 6) {
        await m.createTable(budgets);
        await m.createTable(savingsGoals);
        await m.createTable(debts);
        await m.createTable(recurringExpenses);
      }
      if (from < 7) await m.createTable(habitCompletions);
      if (from < 8) await m.addColumn(notes, notes.tags);
      if (from < 9) {
        // Sincronización bidireccional de hábitos: marcas de tiempo, cola
        // offline y tabla de tumbas para los borrados.
        await m.addColumn(habits, habits.actualizadoEn);
        await m.addColumn(habits, habits.pendienteSync);
        await m.addColumn(habitCompletions, habitCompletions.pendienteSync);
        await m.createTable(syncTombstones);
      }
      if (from < 10) {
        // Sync de finanzas, notas, agenda y rutinas: marcas de sync en cada
        // tabla + triggers que las mantienen (ver _crearInfraestructuraSync).
        //
        // Se hace con SQL crudo y defaults CONSTANTES a propósito. Con
        // `m.addColumn` y un default no-constante (currentDateAndTime →
        // strftime), SQLite rechaza el ALTER ("Cannot add a column with
        // non-constant default"), y si eso fallaba a media migración la base
        // quedaba rota (era la causa de que la web mostrara todo vacío y
        // crasheara al guardar). Además, cada columna se añade solo si falta,
        // para poder repetir la migración sin "duplicate column name".
        for (final t in tablasSincronizables) {
          await _agregarColumnasSync(t);
        }
        await _crearInfraestructuraSync();
      }
      if (from < 11) {
        // Perfil de usuario en local: hasta ahora vivía en SharedPreferences
        // (foto y estado) y en el metadata de auth (nombre), sin llegar nunca
        // a la tabla `profiles` del servidor — que es la única que ven los
        // demás. Ver deploy/db-init/19-perfil-social.sql.
        await m.createTable(profiles);
        await _crearTriggerPerfil();
      }
      if (from < 12) {
        // Borradores del editor de notas: lo que se está escribiendo se guarda
        // aquí para no perderlo al minimizar la app o salir sin guardar.
        await m.createTable(noteDrafts);
      }
      if (from < 13) {
        // Duración de los eventos. Los que ya existían se quedan con la hora
        // por defecto de la columna, que es justo lo que se quiere: antes no
        // había forma de decir cuánto duraban.
        await m.addColumn(events, events.duracionMinutos);
      }
      if (from < 14) {
        // Foto de perfil (Storage). Las columnas del avatar se añaden aquí, y
        // no basta con haberlas puesto en la definición de la tabla: quien ya
        // tenía la tabla `profiles` (creada en v11, antes de que existiera la
        // foto) NO vuelve a pasar por su `createTable` al actualizar, así que
        // sin este paso le faltarían las columnas y la app crashearía al
        // cambiar la foto con "no such column: avatar_bytes".
        //
        // Idempotente y con defaults constantes, por lo mismo que la v10: se
        // salta la columna que ya exista (los builds que crearon `profiles`
        // con las columnas nuevas ya la tienen) y se usa ALTER con default
        // constante, que es lo único que SQLite acepta.
        await _agregarColumnasAvatar();
      }
    },
  );

  /// Añade a `profiles` las columnas del avatar que falten, con las mismas
  /// definiciones que genera Drift en el esquema. Saltar las existentes evita
  /// el "duplicate column name" en las bases que ya las tienen.
  Future<void> _agregarColumnasAvatar() async {
    final existentes = (await customSelect(
      "SELECT name FROM pragma_table_info('profiles')",
    ).get())
        .map((r) => r.data['name'] as String)
        .toSet();

    if (!existentes.contains('avatar_url')) {
      await customStatement('ALTER TABLE profiles ADD COLUMN avatar_url TEXT');
    }
    if (!existentes.contains('avatar_bytes')) {
      await customStatement('ALTER TABLE profiles ADD COLUMN avatar_bytes BLOB');
    }
    if (!existentes.contains('avatar_pendiente')) {
      await customStatement(
        'ALTER TABLE profiles ADD COLUMN avatar_pendiente INTEGER NOT NULL '
        'DEFAULT 0 CHECK ("avatar_pendiente" IN (0, 1))',
      );
    }
  }

  /// Añade `actualizado_en` y `pendiente_sync` a [tabla] con SQL crudo y
  /// defaults constantes, saltando las que ya existan.
  Future<void> _agregarColumnasSync(String tabla) async {
    final existentes = (await customSelect(
      "SELECT name FROM pragma_table_info('$tabla')",
    ).get())
        .map((r) => r.data['name'] as String)
        .toSet();

    if (!existentes.contains('actualizado_en')) {
      // Default constante 0; luego se pone "ahora" a las filas existentes.
      await customStatement(
        'ALTER TABLE $tabla ADD COLUMN actualizado_en INTEGER NOT NULL DEFAULT 0',
      );
      await customStatement(
        "UPDATE $tabla SET actualizado_en = CAST(strftime('%s','now') AS INTEGER)",
      );
    }
    if (!existentes.contains('pendiente_sync')) {
      // Las filas que ya existían nacen pendientes → suben en el primer sync.
      await customStatement(
        'ALTER TABLE $tabla ADD COLUMN pendiente_sync INTEGER NOT NULL DEFAULT 1',
      );
    }
  }

  /// Crea la tabla de estado del sync y los triggers que, en cada cambio del
  /// usuario, marcan la fila como pendiente y actualizan su marca de tiempo; y
  /// que al borrar dejan una tumba. Así el sync no exige tocar cada método de
  /// escritura de los repositorios.
  ///
  /// Los triggers se saltan cuando `sync_estado.activo = 1`, que es justo
  /// cuando el motor de sync está aplicando datos que vienen del servidor
  /// (si no, esas escrituras se re-marcarían como pendientes y rebotarían).
  Future<void> _crearInfraestructuraSync() async {
    await customStatement(
      'CREATE TABLE IF NOT EXISTS sync_estado (activo INTEGER NOT NULL DEFAULT 0)',
    );
    // Garantizar exactamente una fila
    await customStatement('DELETE FROM sync_estado');
    await customStatement('INSERT INTO sync_estado (activo) VALUES (0)');

    for (final t in tablasSincronizables) {
      await customStatement('''
        CREATE TRIGGER IF NOT EXISTS glint_touch_$t
        AFTER UPDATE ON $t FOR EACH ROW
        WHEN (SELECT activo FROM sync_estado LIMIT 1) = 0
             AND NEW.actualizado_en = OLD.actualizado_en
        BEGIN
          UPDATE $t
             SET actualizado_en = CAST(strftime('%s','now') AS INTEGER),
                 pendiente_sync = 1
           WHERE id = NEW.id;
        END;
      ''');
      await customStatement('''
        CREATE TRIGGER IF NOT EXISTS glint_tomb_$t
        AFTER DELETE ON $t FOR EACH ROW
        WHEN (SELECT activo FROM sync_estado LIMIT 1) = 0
        BEGIN
          INSERT OR REPLACE INTO sync_tombstones (fila_id, tabla, usuario_id, borrado_en)
          VALUES (OLD.id, '$t', OLD.usuario_id, CAST(strftime('%s','now') AS INTEGER));
        END;
      ''');
    }
  }

  /// Trigger de `profiles`, aparte del resto por dos motivos: la fila se
  /// identifica por `id` (no hay `usuario_id`) y el perfil NO se borra, así que
  /// no lleva trigger de tumba.
  ///
  /// Llama primero a [_crearInfraestructuraSync] porque depende de la tabla
  /// `sync_estado`; es idempotente, así que repetirlo no cuesta nada.
  Future<void> _crearTriggerPerfil() async {
    await _crearInfraestructuraSync();
    await customStatement('''
      CREATE TRIGGER IF NOT EXISTS glint_touch_profiles
      AFTER UPDATE ON profiles FOR EACH ROW
      WHEN (SELECT activo FROM sync_estado LIMIT 1) = 0
           AND NEW.actualizado_en = OLD.actualizado_en
      BEGIN
        UPDATE profiles
           SET actualizado_en = CAST(strftime('%s','now') AS INTEGER),
               pendiente_sync = 1
         WHERE id = NEW.id;
      END;
    ''');
  }

  /// Activa/desactiva la supresión de triggers mientras el sync aplica datos
  /// remotos. Lo usa el motor de sync; no llamar desde otro sitio.
  Future<void> marcarSyncActivo(bool activo) =>
      customStatement('UPDATE sync_estado SET activo = ${activo ? 1 : 0}');
}
