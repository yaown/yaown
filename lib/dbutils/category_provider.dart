import 'dart:async';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:yaown/dbutils/interfaces/db_interface.dart';
import 'package:yaown/dbutils/interfaces/exceptions.dart';
import 'package:yaown/dbutils/interfaces/record_fields.dart';
import 'package:yaown/dbutils/interfaces/record_interface.dart';
import 'package:yaown/dbutils/interfaces/record_provider.dart';

class CategoryProvider extends DBInterface with RecordProvider<Category> {

  //-------------------- Singleton --------------------
  factory CategoryProvider() {
    if(_this == null) _this = CategoryProvider._instance();
    return _this;
  }

  static CategoryProvider _this;
  CategoryProvider._instance(): super();
  //---------------------------------------------------

  @override
  Future<String> get dir async =>
      (await getApplicationDocumentsDirectory()).path;

  @override
  String get file => "database";

  @override
  int get version => 1;

  @override
  String get tableName => Category().tableName;

  @override
  Future onCreate(Database db, int version) async {
    return await db.execute(Category().createTable);
  }

  @override
  Future<List<Category>> init() async {
    await super.init();
    var res = await query(tableName);
    return res.isNotEmpty ? res.map((c) => Category._fromMap(c)).toList() : [];
  }

  @override
  Future<Category> newRecord({String name, int parent}) async {
    Category category = Category._(await generateId(), name: name, parent: parent);
    await CategoryProvider().add(category);
    return category;
  }

  @override
  Future<List<Category>> clear() async {
    final List<Category> categories = await super.clear();
    categories.forEach((category) => category._immutable = true);
    return categories;
  }

  @override
  Future<List<Category>> close() async {
    final List<Category> categories = await super.close();
    categories.forEach((category) => category._immutable = true);
    return categories;
  }

}

class Category extends RecordInterface {

  //-------------------- Singleton --------------------
  factory Category() {
    if(_this == null) _this = Category._instance();
    return  _this;
  }

  static Category _this;
  Category._instance() {
    this._id = SqlId(-1);
    this._name = SqlText("name");
    this._parent = SqlInt("parent");
  }

  @override
  String get tableName => "Category";

  @override
  String get createTable => RecordEntry.generateCreateTable(
      tableName, [_id, _name, _parent]
  );
  //---------------------------------------------------

  SqlId _id;
  SqlText _name;
  SqlInt _parent;
  bool _immutable = false;

  Category._(int id, {String name, int parent}) {
    this._id = SqlId(id);
    this._name = SqlText("name",
        value: name,
        onSet: (_) async => await CategoryProvider().refresh(this)
    );
    this._parent = SqlInt("parent",
        value: parent,
        onSet: (_) async => await CategoryProvider().refresh(this)
    );
  }

  int get id => _id.value;
  String get name => _name.value;
  int get parent => _parent.value;
  bool get immutable => _immutable;

  Future setName(String name) async {
    if(immutable) throw new RecordIsImmutable();
    await _name.setValue(name);
  }

  Future setParent(int parent) async {
    if(immutable) throw new RecordIsImmutable();
    await _parent.setValue(parent);
  }

  factory Category._fromMap(Map<String, dynamic> map) => new Category._(
      map["id"],
      name: map["name"],
      parent: map["parent"]
  );

  @override
  Future destroy() async {
    // remove as parent from other records
    List<Category> categories = await CategoryProvider().getAll();
    for(Category category in categories)
      if(category.parent == this.id)
        await category.setParent(null);

    this._immutable = true;
    return await CategoryProvider().remove(this);
  }

  @override
  Map<String, dynamic> asMap() => {
    "id": id,
    "name": name,
    "parent": parent
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
      runtimeType == other.runtimeType &&
      id == other.id &&
      name == other.name &&
      parent == other.parent;

  @override
  int get hashCode => _id.hashCode ^ _name.hashCode ^ _parent.hashCode;

}
