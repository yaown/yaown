
/// Top class holding unimplemented methods
/// that are needed for table creation
abstract class RecordEntry {

  String get entryName;

  String get entryType;

  String get entryString => "$entryName $entryType";

  static String generateCreateTable(String tableName, List<RecordEntry> entries) {
    var buffer = StringBuffer();
    buffer.write("CREATE TABLE $tableName (");
    buffer.write(entries.map((entry) => entry.entryString).join(","));
    buffer.write(")");
    return buffer.toString();
  }

}

/// Mixin class that holds a generic
/// value, with getter and setter.
mixin SingleValue<T> on RecordEntry {

  T _value;
  Function(T) _onSet;

  Future setValue(T value) async {
    this._value = value;
    return onSet != null ? await onSet(value) : null;
  }

  T get value => _value;

  Function(T) get onSet => _onSet;



}

/// Mixin class that holds a list
/// of generic values, with getters and setters
mixin ListValue<T> on RecordEntry {

  List<T> _values;
  Function(Change, T) _onChange;

  Future addValue(T value) async {
    this._values.add(value);
    return onChange != null ? await onChange(Change.ADD, value) : null;
  }

  Future removeValue(T value) async {
    this._values.remove(value);
    return onChange != null ? await onChange(Change.REMOVE, value) : null;
  }

  List<T> get values => List.from(_values);

  Function(Change, T) get onChange => _onChange;

}
/// Enum for that onChange function of the mixin ListValue
enum Change { ADD, REMOVE }

/// Implementation that creates a SQL id field
class SqlId extends RecordEntry with SingleValue<int> {

  SqlId(value, {onSet}) {
    this._value = value;
    this._onSet = onSet;
  }

  @override
  String get entryName => "id";

  @override
  String get entryType => "INTEGER PRIMARY KEY";

}

/// Implementation that creates a SQL text field
class SqlText extends RecordEntry with SingleValue<String> {

  final String _entryName;

  SqlText(this._entryName, {value, onSet}) {
    this._value = value;
    this._onSet = onSet;
  }

  @override
  String get entryName => _entryName;

  @override
  String get entryType => "TEXT";

}

/// Implementation that creates a SQL int field
class SqlInt extends RecordEntry with SingleValue<int> {

  final String _entryName;

  SqlInt(this._entryName, {value, onSet}) {
    this._value = value;
    this._onSet = onSet;
  }

  @override
  String get entryName => _entryName;

  @override
  String get entryType => "INTEGER";

}
