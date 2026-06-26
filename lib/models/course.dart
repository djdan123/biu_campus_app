class Course {
  String id;
  String code;
  String name;
  String description;
  String teacherId; // ID de l'enseignant responsable
  int totalHours;
  String department;
  List<String> studentIds; // étudiants inscrits
  List<String> syllabusItemIds;
  List<String> assignmentIds; // pour les TP
  List<String> examIds;

  Course({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.teacherId,
    required this.totalHours,
    required this.department,
    this.studentIds = const [],
    this.syllabusItemIds = const [],
    this.assignmentIds = const [],
    this.examIds = const [],
  });
}