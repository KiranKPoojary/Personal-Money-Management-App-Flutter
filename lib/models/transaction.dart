class TransactionModel {
  int? id;
  String title;
  double amount;
  String date; // You can later switch to DateTime if needed
  String type; // 'income' or 'expense'

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
  });

  // For printing or debugging
  @override
  String toString() {
    return 'TransactionModel(id: $id, title: $title, amount: $amount, date: $date, type: $type)';
  }

  // For JSON encoding/decoding if needed (e.g., Hive, SQLite, APIs)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date,
      'type': type,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: map['date'],
      type: map['type'],
    );
  }
}
