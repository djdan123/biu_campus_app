import 'package:flutter/material.dart';
import '../../services/data_service.dart';
import '../../constants/colors.dart';

class TeacherHome extends StatelessWidget {
  final String teacherId;
  const TeacherHome({super.key, required this.teacherId});

  @override
  Widget build(BuildContext context) {
    final data = DataService();
    final teacher = data.getTeacher(teacherId);
    if (teacher == null) {
      return const Center(child: Text('Enseignant non trouvé'));
    }

    final courses = data.getCoursesForTeacher(teacherId);
    final completed = data.getCompletedHours(teacherId);
    final totalHours = courses.fold(0, (sum, c) => sum + c.totalHours);
    final remaining = data.getRemainingHours(teacherId);
    final studentsCount =
        courses.fold(0, (sum, c) => sum + c.studentIds.length);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, const Color(0xFF1E3A8A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour ${teacher.fullName} ! 👨‍🏫',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Département : ${teacher.department}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '📊 Vos statistiques',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildStatCard('Cours enseignés', courses.length, Icons.book,
                  AppColors.primary),
              _buildStatCard('Étudiants', studentsCount, Icons.people,
                  Colors.blue.shade700),
              _buildStatCard('Heures complétées', completed, Icons.timer,
                  Colors.green.shade700),
              _buildStatCard('Heures restantes', remaining, Icons.hourglass_top,
                  Colors.purple.shade700),
            ],
          ),
          const SizedBox(height: 24),
          if (courses.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📚 Vos cours',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 12),
                ...courses.map((c) => Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.secondary,
                          child: Text(
                            c.code,
                            style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(c.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            '${c.studentIds.length} étudiants • ${c.totalHours}h'),
                      ),
                    )),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, int value, IconData icon, Color color) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 8),
            Text('$value',
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            Text(label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }
}
