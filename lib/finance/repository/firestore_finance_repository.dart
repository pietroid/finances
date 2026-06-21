import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:finances/finance/models/transaction.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreFinanceRepository {
  final _transactions = <Transaction>[];
  final _subject = BehaviorSubject<List<Transaction>>.seeded(const []);
  final _collection = FirebaseFirestore.instance.collection('transactions');

  FirestoreFinanceRepository() {
    _listenToTransactions();
  }

  void _listenToTransactions() {
    _collection.snapshots().listen((snapshot) {
      final transactions = snapshot.docs.map((doc) {
        final data = doc.data();
        return Transaction(
          id: doc.id,
          category: data['category'] as String,
          value: (data['value'] as num).toDouble(),
          date: (data['date'] as Timestamp).toDate(),
          description: data['description'] as String,
        );
      }).toList();

      transactions.sort((a, b) => b.date.compareTo(a.date));

      _transactions.clear();
      _transactions.addAll(transactions);
      _subject.add(List.unmodifiable(_transactions));
    });
  }

  Stream<List<Transaction>> watchTransactions() => _subject.stream;

  Future<void> addTransaction(Transaction transaction) async {
    await _collection.add({
      'category': transaction.category,
      'value': transaction.value,
      'date': Timestamp.fromDate(transaction.date),
      'description': transaction.description,
    });
  }

  Future<void> deleteTransaction(String transactionId) async {
    await _collection.doc(transactionId).delete();
  }
}
