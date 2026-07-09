// lib/screens/student/student_grades.dart
import 'package:flutter/material.dart';
import '../../services/data_service.dart';
import '../../constants/colors.dart';

class StudentGrades extends StatelessWidget {
  final String studentId;
  const StudentGrades({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    final data = DataService();
    final student = data.getStudent(studentId);
    if (student == null) {
      return const Center(child: Text('Étudiant non trouvé'));
    }

    final grades = data.grades.where((g) => g.studentId == studentId).toList();
    final average = data.getAverageGrade(studentId);

    if (grades.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.grade, size: 80, color: Colors.grey),
            SizedBox(height: 10),
            Text('Aucune note disponible'),
          ],
        ),
      );
    }

    return Column(
      children: [
        if (average != null)
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Moyenne générale',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  average.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: grades.length,
            itemBuilder: (ctx, index) {
              final g = grades[index];
              final course = data.getCourse(g.courseId);
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  title: Text(course?.name ?? 'Cours inconnu'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TP: ${g.assignmentScore?.toStringAsFixed(1) ?? '-'}'),
                      Text('Examen: ${g.examScore?.toStringAsFixed(1) ?? '-'}'),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        g.finalScore?.toStringAsFixed(1) ?? '-',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      if (g.letterGrade != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getLetterColor(g.letterGrade!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            g.letterGrade!,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getLetterColor(String grade) {
    switch (grade) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.blue;
      case 'C':
        return Colors.orange;
      case 'D':
        return Colors.orange.shade800;
      case 'F':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}