import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../widgets/custom_drawer.dart';
import 'teacher/teacher_home.dart';
import 'teacher/schedule_view.dart';
import 'teacher/attendance_management.dart';
import 'teacher/grade_management.dart';
import 'teacher/syllabus_management.dart';

class TeacherDashboard extends StatefulWidget {
  final String teacherId;
  const TeacherDashboard({super.key, required this.teacherId});

  @override
  _TeacherDashboardState createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _selectedIndex = 0;
  final DataService data = DataService();

  late final List<Widget> _widgetOptions;
  late final List<String> _titles;

  @override
  void initState() {
    super.initState();
    final teacher = data.getTeacher(widget.teacherId);
    final name = teacher?.fullName ?? 'Enseignant';
    _titles = [
      'Accueil - $name',
      'Emploi du temps',
      'Gestion des présences',
      'Gestion des notes',
      'Gestion du syllabus',
    ];
    _widgetOptions = [
      TeacherHome(teacherId: widget.teacherId),
      ScheduleView(teacherId: widget.teacherId),
      AttendanceManagement(teacherId: widget.teacherId),
      GradeManagement(teacherId: widget.teacherId),
      SyllabusManagement(teacherId: widget.teacherId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Colors.orange.shade700,
        elevation: 0,
      ),
      drawer: CustomDrawer(
        role: 'teacher',
        onItemSelected: (index) => setState(() => _selectedIndex = index),
      ),
      body: _widgetOptions[_selectedIndex],
    );
  }
}