/// Notification Model for QHSE App
class NotificationModel {
  final String id;
  final String title;
  final String titleAr;
  final String message;
  final String messageAr;
  final NotificationType type;
  final String? referenceId;
  final String? referenceType;
  final DateTime createdAt;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.message,
    required this.messageAr,
    required this.type,
    this.referenceId,
    this.referenceType,
    required this.createdAt,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      titleAr: json['titleAr'] ?? json['title_ar'] ?? json['title'] ?? '',
      message: json['message'] ?? '',
      messageAr: json['messageAr'] ?? json['message_ar'] ?? json['message'] ?? '',
      type: _parseNotificationType(json['type']),
      referenceId: json['referenceId']?.toString() ?? json['reference_id']?.toString(),
      referenceType: json['referenceType'] ?? json['reference_type'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : json['created_at'] != null 
              ? DateTime.parse(json['created_at'])
              : DateTime.now(),
      isRead: json['isRead'] ?? json['is_read'] ?? false,
    );
  }

  /// Factory for cloud API response format
  factory NotificationModel.fromApiJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      titleAr: json['title'] ?? '',  // API returns Arabic title in 'title'
      message: json['message'] ?? '',
      messageAr: json['message'] ?? '',  // API returns Arabic message in 'message'
      type: _parseNotificationType(json['type']),
      referenceId: json['relatedId']?.toString(),
      referenceType: json['relatedType'],
      createdAt: json['sentAt'] != null 
          ? DateTime.parse(json['sentAt']) 
          : DateTime.now(),
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'titleAr': titleAr,
      'message': message,
      'messageAr': messageAr,
      'type': type.name,
      'referenceId': referenceId,
      'referenceType': referenceType,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? titleAr,
    String? message,
    String? messageAr,
    NotificationType? type,
    String? referenceId,
    String? referenceType,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      titleAr: titleAr ?? this.titleAr,
      message: message ?? this.message,
      messageAr: messageAr ?? this.messageAr,
      type: type ?? this.type,
      referenceId: referenceId ?? this.referenceId,
      referenceType: referenceType ?? this.referenceType,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  static NotificationType _parseNotificationType(dynamic type) {
    if (type == null) return NotificationType.general;
    final typeStr = type.toString().toLowerCase();
    switch (typeStr) {
      case 'violation':
      case 'new_violation':
        return NotificationType.newViolation;
      case 'status_change':
      case 'statuschange':
        return NotificationType.statusChange;
      case 'assignment':
      case 'assigned':
        return NotificationType.assignment;
      case 'reminder':
        return NotificationType.reminder;
      case 'deadline':
        return NotificationType.deadline;
      case 'approval':
      case 'approved':
        return NotificationType.approval;
      case 'rejection':
      case 'rejected':
        return NotificationType.rejection;
      default:
        return NotificationType.general;
    }
  }

  String getLocalizedTitle(bool isArabic) {
    return isArabic ? (titleAr.isNotEmpty ? titleAr : title) : title;
  }

  String getLocalizedMessage(bool isArabic) {
    return isArabic ? (messageAr.isNotEmpty ? messageAr : message) : message;
  }
}

enum NotificationType {
  newViolation,
  statusChange,
  assignment,
  reminder,
  deadline,
  approval,
  rejection,
  general,
}

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.newViolation:
        return 'New Violation';
      case NotificationType.statusChange:
        return 'Status Change';
      case NotificationType.assignment:
        return 'Assignment';
      case NotificationType.reminder:
        return 'Reminder';
      case NotificationType.deadline:
        return 'Deadline';
      case NotificationType.approval:
        return 'Approval';
      case NotificationType.rejection:
        return 'Rejection';
      case NotificationType.general:
        return 'General';
    }
  }

  String get displayNameAr {
    switch (this) {
      case NotificationType.newViolation:
        return 'مخالفة جديدة';
      case NotificationType.statusChange:
        return 'تغيير الحالة';
      case NotificationType.assignment:
        return 'تعيين';
      case NotificationType.reminder:
        return 'تذكير';
      case NotificationType.deadline:
        return 'موعد نهائي';
      case NotificationType.approval:
        return 'موافقة';
      case NotificationType.rejection:
        return 'رفض';
      case NotificationType.general:
        return 'عام';
    }
  }
}
