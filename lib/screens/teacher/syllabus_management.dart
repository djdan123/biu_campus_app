import 'package:flutter/material.dart';
import '../../services/data_service.dart';
import '../../models/syllabus_item.dart';
import '../../constants/colors.dart';

class SyllabusManagement extends StatefulWidget {
  final String teacherId;
  const SyllabusManagement({super.key, required this.teacherId});

  @override
  _SyllabusManagementState createState() => _SyllabusManagementState();
}

class _SyllabusManagementState extends State<SyllabusManagement> {
  final DataService data = DataService();
  String? selectedCourseId;
  List<SyllabusItem> items = [];

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
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Choisir un cours',
                    prefixIcon: Icon(Icons.book, color: AppColors.primary),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  value: selectedCourseId,
                  items: courses
                      .map((c) => DropdownMenuItem(
                            value: c.id,
                            child: Text('${c.code} - ${c.name}'),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedCourseId = val;
                      items = data.syllabusItems
                          .where((s) => s.courseId == val)
                          .toList();
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: _addSyllabusItem,
                icon: const Icon(Icons.add),
                label: const Text('Ajouter'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (selectedCourseId != null)
            Expanded(
              child: items.isEmpty
                  ? const Center(child: Text('Aucun élément de syllabus'))
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (ctx, index) {
                        final item = items[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                                'Semaine ${item.weekNumber} : ${item.title}'),
                            subtitle: Text(item.description),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                data.deleteSyllabusItem(item.id);
                                setState(() {
                                  items.remove(item);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Élément supprimé'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
        ],
      ),
    );
  }

  void _addSyllabusItem() {
    if (selectedCourseId == null) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SyllabusItemForm(
        courseId: selectedCourseId!,
        onSave: () {
          setState(() {
            items = data.syllabusItems
                .where((s) => s.courseId == selectedCourseId)
                .toList();
          });
          Navigator.pop(context);
        },
      ),
    );
  }
}

class SyllabusItemForm extends StatefulWidget {
  final String courseId;
  final VoidCallback onSave;
  const SyllabusItemForm(
      {super.key, required this.courseId, required this.onSave});

  @override
  _SyllabusItemFormState createState() => _SyllabusItemFormState();
}

class _SyllabusItemFormState extends State<SyllabusItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _weekController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.list_alt, color: AppColors.primary),
          const SizedBox(width: 10),
          const Text('Ajouter un élément de syllabus'),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(_titleController, 'Titre', Icons.title),
              const SizedBox(height: 12),
              _buildTextField(
                  _descriptionController, 'Description', Icons.description),
              const SizedBox(height: 12),
              _buildTextField(_weekController, 'Semaine', Icons.calendar_today,
                  keyboardType: TextInputType.number),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _saveItem,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Ajouter'),
        ),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      keyboardType: keyboardType,
      validator: (v) => v!.isEmpty ? 'Requis' : null,
    );
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final data = DataService();
      data.addSyllabusItem(SyllabusItem(
        id: data.generateSyllabusId(),
        courseId: widget.courseId,
        title: _titleController.text,
        description: _descriptionController.text,
        weekNumber: int.parse(_weekController.text),
      ));
      widget.onSave();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Élément ajouté avec succès'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _weekController.dispose();
    super.dispose();
  }
}
