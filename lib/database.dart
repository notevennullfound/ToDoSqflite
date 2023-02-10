import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {
  static const dbName = 'myDatabase.db';
  static const dbVersion = 1;
  static const dbTable = 'myTable';
  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnDescription = 'description';

  static Future<void> createTable(sql.Database database) async {
    await database.execute("""
      CREATE TABLE $dbTable(
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      $columnTitle TEXT,
      $columnDescription TEXT,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(dbName, version: dbVersion,
        onCreate: (sql.Database database, int version) async {
          await createTable(database);
        });
  }

  static Future<int> createItem(String title, String desc) async {
    final db = await DatabaseHelper.db();
    final data = {columnTitle: title, columnDescription: desc};
    final id = await db.insert(dbTable, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    print(id.toString());
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await DatabaseHelper.db();
    return db.query(dbTable, orderBy: columnId);
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await DatabaseHelper.db();
    return db.query(dbTable, where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(int id, String title, String desc) async {
    final db = await DatabaseHelper.db();

    final data = {
      columnTitle: title,
      columnDescription: desc,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update(dbTable, data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<int> deleteItem(int id) async {
    final db = await DatabaseHelper.db();

    final result = db.delete(dbTable, where: "id = ?", whereArgs: [id]);
    return result;
  }


}
