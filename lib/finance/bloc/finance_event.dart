part of 'finance_bloc.dart';

@immutable
sealed class FinanceEvent {}

final class FinanceSubscriptionRequested extends FinanceEvent {}

final class FinanceTransactionAdded extends FinanceEvent {
  FinanceTransactionAdded(this.transaction);
  final Transaction transaction;
}
