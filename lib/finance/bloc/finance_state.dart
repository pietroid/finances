part of 'finance_bloc.dart';

@immutable
sealed class FinanceState {}

final class FinanceInitial extends FinanceState {}

final class FinanceLoading extends FinanceState {}

final class FinanceLoaded extends FinanceState {
  FinanceLoaded({
    required this.transactions,
    required this.activeMonth,
    required this.categoryBudgets,
  });

  final List<Transaction> transactions;
  final int activeMonth;
  final List<CategoryBudget> categoryBudgets;
}

final class FinanceError extends FinanceState {
  FinanceError(this.message);
  final String message;
}
