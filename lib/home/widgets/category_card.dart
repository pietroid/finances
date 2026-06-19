import 'package:app_ui/app_ui.dart';
import 'package:finances/home/widgets/add_transaction_bottom_sheet.dart';
import 'package:finances/home/widgets/progress_bar.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category});

  final String category;

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
              Text(category, style: textTheme.headlineSmall),
              Spacer(),
              GestureDetector(
                onTap: () {
                  AddTransactionBottomSheet.show(context, category: category);
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
          ProgressBar(percentage: 0.2, targetPercentage: 0.1),
          SizedBox(height: AppSpacing.small),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Gasto:", style: textTheme.bodySmall),
              Text("R\$ 200,00", style: textTheme.bodySmall),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Previsto:", style: textTheme.bodySmall),
              Text("R\$ 200,00", style: textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
