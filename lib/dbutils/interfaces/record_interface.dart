
abstract class RecordInterface {

  int get id;

  bool get immutable;

  Future destroy();

  bool isMutable() {
    if(immutable)
      throw("Entry is immutable");
    return true;
  }

  String get createTable;

  String get tableName;

  Map<String, dynamic> asMap();

}