import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class DBInterface {

  static Database _database;

  Future<Database> get database async {
    if(_database == null)
      await init();
    return _database;
  }

  String get file;

  int get version;

  Future<String> get dir;

  bool get open => _database != null && _database.isOpen;

  bool get closed => _database == null || !_database.isOpen;

  Future onCreate(Database db, int version);

  Future onConfigure(Database db) => Future.value();

  Future onOpen(Database db) => Future.value();

  Future onUpgrade(Database db, int oldVersion, int newVersion) => Future.value();

  Future onDowngrade(Database db, int oldVersion, int newVersion) => Future.value();

  @mustCallSuper
  Future init() async {
    if(_database == null)
      _database = await openDatabase(
        join((await dir), file),
        version: version,
        onCreate: onCreate,
        onConfigure: onConfigure,
        onOpen: onOpen,
        onUpgrade: onUpgrade,
        onDowngrade: onDowngrade
      );
  }

  @mustCallSuper
  Future<List<Map<String, dynamic>>> query(
      String table,
      {
        bool distinct,
        List<String> columns,
        String where,
        List<dynamic> whereArgs,
        String groupBy,
        String having,
        String orderBy,
        int limit,
        int offset
      }
  ) async {
    final db = await database;
    return await db.query(
        table,
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset
    );
  }

  @mustCallSuper
  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return await db.insert(table, values);
  }

  @mustCallSuper
  Future<int> update(String table, Map<String, dynamic> values, {String where, List<dynamic> whereArgs}) async {
    final db = await database;
    return await db.update(table, values, where: where, whereArgs: whereArgs);
  }

  @mustCallSuper
  Future<int> delete(String table, {String where, List<dynamic> whereArgs}) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  @mustCallSuper
  Future<void> close() async {
    if(open)
      await _database.close();
    _database = null;
  }

}