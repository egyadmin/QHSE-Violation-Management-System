import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../data/services/approval_service.dart';
import '../data/services/auth_service.dart';

/// Provider for managing pending approvals state
class ApprovalsProvider extends ChangeNotifier {
  final ApprovalService _approvalService = ApprovalService();
  final AuthService _authService = AuthService();

  List<PendingApproval> _approvals = [];
  bool _isLoading = false;
  String? _error;
  int _pendingCount = 0;
  String? _userRole;
  String? _userId;

  // Getters
  List<PendingApproval> get approvals => _approvals;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get pendingCount => _pendingCount;
  bool get hasPending => _pendingCount > 0;
  String? get userRole => _userRole;

  /// Get current user ID from auth
  Future<String?> _getUserId() async {
    if (_userId != null) return _userId;
    
    final user = await _authService.getCurrentUser();
    _userId = user?['id'] as String?;
    return _userId;
  }

  /// Fetch pending approvals from cloud
  Future<void> fetchApprovals() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userId = await _getUserId();
      
      if (userId == null) {
        developer.log('⚠️ No user logged in, cannot fetch approvals');
        _approvals = [];
        _pendingCount = 0;
        _error = 'Please login to view approvals';
      } else {
        _approvals = await _approvalService.getPendingApprovals(userId);
        _pendingCount = _approvals.length;
        _userRole = await _approvalService.getUserRole(userId);
        _error = null;
        developer.log('✅ Loaded ${_approvals.length} pending approvals');
      }
    } catch (e) {
      developer.log('❌ Error fetching approvals: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh approvals
  Future<void> refresh() async {
    await fetchApprovals();
  }

  /// Fetch pending count only (for badge)
  Future<void> fetchPendingCount() async {
    try {
      final userId = await _getUserId();
      if (userId != null) {
        _pendingCount = await _approvalService.getPendingCount(userId);
        notifyListeners();
      }
    } catch (e) {
      developer.log('Error fetching pending count: $e');
    }
  }

  /// Get approvals by domain
  List<PendingApproval> getByDomain(String domainCode) {
    return _approvals.where((a) => a.domainCode == domainCode).toList();
  }

  /// Get approvals by severity
  List<PendingApproval> getBySeverity(String severity) {
    return _approvals.where((a) => a.severity == severity).toList();
  }
}
