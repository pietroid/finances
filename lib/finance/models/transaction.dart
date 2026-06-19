class Transaction {
  const Transaction({
    required this.id,
    required this.category,
    required this.value,
    required this.date,
    required this.description,
  });

  final String id;
  final String category;
  final double value;
  final DateTime date;
  final String description;
}
