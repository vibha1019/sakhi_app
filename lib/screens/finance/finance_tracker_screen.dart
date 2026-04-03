import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/transaction.dart';
import '../../services/firestore_service.dart';

class FinanceTrackerScreen extends StatefulWidget {
  const FinanceTrackerScreen({super.key});

  @override
  State<FinanceTrackerScreen> createState() => _FinanceTrackerScreenState();
}

class _FinanceTrackerScreenState extends State<FinanceTrackerScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Date filter coming soon!')),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Transaction>>(
        stream: _firestoreService.getTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final transactions = snapshot.data ?? [];

          final totalIncome = transactions
              .where((t) => t.type == TransactionType.income)
              .fold(0.0, (sum, t) => sum + t.amount);

          final totalExpense = transactions
              .where((t) => t.type == TransactionType.expense)
              .fold(0.0, (sum, t) => sum + t.amount);

          final balance = totalIncome - totalExpense;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Summary Cards
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF06D6A0).withOpacity(0.1),
                  ),
                  child: Column(
                    children: [
                      // Balance Card
                      Card(
                        elevation: 4,
                        color: const Color(0xFF06D6A0),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text(
                                'Current Balance',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Colors.white70,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '₹${balance.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Income & Expense Cards
                      Row(
                        children: [
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    const Icon(Icons.arrow_downward,
                                        color: Color(0xFF06D6A0), size: 32),
                                    const SizedBox(height: 8),
                                    Text('Income',
                                        style: Theme.of(context).textTheme.bodyMedium),
                                    const SizedBox(height: 4),
                                    Text(
                                      '₹${totalIncome.toStringAsFixed(2)}',
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                            color: const Color(0xFF06D6A0),
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    const Icon(Icons.arrow_upward,
                                        color: Color(0xFFE63946), size: 32),
                                    const SizedBox(height: 8),
                                    Text('Expenses',
                                        style: Theme.of(context).textTheme.bodyMedium),
                                    const SizedBox(height: 4),
                                    Text(
                                      '₹${totalExpense.toStringAsFixed(2)}',
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                            color: const Color(0xFFE63946),
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Transactions List
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Transactions',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),

                      if (transactions.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              children: [
                                Icon(Icons.receipt_long,
                                    size: 64, color: Colors.grey[300]),
                                const SizedBox(height: 16),
                                Text(
                                  'No transactions yet.\nTap + to add your first one!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Transaction Items
                      ...transactions.map((transaction) {
                        return _TransactionItem(
                          transaction: transaction,
                          onDelete: () =>
                              _firestoreService.deleteTransaction(transaction.id!),
                        );
                      }),

                      const SizedBox(height: 16),

                      // Voice Input Button (placeholder for now)
                      Card(
                        color: const Color(0xFF6B4CE6).withOpacity(0.1),
                        child: InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Voice input coming soon!'),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                const Icon(Icons.mic,
                                    color: Color(0xFF6B4CE6), size: 32),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Try Voice Input',
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                      Text(
                                        'Say "I earned 200 rupees today"',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTransactionDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Transaction'),
        backgroundColor: const Color(0xFF06D6A0),
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    TransactionType selectedType = TransactionType.income;
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Transaction'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Income / Expense Toggle
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setDialogState(
                          () => selectedType = TransactionType.income),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedType == TransactionType.income
                              ? const Color(0xFF06D6A0)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '+ Income',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: selectedType == TransactionType.income
                                ? Colors.white
                                : Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setDialogState(
                          () => selectedType = TransactionType.expense),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedType == TransactionType.expense
                              ? const Color(0xFFE63946)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '- Expense',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: selectedType == TransactionType.expense
                                ? Colors.white
                                : Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Amount Field
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount (₹)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
              ),
              const SizedBox(height: 12),

              // Description Field
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.notes),
                  hintText: 'e.g. Sold embroidered saree',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF06D6A0),
              ),
              onPressed: isLoading
                  ? null
                  : () async {
                      final amount = double.tryParse(amountController.text.trim());
                      final description = descriptionController.text.trim();

                      if (amount == null || amount <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a valid amount')),
                        );
                        return;
                      }
                      if (description.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a description')),
                        );
                        return;
                      }

                      setDialogState(() => isLoading = true);

                      await _firestoreService.addTransaction(
                        Transaction(
                          type: selectedType,
                          amount: amount,
                          description: description,
                          date: DateTime.now(),
                        ),
                      );

                      if (context.mounted) Navigator.pop(context);
                    },
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onDelete;

  const _TransactionItem({required this.transaction, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? const Color(0xFF06D6A0) : const Color(0xFFE63946);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: color,
          ),
        ),
        title: Text(
          transaction.description,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          _formatDate(transaction.date),
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${isIncome ? '+' : '-'}₹${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            // Swipe or long press to delete
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.grey[400], size: 20),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inHours < 1) return '${difference.inMinutes} minutes ago';
    if (difference.inHours < 24) return '${difference.inHours} hours ago';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}