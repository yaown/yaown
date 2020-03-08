/*
@MaxL
08032020
v.1
*/

import 'package:flutter/cupertino.dart';

enum Currency {
  EUR,
  USD,
  GBP
}

// Klasse der Accounts
class Account{
  //----------------------------------------------------------------------------region variables
  final int account_id;
  final String name;
  double balance;
  double start_date;
  // ignore: non_constant_identifier_names
  int fk_user_id; //foreign key
  Type currency = Currency; // enum
  //------------------------------------------------------------------------------endregion variables

  //------------------------------------------------------------------------------region methods
  double deposit(double amount) => balance = balance + amount;
  double withdraw(double amount) => balance = balance - amount;
  //------------------------------------------------------------------------------end region methods
}

//Klasse Transaktionen auf Konten
// TRX = Transaction Business >> Accounting
class Transaction {
  //-------------------------------------------------------------------------------------- region Variables
  final int trx_id;
  int name;
  double trx_amount;
  Type currency = Currency; // enum
  double trx_time; //Zeitpunkt der Transaktion
  String geo_tag; //Location  of the device
  String desciption;
  //----------------------------------------------------------------------------------- endregion Variables

  //--------------------------------------------------------------------------------- region Initialization

  //------------------------------------------------------------------------------ endregion Initialization
}

class Category extends Account{
  //-------------------------------------------------------------------------------------- region Variables
  final int category_id;
  int fk_category_id; //parent
  var sub_categories = new List<int>(); //child
  //----------------------------------------------------------------------------------- endregion Variables
}
//Can be any kind of Document including Receipts
class Document{
  //-------------------------------------------------------------------------------------- region Variables
  final int document_id;
  String name;
  Image document_image; //Repräsentation?
  //----------------------------------------------------------------------------------- endregion Variables

}

//Partner sind Debitoren und Kreditoren auch deine Mutter!
class Partner{
  final int partner_id;
  String name;
  String address;
  String bankaccount;

}

