import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/premium_widgets.dart';
import '../../../providers/violations_provider.dart';
import '../../../data/models/violation_model.dart';
import 'violation_details_screen.dart';

class ViolationsListScreen extends StatefulWidget {
  const ViolationsListScreen({super.key});

  @override
  State<ViolationsListScreen> createState() => _ViolationsListScreenState();
}

class _ViolationsListScreenState extends State<ViolationsListScreen> {
  String? _selectedFilter;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ViolationsProvider>(context, listen: false).fetchViolations();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // Premium Gradient AppBar
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: PremiumWidgets.primaryGreen,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0B7A3E), Color(0xFF10B981)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArabic ? 'قائمة المخالفات' : 'Violations',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Consumer<ViolationsProvider>(
                          builder: (context, provider, _) {
                            return Text(
                              isArabic 
                                ? '${provider.totalViolations} مخالفة مسجلة'
                                : '${provider.totalViolations} violations recorded',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.filter_list, color: Colors.white, size: 22),
                ),
                onPressed: () => _showFilterSheet(context, isArabic),
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: isArabic ? 'بحث في المخالفات...' : 'Search violations...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                ),
              ),
            ),
          ),

          // Filter Chips
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildFilterChip('all', isArabic ? 'الكل' : 'All', Colors.grey),
                  _buildFilterChip('safety', isArabic ? 'السلامة' : 'Safety', const Color(0xFFEF4444)),
                  _buildFilterChip('health', isArabic ? 'الصحة' : 'Health', const Color(0xFF10B981)),
                  _buildFilterChip('quality', isArabic ? 'الجودة' : 'Quality', const Color(0xFF3B82F6)),
                  _buildFilterChip('environment', isArabic ? 'البيئة' : 'Environment', const Color(0xFF059669)),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Violations List
          Consumer<ViolationsProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading && provider.violations.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF0B7A3E)),
                  ),
                );
              }

              if (provider.violations.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0B7A3E).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.folder_open,
                            size: 50,
                            color: Color(0xFF0B7A3E),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          isArabic ? 'لا توجد مخالفات' : 'No violations found',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isArabic ? 'المخالفات ستظهر هنا' : 'Violations will appear here',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= provider.violations.length) return null;
                      return _buildPremiumViolationCard(provider.violations[index], isArabic);
                    },
                    childCount: provider.violations.length + 1, // +1 for bottom padding
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label, Color color) {
    final isSelected = _selectedFilter == value || (value == 'all' && _selectedFilter == null);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = value == 'all' ? null : value;
        });
        Provider.of<ViolationsProvider>(context, listen: false)
            .fetchViolations(qhseDomain: _selectedFilter);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected 
            ? LinearGradient(colors: [color, color.withOpacity(0.8)])
            : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade200,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumViolationCard(Violation violation, bool isArabic) {
    final domainColor = _getDomainColor(violation.qhseDomain);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: domainColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
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
                builder: (context) => ViolationDetailsScreen(violation: violation),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row - Domain & Status
                Row(
                  children: [
                    // Domain Badge with gradient
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [domainColor.withOpacity(0.15), domainColor.withOpacity(0.05)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: domainColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_getDomainIcon(violation.qhseDomain), size: 16, color: domainColor),
                          const SizedBox(width: 6),
                          Text(
                            _getDomainLabel(violation.qhseDomain, isArabic),
                            style: TextStyle(
                              color: domainColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(violation.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _getStatusColor(violation.status),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _getStatusLabel(violation.status, isArabic),
                            style: TextStyle(
                              color: _getStatusColor(violation.status),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Title
                Text(
                  violation.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 8),
                
                // Description
                Text(
                  violation.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 16),
                
                // Footer Row
                Row(
                  children: [
                    // Severity
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getSeverityColor(violation.severity).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.priority_high,
                            size: 14,
                            color: _getSeverityColor(violation.severity),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getSeverityLabel(violation.severity, isArabic),
                            style: TextStyle(
                              fontSize: 11,
                              color: _getSeverityColor(violation.severity),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Date
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: Colors.grey[400]),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(violation.createdAt, isArabic),
                          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context, bool isArabic) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isArabic ? 'تصفية المخالفات' : 'Filter Violations',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            PremiumWidgets.gradientButton(
              text: isArabic ? 'تطبيق' : 'Apply Filters',
              icon: Icons.check,
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Color _getDomainColor(String domain) {
    switch (domain.toLowerCase()) {
      case 'safety': return const Color(0xFFEF4444);
      case 'health': return const Color(0xFF10B981);
      case 'quality': return const Color(0xFF3B82F6);
      case 'environment': return const Color(0xFF059669);
      default: return Colors.grey;
    }
  }

  IconData _getDomainIcon(String domain) {
    switch (domain.toLowerCase()) {
      case 'safety': return Icons.shield_outlined;
      case 'health': return Icons.favorite_outline;
      case 'quality': return Icons.verified_outlined;
      case 'environment': return Icons.eco_outlined;
      default: return Icons.category;
    }
  }

  String _getDomainLabel(String domain, bool isArabic) {
    switch (domain.toLowerCase()) {
      case 'safety': return isArabic ? 'السلامة' : 'Safety';
      case 'health': return isArabic ? 'الصحة' : 'Health';
      case 'quality': return isArabic ? 'الجودة' : 'Quality';
      case 'environment': return isArabic ? 'البيئة' : 'Environment';
      default: return domain;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return const Color(0xFFF59E0B);
      case 'under_review': return const Color(0xFFF97316);
      case 'approved': return const Color(0xFF22C55E);
      case 'closed': return const Color(0xFF3B82F6);
      case 'rejected': return const Color(0xFFEF4444);
      default: return Colors.grey;
    }
  }

  String _getStatusLabel(String status, bool isArabic) {
    switch (status.toLowerCase()) {
      case 'pending': return isArabic ? 'قيد الانتظار' : 'Pending';
      case 'under_review': return isArabic ? 'قيد المراجعة' : 'Under Review';
      case 'approved': return isArabic ? 'موافق عليها' : 'Approved';
      case 'closed': return isArabic ? 'مغلقة' : 'Closed';
      case 'rejected': return isArabic ? 'مرفوضة' : 'Rejected';
      default: return status;
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'low': return const Color(0xFF22C55E);
      case 'medium': return const Color(0xFFF59E0B);
      case 'high': return const Color(0xFFF97316);
      case 'critical': return const Color(0xFFEF4444);
      default: return Colors.grey;
    }
  }

  String _getSeverityLabel(String severity, bool isArabic) {
    switch (severity.toLowerCase()) {
      case 'low': return isArabic ? 'منخفضة' : 'Low';
      case 'medium': return isArabic ? 'متوسطة' : 'Medium';
      case 'high': return isArabic ? 'عالية' : 'High';
      case 'critical': return isArabic ? 'حرجة' : 'Critical';
      default: return severity;
    }
  }

  String _formatDate(DateTime date, bool isArabic) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return isArabic ? 'منذ ${difference.inMinutes} دقيقة' : '${difference.inMinutes}m ago';
      }
      return isArabic ? 'منذ ${difference.inHours} ساعة' : '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return isArabic ? 'منذ ${difference.inDays} يوم' : '${difference.inDays}d ago';
    }
    
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
