import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../data/models/notification_model.dart';
import '../data/services/notification_service.dart';
import '../data/services/auth_service.dart';

/// Provider for managing notifications state with Cloud API
class NotificationsProvider extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  final AuthService _authService = AuthService();

  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _error;
  int _unreadCount = 0;
  String? _userId;

  // Getters
  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get unreadCount => _unreadCount;
  bool get hasUnread => _unreadCount > 0;
  
  List<NotificationModel> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();
  
  List<NotificationModel> get readNotifications =>
      _notifications.where((n) => n.isRead).toList();

  /// Get current user ID from auth
  Future<String?> _getUserId() async {
    if (_userId != null) return _userId;
    
    final user = await _authService.getCurrentUser();
    _userId = user?['id'] as String?;
    
    developer.log('📱 Current user ID: $_userId');
    return _userId;
  }

  /// Fetch all notifications from cloud
  Future<void> fetchNotifications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userId = await _getUserId();
      
      if (userId == null) {
        developer.log('⚠️ No user logged in, cannot fetch notifications');
        _notifications = [];
        _unreadCount = 0;
        _error = 'Please login to view notifications';
      } else {
        _notifications = await _notificationService.getNotifications(userId);
        _unreadCount = _notifications.where((n) => !n.isRead).length;
        _error = null;
        developer.log('✅ Loaded ${_notifications.length} notifications, ${_unreadCount} unread');
      }
    } catch (e) {
      developer.log('❌ Error fetching notifications: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh notifications
  Future<void> refresh() async {
    await fetchNotifications();
  }

  /// Reset notifications - clear cache and refetch from cloud
  Future<void> resetNotifications() async {
    _notifications = [];
    _unreadCount = 0;
    _userId = null; // Reset user ID to refetch
    notifyListeners();
    await fetchNotifications();
  }

  /// Fetch unread count only (for badge)
  Future<void> fetchUnreadCount() async {
    try {
      final userId = await _getUserId();
      if (userId != null) {
        _unreadCount = await _notificationService.getUnreadCount(userId);
        notifyListeners();
      }
    } catch (e) {
      developer.log('Error fetching unread count: $e');
    }
  }

  /// Mark a single notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      final notificationIdInt = int.tryParse(notificationId);
      if (notificationIdInt != null) {
        final success = await _notificationService.markAsRead(notificationIdInt);
        if (success) {
          final index = _notifications.indexWhere((n) => n.id == notificationId);
          if (index != -1 && !_notifications[index].isRead) {
            _notifications[index] = _notifications[index].copyWith(isRead: true);
            _unreadCount = _unreadCount > 0 ? _unreadCount - 1 : 0;
            notifyListeners();
          }
        }
      }
    } catch (e) {
      developer.log('Error marking notification as read: $e');
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      final userId = await _getUserId();
      if (userId != null) {
        final success = await _notificationService.markAllAsRead(userId);
        if (success) {
          _notifications = _notifications
              .map((n) => n.copyWith(isRead: true))
              .toList();
          _unreadCount = 0;
          notifyListeners();
        }
      }
    } catch (e) {
      developer.log('Error marking all as read: $e');
    }
  }

  /// Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      final success = await _notificationService.deleteNotification(notificationId);
      if (success) {
        final notification = _notifications.firstWhere(
          (n) => n.id == notificationId,
          orElse: () => _notifications.first,
        );
        if (!notification.isRead) {
          _unreadCount = _unreadCount > 0 ? _unreadCount - 1 : 0;
        }
        _notifications.removeWhere((n) => n.id == notificationId);
        notifyListeners();
      }
    } catch (e) {
      developer.log('Error deleting notification: $e');
    }
  }

  /// Clear all notifications
  Future<void> clearAll() async {
    for (final notification in List.from(_notifications)) {
      await _notificationService.deleteNotification(notification.id);
    }
    _notifications.clear();
    _unreadCount = 0;
    notifyListeners();
  }

  /// Get notifications by type
  List<NotificationModel> getByType(NotificationType type) {
    return _notifications.where((n) => n.type == type).toList();
  }
}
