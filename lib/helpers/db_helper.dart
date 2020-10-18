import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<sql.Database> database(String table) async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath,
          'places.db'), // Opens the existing database at the path specified, else creates one there.
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE $table(id TEXT PRIMARY KEY, title TEXT, image TEXT, loc_lat REAL, loc_lng REAL, address TEXT)');
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database(table);
    await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm
          .replace, // If the row already exists, overwrite data in that row.
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async{
    final db = await DBHelper.database(table);
    return db.query(table);
  }
}
