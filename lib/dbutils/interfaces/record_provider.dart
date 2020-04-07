import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:yaown/dbutils/interfaces/db_interface.dart';
import 'package:yaown/dbutils/interfaces/record_interface.dart';

mixin RecordProvider<T extends RecordInterface> on DBInterface {

  List<T> _records;

  @mustCallSuper
  Future<List<T>> get records async {
    if(_records == null)
      _records = await init();
    return _records;
  }

  /// NEEDS TO BE OVERWRITTEN !!!
  @override
  @mustCallSuper
  Future<List<T>> init() async {
    await super.init();
    return null;
  }

  String get tableName;

  @mustCallSuper
  Future<List<T>> clear() async {
    List<T> _records = List.from(await records);
    this._records.clear();
    _records.forEach((record) async => await this.remove(record));
    return _records;
  }

  @override
  @mustCallSuper
  Future<List<T>> close() async {
    await super.close();
    final List<T> _records = List.from(await records);
    this._records = null;
    return _records;
  }

  Future<List<T>> getAll() async {
    return List.from(await records);
  }

  Future<T> get(int id) async {
    final List<T> _records = await records;
    return _records.firstWhere(
        (record) => record.id == id,
        orElse: null
    );
  }

  // must call add
  Future<T> newRecord();

  @mustCallSuper
  Future<int> add(T record) async {
    int res = await super.insert(tableName, record.asMap());
    final List<T> _records = await records;
    if(!_records.contains(record))
      _records.add(record);
    return res;
  }

  @mustCallSuper
  Future<int> refresh(T record) async {
    return await super.update(tableName, record.asMap(), where: "id = ?", whereArgs: [record.id]);
  }

  @mustCallSuper
  Future<T> remove(T record) async {
    final _records = await records;
    if(_records.contains(record)) {
      await super.delete(
          tableName,
          where: "id = ?",
          whereArgs: [record.id]
      );
      _records.remove(record);
    }
    return record;
  }

  @mustCallSuper
  Future<T> removeById(int id) async {
    final _records = await get(id);
    return remove(_records);
  }

  Future generateId() async {
    final _records = await records;
    var id = 0;
    while(_records.any((records) => records.id == id))
      id++;
    return id;
  }

}
