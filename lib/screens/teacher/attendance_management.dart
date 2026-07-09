import 'package:flutter/material.dart';
import '../../services/data_service.dart';
import '../../models/attendance.dart';
import '../../models/student.dart';
import '../../constants/colors.dart';

class AttendanceManagement extends StatefulWidget {
  final String teacherId;
  const AttendanceManagement({super.key, required this.teacherId});

  @override
  _AttendanceManagementState createState() => _AttendanceManagementState();
}

class _AttendanceManagementState extends State<AttendanceManagement> {
  final DataService data = DataService();
  String? selectedCourseId;
  List<Student> students = [];
  Map<String, String> attendanceStatus = {};

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
                attendanceStatus.clear();
                for (var s in students) {
                  // Vérifier s'il y a déjà une présence pour aujourd'hui
                  Attendance? existing;
                  try {
                    existing = data.attendances.firstWhere(
                      (a) =>
                          a.studentId == s.id &&
                          a.courseId == val &&
                          a.date == DateTime.now(),
                    );
                  } catch (e) {
                    existing = null;
                  }
                  attendanceStatus[s.id] = existing?.status ?? 'present';
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
                      Text('${students.length} étudiants',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      ElevatedButton.icon(
                        onPressed: _saveAttendance,
                        icon: const Icon(Icons.save),
                        label: const Text('Enregistrer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
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
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.secondary,
                              child: Text(
                                student.fullName[0].toUpperCase(),
                                style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Text(student.fullName),
                            subtitle: Text(student.email),
                            trailing: DropdownButton<String>(
                              value: attendanceStatus[student.id],
                              items: const [
                                DropdownMenuItem(
                                    value: 'present', child: Text('Présent')),
                                DropdownMenuItem(
                                    value: 'absent', child: Text('Absent')),
                                DropdownMenuItem(
                                    value: 'excused', child: Text('Excused')),
                              ],
                              onChanged: (val) {
                                setState(() {
                                  attendanceStatus[student.id] = val!;
                                });
                              },
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

  void _saveAttendance() {
    if (selectedCourseId == null) return;
    for (var student in students) {
      final status = attendanceStatus[student.id] ?? 'present';
      // Vérifier si une présence existe déjà pour ce jour
      Attendance? existing;
      try {
        existing = data.attendances.firstWhere(
          (a) =>
              a.studentId == student.id &&
              a.courseId == selectedCourseId &&
              a.date == DateTime.now(),
        );
      } catch (e) {
        existing = null;
      }
      if (existing != null) {
        // Mettre à jour
        data.updateAttendance(Attendance(
          id: existing.id,
          studentId: student.id,
          courseId: selectedCourseId!,
          date: DateTime.now(),
          status: status,
        ));
      } else {
        // Créer
        data.addAttendance(Attendance(
          id: data.generateAttendanceId(),
          studentId: student.id,
          courseId: selectedCourseId!,
          date: DateTime.now(),
          status: status,
        ));
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Présences enregistrées'),
          backgroundColor: Colors.green),
    );
  }
}
