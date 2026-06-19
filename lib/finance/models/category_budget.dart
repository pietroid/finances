class CategoryBudget {
  const CategoryBudget({
    required this.category,
    required this.spent,
    required this.limit,
    required this.percentage,
    required this.targetPercentage,
    required this.previsto,
  });

  final String category;
  final double spent;
  final double limit;
  final double percentage;
  final double targetPercentage;
  final double previsto;
}
