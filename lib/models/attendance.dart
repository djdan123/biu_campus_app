class Attendance {
  String id;
  String studentId;
  String courseId;
  DateTime date;
  String status; // "present", "absent", "excused"

  Attendance({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.date,
    required this.status,
  });
}