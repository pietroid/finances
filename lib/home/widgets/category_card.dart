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
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(category, style: textTheme.headlineSmall),
          ProgressBar(percentage: 0.1),
          ProgressBar(percentage: 0.1),
        ],
      ),
    );
  }
}
