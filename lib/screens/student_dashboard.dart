import 'package:flutter/material.dart';
import '../services/data_service.dart';
import 'student/student_profile.dart';
import 'student/student_schedule.dart';
import 'student/student_payments.dart';
import 'student/student_grades.dart';
import 'student/student_attendance.dart';
import 'student/exam_eligibility.dart';
import '../widgets/custom_drawer.dart';

class StudentDashboard extends StatefulWidget {
  final String studentId;
  const StudentDashboard({super.key, required this.studentId});

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _selectedIndex = 0;
  late final DataService data;

  @override
  void initState() {
    super.initState();
    data = DataService();
  }

  @override
  Widget build(BuildContext context) {
    final student = data.getStudent(widget.studentId);
    if (student == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Erreur')),
        body: const Center(child: Text('Étudiant non trouvé')),
      );
    }

    final List<Widget> widgetOptions = [
      StudentProfile(studentId: widget.studentId),
      StudentSchedule(studentId: widget.studentId),
      StudentPayments(studentId: widget.studentId),
      StudentGrades(studentId: widget.studentId),
      StudentAttendance(studentId: widget.studentId),
      ExamEligibility(studentId: widget.studentId),
    ];

    final List<String> titles = [
      'Profil',
      'Emploi du temps',
      'Paiements',
      'Notes',
      'Présences',
      'Éligibilité examen',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('${student.fullName} - ${titles[_selectedIndex]}'),
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
      ),
      drawer: CustomDrawer(
        role: 'student',
        onItemSelected: (index) => setState(() => _selectedIndex = index),
      ),
      body: widgetOptions[_selectedIndex],
    );
  }
}