import 'dart:developer' as developer;
import '../models/violation_model.dart';
import 'api_client.dart';

/// Service for QHSE Violations - Connected to Cloud Backend
class ViolationsService {
  final ApiClient _apiClient;

  ViolationsService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Parse response - handles both tRPC format and direct responses
  dynamic _parseTRPCResponse(dynamic responseData) {
    // Public API returns arrays directly
    if (responseData is List) {
      return responseData;
    }
    
    // tRPC format: { result: { data: [...] } }
    if (responseData is Map<String, dynamic>) {
      if (responseData.containsKey('result')) {
        final result = responseData['result'];
        if (result is Map && result.containsKey('data')) {
          return result['data'];
        }
        return result;
      }
    }
    
    return responseData;
  }

  /// Get all violations from cloud
  Future<List<Violation>> getViolations({
    int page = 1,
    int pageSize = 20,
    String? status,
    String? qhseDomain,
  }) async {
    try {
      developer.log('📋 Fetching QHSE violations from cloud');
      developer.log('   Page: $page, PageSize: $pageSize');
      if (status != null) developer.log('   Status filter: $status');
      if (qhseDomain != null) developer.log('   Domain filter: $qhseDomain');
      
      final queryParams = {
        'page': page.toString(),
        'pageSize': pageSize.toString(),
        if (status != null) 'status': status,
        if (qhseDomain != null) 'domain': qhseDomain,
      };

      final response = await _apiClient.get(
        '/api/public/violations',
        queryParameters: queryParams,
      );
      
      developer.log('📦 Raw response type: ${response.data.runtimeType}');
      developer.log('📦 Raw response data (first 500 chars): ${response.data.toString().substring(0, response.data.toString().length > 500 ? 500 : response.data.toString().length)}');
      
      final data = _parseTRPCResponse(response.data);
      
      developer.log('📦 Parsed data type: ${data.runtimeType}');
      developer.log('📦 Is List? ${data is List}');
      if (data is List) {
        developer.log('📦 List length: ${data.length}');
      }
      developer.log('✅ Fetched ${data is List ? data.length : 0} violations');
      
      if (data is List) {
        return data.map((v) => Violation.fromJson(v as Map<String, dynamic>)).toList();
      }
      
      developer.log('⚠️ Unexpected response format, returning empty list');
      return [];
    } catch (e, stackTrace) {
      developer.log('❌ Error fetching violations: $e');
      developer.log('   Stack trace: $stackTrace');
      return [];
    }
  }

  /// Get violation by ID
  Future<Violation?> getViolationById(String id) async {
    try {
      developer.log('🔍 Fetching violation: $id');
      
      final response = await _apiClient.get(
        '/api/public/violations',
        queryParameters: {'id': id},
      );
      
      final data = _parseTRPCResponse(response.data);
      
      if (data is Map<String, dynamic>) {
        return Violation.fromJson(data);
      }
      
      return null;
    } catch (e) {
      developer.log('❌ Error fetching violation: $e');
      return null;
    }
  }

  /// Create new violation - Updated to match backend API contract
  Future<Violation> createViolation({
    required String title,
    required String description,
    required String qhseDomain,
    required String severity,
    required int violationTypeId,  // Must be violation type ID from API
    String? projectId,
    String? location,
    double? latitude,
    double? longitude,
    String? violatorName,
    String? violatorId,
    String? violatorEmpId,
    List<String>? attachments,
  }) async {
    try {
      developer.log('➕ Creating QHSE violation on cloud');
      
      // Convert domain string to ID (safety=1, health=2, quality=3, environment=4)
      final domainId = _getDomainId(qhseDomain);
      
      // Convert projectId to int
      final projectIdInt = projectId != null ? int.tryParse(projectId) : null;
      
      final data = {
        'domainId': domainId,
        'violationTypeId': violationTypeId,
        'description': description,
        'reporterId': 'mobile_app',  // TODO: Replace with actual user ID
        if (location != null) 'location': location,
        if (projectIdInt != null) 'projectId': projectIdInt,
        if (violatorName != null) 'violatorName': violatorName,
        if (violatorId != null) 'violatorId': violatorId,
        if (violatorEmpId != null) 'violatorEmpId': violatorEmpId,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        'category': 'minor',  // Default category
        'severity': severity.toLowerCase(),  // low/medium/high/critical
      };

      developer.log('📤 Sending data: $data');

      final response = await _apiClient.post(
        '/api/public/violations',
        data: data,
      );
      
      developer.log('📥 Response: ${response.data}');
      
      final responseData = _parseTRPCResponse(response.data);
      
      if (responseData is Map<String, dynamic>) {
        // Parse the 'violation' field from response
        final violationData = responseData['violation'] ?? responseData;
        developer.log('✅ Violation created successfully: ${violationData['id']}');
        return Violation.fromJson(violationData);
      }
      
      // Fallback if response format is unexpected
      developer.log('⚠️ Unexpected response format, creating local violation');
      return Violation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        qhseDomain: qhseDomain,
        severity: severity,
        status: 'pending',
        location: location,
        reportedBy: 'mobile_app',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e, stackTrace) {
      developer.log('❌ Error creating violation: $e');
      developer.log('Stack trace: $stackTrace');
      rethrow;
    }
  }
  
  /// Helper to convert domain  string to ID
  int _getDomainId(String domain) {
    switch (domain.toLowerCase()) {
      case 'safety':
        return 1;
      case 'health':
        return 2;
      case 'quality':
        return 3;
      case 'environment':
        return 4;
      default:
        return 1;  // Default to safety
    }
  }

  /// Submit violation for review
  Future<bool> submitViolation(String violationId) async {
    try {
      developer.log('📤 Submitting violation for review: $violationId');
      
      await _apiClient.post(
        '/violations.submit',
        data: {'violationId': violationId},
      );
      
      developer.log('✅ Violation submitted');
      return true;
    } catch (e) {
      developer.log('❌ Error submitting violation: $e');
      return false;
    }
  }

  /// Review violation
  Future<bool> reviewViolation(
    String violationId, {
    required String newStatus,
    String? notes,
  }) async {
    try {
      developer.log('✅ Reviewing violation: $violationId');
      
      await _apiClient.post(
        '/violations.review',
        data: {
          'violationId': violationId,
          'status': newStatus,
          if (notes != null) 'notes': notes,
        },
      );
      
      developer.log('✅ Violation reviewed');
      return true;
    } catch (e) {
      developer.log('❌ Error reviewing violation: $e');
      return false;
    }
  }

  /// Delete violation
  Future<bool> deleteViolation(String violationId) async {
    try {
      developer.log('🗑️ Deleting violation: $violationId');
      
      await _apiClient.delete('/violations/$violationId');
      
      developer.log('✅ Violation deleted');
      return true;
    } catch (e) {
      developer.log('❌ Error deleting violation: $e');
      return false;
    }
  }

  /// Update violation
  Future<Violation?> updateViolation(
    String violationId,
    Map<String, dynamic> updates,
  ) async {
    try {
      developer.log('🔄 Updating violation: $violationId');
      
      final response = await _apiClient.put(
        '/violations/$violationId',
        data: updates,
      );
      
      final data = _parseTRPCResponse(response.data);
      
      if (data is Map<String, dynamic>) {
        developer.log('✅ Violation updated');
        return Violation.fromJson(data);
      }
      
      return null;
    } catch (e) {
      developer.log('❌ Error updating violation: $e');
      return null;
    }
  }
}
