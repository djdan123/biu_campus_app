import 'package:flutter/material.dart'; // Ajout pour TimeOfDay
import '../models/student.dart';
import '../models/teacher.dart';
import '../models/course.dart';
import '../models/schedule.dart';
import '../models/payment.dart';
import '../models/grade.dart';
import '../models/attendance.dart';
import '../models/syllabus_item.dart';
import '../models/teaching_session.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  // Listes principales
  List<Student> students = [];
  List<Teacher> teachers = [];
  List<Course> courses = [];
  List<Schedule> schedules = [];
  List<Payment> payments = [];
  List<Grade> grades = [];
  List<Attendance> attendances = [];
  List<SyllabusItem> syllabusItems = [];
  List<TeachingSession> teachingSessions = [];

  // Compteurs pour IDs
  int _studentCounter = 1;
  int _teacherCounter = 1;
  int _courseCounter = 1;
  int _scheduleCounter = 1;
  int _paymentCounter = 1;
  int _gradeCounter = 1;
  int _attendanceCounter = 1;
  int _syllabusCounter = 1;
  int _teachingSessionCounter = 1;

  void initData() {
    students.clear();
    teachers.clear();
    courses.clear();
    schedules.clear();
    payments.clear();
    grades.clear();
    attendances.clear();
    syllabusItems.clear();

    _studentCounter = 1;
    _teacherCounter = 1;
    _courseCounter = 1;
    _scheduleCounter = 1;
    _paymentCounter = 1;
    _gradeCounter = 1;
    _attendanceCounter = 1;
    _syllabusCounter = 1;

    // Ajouter quelques enseignants
    final teacher1 = Teacher(
      id: 'T001',
      firstName: 'Jean',
      lastName: 'Dupont',
      email: 'jean.dupont@bui.edu',
      phone: '+257 71 234 567',
      department: 'Informatique',
    );
    final teacher2 = Teacher(
      id: 'T002',
      firstName: 'Marie',
      lastName: 'Martin',
      email: 'marie.martin@bui.edu',
      phone: '+257 72 345 678',
      department: 'Mathématiques',
    );
    final teacher3 = Teacher(
      id: 'T003',
      firstName: 'Pierre',
      lastName: 'Ndayizeye',
      email: 'pierre.ndayizeye@bui.edu',
      phone: '+257 73 456 789',
      department: 'Physique',
    );
    teachers.addAll([teacher1, teacher2, teacher3]);
    _teacherCounter = 4;

    // Ajouter quelques cours
    final course1 = Course(
      id: 'C001',
      code: 'INF101',
      name: 'Programmation Mobile',
      description: 'Introduction au développement mobile avec Flutter',
      teacherId: teacher1.id,
      totalHours: 30,
      department: 'Informatique',
    );
    final course2 = Course(
      id: 'C002',
      code: 'MATH201',
      name: 'Analyse Numérique',
      description: 'Méthodes numériques pour l\'ingénierie',
      teacherId: teacher2.id,
      totalHours: 24,
      department: 'Mathématiques',
    );
    final course3 = Course(
      id: 'C003',
      code: 'PHY301',
      name: 'Mécanique Quantique',
      description: 'Introduction à la mécanique quantique',
      teacherId: teacher3.id,
      totalHours: 28,
      department: 'Physique',
    );
    courses.addAll([course1, course2, course3]);
    _courseCounter = 4;

    // Ajouter des étudiants
    final student1 = Student(
      id: 'S001',
      firstName: 'Alice',
      lastName: 'Niyonzima',
      email: 'alice.niyonzima@bui.edu',
      phone: '+257 74 567 890',
      department: 'Informatique',
      promotion: 'L3',
      courseIds: [course1.id, course2.id],
      enrollmentDate: DateTime.now().subtract(const Duration(days: 180)),
    );
    final student2 = Student(
      id: 'S002',
      firstName: 'Bob',
      lastName: 'Hakizimana',
      email: 'bob.hakizimana@bui.edu',
      phone: '+257 75 678 901',
      department: 'Mathématiques',
      promotion: 'M1',
      courseIds: [course2.id],
      enrollmentDate: DateTime.now().subtract(const Duration(days: 120)),
    );
    final student3 = Student(
      id: 'S003',
      firstName: 'Claire',
      lastName: 'Iradukunda',
      email: 'claire.iradukunda@bui.edu',
      phone: '+257 76 789 012',
      department: 'Informatique',
      promotion: 'L1',
      courseIds: [course1.id],
      enrollmentDate: DateTime.now().subtract(const Duration(days: 60)),
    );
    students.addAll([student1, student2, student3]);
    _studentCounter = 4;

    // Ajouter un emploi du temps
    schedules.add(Schedule(
      id: 'SCH001',
      courseId: course1.id,
      teacherId: teacher1.id,
      dayOfWeek: 'Lundi',
      startTime: const TimeOfDay(hour: 8, minute: 0),
      endTime: const TimeOfDay(hour: 10, minute: 0),
      room: 'A101',
    ));
    schedules.add(Schedule(
      id: 'SCH002',
      courseId: course2.id,
      teacherId: teacher2.id,
      dayOfWeek: 'Mercredi',
      startTime: const TimeOfDay(hour: 10, minute: 0),
      endTime: const TimeOfDay(hour: 12, minute: 0),
      room: 'B205',
    ));
    _scheduleCounter = 3;

    // Ajouter des syllabus items
    syllabusItems.add(SyllabusItem(
      id: 'SYL001',
      courseId: course1.id,
      title: 'Introduction à Flutter',
      description:
          'Présentation du framework Flutter, architecture des widgets',
      weekNumber: 1,
    ));
    syllabusItems.add(SyllabusItem(
      id: 'SYL002',
      courseId: course1.id,
      title: 'Widgets de base',
      description: 'Text, Container, Row, Column, Stack',
      weekNumber: 2,
    ));
    _syllabusCounter = 3;

    // Ajouter des paiements
    payments.add(Payment(
      id: 'PAY001',
      studentId: student1.id,
      amount: 500.0,
      date: DateTime.now().subtract(const Duration(days: 10)),
      status: 'paid',
      description: 'Frais de scolarité Semestre 1',
    ));
    payments.add(Payment(
      id: 'PAY002',
      studentId: student2.id,
      amount: 450.0,
      date: DateTime.now().subtract(const Duration(days: 5)),
      status: 'unpaid',
      description: 'Frais de scolarité Semestre 1',
    ));
    payments.add(Payment(
      id: 'PAY003',
      studentId: student3.id,
      amount: 500.0,
      date: DateTime.now().subtract(const Duration(days: 20)),
      status: 'partial',
      description: 'Frais de scolarité Semestre 1',
    ));
    _paymentCounter = 4;

    // Ajouter des présences
    attendances.add(Attendance(
      id: 'ATT001',
      studentId: student1.id,
      courseId: course1.id,
      date: DateTime.now().subtract(const Duration(days: 5)),
      status: 'present',
    ));
    attendances.add(Attendance(
      id: 'ATT002',
      studentId: student1.id,
      courseId: course1.id,
      date: DateTime.now().subtract(const Duration(days: 3)),
      status: 'absent',
    ));
    attendances.add(Attendance(
      id: 'ATT003',
      studentId: student1.id,
      courseId: course1.id,
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: 'absent',
    ));
    attendances.add(Attendance(
      id: 'ATT004',
      studentId: student2.id,
      courseId: course2.id,
      date: DateTime.now().subtract(const Duration(days: 4)),
      status: 'present',
    ));
    _attendanceCounter = 5;

    // Ajouter quelques sessions d'enseignement
    teachingSessions.add(TeachingSession(
      id: 'TS001',
      teacherId: teacher1.id,
      courseId: course1.id,
      date: DateTime.now().subtract(const Duration(days: 3)),
      duration: 2,
      topic: 'Introduction à Flutter',
    ));
    teachingSessions.add(TeachingSession(
      id: 'TS002',
      teacherId: teacher1.id,
      courseId: course1.id,
      date: DateTime.now().subtract(const Duration(days: 1)),
      duration: 2,
      topic: 'Widgets de base',
    ));
    _teachingSessionCounter = 3;

    // Ajouter des notes
    Grade grade1 = Grade(
      id: 'GRD001',
      studentId: student1.id,
      courseId: course1.id,
      assignmentScore: 85.0,
      examScore: 78.0,
    );
    grade1.computeFinal();
    grades.add(grade1);

    Grade grade2 = Grade(
      id: 'GRD002',
      studentId: student2.id,
      courseId: course2.id,
      assignmentScore: 70.0,
      examScore: 65.0,
    );
    grade2.computeFinal();
    grades.add(grade2);
    _gradeCounter = 3;
  }

  // --- Méthodes CRUD pour étudiants ---
  String generateStudentId() => 'S${_studentCounter++}'.padLeft(4, '0');
  void addStudent(Student s) => students.add(s);
  void updateStudent(Student s) {
    final index = students.indexWhere((e) => e.id == s.id);
    if (index != -1) students[index] = s;
  }

  void deleteStudent(String id) => students.removeWhere((e) => e.id == id);

  // Correction : retourne Student? (nullable)
  Student? getStudent(String id) {
    try {
      return students.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  // --- Méthodes CRUD pour enseignants ---
  String generateTeacherId() => 'T${_teacherCounter++}'.padLeft(4, '0');
  void addTeacher(Teacher t) => teachers.add(t);
  void updateTeacher(Teacher t) {
    final index = teachers.indexWhere((e) => e.id == t.id);
    if (index != -1) teachers[index] = t;
  }

  void deleteTeacher(String id) => teachers.removeWhere((e) => e.id == id);

  // Correction : retourne Teacher? (nullable)
  Teacher? getTeacher(String id) {
    try {
      return teachers.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  // --- Méthodes CRUD pour cours ---
  String generateCourseId() => 'C${_courseCounter++}'.padLeft(4, '0');
  void addCourse(Course c) => courses.add(c);
  void updateCourse(Course c) {
    final index = courses.indexWhere((e) => e.id == c.id);
    if (index != -1) courses[index] = c;
  }

  void deleteCourse(String id) => courses.removeWhere((e) => e.id == id);

  // Correction : retourne Course? (nullable)
  Course? getCourse(String id) {
    try {
      return courses.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  // --- Méthodes CRUD pour emploi du temps ---
  String generateScheduleId() => 'SCH${_scheduleCounter++}'.padLeft(4, '0');
  void addSchedule(Schedule s) => schedules.add(s);
  void updateSchedule(Schedule s) {
    final index = schedules.indexWhere((e) => e.id == s.id);
    if (index != -1) schedules[index] = s;
  }

  void deleteSchedule(String id) => schedules.removeWhere((e) => e.id == id);

  Schedule? getSchedule(String id) {
    try {
      return schedules.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  // --- Méthodes CRUD pour sessions d'enseignement ---
  String generateTeachingSessionId() =>
      'TS${_teachingSessionCounter++}'.padLeft(4, '0');
  void addTeachingSession(TeachingSession s) => teachingSessions.add(s);
  void updateTeachingSession(TeachingSession s) {
    final index = teachingSessions.indexWhere((e) => e.id == s.id);
    if (index != -1) teachingSessions[index] = s;
  }

  void deleteTeachingSession(String id) =>
      teachingSessions.removeWhere((e) => e.id == id);

  List<TeachingSession> getTeachingSessionsForTeacher(String teacherId) {
    return teachingSessions.where((s) => s.teacherId == teacherId).toList();
  }

  List<TeachingSession> getTeachingSessionsForCourse(String courseId) {
    return teachingSessions.where((s) => s.courseId == courseId).toList();
  }

  // --- Méthodes CRUD pour paiements ---
  String generatePaymentId() => 'PAY${_paymentCounter++}'.padLeft(4, '0');
  void addPayment(Payment p) => payments.add(p);
  void updatePayment(Payment p) {
    final index = payments.indexWhere((e) => e.id == p.id);
    if (index != -1) payments[index] = p;
  }

  void deletePayment(String id) => payments.removeWhere((e) => e.id == id);

  Payment? getPayment(String id) {
    try {
      return payments.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  // --- Méthodes CRUD pour notes ---
  String generateGradeId() => 'GRD${_gradeCounter++}'.padLeft(4, '0');
  void addGrade(Grade g) => grades.add(g);
  void updateGrade(Grade g) {
    final index = grades.indexWhere((e) => e.id == g.id);
    if (index != -1) grades[index] = g;
  }

  void deleteGrade(String id) => grades.removeWhere((e) => e.id == id);

  Grade? getGrade(String studentId, String courseId) {
    try {
      return grades.firstWhere(
          (e) => e.studentId == studentId && e.courseId == courseId);
    } catch (e) {
      return null;
    }
  }

  // --- Méthodes CRUD pour présences ---
  String generateAttendanceId() => 'ATT${_attendanceCounter++}'.padLeft(4, '0');
  void addAttendance(Attendance a) => attendances.add(a);
  void updateAttendance(Attendance a) {
    final index = attendances.indexWhere((e) => e.id == a.id);
    if (index != -1) attendances[index] = a;
  }

  void deleteAttendance(String id) =>
      attendances.removeWhere((e) => e.id == id);

  List<Attendance> getAttendancesForStudent(String studentId) {
    return attendances.where((a) => a.studentId == studentId).toList();
  }

  // --- Méthodes CRUD pour syllabus ---
  String generateSyllabusId() => 'SYL${_syllabusCounter++}'.padLeft(4, '0');
  void addSyllabusItem(SyllabusItem s) => syllabusItems.add(s);
  void updateSyllabusItem(SyllabusItem s) {
    final index = syllabusItems.indexWhere((e) => e.id == s.id);
    if (index != -1) syllabusItems[index] = s;
  }

  void deleteSyllabusItem(String id) =>
      syllabusItems.removeWhere((e) => e.id == id);

  List<SyllabusItem> getSyllabusForCourse(String courseId) {
    return syllabusItems.where((s) => s.courseId == courseId).toList();
  }

  // --- Statistiques ---
  int get studentCount => students.length;
  int get teacherCount => teachers.length;
  int get courseCount => courses.length;

  // Statistiques supplémentaires
  int get paymentCount => payments.length;
  int get gradeCount => grades.length;
  int get attendanceCount => attendances.length;

  Map<String, int> getStudentsByDepartment() {
    final Map<String, int> deptMap = {};
    for (var student in students) {
      deptMap[student.department] = (deptMap[student.department] ?? 0) + 1;
    }
    return deptMap;
  }

  Map<String, int> getStudentsByPromotion() {
    final Map<String, int> promoMap = {};
    for (var student in students) {
      promoMap[student.promotion] = (promoMap[student.promotion] ?? 0) + 1;
    }
    return promoMap;
  }

  // --- Heures enseignées ---
  int getCompletedHours(String teacherId) {
    int total = 0;
    for (var session
        in teachingSessions.where((s) => s.teacherId == teacherId)) {
      total += session.duration;
    }
    return total;
  }

  int getRemainingHours(String teacherId) {
    int total = 0;
    for (var course in courses.where((c) => c.teacherId == teacherId)) {
      total += course.totalHours;
    }
    int completed = getCompletedHours(teacherId);
    return total - completed;
  }

  // --- Éligibilité examen ---
  bool isEligibleForExam(String studentId) {
    // Règle : plus de 3 absences non justifiées => non éligible
    int unexcusedAbsences = attendances
        .where((a) => a.studentId == studentId && a.status == 'absent')
        .length;
    return unexcusedAbsences <= 3;
  }

  // Obtenir le nombre d'absences non justifiées pour un étudiant
  int getUnexcusedAbsences(String studentId) {
    return attendances
        .where((a) => a.studentId == studentId && a.status == 'absent')
        .length;
  }

  // Obtenir le nombre de présences pour un étudiant
  int getPresentCount(String studentId) {
    return attendances
        .where((a) => a.studentId == studentId && a.status == 'present')
        .length;
  }

  // --- Méthodes utilitaires pour les notes ---
  double? getAverageGrade(String studentId) {
    final studentGrades =
        grades.where((g) => g.studentId == studentId).toList();
    if (studentGrades.isEmpty) return null;

    double sum = 0;
    int count = 0;
    for (var grade in studentGrades) {
      if (grade.finalScore != null) {
        sum += grade.finalScore!;
        count++;
      }
    }
    if (count == 0) return null;
    return sum / count;
  }

  // Obtenir les cours d'un étudiant
  List<Course> getCoursesForStudent(String studentId) {
    final student = getStudent(studentId);
    if (student == null) return [];
    return courses.where((c) => student.courseIds.contains(c.id)).toList();
  }

  // Obtenir les cours d'un enseignant
  List<Course> getCoursesForTeacher(String teacherId) {
    return courses.where((c) => c.teacherId == teacherId).toList();
  }

  // Obtenir les étudiants d'un cours
  List<Student> getStudentsForCourse(String courseId) {
    final course = getCourse(courseId);
    if (course == null) return [];
    return students.where((s) => course.studentIds.contains(s.id)).toList();
  }

  // Récupère les 5 dernières activités sous forme de liste de Map
  List<Map<String, String>> getRecentActivities() {
    List<Map<String, String>> activities = [];

    // Exemple : on prend les 3 derniers étudiants inscrits
    for (var student in students.reversed.take(2)) {
      activities.add({
        'name': student.fullName,
        'action': 'Nouvelle inscription',
        'date': _formatDate(student.enrollmentDate),
      });
    }

    // Les 2 derniers paiements
    for (var payment in payments.reversed.take(2)) {
      final student = getStudent(payment.studentId);
      activities.add({
        'name': student?.fullName ?? 'Inconnu',
        'action': 'Paiement effectué',
        'date': _formatDate(payment.date),
      });
    }

    // Les 2 dernières présences marquées
    for (var attendance in attendances.reversed.take(2)) {
      final student = getStudent(attendance.studentId);
      activities.add({
        'name': student?.fullName ?? 'Inconnu',
        'action': 'Présence enregistrée',
        'date': _formatDate(attendance.date),
      });
    }

    // Trier par date décroissante (les plus récentes d'abord)
    activities.sort((a, b) => b['date']!.compareTo(a['date']!));

    // Garder les 5 premières
    return activities.take(5).toList();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return "Aujourd'hui";
    if (diff.inDays == 1) return "Hier";
    return "${diff.inDays} jours";
  }
    // ================= COURS D'AUJOURD'HUI =================
  List<Schedule> getTodaySchedules(String teacherId) {
    final now = DateTime.now();
    // On détermine le jour de la semaine en français
    final days = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];
    // La méthode DateTime.weekday donne 1 pour lundi, 7 pour dimanche
    // On convertit : 1->Lundi, 2->Mardi, ...
    final todayName = days[now.weekday - 1];
    return schedules.where((s) => s.teacherId == teacherId && s.dayOfWeek == todayName).toList();
  }

  // ================= ACTIVITÉS RÉCENTES POUR UN ENSEIGNANT =================
  List<Map<String, String>> getRecentActivitiesForTeacher(String teacherId) {
    final List<Map<String, String>> activities = [];

    // Récupérer les cours de l'enseignant pour filtrer les activités associées
    final teacherCourses = getCoursesForTeacher(teacherId);
    final courseIds = teacherCourses.map((c) => c.id).toSet();

    // 1. Dernières présences (attendances)
    final recentAttendances = attendances
        .where((a) => courseIds.contains(a.courseId))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    for (var att in recentAttendances.take(3)) {
      final student = getStudent(att.studentId);
      final course = getCourse(att.courseId);
      activities.add({
        'title': 'Présence enregistrée',
        'description': '${student?.fullName ?? 'Étudiant'} - ${course?.name ?? 'Cours'}',
        'time': _formatTime(att.date),
        'type': 'attendance',
      });
    }

    // 2. Dernières notes (grades) mises à jour
    final recentGrades = grades
        .where((g) => courseIds.contains(g.courseId))
        .toList()
      ..sort((a, b) {
        // On utilise la date de mise à jour, non stockée. On prend la date de maintenant pour l'exemple.
        // Dans un vrai projet, il faudrait un champ updateDate. On simule avec l'ID.
        return b.id.compareTo(a.id);
      });
    for (var g in recentGrades.take(3)) {
      final student = getStudent(g.studentId);
      final course = getCourse(g.courseId);
      activities.add({
        'title': 'Note ajoutée',
        'description': '${student?.fullName ?? 'Étudiant'} - ${course?.name ?? 'Cours'}',
        'time': 'Récemment', // On pourrait avoir une date
        'type': 'grade',
      });
    }

    // 3. Derniers syllabus modifiés
    final recentSyllabus = syllabusItems
        .where((s) => courseIds.contains(s.courseId))
        .toList()
      ..sort((a, b) => b.id.compareTo(a.id));
    for (var s in recentSyllabus.take(3)) {
      final course = getCourse(s.courseId);
      activities.add({
        'title': 'Syllabus modifié',
        'description': '${course?.name ?? 'Cours'} - Semaine ${s.weekNumber}',
        'time': 'Récemment',
        'type': 'syllabus',
      });
    }

    // Trier par date/heure (on utilise un ordre arbitraire pour l'exemple)
    // Comme nous n'avons pas de timestamp, on garde l'ordre de création.
    // On limite à 5 activités.
    return activities.take(5).toList();
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) {
      if (diff.inHours < 1) {
        return 'Il y a ${diff.inMinutes} min';
      }
      return 'Il y a ${diff.inHours} h';
    } else if (diff.inDays == 1) {
      return 'Hier';
    } else if (diff.inDays < 7) {
      return 'Il y a ${diff.inDays} jours';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
