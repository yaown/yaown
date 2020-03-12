import 'dart:ui';

class Account {
  final int id;
  int userID;
  String name;
  double balance;
  Currency currency;

  List<Transaction> transactions;

  Account(this.id);

}

// maybe rename this to something more meaningful
class Category {
  final int id;
  String name;
  Category parent;
  List<Category> children;

  List<Transaction> transactions;

  Category(this.id);

}

class Transaction {
  final int id;
  final double amount;
  final Account account;
  final Partner partner;
  Category category;
  Receipt receipt;
  Currency currency;
  DateTime dateTime;
  // GeoTag geotag; // this will get its own class
  String name;
  String description;

  Transaction(this.id, this.amount, this.account, this.partner);

}

class Receipt {
  final int id;
  //final Image receipt_image; // wont need a image i guess
  final String name;
  final DateTime dateTime;

  Transaction transaction;

  Receipt(this.id, this.name, this.dateTime);
}

class Partner {
  final int id;
  String name;
  String address;
  String bankAccount;

  List<Transaction> transactions;

  Partner(this.id);


}


enum Currency {
  EUR, DLR
}