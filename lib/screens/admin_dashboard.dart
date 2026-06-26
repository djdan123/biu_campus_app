// import 'package:flutter/material.dart';
// import '../services/data_service.dart';
// import 'admin/student_management.dart';
// import 'admin/teacher_management.dart';
// import 'admin/course_management.dart';
// import 'admin/payment_management.dart';
// import 'statistics_screen.dart';
// import 'settings_screen.dart';

// class AdminDashboard extends StatefulWidget {
//   @override
//   _AdminDashboardState createState() => _AdminDashboardState();
// }

// class _AdminDashboardState extends State<AdminDashboard> {
//   final DataService data = DataService();
//   int _selectedIndex = 0;

//   static List<Widget> _widgetOptions = <Widget>[
//     DashboardHome(),
//     StudentManagement(),
//     TeacherManagement(),
//     CourseManagement(),
//     PaymentManagement(),
//     StatisticsScreen(),
//     SettingsScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin Dashboard'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.dark_mode),
//             onPressed: () => _navigateToSettings(),
//           ),
//         ],
//       ),
//       drawer: CustomDrawer(role: 'admin', onItemSelected: (index) => setState(() => _selectedIndex = index)),
//       body: _widgetOptions[_selectedIndex],
//     );
//   }

//   void _navigateToSettings() {
//     setState(() => _selectedIndex = 6);
//   }
// }

// // Widget d'accueil du dashboard
// class DashboardHome extends StatelessWidget {
//   final DataService data = DataService();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Bienvenue, Administrateur !', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//           SizedBox(height: 20),
//           Text('Statistiques rapides', style: TextStyle(fontSize: 20)),
//           SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildCounterCard('Étudiants', data.studentCount, Icons.people),
//               _buildCounterCard('Enseignants', data.teacherCount, Icons.person),
//               _buildCounterCard('Cours', data.courseCount, Icons.book),
//             ],
//           ),
//           SizedBox(height: 30),
//           Text('Actions rapides', style: TextStyle(fontSize: 20)),
//           SizedBox(height: 10),
//           Wrap(
//             spacing: 10,
//             children: [
//               _buildActionButton(context, 'Gérer étudiants', Icons.people, () => Navigator.pushNamed(context, '/admin/students')),
//               _buildActionButton(context, 'Gérer enseignants', Icons.person, () => Navigator.pushNamed(context, '/admin/teachers')),
//               _buildActionButton(context, 'Gérer cours', Icons.book, () => Navigator.pushNamed(context, '/admin/courses')),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCounterCard(String label, int count, IconData icon) {
//     return Card(
//       elevation: 4,
//       child: Container(
//         width: 100,
//         padding: EdgeInsets.all(12),
//         child: Column(
//           children: [
//             Icon(icon, size: 40, color: Colors.blue),
//             Text('$count', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//             Text(label, style: TextStyle(fontSize: 14)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButton(BuildContext context, String label, IconData icon, VoidCallback onTap) {
//     return ElevatedButton.icon(
//       onPressed: onTap,
//       icon: Icon(icon),
//       label: Text(label),
//       style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade100),
//     );
//   }
// }

// // CustomDrawer (widgets/custom_drawer.dart)
// class CustomDrawer extends StatelessWidget {
//   final String role;
//   final Function(int) onItemSelected;

//   CustomDrawer({required this.role, required this.onItemSelected});

//   @override
//   Widget build(BuildContext context) {
//     List<Map<String, dynamic>> items;
//     if (role == 'admin') {
//       items = [
//         {'title': 'Accueil', 'icon': Icons.home, 'index': 0},
//         {'title': 'Étudiants', 'icon': Icons.people, 'index': 1},
//         {'title': 'Enseignants', 'icon': Icons.person, 'index': 2},
//         {'title': 'Cours', 'icon': Icons.book, 'index': 3},
//         {'title': 'Paiements', 'icon': Icons.payment, 'index': 4},
//         {'title': 'Statistiques', 'icon': Icons.bar_chart, 'index': 5},
//         {'title': 'Paramètres', 'icon': Icons.settings, 'index': 6},
//       ];
//     } else if (role == 'teacher') {
//       items = [
//         {'title': 'Accueil', 'icon': Icons.home, 'index': 0},
//         {'title': 'Emploi du temps', 'icon': Icons.schedule, 'index': 1},
//         {'title': 'Présences', 'icon': Icons.checklist, 'index': 2},
//         {'title': 'Notes', 'icon': Icons.grade, 'index': 3},
//         {'title': 'Syllabus', 'icon': Icons.list, 'index': 4},
//         {'title': 'Paramètres', 'icon': Icons.settings, 'index': 5},
//       ];
//     } else {
//       items = [
//         {'title': 'Accueil', 'icon': Icons.home, 'index': 0},
//         {'title': 'Profil', 'icon': Icons.person, 'index': 1},
//         {'title': 'Emploi du temps', 'icon': Icons.schedule, 'index': 2},
//         {'title': 'Paiements', 'icon': Icons.payment, 'index': 3},
//         {'title': 'Notes', 'icon': Icons.grade, 'index': 4},
//         {'title': 'Présences', 'icon': Icons.checklist, 'index': 5},
//         {'title': 'Éligibilité examen', 'icon': Icons.assignment, 'index': 6},
//         {'title': 'Paramètres', 'icon': Icons.settings, 'index': 7},
//       ];
//     }

//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(color: Colors.blue),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Icon(Icons.school, size: 50, color: Colors.white),
//                 SizedBox(height: 10),
//                 Text('BUI Smart Campus', style: TextStyle(color: Colors.white, fontSize: 20)),
//                 Text('Rôle: ${role.toUpperCase()}', style: TextStyle(color: Colors.white70, fontSize: 14)),
//               ],
//             ),
//           ),
//           ...items.map((item) => ListTile(
//             leading: Icon(item['icon']),
//             title: Text(item['title']),
//             onTap: () {
//               onItemSelected(item['index']);
//               Navigator.pop(context);
//             },
//           )),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../services/data_service.dart';
import 'admin/student_management.dart';
import 'admin/teacher_management.dart';
import 'admin/course_management.dart';
import 'admin/payment_management.dart';
import 'statistics_screen.dart';
import 'settings_screen.dart';
import '../widgets/custom_drawer.dart';
import 'login_screen.dart';

class AdminDashboard extends StatefulWidget {
  final VoidCallback toggleDarkMode;
  const AdminDashboard({super.key, required this.toggleDarkMode});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final DataService data = DataService();
  int _selectedIndex = 0;

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = [
      DashboardHome(toggleDarkMode: widget.toggleDarkMode),
      StudentManagement(),
      const TeacherManagement(),
      const CourseManagement(),
      const PaymentManagement(),
      const StatisticsScreen(),
      SettingsScreen(toggleDarkMode: widget.toggleDarkMode),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () {
              widget.toggleDarkMode();
              setState(() => _selectedIndex = 6);
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Text('Déconnexion'),
              ),
            ],
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(
                      toggleDarkMode: widget.toggleDarkMode,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      drawer: CustomDrawer(
        role: 'admin',
        onItemSelected: (index) => setState(() => _selectedIndex = index),
      ),
      body: _widgetOptions[_selectedIndex],
    );
  }
}

// ==================== DASHBOARD HOME ====================
class DashboardHome extends StatelessWidget {
  final VoidCallback toggleDarkMode;
  const DashboardHome({super.key, required this.toggleDarkMode});

  @override
  Widget build(BuildContext context) {
    final data = DataService();
    final unexcusedAbsences = data.attendances
        .where((a) => a.status == 'absent')
        .length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, const Color(0xFF1E3A8A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bienvenue, Administrateur ! 👋',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Gérez efficacement votre établissement',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          Text(
            '📊 Statistiques globales',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 16),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.15,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildStatCard(
                'Étudiants',
                data.studentCount,
                Icons.people_alt,
                AppColors.primary,
                AppColors.secondary,
              ),
              _buildStatCard(
                'Enseignants',
                data.teacherCount,
                Icons.person,
                Colors.orange.shade700,
                Colors.orange.shade50,
              ),
              _buildStatCard(
                'Cours',
                data.courseCount,
                Icons.book,
                Colors.green.shade700,
                Colors.green.shade50,
              ),
              _buildStatCard(
                'Absences non justifiées',
                unexcusedAbsences,
                Icons.warning_amber_rounded,
                Colors.red.shade700,
                Colors.red.shade50,
              ),
            ],
          ),

          const SizedBox(height: 32),

          Text(
            '⚡ Actions rapides',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 16),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildActionCard(
                context,
                'Gérer étudiants',
                Icons.people,
                AppColors.primary,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => StudentManagement()),
                ),
              ),
              _buildActionCard(
                context,
                'Gérer enseignants',
                Icons.person,
                Colors.orange.shade700,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TeacherManagement()),
                ),
              ),
              _buildActionCard(
                context,
                'Gérer cours',
                Icons.book,
                Colors.green.shade700,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CourseManagement()),
                ),
              ),
              _buildActionCard(
                context,
                'Gérer paiements',
                Icons.payment,
                Colors.purple.shade700,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PaymentManagement()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, int count, IconData icon, Color color, Color bgColor) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [bgColor, bgColor.withOpacity(0.6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.accent,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}