import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/transaction.dart';
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Each user gets their own transactions subcollection
  CollectionReference get _transactionsRef {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return _db.collection('users').doc(uid).collection('transactions');
  }

  // Add a transaction
  Future<void> addTransaction(Transaction transaction) async {
    await _transactionsRef.add({
      'type': transaction.type.name, // 'income' or 'expense'
      'amount': transaction.amount,
      'description': transaction.description,
      'date': Timestamp.fromDate(transaction.date),
    });
  }

  // Real-time stream of transactions
  Stream<List<Transaction>> getTransactions() {
    return _transactionsRef
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return Transaction(
                id: doc.id, // add this field to your model
                type: data['type'] == 'income'
                    ? TransactionType.income
                    : TransactionType.expense,
                amount: (data['amount'] as num).toDouble(),
                description: data['description'],
                date: (data['date'] as Timestamp).toDate(),
              );
            }).toList());
  }

  // Delete a transaction
  Future<void> deleteTransaction(String id) async {
    await _transactionsRef.doc(id).delete();
  }
}