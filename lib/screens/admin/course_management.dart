import 'package:flutter/material.dart';
import '../../models/course.dart';
import '../../services/data_service.dart';
import '../../constants/colors.dart';

class CourseManagement extends StatefulWidget {
  const CourseManagement({super.key});

  @override
  _CourseManagementState createState() => _CourseManagementState();
}

class _CourseManagementState extends State<CourseManagement> {
  final DataService data = DataService();
  List<Course> _filteredCourses = [];
  String _searchQuery = '';
  String _selectedDepartment = 'Tous';

  @override
  void initState() {
    super.initState();
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _filteredCourses = data.courses.where((c) {
        bool matchSearch =
            c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                c.code.toLowerCase().contains(_searchQuery.toLowerCase());
        bool matchDept = _selectedDepartment == 'Tous' ||
            c.department == _selectedDepartment;
        return matchSearch && matchDept;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final departments = [
      'Tous',
      ...data.courses.map((c) => c.department).toSet()
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Cours'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCourseForm(),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Rechercher...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    onChanged: (val) {
                      _searchQuery = val;
                      _applyFilters();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedDepartment,
                    underline: const SizedBox(),
                    items: departments
                        .map((d) => DropdownMenuItem(
                              value: d,
                              child: Text(d),
                            ))
                        .toList(),
                    onChanged: (val) {
                      _selectedDepartment = val!;
                      _applyFilters();
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredCourses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.book, size: 80, color: Colors.grey.shade300),
                        const SizedBox(height: 10),
                        Text('Aucun cours trouvé',
                            style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _filteredCourses.length,
                    itemBuilder: (ctx, i) {
                      final course = _filteredCourses[i];
                      final teacher = data.getTeacher(course.teacherId);
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                course.code,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          title: Text(
                            course.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Code: ${course.code}'),
                              Text(
                                'Enseignant: ${teacher?.fullName ?? 'Non assigné'}',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade600),
                              ),
                              Text(
                                'Département: ${course.department} | Heures: ${course.totalHours}h',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: AppColors.primary),
                                onPressed: () =>
                                    _showCourseForm(course: course),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteCourse(course.id),
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
    );
  }

  void _showCourseForm({Course? course}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CourseForm(
        course: course,
        onSave: () => _applyFilters(),
      ),
    );
  }

  void _deleteCourse(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Voulez-vous vraiment supprimer ce cours ?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              data.deleteCourse(id);
              Navigator.pop(context);
              _applyFilters();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cours supprimé avec succès'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}

class CourseForm extends StatefulWidget {
  final Course? course;
  final VoidCallback onSave;
  const CourseForm({super.key, this.course, required this.onSave});

  @override
  _CourseFormState createState() => _CourseFormState();
}

class _CourseFormState extends State<CourseForm> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _departmentController = TextEditingController();
  final _totalHoursController = TextEditingController();
  String? _selectedTeacherId;
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.course != null;
    if (widget.course != null) {
      _codeController.text = widget.course!.code;
      _nameController.text = widget.course!.name;
      _descriptionController.text = widget.course!.description;
      _departmentController.text = widget.course!.department;
      _totalHoursController.text = widget.course!.totalHours.toString();
      _selectedTeacherId = widget.course!.teacherId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = DataService();
    final teachers = data.teachers;

    return AlertDialog(
      title: Row(
        children: [
          Icon(_isEdit ? Icons.edit : Icons.book, color: AppColors.primary),
          const SizedBox(width: 10),
          Text(_isEdit ? 'Modifier cours' : 'Ajouter cours'),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(_codeController, 'Code du cours', Icons.code),
                const SizedBox(height: 12),
                _buildTextField(_nameController, 'Nom du cours', Icons.book),
                const SizedBox(height: 12),
                _buildTextField(
                    _descriptionController, 'Description', Icons.description,
                    maxLines: 2),
                const SizedBox(height: 12),
                _buildTextField(
                    _departmentController, 'Département', Icons.business),
                const SizedBox(height: 12),
                _buildTextField(
                    _totalHoursController, 'Total d\'heures', Icons.timer,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _selectedTeacherId,
                  decoration: InputDecoration(
                    labelText: 'Enseignant responsable',
                    prefixIcon: const Icon(Icons.person, color: AppColors.primary),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Aucun')),
                    ...teachers.map((t) => DropdownMenuItem(
                          value: t.id,
                          child: Text(t.fullName),
                        )),
                  ],
                  onChanged: (val) => setState(() => _selectedTeacherId = val),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _saveCourse,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(_isEdit ? 'Modifier' : 'Ajouter'),
        ),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {int maxLines = 1, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (v) => v!.isEmpty ? 'Requis' : null,
    );
  }

  void _saveCourse() {
    if (_formKey.currentState!.validate()) {
      final data = DataService();
      if (_isEdit) {
        final updated = Course(
          id: widget.course!.id,
          code: _codeController.text,
          name: _nameController.text,
          description: _descriptionController.text,
          teacherId: _selectedTeacherId ?? '',
          totalHours: int.parse(_totalHoursController.text),
          department: _departmentController.text,
          studentIds: widget.course!.studentIds,
          syllabusItemIds: widget.course!.syllabusItemIds,
          assignmentIds: widget.course!.assignmentIds,
          examIds: widget.course!.examIds,
        );
        data.updateCourse(updated);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Cours modifié avec succès'),
              backgroundColor: Colors.green),
        );
      } else {
        final newCourse = Course(
          id: data.generateCourseId(),
          code: _codeController.text,
          name: _nameController.text,
          description: _descriptionController.text,
          teacherId: _selectedTeacherId ?? '',
          totalHours: int.parse(_totalHoursController.text),
          department: _departmentController.text,
          studentIds: [],
          syllabusItemIds: [],
          assignmentIds: [],
          examIds: [],
        );
        data.addCourse(newCourse);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Cours ajouté avec succès'),
              backgroundColor: Colors.green),
        );
      }
      Navigator.pop(context);
      widget.onSave();
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _departmentController.dispose();
    _totalHoursController.dispose();
    super.dispose();
  }
}
