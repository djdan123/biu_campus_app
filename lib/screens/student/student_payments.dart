// lib/screens/student/student_payments.dart
import 'package:flutter/material.dart';
import '../../services/data_service.dart';
import '../../constants/colors.dart';

class StudentPayments extends StatelessWidget {
  final String studentId;
  const StudentPayments({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    final data = DataService();
    final student = data.getStudent(studentId);
    if (student == null) {
      return const Center(child: Text('Étudiant non trouvé'));
    }

    final payments = data.payments.where((p) => p.studentId == studentId).toList();

    if (payments.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.payment, size: 80, color: Colors.grey),
            SizedBox(height: 10),
            Text('Aucun paiement enregistré'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: payments.length,
      itemBuilder: (ctx, index) {
        final p = payments[index];
        final statusColor = p.status == 'paid'
            ? Colors.green
            : p.status == 'partial'
                ? Colors.orange
                : Colors.red;
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ListTile(
            leading: Icon(
              p.status == 'paid'
                  ? Icons.check_circle
                  : p.status == 'partial'
                      ? Icons.pending_actions
                      : Icons.cancel,
              color: statusColor,
            ),
            title: Text(p.description),
            subtitle: Text('Date: ${p.date.toString().substring(0, 10)}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${p.amount.toStringAsFixed(0)} FBu',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text(p.status.toUpperCase()),
                  backgroundColor: statusColor.withOpacity(0.2),
                  labelStyle: TextStyle(color: statusColor, fontSize: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}