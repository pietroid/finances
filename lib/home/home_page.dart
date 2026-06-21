import 'package:app_ui/app_ui.dart';
import 'package:finances/finance/bloc/finance_bloc.dart';
import 'package:finances/finance/models/category_budget.dart';
import 'package:finances/home/widgets/category_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: BlocBuilder<FinanceBloc, FinanceState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.small,
                children: [
                  if (state is FinanceLoaded) ...[
                    CategoryCard(
                      budget: _budgetFor(state.categoryBudgets, "Básico"),
                    ),
                    CategoryCard(
                      budget: _budgetFor(state.categoryBudgets, "Compras"),
                    ),
                    CategoryCard(
                      budget: _budgetFor(state.categoryBudgets, "Lazer"),
                    ),
                  ],
                  SizedBox(height: AppSpacing.small),
                  Text(
                    'Transações Recentes',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const _TransactionsList(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  CategoryBudget _budgetFor(List<CategoryBudget> budgets, String category) {
    return budgets.firstWhere((b) => b.category == category);
  }
}

class _TransactionsList extends StatelessWidget {
  const _TransactionsList();

  String dayOfTheWeek(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Seg';
      case DateTime.tuesday:
        return 'Ter';
      case DateTime.wednesday:
        return 'Qua';
      case DateTime.thursday:
        return 'Qui';
      case DateTime.friday:
        return 'Sex';
      case DateTime.saturday:
        return 'Sáb';
      case DateTime.sunday:
        return 'Dom';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinanceBloc, FinanceState>(
      builder: (context, state) {
        return switch (state) {
          FinanceInitial() || FinanceLoading() => const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.medium),
              child: CircularProgressIndicator(),
            ),
          ),
          FinanceLoaded() => Expanded(
            child: ListView.builder(
              itemCount: state.transactions.length,
              itemBuilder: (context, index) {
                final transaction = state.transactions[index];
                return Dismissible(
                  key: Key(transaction.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: AppSpacing.medium),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    context.read<FinanceBloc>().add(
                      FinanceTransactionDeleted(transaction.id),
                    );
                  },
                  child: ListTile(
                    leading: SizedBox(
                      width: 40,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            transaction.date.day.toString().padLeft(2, '0'),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            dayOfTheWeek(transaction.date.weekday),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    title: Text(transaction.description),
                    subtitle: Text(transaction.category),
                    trailing: Text(
                      'R\$ ${transaction.value.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                );
              },
            ),
          ),
          FinanceError() => Center(child: Text(state.message)),
        };
      },
    );
  }
}
