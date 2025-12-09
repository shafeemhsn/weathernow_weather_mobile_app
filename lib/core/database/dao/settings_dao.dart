import 'package:sqflite/sqflite.dart';

import '../app_database.dart';

/// Encapsulates settings table operations.
class SettingsDao {
  SettingsDao(this._database);

  final AppDatabase _database;

  Future<Map<String, dynamic>?> fetch() async {
    final Database db = await _database.database;
    final result = await db.query(
      AppDatabase.settingsTable,
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return result.first;
  }

  Future<int> update(Map<String, dynamic> data) async {
    final Database db = await _database.database;
    return db.update(
      AppDatabase.settingsTable,
      data,
      where: 'id = ?',
      whereArgs: [1],
    );
  }
}
