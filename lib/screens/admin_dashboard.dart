// lib/screens/admin_dashboard.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../constants/colors.dart';
import '../services/data_service.dart';
import '../widgets/custom_drawer.dart';
import 'admin/student_management.dart';
import 'admin/teacher_management.dart';
import 'admin/course_management.dart';
import 'admin/payment_management.dart';
import 'statistics_screen.dart';
import 'settings_screen.dart';
import 'login_screen.dart';

class AdminDashboard extends StatefulWidget {
  final VoidCallback toggleDarkMode;
  const AdminDashboard({super.key, required this.toggleDarkMode});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int selectedIndex = 0;
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      DashboardHome(),
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
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text(
          "BUI Smart Campus",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: widget.toggleDarkMode,
          ),
          PopupMenuButton(
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: "logout",
                child: Text("Déconnexion"),
              )
            ],
            onSelected: (value) {
              if (value == "logout") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(
                      toggleDarkMode: widget.toggleDarkMode,
                    ),
                  ),
                );
              }
            },
          )
        ],
      ),
      drawer: CustomDrawer(
        role: "admin",
        onItemSelected: (i) {
          setState(() {
            selectedIndex = i;
          });
        },
      ),
      body: pages[selectedIndex],
    );
  }
}

// ==================== DASHBOARD HOME ====================
class DashboardHome extends StatelessWidget {
  DashboardHome({super.key});
  final DataService data = DataService();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return LayoutBuilder(
      builder: (context, constraints) {
        bool desktop = constraints.maxWidth > 1000;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 25),
              _topCards(context),
              const SizedBox(height: 25),
              desktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: _chartCard(context),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: 280,
                          child: _rightStatistics(context),
                        )
                      ],
                    )
                  : Column(
                      children: [
                        _chartCard(context),
                        const SizedBox(height: 20),
                        _rightStatistics(context),
                      ],
                    ),
              const SizedBox(height: 25),
              _quickActions(context),
              const SizedBox(height: 25),
              _recentActivities(context),
            ],
          ),
        );
      },
    );
  }

  // ================= HEADER =================
  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Voir toutes les données de l'application ici",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Tableau de bord BUI Smart Campus",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= TOP CARDS =================
  Widget _topCards(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 18,
      mainAxisSpacing: 18,
      childAspectRatio: 1.45,
      children: [
        _statCard(context, "Étudiants", data.studentCount.toString(), Icons.people, AppColors.primary),
        _statCard(context, "Enseignants", data.teacherCount.toString(), Icons.person, Colors.orange),
        _statCard(context, "Cours", data.courseCount.toString(), Icons.menu_book, Colors.green),
        _statCard(context, "Paiements", data.payments.length.toString(), Icons.payments, Colors.purple),
      ],
    );
  }

  Widget _statCard(BuildContext context, String title, String value, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= CHART =================
  Widget _chartCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return Container(
      height: 420,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.analytics,
                color: AppColors.primary,
              ),
              const SizedBox(width: 10),
              Text(
                "Vue d'ensemble",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin'];
                        if (value.toInt() >= 0 && value.toInt() < months.length) {
                          return Text(
                            months[value.toInt()],
                            style: TextStyle(
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                              fontSize: 12,
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 4),
                      FlSpot(1, 5),
                      FlSpot(2, 3),
                      FlSpot(3, 7),
                      FlSpot(4, 8),
                      FlSpot(5, 6),
                    ],
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 4,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primary.withValues(alpha: 0.15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= RIGHT PANEL =================
  Widget _rightStatistics(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return Column(
      children: [
        _kpiCard(context, "Étudiants", data.studentCount.toString(), Icons.people, AppColors.primary),
        const SizedBox(height: 18),
        _kpiCard(context, "Enseignants", data.teacherCount.toString(), Icons.person, Colors.orange),
        const SizedBox(height: 18),
        _kpiCard(context, "Cours", data.courseCount.toString(), Icons.menu_book, Colors.green),
        const SizedBox(height: 18),
        _kpiCard(context, "Paiements", data.payments.length.toString(), Icons.payments, Colors.purple),
      ],
    );
  }

  Widget _kpiCard(BuildContext context, String title, String value, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: color.withValues(alpha: .10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: textColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // ================= QUICK ACTIONS =================
  Widget _quickActions(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Actions rapides",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            _actionCard(context, "Étudiants", Icons.people, AppColors.primary, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => StudentManagement()),
              );
            }),
            _actionCard(context, "Enseignants", Icons.person, Colors.orange, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TeacherManagement()),
              );
            }),
            _actionCard(context, "Cours", Icons.menu_book, Colors.green, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CourseManagement()),
              );
            }),
            _actionCard(context, "Paiements", Icons.payments, Colors.purple, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PaymentManagement()),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _actionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 160,
        height: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withValues(alpha: .10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= RECENT ACTIVITIES =================
  Widget _recentActivities(BuildContext context) {
    final activities = DataService().getRecentActivities();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final headingColor = isDark ? Colors.grey[800] : Colors.grey[100];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Dernières activités",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: textColor,
            ),
          ),
          const SizedBox(height: 20),
          if (activities.isEmpty)
            Center(
              child: Text(
                "Aucune activité récente",
                style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
              ),
            )
          else
            DataTable(
              headingRowColor: WidgetStateProperty.all(headingColor),
              columnSpacing: 20,
              columns: const [
                DataColumn(label: Text("Nom")),
                DataColumn(label: Text("Action")),
                DataColumn(label: Text("Date")),
              ],
              rows: activities.map((activity) {
                return DataRow(
                  cells: [
                    DataCell(Text(activity['name']!, style: TextStyle(color: textColor))),
                    DataCell(Text(activity['action']!, style: TextStyle(color: textColor))),
                    DataCell(Text(activity['date']!, style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]))),
                  ],
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}