import 'dart:ffi';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class NoteDbHelper {
  static const String dbName = 'notes.db';
  static const int dbVersion = 1;
  static const String tableName = 'notes';
  static const String colId = 'id';
  static const String colTitle = 'title';
  static const String colDescription = 'description';
  static const String colCreatedAt = 'createdAt';

  static final NoteDbHelper instance = NoteDbHelper() as NoteDbHelper;

  static Database? notedb;

  Future<Database?> get db async {
    notedb ??= await _initDb();
    return notedb;
  }

  _initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = p.join(documentsDirectory.path, dbName);
    return await openDatabase(path, version: dbVersion, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute(''' CREATE TABLE $tableName(
      $colId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      $colTitle TEXT,
      $colDescription TEXT,
    ) ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.db;
    return await db!.insert(tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database? db = await instance.db;
    return await db!.query(tableName);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.db;
    int id = row[colId];
    return await db!
        .update(tableName, row, where: '$colId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database? db = await instance.db;

    return await db!.delete(tableName, where: '$colId = ?', whereArgs: [id]);
  }

  Future close() async {
    Database? db = await instance.db;
    db!.close();
  }
}
