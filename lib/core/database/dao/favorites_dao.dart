import 'package:sqflite/sqflite.dart';

import '../app_database.dart';

/// Encapsulates favorites table operations to keep AppDatabase focused on setup.
class FavoritesDao {
  FavoritesDao(this._database);

  final AppDatabase _database;

  Future<int> insert(Map<String, dynamic> data) async {
    final Database db = await _database.database;
    return db.insert(AppDatabase.favoritesTable, data);
  }

  Future<List<Map<String, dynamic>>> fetchAll() async {
    final Database db = await _database.database;
    return db.query(AppDatabase.favoritesTable, orderBy: 'created_at DESC');
  }

  Future<int> deleteById(int id) async {
    final Database db = await _database.database;
    return db.delete(
      AppDatabase.favoritesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
