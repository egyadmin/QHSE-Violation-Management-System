import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../data/models/violation_model.dart';

class ViolationDetailsScreen extends StatelessWidget {
  final Violation violation;

  const ViolationDetailsScreen({
    super.key,
    required this.violation,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0B7A3E),
        title: Text(
          isArabic ? 'تفاصيل المخالفة' : 'Violation Details',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with domain and status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getDomainColor(violation.qhseDomain),
                    _getDomainColor(violation.qhseDomain).withOpacity(0.7),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Domain badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getDomainIcon(violation.qhseDomain),
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getDomainLabel(violation.qhseDomain, isArabic),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Title
                  Text(
                    violation.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Metadata
                  Row(
                    children: [
                      _buildMetaChip(
                        _getSeverityLabel(violation.severity, isArabic),
                        _getSeverityColor(violation.severity),
                      ),
                      const SizedBox(width: 8),
                      _buildMetaChip(
                        _getStatusLabel(violation.status, isArabic),
                        _getStatusColor(violation.status),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description section
                  _buildSection(
                    isArabic ? 'الوصف' : 'Description',
                    Icons.description,
                    violation.description,
                    isArabic,
                  ),

                  const SizedBox(height: 20),

                  // Project
                  if (violation.projectName != null && violation.projectName!.isNotEmpty)
                    _buildSection(
                      isArabic ? 'المشروع' : 'Project',
                      Icons.folder,
                      violation.projectName!,
                      isArabic,
                    ),

                  if (violation.projectName != null && violation.projectName!.isNotEmpty)
                    const SizedBox(height: 20),

                  // Location
                  if (violation.location != null && violation.location!.isNotEmpty)
                    _buildSection(
                      isArabic ? 'الموقع' : 'Location',
                      Icons.location_on,
                      violation.location!,
                      isArabic,
                    ),

                  if (violation.location != null && violation.location!.isNotEmpty)
                    const SizedBox(height: 20),

                  // Reported by
                  if (violation.reportedByName != null && violation.reportedByName!.isNotEmpty)
                    _buildSection(
                      isArabic ? 'المُبلغ' : 'Reported By',
                      Icons.person,
                      violation.reportedByName!,
                      isArabic,
                    ),

                  if (violation.reportedByName != null && violation.reportedByName!.isNotEmpty)
                    const SizedBox(height: 20),

                  // Dates
                  _buildInfoCard(
                    isArabic,
                    [
                      {
                        'label': isArabic ? 'تاريخ الإنشاء' : 'Created',
                        'value': _formatDate(violation.createdAt, isArabic),
                        'icon': Icons.calendar_today,
                      },
                      {
                        'label': isArabic ? 'آخر تحديث' : 'Last Updated',
                        'value': _formatDate(violation.updatedAt ?? violation.createdAt, isArabic),
                        'icon': Icons.update,
                      },
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Attachments
                  if (violation.attachments != null && violation.attachments!.isNotEmpty) ...[
                    _buildSectionTitle(isArabic ? 'المرفقات' : 'Attachments', Icons.attach_file),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: violation.attachments!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(violation.attachments![index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, String content, bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title, icon),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
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
          child: Text(
            content,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF0B7A3E)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(bool isArabic, List<Map<String, dynamic>> items) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Icon(item['icon'], size: 20, color: const Color(0xFF0B7A3E)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['label'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['value'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMetaChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getDomainColor(String domain) {
    switch (domain.toLowerCase()) {
      case 'safety':
        return const Color(0xFFE53935);
      case 'health':
        return const Color(0xFF43A047);
      case 'quality':
        return const Color(0xFF1E88E5);
      case 'environment':
        return const Color(0xFF00ACC1);
      default:
        return const Color(0xFF757575);
    }
  }

  IconData _getDomainIcon(String domain) {
    switch (domain.toLowerCase()) {
      case 'safety':
        return Icons.security;
      case 'health':
        return Icons.favorite;
      case 'quality':
        return Icons.verified;
      case 'environment':
        return Icons.eco;
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
    if (status.toLowerCase().contains('open') || status.toLowerCase().contains('pending')) {
      return Colors.orange;
    } else if (status.toLowerCase().contains('closed') || status.toLowerCase().contains('resolved')) {
      return Colors.green;
    } else if (status.toLowerCase().contains('progress')) {
      return Colors.blue;
    }
    return Colors.grey;
  }

  String _getStatusLabel(String status, bool isArabic) {
    if (status.toLowerCase().contains('open') || status.toLowerCase().contains('pending')) {
      return isArabic ? 'قيد الانتظار' : 'Pending';
    } else if (status.toLowerCase().contains('closed') || status.toLowerCase().contains('resolved')) {
      return isArabic ? 'مغلقة' : 'Closed';
    } else if (status.toLowerCase().contains('progress')) {
      return isArabic ? 'قيد المعالجة' : 'In Progress';
    }
    return status;
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return const Color(0xFFD32F2F);
      case 'high':
        return const Color(0xFFF57C00);
      case 'medium':
        return const Color(0xFFFBC02D);
      case 'low':
        return const Color(0xFF388E3C);
      default:
        return Colors.grey;
    }
  }

  String _getSeverityLabel(String severity, bool isArabic) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return isArabic ? 'حرجة' : 'Critical';
      case 'high':
        return isArabic ? 'عالية' : 'High';
      case 'medium':
        return isArabic ? 'متوسطة' : 'Medium';
      case 'low':
        return isArabic ? 'منخفضة' : 'Low';
      default:
        return severity;
    }
  }

  String _formatDate(DateTime date, bool isArabic) {
    if (isArabic) {
      return DateFormat('dd/MM/yyyy - hh:mm a', 'ar').format(date);
    }
    return DateFormat('MMM dd, yyyy - hh:mm a').format(date);
  }
}
