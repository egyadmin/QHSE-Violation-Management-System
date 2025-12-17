import 'dart:convert';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model.dart';
import 'api_client.dart';

/// Notification Service - Connected to Cloud Backend
class NotificationService {
  final ApiClient _apiClient = ApiClient();
  static const String _localNotificationsKey = 'local_notifications';
  
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  /// Fetch notifications from cloud API
  Future<List<NotificationModel>> getNotifications(String userId) async {
    try {
      developer.log('📬 Fetching notifications for user: $userId');
      
      final response = await _apiClient.get(
        '/api/public/notifications/$userId',
      );
      
      developer.log('📬 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['success'] == true && data['notifications'] != null) {
          final notificationsList = (data['notifications'] as List)
              .map((json) => NotificationModel.fromApiJson(json))
              .toList();
          
          developer.log('✅ Fetched ${notificationsList.length} notifications from cloud');
          
          // Cache locally
          await saveLocalNotifications(notificationsList);
          
          return notificationsList;
        }
      }
      
      // Fallback to local
      developer.log('⚠️ Cloud fetch failed, using local cache');
      return await getLocalNotifications();
    } catch (e) {
      developer.log('❌ Error fetching notifications: $e');
      return await getLocalNotifications();
    }
  }

  /// Get unread notifications count from cloud
  Future<int> getUnreadCount(String userId) async {
    try {
      final response = await _apiClient.get(
        '/api/public/notifications/$userId/unread-count',
      );
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['unreadCount'] ?? 0;
      }
      return 0;
    } catch (e) {
      developer.log('❌ Error getting unread count: $e');
      return 0;
    }
  }

  /// Mark notification as read on cloud
  Future<bool> markAsRead(int notificationId) async {
    try {
      developer.log('📖 Marking notification $notificationId as read');
      
      final response = await _apiClient.patch(
        '/api/public/notifications/$notificationId/read',
      );
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        developer.log('✅ Notification marked as read');
        return true;
      }
      return false;
    } catch (e) {
      developer.log('❌ Error marking as read: $e');
      return false;
    }
  }

  /// Mark all notifications as read on cloud
  Future<bool> markAllAsRead(String userId) async {
    try {
      developer.log('📖 Marking all notifications as read for user: $userId');
      
      final response = await _apiClient.patch(
        '/api/public/notifications/user/$userId/read-all',
      );
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        developer.log('✅ All notifications marked as read');
        return true;
      }
      return false;
    } catch (e) {
      developer.log('❌ Error marking all as read: $e');
      return false;
    }
  }

  /// Delete notification (local only for now)
  Future<bool> deleteNotification(String notificationId) async {
    try {
      final notifications = await getLocalNotifications();
      notifications.removeWhere((n) => n.id == notificationId);
      await saveLocalNotifications(notifications);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get local notifications from cache
  Future<List<NotificationModel>> getLocalNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_localNotificationsKey);
      
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((json) => NotificationModel.fromJson(json)).toList();
      }
    } catch (e) {
      developer.log('Error loading local notifications: $e');
    }
    return [];
  }

  /// Save notifications locally
  Future<void> saveLocalNotifications(List<NotificationModel> notifications) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(notifications.map((n) => n.toJson()).toList());
      await prefs.setString(_localNotificationsKey, jsonString);
    } catch (e) {
      developer.log('Error saving local notifications: $e');
    }
  }
}
