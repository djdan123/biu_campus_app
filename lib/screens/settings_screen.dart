import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../services/data_service.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback toggleDarkMode;
  const SettingsScreen({super.key, required this.toggleDarkMode});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final DataService data = DataService();
  bool _notifications = true;
  bool _autoSave = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '⚙️ Paramètres',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 24),

            // === Apparence ===
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.palette, color: AppColors.primary),
                        SizedBox(width: 12),
                        Text(
                          'Apparence',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 30),
                    ListTile(
                      leading: const Icon(Icons.dark_mode, color: AppColors.primary),
                      title: const Text('Mode sombre'),
                      trailing: Switch(
                        value: Theme.of(context).brightness == Brightness.dark,
                        onChanged: (_) => widget.toggleDarkMode(),
                        activeThumbColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // === Préférences ===
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.settings, color: AppColors.primary),
                        SizedBox(width: 12),
                        Text(
                          'Préférences',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 30),
                    SwitchListTile(
                      title: const Text('Notifications'),
                      subtitle: const Text('Recevoir des notifications push'),
                      value: _notifications,
                      onChanged: (val) => setState(() => _notifications = val),
                      activeThumbColor: AppColors.primary,
                    ),
                    SwitchListTile(
                      title: const Text('Auto-sauvegarde'),
                      subtitle: const Text(
                          'Sauvegarder les modifications automatiquement'),
                      value: _autoSave,
                      onChanged: (val) => setState(() => _autoSave = val),
                      activeThumbColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // === Informations ===
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info, color: AppColors.primary),
                        SizedBox(width: 12),
                        Text(
                          'Informations',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 30),
                    const ListTile(
                      leading: Icon(Icons.school, color: AppColors.primary),
                      title: Text('BUI Smart Campus'),
                      subtitle: Text('Version 1.0.0'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.data_usage, color: AppColors.primary),
                      title: const Text('Données en mémoire'),
                      subtitle: Text(
                        '${data.studentCount} étudiants • ${data.teacherCount} enseignants • ${data.courseCount} cours',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Bouton Réinitialiser
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showResetDialog,
                icon: const Icon(Icons.refresh),
                label: const Text('Réinitialiser toutes les données'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('⚠️ Réinitialisation'),
        content: const Text(
          'Voulez-vous vraiment réinitialiser toutes les données ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              DataService().students.clear();
              DataService().teachers.clear();
              DataService().courses.clear();
              DataService().payments.clear();
              DataService().attendances.clear();
              DataService().grades.clear();
              DataService().syllabusItems.clear();
              DataService().schedules.clear();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Données réinitialisées avec succès'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Réinitialiser'),
          ),
        ],
      ),
    );
  }
}
