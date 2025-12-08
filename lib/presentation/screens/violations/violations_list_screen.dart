import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ViolationsProvider>(context, listen: false).fetchViolations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0B7A3E),
        title: Text(
          isArabic ? 'قائمة المخالفات' : 'Violations List',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () => _showFilterDialog(context, isArabic),
          ),
        ],
      ),
      body: Consumer<ViolationsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.violations.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF0B7A3E),
              ),
            );
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.errorMessage!,
                    style: TextStyle(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.refresh(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B7A3E),
                    ),
                    child: Text(isArabic ? 'إعادة المحاولة' : 'Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.violations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_open,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isArabic ? 'لا توجد مخالفات' : 'No violations found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.refresh(),
            color: const Color(0xFF0B7A3E),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.violations.length,
              itemBuilder: (context, index) {
                final violation = provider.violations[index];
                return _buildViolationCard(violation, isArabic);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildViolationCard(Violation violation, bool isArabic) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
                builder: (context) => ViolationDetailsScreen(violation: violation),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    // Domain Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getDomainColor(violation.qhseDomain).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getDomainIcon(violation.qhseDomain),
                            size: 16,
                            color: _getDomainColor(violation.qhseDomain),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getDomainLabel(violation.qhseDomain, isArabic),
                            style: TextStyle(
                              color: _getDomainColor(violation.qhseDomain),
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
                      child: Text(
                        _getStatusLabel(violation.status, isArabic),
                        style: TextStyle(
                          color: _getStatusColor(violation.status),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Title
                Text(
                  violation.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
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
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 12),
                
                // Footer Row
                Row(
                  children: [
                    // Severity
                    Icon(
                      Icons.priority_high,
                      size: 16,
                      color: _getSeverityColor(violation.severity),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getSeverityLabel(violation.severity, isArabic),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getSeverityColor(violation.severity),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Date
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(violation.createdAt, isArabic),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
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

  void _showFilterDialog(BuildContext context, bool isArabic) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isArabic ? 'تصفية المخالفات' : 'Filter Violations',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Status Filters
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFilterChip('all', isArabic ? 'الكل' : 'All', isArabic),
                _buildFilterChip('pending', isArabic ? 'قيد الانتظار' : 'Pending', isArabic),
                _buildFilterChip('under_review', isArabic ? 'قيد المراجعة' : 'Under Review', isArabic),
                _buildFilterChip('approved', isArabic ? 'موافق عليها' : 'Approved', isArabic),
                _buildFilterChip('closed', isArabic ? 'مغلقة' : 'Closed', isArabic),
              ],
            ),
            
            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedFilter = null;
                      });
                      Provider.of<ViolationsProvider>(context, listen: false)
                          .fetchViolations();
                      Navigator.pop(context);
                    },
                    child: Text(isArabic ? 'إعادة تعيين' : 'Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B7A3E),
                    ),
                    child: Text(isArabic ? 'تطبيق' : 'Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label, bool isArabic) {
    final isSelected = _selectedFilter == value || (value == 'all' && _selectedFilter == null);
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value == 'all' ? null : value;
        });
        Provider.of<ViolationsProvider>(context, listen: false)
            .fetchViolations(status: _selectedFilter);
      },
      selectedColor: const Color(0xFF0B7A3E).withOpacity(0.1),
      checkmarkColor: const Color(0xFF0B7A3E),
    );
  }

  Color _getDomainColor(String domain) {
    switch (domain.toLowerCase()) {
      case 'safety':
        return const Color(0xFFEF4444);
      case 'health':
        return const Color(0xFF10B981);
      case 'quality':
        return const Color(0xFF3B82F6);
      case 'environment':
        return const Color(0xFFF59E0B);
      default:
        return Colors.grey;
    }
  }

  IconData _getDomainIcon(String domain) {
    switch (domain.toLowerCase()) {
      case 'safety':
        return Icons.shield_outlined;
      case 'health':
        return Icons.favorite_outline;
      case 'quality':
        return Icons.verified_outlined;
      case 'environment':
        return Icons.eco_outlined;
      default:
        return Icons.category;
    }
  }

  String _getDomainLabel(String domain, bool isArabic) {
    switch (domain.toLowerCase()) {
      case 'safety':
        return isArabic ? 'السلامة' : 'Safety';
      case 'health':
        return isArabic ? 'الصحة' : 'Health';
      case 'quality':
        return isArabic ? 'الجودة' : 'Quality';
      case 'environment':
        return isArabic ? 'البيئة' : 'Environment';
      default:
        return domain;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'under_review':
        return const Color(0xFFF97316);
      case 'approved':
        return const Color(0xFF22C55E);
      case 'closed':
        return const Color(0xFF3B82F6);
      case 'rejected':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status, bool isArabic) {
    switch (status.toLowerCase()) {
      case 'pending':
        return isArabic ? 'قيد الانتظار' : 'Pending';
      case 'under_review':
        return isArabic ? 'قيد المراجعة' : 'Under Review';
      case 'approved':
        return isArabic ? 'موافق عليها' : 'Approved';
      case 'closed':
        return isArabic ? 'مغلقة' : 'Closed';
      case 'rejected':
        return isArabic ? 'مرفوضة' : 'Rejected';
      default:
        return status;
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'low':
        return const Color(0xFF22C55E);
      case 'medium':
        return const Color(0xFFF59E0B);
      case 'high':
        return const Color(0xFFF97316);
      case 'critical':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }

  String _getSeverityLabel(String severity, bool isArabic) {
    switch (severity.toLowerCase()) {
      case 'low':
        return isArabic ? 'منخفضة' : 'Low';
      case 'medium':
        return isArabic ? 'متوسطة' : 'Medium';
      case 'high':
        return isArabic ? 'عالية' : 'High';
      case 'critical':
        return isArabic ? 'حرجة' : 'Critical';
      default:
        return severity;
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
