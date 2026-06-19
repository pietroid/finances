import 'package:app_ui/app_ui.dart';
import 'package:finances/finance/models/category_budget.dart';
import 'package:finances/home/widgets/add_transaction_bottom_sheet.dart';
import 'package:finances/home/widgets/progress_bar.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.budget});

  final CategoryBudget budget;

  String _formatCurrency(double value) {
    final formatted = value.toStringAsFixed(2).replaceAll('.', ',');
    return 'R\$ $formatted';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(budget.category, style: textTheme.headlineSmall),
              Spacer(),
              GestureDetector(
                onTap: () {
                  AddTransactionBottomSheet.show(
                    context,
                    category: budget.category,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(Icons.add, size: 18),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.small),
          ProgressBar(
            percentage: budget.percentage,
            targetPercentage: budget.targetPercentage,
          ),
          SizedBox(height: AppSpacing.small),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Gasto:", style: textTheme.bodySmall),
              Text(_formatCurrency(budget.spent), style: textTheme.bodySmall),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Previsto:", style: textTheme.bodySmall),
              Text(
                _formatCurrency(budget.previsto),
                style: textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
