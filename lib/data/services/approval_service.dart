import 'dart:developer' as developer;
import 'api_client.dart';

/// Pending Approval Model
class PendingApproval {
  final int id;
  final String number;
  final String description;
  final String severity;
  final String category;
  final String? location;
  final String? violatorName;
  final DateTime? violationDate;
  final Map<String, dynamic>? domain;
  final Map<String, dynamic>? stage;
  final Map<String, dynamic>? project;

  PendingApproval({
    required this.id,
    required this.number,
    required this.description,
    required this.severity,
    required this.category,
    this.location,
    this.violatorName,
    this.violationDate,
    this.domain,
    this.stage,
    this.project,
  });

  factory PendingApproval.fromJson(Map<String, dynamic> json) {
    return PendingApproval(
      id: json['id'] ?? 0,
      number: json['number'] ?? '',
      description: json['description'] ?? '',
      severity: json['severity'] ?? 'low',
      category: json['category'] ?? 'minor',
      location: json['location'],
      violatorName: json['violatorName'],
      violationDate: json['violationDate'] != null 
          ? DateTime.parse(json['violationDate']) 
          : null,
      domain: json['domain'] as Map<String, dynamic>?,
      stage: json['stage'] as Map<String, dynamic>?,
      project: json['project'] as Map<String, dynamic>?,
    );
  }

  String get domainNameAr => domain?['nameAr'] ?? 'غير محدد';
  String get domainNameEn => domain?['nameEn'] ?? 'Unknown';
  String get domainCode => domain?['code'] ?? 'general';
  String get domainColor => domain?['color'] ?? '#6B7280';
  
  String get stageNameAr => stage?['nameAr'] ?? 'غير محدد';
  String get stageNameEn => stage?['nameEn'] ?? 'Unknown';
  String get stageColor => stage?['color'] ?? '#6B7280';
  
  String get projectName => project?['name'] ?? 'غير محدد';
  String get projectCode => project?['code'] ?? '';
}

/// Approval Service - Connected to Cloud Backend
class ApprovalService {
  final ApiClient _apiClient = ApiClient();
  
  // Singleton pattern
  static final ApprovalService _instance = ApprovalService._internal();
  factory ApprovalService() => _instance;
  ApprovalService._internal();

  /// Fetch pending approvals for user based on their role
  Future<List<PendingApproval>> getPendingApprovals(String userId) async {
    try {
      developer.log('📋 Fetching pending approvals for user: $userId');
      
      final response = await _apiClient.get(
        '/api/public/pending-approvals/$userId',
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['success'] == true && data['approvals'] != null) {
          final approvalsList = (data['approvals'] as List)
              .map((json) => PendingApproval.fromJson(json))
              .toList();
          
          developer.log('✅ Fetched ${approvalsList.length} pending approvals');
          developer.log('   User role: ${data['userRole']}');
          
          return approvalsList;
        }
      }
      
      developer.log('⚠️ No pending approvals found');
      return [];
    } catch (e) {
      developer.log('❌ Error fetching pending approvals: $e');
      return [];
    }
  }

  /// Get pending approvals count
  Future<int> getPendingCount(String userId) async {
    try {
      final response = await _apiClient.get(
        '/api/public/pending-approvals/$userId/count',
      );
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['count'] ?? 0;
      }
      return 0;
    } catch (e) {
      developer.log('❌ Error getting pending count: $e');
      return 0;
    }
  }

  /// Get user role from pending approvals response
  Future<String?> getUserRole(String userId) async {
    try {
      final response = await _apiClient.get(
        '/api/public/pending-approvals/$userId',
      );
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['userRole'] as String?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
