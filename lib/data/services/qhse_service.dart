import 'dart:developer' as developer;
import 'api_client.dart';

/// QHSE Service for fetching master data from tRPC API
class QHSEService {
  final ApiClient _apiClient;

  QHSEService({ApiClient? apiClient})
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

  /// Get all QHSE domains
  Future<List<Map<String, dynamic>>> getDomains() async {
    try {
      developer.log('🛡️ Fetching QHSE domains from tRPC');
      
      final response = await _apiClient.get('/api/public/domains');
      final data = _parseTRPCResponse(response.data);
      
      developer.log('✅ Domains fetched successfully');
      
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      }
      
      return _getDefaultDomains();
    } catch (e) {
      developer.log('❌ Error fetching domains: $e');
      return _getDefaultDomains();
    }
  }

  List<Map<String, dynamic>> _getDefaultDomains() {
    return [
      {'id': 1, 'code': 'safety', 'nameAr': 'السلامة', 'nameEn': 'Safety', 'color': '#DC2626'},
      {'id': 2, 'code': 'health', 'nameAr': 'الصحة', 'nameEn': 'Health', 'color': '#10B981'},
      {'id': 3, 'code': 'quality', 'nameAr': 'الجودة', 'nameEn': 'Quality', 'color': '#3B82F6'},
      {'id': 4, 'code': 'environment', 'nameAr': 'البيئة', 'nameEn': 'Environment', 'color': '#22C55E'},
    ];
  }

  /// Get all projects
  Future<List<Map<String, dynamic>>> getProjects() async {
    try {
      developer.log('🏗️ Fetching projects from tRPC');
      
      final response = await _apiClient.get('/api/public/projects');
      final data = _parseTRPCResponse(response.data);
      
      developer.log('✅ Projects fetched successfully');
      
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      }
      
      return [];
    } catch (e) {
      developer.log('❌ Error fetching projects: $e');
      return [];
    }
  }

  /// Get projects grouped by region
  Future<Map<String, dynamic>> getProjectsByRegion() async {
    try {
      developer.log('🌍 Fetching projects by region');
      
      final response = await _apiClient.get(
        '/api/public/projects/by-region',
      );
      
      // The API returns the map directly as per user snippet
      if (response.data is Map<String, dynamic>) {
        developer.log('✅ Projects by region fetched successfully');
        return response.data as Map<String, dynamic>;
      }
      
      developer.log('⚠️ Unexpected format for projects by region');
      return {};
    } catch (e) {
      developer.log('❌ Error fetching projects by region: $e');
      return {};
    }
  }

  /// Search projects
  Future<List<Map<String, dynamic>>> searchProjects(String query) async {
    try {
      developer.log('🔍 Searching projects: $query');
      
      final response = await _apiClient.get(
        '/api/public/projects',
        queryParameters: {'q': query},
      );
      final data = _parseTRPCResponse(response.data);
      
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      }
      
      return [];
    } catch (e) {
      developer.log('❌ Error searching projects: $e');
      return [];
    }
  }

  /// Get violation types by domain
  Future<List<Map<String, dynamic>>> getViolationTypes({String? domain}) async {
    try {
      developer.log('📋 Fetching violation types${domain != null ? ' for domain: $domain' : ''}');
      
      final response = await _apiClient.get(
        '/api/public/violation-types',
        queryParameters: domain != null ? {'domain': domain} : null,
      );
      
      final data = _parseTRPCResponse(response.data);
      
      // API returns a direct array of violation types
      if (data is List) {
        developer.log('✅ Violation types fetched successfully: ${data.length} types');
        return List<Map<String, dynamic>>.from(data);
      }
      
      developer.log('⚠️ Unexpected response format for violation types: ${data.runtimeType}');
      return [];
    } catch (e) {
      developer.log('❌ Error fetching violation types: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getEmployees({
    String? search,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      developer.log('👥 Fetching employees from public API');
      
      final response = await _apiClient.get(
        '/api/public/violators',
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );
      final data = _parseTRPCResponse(response.data);
      
      developer.log('✅ Employees fetched successfully');
      
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      }
      
      return [];
    } catch (e) {
      developer.log('❌ Error fetching employees: $e');
      return [];
    }
  }

  /// Search employee by empId using dedicated endpoint
  Future<Map<String, dynamic>?> getEmployeeByEmpId(String empId) async {
    try {
      developer.log('🔍 Searching for employee with empId: $empId');
      
      final response = await _apiClient.get(
        '/api/public/violators/by-emp-id/$empId',
      );
      
      final data = _parseTRPCResponse(response.data);
      
      if (data is Map<String, dynamic>) {
        developer.log('✅ Employee found: ${data['fullName']}');
        return data;
      }
      
      developer.log('⚠️ Employee not found');
      return null;
    } catch (e) {
      developer.log('❌ Error searching employee: $e');
      return null;
    }
  }

  /// Search employees
  Future<List<Map<String, dynamic>>> searchEmployees(String query) async {
    try {
      developer.log('🔍 Searching employees: $query');
      
      final response = await _apiClient.get(
        '/api/public/violators/search',
        queryParameters: {'q': query},
      );
      final data = _parseTRPCResponse(response.data);
      
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      }
      
      return [];
    } catch (e) {
      developer.log('❌ Error searching employees: $e');
      return [];
    }
  }

  /// Get equipment list
  Future<List<Map<String, dynamic>>> getEquipment() async {
    try {
      developer.log('🚜 Fetching equipment from tRPC');
      
      final response = await _apiClient.get('/api/public/equipment');
      final data = _parseTRPCResponse(response.data);
      
      developer.log('✅ Equipment fetched successfully');
      
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      }
      
      return [];
    } catch (e) {
      developer.log('❌ Error fetching equipment: $e');
      return [];
    }
  }

  /// Search equipment
  Future<List<Map<String, dynamic>>> searchEquipment(String query) async {
    try {
      developer.log('🔍 Searching equipment: $query');
      
      final response = await _apiClient.get(
        '/api/public/equipment',
        queryParameters: {'q': query},
      );
      final data = _parseTRPCResponse(response.data);
      
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      }
      
      return [];
    } catch (e) {
      developer.log('❌ Error searching equipment: $e');
      return [];
    }
  }

  /// Get drivers list
  Future<List<Map<String, dynamic>>> getDrivers() async {
    try {
      developer.log('🚗 Fetching drivers from tRPC');
      
      final response = await _apiClient.get('/api/public/drivers');
      final data = _parseTRPCResponse(response.data);
      
      developer.log('✅ Drivers fetched successfully');
      
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      }
      
      return [];
    } catch (e) {
      developer.log('❌ Error fetching drivers: $e');
      return [];
    }
  }

  /// Get dashboard statistics
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      developer.log('📊 Fetching dashboard stats from tRPC');
      
      final response = await _apiClient.get('/api/public/stats');
      final data = _parseTRPCResponse(response.data);
      
      developer.log('✅ Dashboard stats fetched successfully');
      
      if (data is Map<String, dynamic>) {
        return data;
      }
      
      return {};
    } catch (e) {
      developer.log('❌ Error fetching dashboard stats: $e');
      return {};
    }
  }
}
