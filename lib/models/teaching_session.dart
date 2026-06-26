class TeachingSession {
  String id;
  String teacherId;
  String courseId;
  DateTime date;
  int duration; // en heures
  String topic;

  TeachingSession({
    required this.id,
    required this.teacherId,
    required this.courseId,
    required this.date,
    required this.duration,
    required this.topic,
  });
}