import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final String dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'videos.db'),
        onCreate: (Database db, int version) {
      return db.execute(
          'CREATE TABLE user_videos(id TEXT PRIMARY KEY, mood TEXT, thumbnailPath TEXT, videoPath TEXT, loc_lat REAL, loc_lng REAL, address TEXT)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final Database db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> delete(String id) async {
    final Database db = await DBHelper.database();
    return await db.delete('user_videos', where: 'id = ?', whereArgs: <String>[id]);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final Database db = await DBHelper.database();
    return db.query(table);
  }
}
