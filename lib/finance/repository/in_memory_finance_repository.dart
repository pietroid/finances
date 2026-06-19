import 'package:finances/finance/models/transaction.dart';
import 'package:rxdart/rxdart.dart';

class InMemoryFinanceRepository {
  final _transactions = <Transaction>[];
  final _subject = BehaviorSubject<List<Transaction>>.seeded(const []);

  Stream<List<Transaction>> watchTransactions() => _subject.stream;

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    _subject.add(List.unmodifiable(_transactions));
  }
}
