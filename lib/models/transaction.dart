import 'dart:math';

///* We will create new class for using transactions and we will use it in our app.

class Transaction {
  //* We will use id as identify for each transaction. * 000001 - 000010 - 000011 et cetera.
  //* So those are the keys for identifying each transaction.
  //* And DateTime is a class that holds the date and time. To track when we spend money.
  final String id;
  final String name;
  final double amount;
  final DateTime date;

  const Transaction({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
  });
  static int get generateId {
    return Random().nextInt(100000);
  }
}
