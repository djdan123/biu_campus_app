// lib/screens/student/student_schedule.dart
import 'package:flutter/material.dart';
import '../../services/data_service.dart';
import '../../models/schedule.dart';
import '../../constants/colors.dart';

class StudentSchedule extends StatelessWidget {
  final String studentId;
  const StudentSchedule({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    final data = DataService();
    final student = data.getStudent(studentId);
    if (student == null) {
      return const Center(child: Text('Étudiant non trouvé'));
    }

    final List<Schedule> schedules = data.schedules
        .where((s) => student.courseIds.contains(s.courseId))
        .toList();

    if (schedules.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.schedule, size: 80, color: Colors.grey),
            SizedBox(height: 10),
            Text('Aucun emploi du temps disponible'),
          ],
        ),
      );
    }

    final Map<String, List<Schedule>> grouped = {};
    for (var s in schedules) {
      if (!grouped.containsKey(s.dayOfWeek)) {
        grouped[s.dayOfWeek] = [];
      }
      grouped[s.dayOfWeek]!.add(s);
    }

    final order = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];
    final keys = grouped.keys.toList()..sort((a, b) => order.indexOf(a).compareTo(order.indexOf(b)));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: keys.length,
      itemBuilder: (ctx, index) {
        final day = keys[index];
        final daySchedules = grouped[day]!;
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                ),
                const Divider(),
                ...daySchedules.map((s) {
                  final course = data.getCourse(s.courseId);
                  return ListTile(
                    leading: const Icon(Icons.book, color: AppColors.primary),
                    title: Text(course?.name ?? 'Cours inconnu'),
                    subtitle: Text('${s.startTimeFormatted} - ${s.endTimeFormatted} • Salle ${s.room}'),
                    trailing: Text(course?.code ?? ''),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}