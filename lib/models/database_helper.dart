import 'dart:async';
import 'usr.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tableUsr = 'Water';
  final String columnId = 'id';
  final String image = 'image';
  final String pointLat = 'pointLat';
  final String pointLng = 'pointLng';

  static Database _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'Water.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableUsr($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $image TEXT, $pointLng TEXT, $pointLat TEXT)');
  }

  Future<int> saveUsr(Usr usr) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableUsr, usr.toMap());
//    var result = await dbClient.rawInsert(
//        'INSERT INTO $tableUsr ($columnTitle, $columnDescription) VALUES (\'${usr.title}\', \'${usr.description}\')');

    return result;
  }

  Future<List> getAllUsrs() async {
    var dbClient = await db;
    var result = await dbClient
        .query(tableUsr, columns: [columnId, image, pointLng, pointLat]);
//    var result = await dbClient.rawQuery('SELECT * FROM $tableUsr');
    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM $tableUsr'));
  }

  Future<Usr> getUsr(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableUsr,
        columns: [columnId, image, pointLng, pointLat],
        where: '$columnId = ?',
        whereArgs: [id]);
//    var result = await dbClient.rawQuery('SELECT * FROM $tableUsr WHERE $columnId = $id');

    if (result.length > 0) {
      return new Usr.fromMap(result.first);
    }

    return null;
  }

  Future<int> deleteUsr(String images) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableUsr, where: '$image = ?', whereArgs: [images]);
//    return await dbClient.rawDelete('DELETE FROM $tableUsr WHERE $columnId = $id');
  }

  Future<int> updateUsr(Usr usr) async {
    var dbClient = await db;
    return await dbClient.update(tableUsr, usr.toMap(),
        where: "$columnId = ?", whereArgs: [usr.id]);
//    return await dbClient.rawUpdate(
//        'UPDATE $tableUsr SET $columnTitle = \'${usr.title}\', $columnDescription = \'${usr.description}\' WHERE $columnId = ${usr.id}');
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
