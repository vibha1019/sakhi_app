enum TransactionType { income, expense }

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
