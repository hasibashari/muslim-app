import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// Central SQLite database provider for the application.
///
/// * Does NOT define feature-specific tables.
/// * Features register their own table-creation callbacks via [addMigration].
/// * Call [initialize] once at app startup before any datasource access.
class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  static const String _databaseName = 'myapp.db';
  static const int _databaseVersion = 1;

  Database? _database;

  /// Callbacks that features register to create their own tables.
  final List<Future<void> Function(Database db, int version)>
  _onCreateCallbacks = [];

  /// Callbacks that features register for version-upgrade migrations.
  final List<Future<void> Function(Database db, int oldVersion, int newVersion)>
  _onUpgradeCallbacks = [];

  /// Register a table-creation callback.
  /// Must be called **before** [initialize].
  void addMigration({
    required Future<void> Function(Database db, int version) onCreate,
    Future<void> Function(Database db, int oldVersion, int newVersion)?
    onUpgrade,
  }) {
    _onCreateCallbacks.add(onCreate);
    if (onUpgrade != null) {
      _onUpgradeCallbacks.add(onUpgrade);
    }
  }

  /// Open (or create) the database.
  Future<Database> initialize() async {
    if (_database != null) return _database!;

    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, _databaseName);

    _database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    return _database!;
  }

  /// Returns the opened database instance.
  /// Throws if [initialize] has not been called.
  Database get database {
    if (_database == null) {
      throw StateError(
        'AppDatabase has not been initialized. '
        'Call AppDatabase.instance.initialize() first.',
      );
    }
    return _database!;
  }

  Future<void> _onCreate(Database db, int version) async {
    for (final callback in _onCreateCallbacks) {
      await callback(db, version);
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    for (final callback in _onUpgradeCallbacks) {
      await callback(db, oldVersion, newVersion);
    }
  }

  /// Close the database. Useful for testing tear-down.
  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
