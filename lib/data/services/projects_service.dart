import 'dart:developer' as developer;
import '../models/project_model.dart';
import 'api_client.dart';

class ProjectsService {
  final ApiClient _apiClient;

  ProjectsService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Get all projects
  Future<List<Project>> getProjects({
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      developer.log('🔍 Fetching projects - Page: $page, Limit: $limit');
      
      final queryParams = <String, dynamic>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      
      if (status != null) queryParams['status'] = status;

      final response = await _apiClient.get(
        '/projects',
        queryParameters: queryParams,
      );

      developer.log('✅ Projects fetched successfully');
      
      if (response.data is List) {
        return (response.data as List)
            .map((json) => Project.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      
      return [];
    } catch (e) {
      developer.log('❌ Error fetching projects: $e');
      rethrow;
    }
  }

  /// Get a single project by ID
  Future<Project> getProjectById(String id) async {
    try {
      developer.log('🔍 Fetching project by ID: $id');
      
      final response = await _apiClient.get('/projects/$id');
      
      developer.log('✅ Project fetched successfully');
      return Project.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      developer.log('❌ Error fetching project: $e');
      rethrow;
    }
  }

  /// Create a new project
  Future<Project> createProject({
    required String name,
    String? description,
    String? client,
    String? location,
    required DateTime startDate,
    DateTime? endDate,
    String? projectManager,
    List<String>? team,
  }) async {
    try {
      developer.log('📝 Creating new project: $name');
      
      final data = {
        'name': name,
        if (description != null) 'description': description,
        if (client != null) 'client': client,
        if (location != null) 'location': location,
        'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(),
        'status': 'active',
        if (projectManager != null) 'projectManager': projectManager,
        if (team != null && team.isNotEmpty) 'team': team,
      };

      final response = await _apiClient.post('/projects', data: data);
      
      developer.log('✅ Project created successfully');
      return Project.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      developer.log('❌ Error creating project: $e');
      rethrow;
    }
  }

  /// Update an existing project
  Future<Project> updateProject({
    required String id,
    String? name,
    String? description,
    String? status,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      developer.log('📝 Updating project: $id');
      
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (description != null) data['description'] = description;
      if (status != null) data['status'] = status;
      if (additionalData != null) data.addAll(additionalData);

      final response = await _apiClient.put('/projects/$id', data: data);
      
      developer.log('✅ Project updated successfully');
      return Project.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      developer.log('❌ Error updating project: $e');
      rethrow;
    }
  }

  /// Delete a project
  Future<void> deleteProject(String id) async {
    try {
      developer.log('🗑️ Deleting project: $id');
      
      await _apiClient.delete('/projects/$id');
      
      developer.log('✅ Project deleted successfully');
    } catch (e) {
      developer.log('❌ Error deleting project: $e');
      rethrow;
    }
  }
}
