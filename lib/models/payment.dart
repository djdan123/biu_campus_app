class Payment {
  String id;
  String studentId;
  double amount;
  DateTime date;
  String status; // "paid", "unpaid", "partial"
  String description;

  Payment({
    required this.id,
    required this.studentId,
    required this.amount,
    required this.date,
    required this.status,
    required this.description,
  });
}