import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:finances/finance/models/category_budget.dart';
import 'package:finances/finance/models/transaction.dart';
import 'package:finances/finance/repository/firestore_finance_repository.dart';

part 'finance_event.dart';
part 'finance_state.dart';

class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  FinanceBloc({
    required this._repository,
    required this.limits,
  }) : activeMonth = DateTime.now().month,
       super(FinanceInitial()) {
    on<FinanceSubscriptionRequested>(_onSubscriptionRequested);
    on<FinanceTransactionAdded>(_onTransactionAdded);
  }

  final FirestoreFinanceRepository _repository;
  final Map<String, double> limits;
  final int activeMonth;

  Future<void> _onSubscriptionRequested(
    FinanceSubscriptionRequested event,
    Emitter<FinanceState> emit,
  ) async {
    emit(FinanceLoading());
    try {
      await emit.forEach<List<Transaction>>(
        _repository.watchTransactions(),
        onData: (transactions) => _buildLoadedState(transactions),
        onError: (error, _) => FinanceError(error.toString()),
      );
    } catch (e) {
      emit(FinanceError(e.toString()));
    }
  }

  void _onTransactionAdded(
    FinanceTransactionAdded event,
    Emitter<FinanceState> emit,
  ) {
    _repository.addTransaction(event.transaction);
  }

  FinanceLoaded _buildLoadedState(List<Transaction> transactions) {
    final now = DateTime.now();
    final year = now.year;
    final daysInMonth = DateTime(year, activeMonth + 1, 0).day;
    final daysElapsed = now.month == activeMonth ? now.day : daysInMonth;
    final targetPercentage = daysElapsed / daysInMonth;

    final monthlyTransactions = transactions.where((t) {
      return t.date.year == year && t.date.month == activeMonth;
    });

    final spentByCategory = <String, double>{};
    for (final t in monthlyTransactions) {
      spentByCategory[t.category] = (spentByCategory[t.category] ?? 0) + t.value;
    }

    final categoryBudgets = limits.entries.map((entry) {
      final category = entry.key;
      final limit = entry.value;
      final spent = spentByCategory[category] ?? 0;
      final percentage = limit > 0 ? spent / limit : 0.0;
      final previsto = targetPercentage * limit;

      return CategoryBudget(
        category: category,
        spent: spent,
        limit: limit,
        percentage: percentage,
        targetPercentage: targetPercentage,
        previsto: previsto,
      );
    }).toList();

    return FinanceLoaded(
      transactions: transactions,
      activeMonth: activeMonth,
      categoryBudgets: categoryBudgets,
    );
  }
}
