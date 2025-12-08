import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/constants/app_icons.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import '../../screens/violations/violations_list_screen.dart';
import '../../screens/violations/new_violation_screen.dart';
import '../../screens/projects/projects_list_screen.dart';
import '../../screens/more/more_screen.dart';

/// Main Layout with Bottom Navigation and Center FAB
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const ViolationsListScreen(),
    const ProjectsListScreen(),
    const MoreScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onFabPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewViolationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    
    return Scaffold(
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _onFabPressed,
        backgroundColor: const Color(0xFF0B7A3E),
        elevation: 6,
        child: const Icon(
          Icons.add,
          size: 32,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        elevation: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Dashboard
              _buildNavItem(
                index: 0,
                icon: AppIcons.dashboard,
                label: isArabic ? 'لوحة التحكم' : 'Dashboard',
                isArabic: isArabic,
              ),
              // Violations
              _buildNavItem(
                index: 1,
                icon: AppIcons.violations,
                label: isArabic ? 'المخالفات' : 'Violations',
                isArabic: isArabic,
              ),
              // Spacer for FAB
              const SizedBox(width: 48),
              // Projects
              _buildNavItem(
                index: 2,
                icon: AppIcons.projects,
                label: isArabic ? 'المشاريع' : 'Projects',
                isArabic: isArabic,
              ),
              // More
              _buildNavItem(
                index: 3,
                icon: AppIcons.more,
                label: isArabic ? 'المزيد' : 'More',
                isArabic: isArabic,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isArabic,
  }) {
    final isSelected = _currentIndex == index;
    
    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF0B7A3E) : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? const Color(0xFF0B7A3E) : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
