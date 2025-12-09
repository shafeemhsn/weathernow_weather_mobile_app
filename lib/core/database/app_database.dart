import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Centralized SQLite helper using sqflite.
class AppDatabase {
  AppDatabase._internal();

  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;

  static const _dbName = 'weather_app.db';
  static const _dbVersion = 1;

  static const favoritesTable = 'favorites';
  static const settingsTable = 'app_settings';

  static Database? _database;

  /// Lazily opens the database, creating it if needed.
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $favoritesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        city_name TEXT NOT NULL,
        country_code TEXT NOT NULL,
        lat REAL NOT NULL,
        lon REAL NOT NULL,
        last_temp REAL,
        last_condition TEXT,
        created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE $settingsTable (
        id INTEGER PRIMARY KEY,
        temp_unit TEXT NOT NULL,
        wind_unit TEXT NOT NULL,
        auto_location INTEGER NOT NULL,
        notifications_enabled INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      );
    ''');

    final nowIso = DateTime.now().toIso8601String();
    await db.insert(settingsTable, {
      'id': 1,
      'temp_unit': 'c',
      'wind_unit': 'kmh',
      'auto_location': 1,
      'notifications_enabled': 0,
      'created_at': nowIso,
      'updated_at': nowIso,
    });
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Placeholder for future schema migrations.
    // Add conditional migration logic when bumping _dbVersion.
  }
}
