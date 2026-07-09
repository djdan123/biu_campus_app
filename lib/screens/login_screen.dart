import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'admin_dashboard.dart';
import 'teacher_dashboard.dart';
import 'student_dashboard.dart';
import '../services/data_service.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback toggleDarkMode;
  const LoginScreen({super.key, required this.toggleDarkMode});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _selectedRole = 'admin';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: 0.95),
              const Color(0xFF1E3A8A), // Bleu profond complémentaire
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo / Icône
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        size: 72,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'BUI Smart Campus',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accent,
                      ),
                    ),
                    Text(
                      'Bujumbura International University',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 40),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(
                            label: 'Email',
                            icon: Icons.email_rounded,
                            onChanged: (val) => _email = val,
                            validator: (val) => val!.isEmpty ? 'Veuillez entrer un email' : null,
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            label: 'Mot de passe',
                            icon: Icons.lock_rounded,
                            obscureText: true,
                            onChanged: (val) => _password = val,
                            validator: (val) => val!.isEmpty ? 'Veuillez entrer un mot de passe' : null,
                          ),
                          const SizedBox(height: 24),

                          // Sélection du rôle
                          DropdownButtonFormField<String>(
                            initialValue: _selectedRole,
                            decoration: InputDecoration(
                              labelText: 'Rôle',
                              prefixIcon: const Icon(Icons.person_rounded, color: AppColors.primary),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: AppColors.primary, width: 2),
                              ),
                            ),
                            items: ['admin', 'teacher', 'student']
                                .map((role) => DropdownMenuItem(
                                      value: role,
                                      child: Text(role.toUpperCase()),
                                    ))
                                .toList(),
                            onChanged: (val) => setState(() => _selectedRole = val!),
                          ),

                          const SizedBox(height: 32),

                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 6,
                              ),
                              child: const Text(
                                'Se connecter',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Identifiants de test
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            '🔑 Identifiants de test',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Admin   → admin / admin\n'
                            'Teacher → teacher / teacher\n'
                            'Student → student / student',
                            style: TextStyle(fontSize: 13, height: 1.5),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    bool obscureText = false,
    required Function(String) onChanged,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      ),
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
    );
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      bool valid = false;

      if (_selectedRole == 'admin' && _email == 'admin' && _password == 'admin') {
        valid = true;
      } else if (_selectedRole == 'teacher' && _email == 'teacher' && _password == 'teacher') valid = true;
      else if (_selectedRole == 'student' && _email == 'student' && _password == 'student') valid = true;

      if (valid) {
        Widget nextScreen;

        if (_selectedRole == 'admin') {
          nextScreen = AdminDashboard(toggleDarkMode: widget.toggleDarkMode);
        } else if (_selectedRole == 'teacher') {
          final teacher = DataService().teachers.isNotEmpty
              ? DataService().teachers.first
              : null;
          nextScreen = TeacherDashboard(teacherId: teacher?.id ?? '');
        } else {
          final student = DataService().students.isNotEmpty
              ? DataService().students.first
              : null;
          nextScreen = StudentDashboard(studentId: student?.id ?? '');
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => nextScreen),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Identifiants invalides'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}