class Grade {
  String id;
  String studentId;
  String courseId;
  double? assignmentScore; // note TP
  double? examScore;       // note examen
  double? finalScore;      // calculée
  String? letterGrade;     // A, B, C, D, F

  Grade({
    required this.id,
    required this.studentId,
    required this.courseId,
    this.assignmentScore,
    this.examScore,
    this.finalScore,
    this.letterGrade,
  });

  void computeFinal() {
    if (assignmentScore != null && examScore != null) {
      finalScore = (assignmentScore! * 0.4) + (examScore! * 0.6);
      // Attribution lettre
      if (finalScore! >= 90) {
        letterGrade = 'A';
      } else if (finalScore! >= 80) letterGrade = 'B';
      else if (finalScore! >= 70) letterGrade = 'C';
      else if (finalScore! >= 60) letterGrade = 'D';
      else letterGrade = 'F';
    }
  }
}