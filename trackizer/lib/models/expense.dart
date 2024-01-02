class Expense {
  final int id;
  final String title;
  final double amount;
  final String date;
  final int category;
  final int account;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.account,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      title: json['title'],
      amount: double.parse(json['amount']),
      date: json['date'],
      category: json['category'],
      account: json['account'],
    );
  }
}
