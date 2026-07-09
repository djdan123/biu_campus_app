// lib/screens/admin/student_management.dart
import 'package:flutter/material.dart';
import '../../models/student.dart';
import '../../services/data_service.dart';
import '../../constants/colors.dart';

class StudentManagement extends StatefulWidget {
  const StudentManagement({super.key});

  @override
  _StudentManagementState createState() => _StudentManagementState();
}

class _StudentManagementState extends State<StudentManagement> {
  final DataService data = DataService();
  List<Student> _filteredStudents = [];
  String _searchQuery = '';
  String _selectedPromotion = 'Tous';
  String _selectedDepartment = 'Tous';

  @override
  void initState() {
    super.initState();
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _filteredStudents = data.students.where((s) {
        bool matchSearch =
            s.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                s.email.toLowerCase().contains(_searchQuery.toLowerCase());
        bool matchPromo =
            _selectedPromotion == 'Tous' || s.promotion == _selectedPromotion;
        bool matchDept = _selectedDepartment == 'Tous' ||
            s.department == _selectedDepartment;
        return matchSearch && matchPromo && matchDept;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final promotions = [
      'Tous',
      ...data.students.map((s) => s.promotion).toSet()
    ];
    final departments = [
      'Tous',
      ...data.students.map((s) => s.department).toSet()
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Étudiants'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showStudentForm(),
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
                    value: _selectedPromotion,
                    underline: const SizedBox(),
                    items: promotions
                        .map((p) => DropdownMenuItem(
                              value: p,
                              child: Text(p),
                            ))
                        .toList(),
                    onChanged: (val) {
                      _selectedPromotion = val!;
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
            child: _filteredStudents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_alt,
                            size: 80, color: Colors.grey.shade300),
                        const SizedBox(height: 10),
                        Text('Aucun étudiant trouvé',
                            style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _filteredStudents.length,
                    itemBuilder: (ctx, i) {
                      final student = _filteredStudents[i];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: AppColors.secondary,
                            child: Text(
                              student.fullName[0].toUpperCase(),
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            student.fullName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(student.email),
                              Text(
                                '${student.department} - ${student.promotion}',
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
                                    _showStudentForm(student: student),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteStudent(student.id),
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

  void _showStudentForm({Student? student}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => StudentForm(
        student: student,
        onSave: () => _applyFilters(),
      ),
    );
  }

  void _deleteStudent(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Voulez-vous vraiment supprimer cet étudiant ?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              data.deleteStudent(id);
              Navigator.pop(context);
              _applyFilters();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Étudiant supprimé avec succès'),
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

class StudentForm extends StatefulWidget {
  final Student? student;
  final VoidCallback onSave;
  const StudentForm({super.key, this.student, required this.onSave});

  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _departmentController = TextEditingController();
  final _promotionController = TextEditingController();
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.student != null;
    if (widget.student != null) {
      _firstNameController.text = widget.student!.firstName;
      _lastNameController.text = widget.student!.lastName;
      _emailController.text = widget.student!.email;
      _phoneController.text = widget.student!.phone;
      _departmentController.text = widget.student!.department;
      _promotionController.text = widget.student!.promotion;
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
          Text(_isEdit ? 'Modifier étudiant' : 'Ajouter étudiant'),
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
                const SizedBox(height: 12),
                _buildTextField(
                    _promotionController, 'Promotion', Icons.school),
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
          onPressed: _saveStudent,
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

  void _saveStudent() {
    if (_formKey.currentState!.validate()) {
      final data = DataService();
      if (_isEdit) {
        final updated = Student(
          id: widget.student!.id,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          department: _departmentController.text,
          promotion: _promotionController.text,
          courseIds: widget.student!.courseIds,
          enrollmentDate: widget.student!.enrollmentDate,
        );
        data.updateStudent(updated);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Étudiant modifié avec succès'),
              backgroundColor: Colors.green),
        );
      } else {
        final newStudent = Student(
          id: data.generateStudentId(),
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          department: _departmentController.text,
          promotion: _promotionController.text,
          courseIds: [],
          enrollmentDate: DateTime.now(),
        );
        data.addStudent(newStudent);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Étudiant ajouté avec succès'),
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
    _promotionController.dispose();
    super.dispose();
  }
}
