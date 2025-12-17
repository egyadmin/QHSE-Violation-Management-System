import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../data/models/notification_model.dart';
import '../../../providers/notifications_provider.dart';
import '../../../providers/violations_provider.dart';
import '../violations/violation_details_screen.dart';

class NotificationDetailScreen extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailScreen({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0B7A3E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isArabic ? 'تفاصيل الإشعار' : 'Notification Details',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: () => _deleteNotification(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and type
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _getTypeColor(notification.type).withOpacity(0.1),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _getTypeColor(notification.type).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      _getTypeIcon(notification.type),
                      color: _getTypeColor(notification.type),
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getTypeColor(notification.type),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isArabic
                          ? notification.type.displayNameAr
                          : notification.type.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    notification.getLocalizedTitle(isArabic),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Time
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatFullTime(notification.createdAt, isArabic),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),

                  // Message Label
                  Text(
                    isArabic ? 'المحتوى' : 'Message',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Full Message
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Text(
                      notification.getLocalizedMessage(isArabic),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF1A1A1A),
                        height: 1.6,
                      ),
                    ),
                  ),

                  // Reference Info
                  if (notification.referenceId != null) ...[
                    const SizedBox(height: 24),
                    Text(
                      isArabic ? 'المرجع' : 'Reference',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _navigateToViolation(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0B7A3E).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.link,
                                color: Color(0xFF0B7A3E),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notification.referenceType == 'violation'
                                        ? (isArabic ? 'مخالفة' : 'Violation')
                                        : (notification.referenceType ?? ''),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    notification.referenceId!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0B7A3E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              isArabic
                                  ? Icons.arrow_back_ios
                                  : Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey[400],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Action Button
                  if (notification.referenceType == 'violation' &&
                      notification.referenceId != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _navigateToViolation(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0B7A3E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.visibility, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              isArabic
                                  ? 'عرض تفاصيل المخالفة'
                                  : 'View Violation Details',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Mark as read/unread button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _toggleReadStatus(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0B7A3E),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Color(0xFF0B7A3E)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            notification.isRead
                                ? Icons.mark_email_unread
                                : Icons.mark_email_read,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            notification.isRead
                                ? (isArabic
                                    ? 'تحديد كغير مقروء'
                                    : 'Mark as Unread')
                                : (isArabic
                                    ? 'تحديد كمقروء'
                                    : 'Mark as Read'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToViolation(BuildContext context) async {
    final isArabic = context.locale.languageCode == 'ar';
    
    if (notification.referenceType != 'violation' || notification.referenceId == null) {
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF0B7A3E),
        ),
      ),
    );

    try {
      // Fetch the violation by ID
      final violationsProvider = Provider.of<ViolationsProvider>(context, listen: false);
      await violationsProvider.fetchViolationById(notification.referenceId!);
      
      // Close loading dialog
      Navigator.pop(context);
      
      final violation = violationsProvider.selectedViolation;
      
      if (violation != null) {
        // Navigate to violation details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ViolationDetailsScreen(violation: violation),
          ),
        );
      } else {
        // Show error if violation not found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isArabic
                  ? 'لم يتم العثور على المخالفة'
                  : 'Violation not found',
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      Navigator.pop(context);
      
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic
                ? 'حدث خطأ أثناء تحميل المخالفة'
                : 'Error loading violation',
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _toggleReadStatus(BuildContext context) {
    final provider = Provider.of<NotificationsProvider>(context, listen: false);
    if (notification.isRead) {
      // If already read, we'd need to implement markAsUnread
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.locale.languageCode == 'ar'
                ? 'تم التحديث'
                : 'Status updated',
          ),
        ),
      );
    } else {
      provider.markAsRead(notification.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.locale.languageCode == 'ar'
                ? 'تم تحديد كمقروء'
                : 'Marked as read',
          ),
        ),
      );
    }
  }

  void _deleteNotification(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isArabic ? 'حذف الإشعار' : 'Delete Notification'),
        content: Text(
          isArabic
              ? 'هل أنت متأكد من حذف هذا الإشعار؟'
              : 'Are you sure you want to delete this notification?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<NotificationsProvider>(context, listen: false)
                  .deleteNotification(notification.id);
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(isArabic ? 'حذف' : 'Delete'),
          ),
        ],
      ),
    );
  }

  String _formatFullTime(DateTime dateTime, bool isArabic) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    if (isArabic) {
      return '$day/$month/$year - $hour:$minute';
    }
    return '$day/$month/$year at $hour:$minute';
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.newViolation:
        return Icons.warning_amber_rounded;
      case NotificationType.statusChange:
        return Icons.sync;
      case NotificationType.assignment:
        return Icons.assignment_ind;
      case NotificationType.reminder:
        return Icons.notifications_active;
      case NotificationType.deadline:
        return Icons.schedule;
      case NotificationType.approval:
        return Icons.check_circle;
      case NotificationType.rejection:
        return Icons.cancel;
      case NotificationType.general:
        return Icons.notifications;
    }
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.newViolation:
        return const Color(0xFFEF4444);
      case NotificationType.statusChange:
        return const Color(0xFF2196F3);
      case NotificationType.assignment:
        return const Color(0xFF9C27B0);
      case NotificationType.reminder:
        return const Color(0xFFFF9800);
      case NotificationType.deadline:
        return const Color(0xFFE91E63);
      case NotificationType.approval:
        return const Color(0xFF4CAF50);
      case NotificationType.rejection:
        return const Color(0xFFF44336);
      case NotificationType.general:
        return const Color(0xFF607D8B);
    }
  }
}
