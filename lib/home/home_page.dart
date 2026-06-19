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
                return ListTile(
                  title: Text(transaction.description),
                  subtitle: Text(transaction.category),
                  trailing: Text(
                    'R\$ ${transaction.value.toStringAsFixed(2).replaceAll('.', ',')}',
                  ),
                );
              },
            ),
          ),
          FinanceError() => Center(
            child: Text(state.message),
          ),
        };
      },
    );
  }
}
