import 'package:flutter/material.dart';
import '../../services/data_service.dart';
import '../../constants/colors.dart';

class StudentProfile extends StatelessWidget {
  final String studentId;
  const StudentProfile({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    final data = DataService();
    final student = data.getStudent(studentId);
    if (student == null) {
      return const Center(child: Text('Étudiant non trouvé'));
    }

    final courseCount = student.courseIds.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 6,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.secondary,
                    child: Text(
                      student.fullName[0].toUpperCase(),
                      style: const TextStyle(fontSize: 40, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    student.fullName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    student.email,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informations personnelles',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  _infoTile('Département', student.department, Icons.business),
                  _infoTile('Promotion', student.promotion, Icons.school),
                  _infoTile('Téléphone', student.phone, Icons.phone),
                  _infoTile(
                    'Date d\'inscription',
                    student.enrollmentDate.toString().substring(0, 10),
                    Icons.calendar_today,
                  ),
                  _infoTile('Cours suivis', '$courseCount cours', Icons.book),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.primary),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              Text(
                value,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
