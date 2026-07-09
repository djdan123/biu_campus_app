import 'package:flutter/material.dart';
import '../constants/colors.dart';

class CustomDrawer extends StatelessWidget {
  final String role;
  final Function(int) onItemSelected;

  const CustomDrawer({
    super.key,
    required this.role,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> items;

    if (role == 'admin') {
      items = [
        {'title': 'Accueil', 'icon': Icons.home_rounded, 'index': 0},
        {'title': 'Étudiants', 'icon': Icons.people_alt_rounded, 'index': 1},
        {'title': 'Enseignants', 'icon': Icons.person_rounded, 'index': 2},
        {'title': 'Cours', 'icon': Icons.book_rounded, 'index': 3},
        {'title': 'Paiements', 'icon': Icons.payment_rounded, 'index': 4},
        {'title': 'Statistiques', 'icon': Icons.bar_chart_rounded, 'index': 5},
        {'title': 'Paramètres', 'icon': Icons.settings_rounded, 'index': 6},
      ];
    } else if (role == 'teacher') {
      items = [
        {'title': 'Accueil', 'icon': Icons.home_rounded, 'index': 0},
        {'title': 'Emploi du temps', 'icon': Icons.schedule_rounded, 'index': 1},
        {'title': 'Présences', 'icon': Icons.checklist_rounded, 'index': 2},
        {'title': 'Notes', 'icon': Icons.grade_rounded, 'index': 3},
        {'title': 'Syllabus', 'icon': Icons.list_alt_rounded, 'index': 4},
        {'title': 'Paramètres', 'icon': Icons.settings_rounded, 'index': 5},
      ];
    } else {
      items = [
        {'title': 'Accueil', 'icon': Icons.home_rounded, 'index': 0},
        {'title': 'Profil', 'icon': Icons.person_rounded, 'index': 1},
        {'title': 'Emploi du temps', 'icon': Icons.schedule_rounded, 'index': 2},
        {'title': 'Paiements', 'icon': Icons.payment_rounded, 'index': 3},
        {'title': 'Notes', 'icon': Icons.grade_rounded, 'index': 4},
        {'title': 'Présences', 'icon': Icons.checklist_rounded, 'index': 5},
        {'title': 'Éligibilité examen', 'icon': Icons.assignment_turned_in_rounded, 'index': 6},
        {'title': 'Paramètres', 'icon': Icons.settings_rounded, 'index': 7},
      ];
    }

    return Drawer(
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary,        // #E8A23D
                  Color(0xFF1E3A8A),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    size: 42,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'BUI Smart Campus',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${role.toUpperCase()}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: Icon(
                    item['icon'],
                    color: AppColors.primary,
                    size: 26,
                  ),
                  title: Text(
                    item['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    onItemSelected(item['index']);
                    Navigator.pop(context);
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  hoverColor: AppColors.secondary,
                );
              },
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 20, color: Colors.grey.shade600),
                const SizedBox(width: 10),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}