import 'package:flutter/material.dart';
import '../../services/data_service.dart';
import '../../models/grade.dart';
import '../../models/student.dart';
import '../../constants/colors.dart';

class GradeManagement extends StatefulWidget {
  final String teacherId;
  const GradeManagement({super.key, required this.teacherId});

  @override
  _GradeManagementState createState() => _GradeManagementState();
}

class _GradeManagementState extends State<GradeManagement> {
  final DataService data = DataService();
  String? selectedCourseId;
  List<Student> students = [];
  Map<String, TextEditingController> assignmentControllers = {};
  Map<String, TextEditingController> examControllers = {};

  @override
  void dispose() {
    for (var c in assignmentControllers.values) {
      c.dispose();
    }
    for (var c in examControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courses = data.getCoursesForTeacher(widget.teacherId);

    if (courses.isEmpty) {
      return const Center(child: Text('Vous n\'avez aucun cours'));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Choisir un cours',
              prefixIcon: const Icon(Icons.book, color: AppColors.primary),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
            initialValue: selectedCourseId,
            items: courses
                .map((c) => DropdownMenuItem(
                      value: c.id,
                      child: Text('${c.code} - ${c.name}'),
                    ))
                .toList(),
            onChanged: (val) {
              setState(() {
                selectedCourseId = val;
                students = data.getStudentsForCourse(val!);
                assignmentControllers.clear();
                examControllers.clear();
                for (var s in students) {
                  final grade = data.getGrade(s.id, val);
                  assignmentControllers[s.id] = TextEditingController(
                    text: grade?.assignmentScore?.toString() ?? '',
                  );
                  examControllers[s.id] = TextEditingController(
                    text: grade?.examScore?.toString() ?? '',
                  );
                }
              });
            },
          ),
          const SizedBox(height: 20),
          if (selectedCourseId != null)
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${students.length} étudiants',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
                        onPressed: _saveGrades,
                        icon: const Icon(Icons.save),
                        label: const Text('Enregistrer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (ctx, index) {
                        final student = students[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: AppColors.secondary,
                                      child: Text(
                                        student.fullName[0].toUpperCase(),
                                        style: const TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(child: Text(student.fullName)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller:
                                            assignmentControllers[student.id],
                                        decoration: const InputDecoration(
                                          labelText: 'Note TP',
                                          border: OutlineInputBorder(),
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        controller: examControllers[student.id],
                                        decoration: const InputDecoration(
                                          labelText: 'Note Examen',
                                          border: OutlineInputBorder(),
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _saveGrades() {
    if (selectedCourseId == null) return;
    for (var student in students) {
      final aText = assignmentControllers[student.id]?.text ?? '';
      final eText = examControllers[student.id]?.text ?? '';
      double? a = aText.isEmpty ? null : double.tryParse(aText);
      double? e = eText.isEmpty ? null : double.tryParse(eText);

      final existing = data.getGrade(student.id, selectedCourseId!);
      if (existing != null) {
        // Mettre à jour
        final updated = Grade(
          id: existing.id,
          studentId: student.id,
          courseId: selectedCourseId!,
          assignmentScore: a,
          examScore: e,
        );
        updated.computeFinal();
        data.updateGrade(updated);
      } else {
        // Créer
        final newGrade = Grade(
          id: data.generateGradeId(),
          studentId: student.id,
          courseId: selectedCourseId!,
          assignmentScore: a,
          examScore: e,
        );
        newGrade.computeFinal();
        data.addGrade(newGrade);
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notes enregistrées avec succès'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
