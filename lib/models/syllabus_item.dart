class SyllabusItem {
  String id;
  String courseId;
  String title;
  String description;
  int weekNumber; // semaine concernée

  SyllabusItem({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.weekNumber,
  });
}