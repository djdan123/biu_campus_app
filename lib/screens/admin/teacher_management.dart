import 'package:flutter/material.dart';
import '../../models/teacher.dart';
import '../../services/data_service.dart';
import '../../constants/colors.dart';

class TeacherManagement extends StatefulWidget {
  const TeacherManagement({super.key});

  @override
  _TeacherManagementState createState() => _TeacherManagementState();
}

class _TeacherManagementState extends State<TeacherManagement> {
  final DataService data = DataService();
  List<Teacher> _filteredTeachers = [];
  String _searchQuery = '';
  String _selectedDepartment = 'Tous';

  @override
  void initState() {
    super.initState();
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _filteredTeachers = data.teachers.where((t) {
        bool matchSearch =
            t.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                t.email.toLowerCase().contains(_searchQuery.toLowerCase());
        bool matchDept = _selectedDepartment == 'Tous' ||
            t.department == _selectedDepartment;
        return matchSearch && matchDept;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final departments = [
      'Tous',
      ...data.teachers.map((t) => t.department).toSet()
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Enseignants'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTeacherForm(),
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
                      prefixIcon: Icon(Icons.search, color: AppColors.primary),
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
            child: _filteredTeachers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_off,
                            size: 80, color: Colors.grey.shade300),
                        const SizedBox(height: 10),
                        Text('Aucun enseignant trouvé',
                            style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _filteredTeachers.length,
                    itemBuilder: (ctx, i) {
                      final teacher = _filteredTeachers[i];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: AppColors.secondary,
                            child: Text(
                              teacher.fullName[0].toUpperCase(),
                              style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            teacher.fullName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${teacher.email}'),
                              Text(
                                'Département: ${teacher.department}',
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
                                    Icon(Icons.edit, color: AppColors.primary),
                                onPressed: () =>
                                    _showTeacherForm(teacher: teacher),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteTeacher(teacher.id),
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

  void _showTeacherForm({Teacher? teacher}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => TeacherForm(
        teacher: teacher,
        onSave: () => _applyFilters(),
      ),
    );
  }

  void _deleteTeacher(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Voulez-vous vraiment supprimer cet enseignant ?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              data.deleteTeacher(id);
              Navigator.pop(context);
              _applyFilters();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Enseignant supprimé avec succès'),
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

class TeacherForm extends StatefulWidget {
  final Teacher? teacher;
  final VoidCallback onSave;
  const TeacherForm({super.key, this.teacher, required this.onSave});

  @override
  _TeacherFormState createState() => _TeacherFormState();
}

class _TeacherFormState extends State<TeacherForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _departmentController = TextEditingController();
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.teacher != null;
    if (widget.teacher != null) {
      _firstNameController.text = widget.teacher!.firstName;
      _lastNameController.text = widget.teacher!.lastName;
      _emailController.text = widget.teacher!.email;
      _phoneController.text = widget.teacher!.phone;
      _departmentController.text = widget.teacher!.department;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(_isEdit ? Icons.edit : Icons.person_add,
              color: AppColors.primary),
          const SizedBox(width: 10),
          Text(_isEdit ? 'Modifier enseignant' : 'Ajouter enseignant'),
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
                _buildTextField(_firstNameController, 'Prénom', Icons.person),
                const SizedBox(height: 12),
                _buildTextField(
                    _lastNameController, 'Nom', Icons.person_outline),
                const SizedBox(height: 12),
                _buildTextField(_emailController, 'Email', Icons.email,
                    validator: (v) {
                  if (v!.isEmpty) return 'Requis';
                  if (!v.contains('@')) return 'Email invalide';
                  return null;
                }),
                const SizedBox(height: 12),
                _buildTextField(_phoneController, 'Téléphone', Icons.phone),
                const SizedBox(height: 12),
                _buildTextField(
                    _departmentController, 'Département', Icons.business),
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
          onPressed: _saveTeacher,
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
      {String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator ?? (v) => v!.isEmpty ? 'Requis' : null,
    );
  }

  void _saveTeacher() {
    if (_formKey.currentState!.validate()) {
      final data = DataService();
      if (_isEdit) {
        final updated = Teacher(
          id: widget.teacher!.id,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          department: _departmentController.text,
          courseIds: widget.teacher!.courseIds,
        );
        data.updateTeacher(updated);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Enseignant modifié avec succès'),
              backgroundColor: Colors.green),
        );
      } else {
        final newTeacher = Teacher(
          id: data.generateTeacherId(),
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          department: _departmentController.text,
          courseIds: [],
        );
        data.addTeacher(newTeacher);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Enseignant ajouté avec succès'),
              backgroundColor: Colors.green),
        );
      }
      Navigator.pop(context);
      widget.onSave();
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _departmentController.dispose();
    super.dispose();
  }
}
