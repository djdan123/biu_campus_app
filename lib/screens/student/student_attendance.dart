// lib/screens/student/student_attendance.dart
import 'package:flutter/material.dart';
import '../../services/data_service.dart';
import '../../constants/colors.dart';

class StudentAttendance extends StatelessWidget {
  final String studentId;
  const StudentAttendance({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    final data = DataService();
    final student = data.getStudent(studentId);
    if (student == null) {
      return const Center(child: Text('Étudiant non trouvé'));
    }

    final attendances = data.attendances.where((a) => a.studentId == studentId).toList();
    final present = attendances.where((a) => a.status == 'present').length;
    final absent = attendances.where((a) => a.status == 'absent').length;
    final excused = attendances.where((a) => a.status == 'excused').length;

    if (attendances.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.checklist, size: 80, color: Colors.grey),
            SizedBox(height: 10),
            Text('Aucune présence enregistrée'),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statChip('Présent', present, Colors.green),
              _statChip('Absent', absent, Colors.red),
              _statChip('Excused', excused, Colors.orange),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: attendances.length,
            itemBuilder: (ctx, index) {
              final a = attendances[index];
              final course = data.getCourse(a.courseId);
              final statusColor = a.status == 'present'
                  ? Colors.green
                  : a.status == 'absent'
                      ? Colors.red
                      : Colors.orange;
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: Icon(
                    a.status == 'present'
                        ? Icons.check_circle
                        : a.status == 'absent'
                            ? Icons.cancel
                            : Icons.warning,
                    color: statusColor,
                  ),
                  title: Text(course?.name ?? 'Cours inconnu'),
                  subtitle: Text(a.date.toString().substring(0, 10)),
                  trailing: Chip(
                    label: Text(a.status.toUpperCase()),
                    backgroundColor: statusColor.withOpacity(0.2),
                    labelStyle: TextStyle(color: statusColor),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _statChip(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
        ),
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
      ],
    );
  }
}