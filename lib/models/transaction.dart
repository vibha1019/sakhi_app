enum TransactionType { income, expense }  // ← must be in this file

class Transaction {
  final String? id;
  final TransactionType type;
  final double amount;
  final String description;
  final DateTime date;

  Transaction({
    this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
  });
}