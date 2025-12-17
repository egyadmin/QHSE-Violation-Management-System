import 'package:flutter/foundation.dart';
import '../data/models/violation_model.dart';
import '../data/services/violations_service.dart';
import '../data/services/auth_service.dart';

class ViolationsProvider with ChangeNotifier {
  final ViolationsService _violationsService = ViolationsService();

  List<Violation> _violations = [];
  Violation? _selectedViolation;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Filters
  String? _filterStatus;
  String? _filterDomain;

  // Getters
  List<Violation> get violations => _violations;
  Violation? get selectedViolation => _selectedViolation;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get filterStatus => _filterStatus;
  String? get filterDomain => _filterDomain;

  // Statistics
  int get totalViolations => _violations.length;
  int get pendingCount => _violations.where((v) => v.status == 'pending').length;
  int get underReviewCount => _violations.where((v) => v.status == 'under_review').length;
  int get approvedCount => _violations.where((v) => v.status == 'approved').length;
  int get closedCount => _violations.where((v) => v.status == 'closed').length;

  // Domain counts
  int get safetyCount => _violations.where((v) => v.qhseDomain == 'safety').length;
  int get healthCount => _violations.where((v) => v.qhseDomain == 'health').length;
  int get qualityCount => _violations.where((v) => v.qhseDomain == 'quality').length;
  int get environmentCount => _violations.where((v) => v.qhseDomain == 'environment').length;

  /// Fetch all violations with optional filters
  Future<void> fetchViolations({
    String? status,
    String? qhseDomain,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _violations = await _violationsService.getViolations(
        status: status,
        qhseDomain: qhseDomain,
      );
      
      _filterStatus = status;
      _filterDomain = qhseDomain;
      
      debugPrint('✅ Fetched ${_violations.length} violations');
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ Error fetching violations: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch a single violation by ID
  Future<void> fetchViolationById(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedViolation = await _violationsService.getViolationById(id);
      debugPrint('✅ Fetched violation: ${_selectedViolation?.title}');
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ Error fetching violation: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create a new violation
  Future<bool> createViolation({
    required String title,
    required String description,
    required String qhseDomain,
    required String severity,
    required int violationTypeId,  // Required: violation type ID from API
    String? projectId,
    String? location,
    double? latitude,
    double? longitude,
    String? violatorName,
    String? violatorId,
    String? violatorEmpId,
    List<String>? attachments,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Get current user ID
      final user = await AuthService().getCurrentUser();
      final reporterId = user?['id']?.toString();
      
      if (reporterId == null) {
        throw Exception('User not logged in or invalid user ID');
      }

      final newViolation = await _violationsService.createViolation(
        title: title,
        description: description,
        qhseDomain: qhseDomain,
        severity: severity,
        reporterId: reporterId,
        violationTypeId: violationTypeId,
        projectId: projectId,
        location: location,
        latitude: latitude,
        longitude: longitude,
        violatorName: violatorName,
        violatorId: violatorId,
        violatorEmpId: violatorEmpId,
        attachments: attachments,
      );

      debugPrint('✅ Created violation: ${newViolation.title}');
      
      // Refresh violations list from API to get the complete data
      await fetchViolations();
      
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ Error creating violation: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update an existing violation
  Future<bool> updateViolation({
    required String id,
    String? title,
    String? description,
    String? status,
    String? severity,
    Map<String, dynamic>? additionalData,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updates = <String, dynamic>{};
      if (title != null) updates['title'] = title;
      if (description != null) updates['description'] = description;
      if (status != null) updates['status'] = status;
      if (severity != null) updates['severity'] = severity;
      if (additionalData != null) updates.addAll(additionalData);
      
      final updatedViolation = await _violationsService.updateViolation(
        id,
        updates,
      );

      if (updatedViolation != null) {
        final index = _violations.indexWhere((v) => v.id == id);
        if (index != -1) {
          _violations[index] = updatedViolation;
        }

        if (_selectedViolation?.id == id) {
          _selectedViolation = updatedViolation;
        }

        debugPrint('✅ Updated violation: ${updatedViolation.title}');
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ Error updating violation: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete a violation
  Future<bool> deleteViolation(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _violationsService.deleteViolation(id);
      _violations.removeWhere((v) => v.id == id);
      
      if (_selectedViolation?.id == id) {
        _selectedViolation = null;
      }

      debugPrint('✅ Deleted violation: $id');
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ Error deleting violation: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear selected violation
  void clearSelectedViolation() {
    _selectedViolation = null;
    notifyListeners();
  }

  /// Clear filters
  void clearFilters() {
    _filterStatus = null;
    _filterDomain = null;
    notifyListeners();
  }

  /// Refresh violations
  Future<void> refresh() async {
    await fetchViolations(
      status: _filterStatus,
      qhseDomain: _filterDomain,
    );
  }
}
