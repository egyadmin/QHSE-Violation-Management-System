import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/violations_provider.dart';
import '../violations/violations_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch violations data on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ViolationsProvider>(context, listen: false).fetchViolations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;
    final isArabic = context.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0B7A3E),
        title: Text(
          isArabic ? 'لوحة التحكم' : 'Dashboard',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isArabic ? 'الإشعارات قريباً' : 'Notifications coming soon'),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.language, color: Colors.white),
            onPressed: () {
              if (context.locale.languageCode == 'ar') {
                context.setLocale(const Locale('en', 'US'));
              } else {
                context.setLocale(const Locale('ar', 'SA'));
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => Provider.of<ViolationsProvider>(context, listen: false).refresh(),
        color: const Color(0xFF0B7A3E),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Gradient Section
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF0B7A3E),
                      Color(0xFF0D9448),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    
                    // User Welcome Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundColor: const Color(0xFF0B7A3E),
                              child: Text(
                                user?.firstName?.substring(0, 1).toUpperCase() ?? 'A',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${isArabic ? 'مرحباً' : 'Welcome'}, ${user?.displayName ?? 'Admin SAJCO'}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user?.position ?? (isArabic ? 'مدير النظام' : 'System Administrator'),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Quick Stats Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'إحصائيات سريعة' : 'Quick Stats',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Stats Grid - Using real data from provider
                    Consumer<ViolationsProvider>(
                      builder: (context, provider, child) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    context,
                                    title: isArabic ? 'المخالفات' : 'Violations',
                                    value: provider.totalViolations.toString(),
                                    icon: Icons.warning_amber_rounded,
                                    color: const Color(0xFF2196F3),
                                    isArabic: isArabic,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildStatCard(
                                    context,
                                    title: isArabic ? 'قيد المراجعة' : 'Under Review',
                                    value: provider.underReviewCount.toString(),
                                    icon: Icons.hourglass_empty_rounded,
                                    color: const Color(0xFFFF9800),
                                    isArabic: isArabic,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    context,
                                    title: isArabic ? 'تم الإغلاق' : 'Closed',
                                    value: provider.closedCount.toString(),
                                    icon: Icons.done_all_rounded,
                                    color: const Color(0xFF757575),
                                    isArabic: isArabic,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildStatCard(
                                    context,
                                    title: isArabic ? 'موافق عليها' : 'Approved',
                                    value: provider.approvedCount.toString(),
                                    icon: Icons.check_circle_rounded,
                                    color: const Color(0xFF4CAF50),
                                    isArabic: isArabic,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // QHSE Domains Section - Using real data
                    Text(
                      isArabic ? 'تصنيفات QHSE' : 'QHSE Categories',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Consumer<ViolationsProvider>(
                      builder: (context, provider, child) {
                        return Column(
                          children: [
                            _buildDomainCard(
                              context,
                              title: isArabic ? 'السلامة' : 'Safety',
                              subtitle: isArabic 
                                  ? '${provider.safetyCount} مخالفة' 
                                  : '${provider.safetyCount} violations',
                              icon: Icons.shield_outlined,
                              color: const Color(0xFFEF4444),
                              isArabic: isArabic,
                              domain: 'safety',
                            ),
                            const SizedBox(height: 12),
                            _buildDomainCard(
                              context,
                              title: isArabic ? 'الصحة' : 'Health',
                              subtitle: isArabic 
                                  ? '${provider.healthCount} مخالفة' 
                                  : '${provider.healthCount} violations',
                              icon: Icons.favorite_border,
                              color: const Color(0xFF00897B),
                              isArabic: isArabic,
                              domain: 'health',
                            ),
                            const SizedBox(height: 12),
                            _buildDomainCard(
                              context,
                              title: isArabic ? 'الجودة' : 'Quality',
                              subtitle: isArabic 
                                  ? '${provider.qualityCount} مخالفة' 
                                  : '${provider.qualityCount} violations',
                              icon: Icons.verified_outlined,
                              color: const Color(0xFF1E88E5),
                              isArabic: isArabic,
                              domain: 'quality',
                            ),
                            const SizedBox(height: 12),
                            _buildDomainCard(
                              context,
                              title: isArabic ? 'البيئة' : 'Environment',
                              subtitle: isArabic 
                                  ? '${provider.environmentCount} مخالفة' 
                                  : '${provider.environmentCount} violations',
                              icon: Icons.eco_outlined,
                              color: const Color(0xFF43A047),
                              isArabic: isArabic,
                              domain: 'environment',
                            ),
                            const SizedBox(height: 100), // Space for FAB
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isArabic,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDomainCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isArabic,
    required String domain,  // Add domain parameter
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ViolationsListScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isArabic ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
