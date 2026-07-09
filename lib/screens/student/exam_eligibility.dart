// lib/screens/student/exam_eligibility.dart
import 'package:flutter/material.dart';
import '../../services/data_service.dart';

class ExamEligibility extends StatelessWidget {
  final String studentId;
  const ExamEligibility({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    final data = DataService();
    final student = data.getStudent(studentId);
    if (student == null) {
      return const Center(child: Text('Étudiant non trouvé'));
    }

    final unexcused = data.getUnexcusedAbsences(studentId);
    final eligible = unexcused <= 3;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: eligible ? Colors.green.shade50 : Colors.red.shade50,
              shape: BoxShape.circle,
              border: Border.all(color: eligible ? Colors.green : Colors.red, width: 4),
            ),
            child: Icon(
              eligible ? Icons.check_circle : Icons.cancel,
              size: 80,
              color: eligible ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            eligible ? 'ÉLIGIBLE' : 'NON ÉLIGIBLE',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: eligible ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Nombre d\'absences non justifiées : $unexcused',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          Text(
            'La règle autorise un maximum de 3 absences non justifiées.',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          if (!eligible) ...[
            const SizedBox(height: 10),
            const Text(
              '❌ Vous avez dépassé le nombre d\'absences autorisées. Vous ne pouvez pas passer les examens.',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
          if (eligible) ...[
            const SizedBox(height: 10),
            const Text(
              '✅ Vous êtes autorisé à passer les examens.',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}