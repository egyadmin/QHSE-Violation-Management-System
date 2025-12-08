import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import '../../../providers/violations_provider.dart';
import '../../../core/utils/image_picker_helper.dart';
import '../../../data/services/qhse_service.dart';
import 'location_picker_screen.dart';

/// Enhanced QHSE Violation Form - Complete & Working
class NewViolationScreen extends StatefulWidget {
  const NewViolationScreen({super.key});

  @override
  State<NewViolationScreen> createState() => _NewViolationScreenState();
}

class _NewViolationScreenState extends State<NewViolationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _employeeIdController = TextEditingController();
  final _employeeNameController = TextEditingController();
  final _companyController = TextEditingController();
  
  // Services
  final _imagePicker = ViolationImagePicker();
  final _qhseService = QHSEService();
  
  // State
  String _selectedDomain = 'safety';
  String _selectedSeverity = 'medium';
  String? _selectedProjectId;
  String? _selectedViolationTypeId;  // NEW: Selected violation type
  bool _isSubmitting = false;
  bool _isLoadingProjects = true;
  bool _isSearchingEmployee = false;
  bool _isLoadingViolationTypes = false;  // NEW: Loading flag
  
  List<File> _images = [];
  List<Map<String, dynamic>> _projects = [];
  List<Map<String, dynamic>> _violationTypes = [];  // NEW: Violation types list
  
  // Location and DateTime
  double? _latitude;
  double? _longitude;
  DateTime _violationDateTime = DateTime.now();  // Auto-set to current time

  @override
  void initState() {
    super.initState();
    _loadProjects();
    _loadViolationTypes();  // Load initial violation types for 'safety'
  }

  Future<void> _loadProjects() async {
    try {
      final projects = await _qhseService.getProjects();
      if (mounted) {
        setState(() {
          _projects = projects;
          _isLoadingProjects = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingProjects = false);
      }
    }
  }

  /// Load violation types based on selected domain
  Future<void> _loadViolationTypes() async {
    setState(() => _isLoadingViolationTypes = true);
    
    try {
      final types = await _qhseService.getViolationTypes(domain: _selectedDomain);
      
      if (mounted) {
        setState(() {
          _violationTypes = types;
          _selectedViolationTypeId = null;  // Reset selection when domain changes
          _isLoadingViolationTypes = false;
        });
        print('✅ Loaded ${types.length} violation types for $_selectedDomain');
      }
    } catch (e) {
      print('❌ Error loading violation types: $e');
      if (mounted) {
        setState(() {
          _violationTypes = [];
          _isLoadingViolationTypes = false;
        });
      }
    }
  }

  Future<void> _searchEmployee(String employeeId) async {
    if (employeeId.length < 2) return;
    
    setState(() => _isSearchingEmployee = true);
    
    try {
      // Use dedicated endpoint for searching by empId
      final employee = await _qhseService.getEmployeeByEmpId(employeeId);
      
      if (employee != null && mounted) {
        // Backend uses 'fullName' not 'name'
        _employeeNameController.text = employee['fullName'] ?? employee['name'] ?? '';
        // Backend uses 'department' not 'company'
        _companyController.text = employee['department'] ?? employee['company'] ?? '';
        
        // Show success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ تم العثور على: ${employee['fullName']}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      } else if (mounted) {
        // Employee not found
        _employeeNameController.clear();
        _companyController.clear();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠️ لم يتم العثور على الموظف'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ خطأ في البحث: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSearchingEmployee = false);
      }
    }
  }

  Future<void> _addImage() async {
    final isArabic = context.locale.languageCode == 'ar';
    final image = await _imagePicker.showImageSourceBottomSheet(context, isArabic);
    
    if (image != null && mounted) {
      setState(() => _images.add(image));
    }
  }

  void _removeImage(int index) {
    setState(() => _images.removeAt(index));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _employeeIdController.dispose();
    _employeeNameController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  Future<void> _submitViolation() async {
    final isArabic = context.locale.languageCode == 'ar';
    
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isArabic ? 'يرجى ملء جميع الحقول المطلوبة' : 'Please fill all required fields'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final provider = Provider.of<ViolationsProvider>(context, listen: false);
      
      // Get violation type name for title
      final violationType = _violationTypes.firstWhere(
        (type) => type['id'].toString() == _selectedViolationTypeId,
        orElse: () => {'nameEn': 'Violation', 'nameAr': 'مخالفة', 'id': 0},
      );
      final title = isArabic ? violationType['nameAr'] : violationType['nameEn'];
      
      // Parse violationTypeId as int
      final violationTypeId = violationType['id'] is int 
          ? violationType['id'] as int
          : int.tryParse(violationType['id'].toString()) ?? 0;
      
      // Combine location text with coordinates if available
      String? locationData = _locationController.text.trim().isNotEmpty 
          ? _locationController.text.trim() 
          : null;
      if (_latitude != null && _longitude != null) {
        locationData = locationData != null 
            ? '$locationData (${_latitude!.toStringAsFixed(6)}, ${_longitude!.toStringAsFixed(6)})'
            : 'Lat: ${_latitude!.toStringAsFixed(6)}, Long: ${_longitude!.toStringAsFixed(6)}';
      }
      
      final success = await provider.createViolation(
        title: title,
        description: _descriptionController.text.trim(),
        qhseDomain: _selectedDomain,
        severity: _selectedSeverity,
        violationTypeId: violationTypeId,  // Required by backend API
        projectId: _selectedProjectId,
        location: locationData,
        latitude: _latitude,  // GPS coordinates
        longitude: _longitude,
        violatorName: _employeeNameController.text.trim().isNotEmpty 
            ? _employeeNameController.text.trim() 
            : null,
        violatorEmpId: _employeeIdController.text.trim().isNotEmpty 
            ? _employeeIdController.text.trim() 
            : null,
        // violatorId will be looked up by backend using empId
      );

      if (!mounted) return;
      
      setState(() => _isSubmitting = false);
        
      if (success) {
        await _showSuccessDialog(isArabic);
      } else {
        _showErrorDialog(isArabic, 'فشل رفع المخالفة');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        _showErrorDialog(isArabic, e.toString());
      }
    }
  }

  Future<void> _showSuccessDialog(bool isArabic) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: Colors.green, size: 32),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isArabic ? 'تم بنجاح!' : 'Success!',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isArabic ? 'تم رفع المخالفة بنجاح' : 'Violation submitted successfully',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              isArabic 
                  ? '• سيতم مراجعة المخالفة من قبل الإدارة\n• ستصلك إشعارات بأي تحديثات\n• يمكنك متابعة الحالة من قائمة المخالفات' 
                  : '• Will be reviewed by management\n• You will receive notifications\n• Track status from violations list',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            if (_images.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.photo_camera, size: 20, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      '${_images.length} ${isArabic ? "صورة مرفقة" : "image(s) attached"}',
                      style: const TextStyle(color: Colors.blue, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              isArabic ? 'حسناً' : 'OK',
              style: const TextStyle(color: Color(0xFF0B7A3E), fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(bool isArabic, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline, color: Colors.red, size: 32),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isArabic ? 'خطأ' : 'Error',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Text(
          isArabic ? 'حدث خطأ: $error' : 'Error: $error',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              isArabic ? 'حسناً' : 'OK',
              style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0B7A3E),
        title: Text(
          isArabic ? 'إضافة مخالفة جديدة' : 'New Violation',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0B7A3E), Color(0xFF0D9448)],
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.warning_amber_rounded, size: 40, color: Color(0xFF0B7A3E)),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isArabic ? 'سجّل مخالفة QHSE' : 'Report QHSE Violation',
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Employee  ID with auto-search
                    _buildSectionTitle(isArabic ? 'رقم الموظف' : 'Employee ID'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _employeeIdController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: isArabic ? 'مثال: 2443' : 'e.g., 2443',
                        prefixIcon: const Icon(Icons.badge, color: Color(0xFF0B7A3E)),
                        suffixIcon: _isSearchingEmployee 
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0B7A3E)),
                                ),
                              )
                            : null,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: _searchEmployee,
                    ),

                    const SizedBox(height: 16),

                    // Employee Name (auto-filled)
                    _buildSectionTitle(isArabic ? 'اسم الموظف' : 'Employee Name'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _employeeNameController,
                      decoration: _buildInputDecoration(
                        isArabic ? 'سيتم ملؤه تلقائياً' : 'Auto-filled',
                        Icons.person,
                      ),
                      validator: (v) => v?.trim().isEmpty ?? true ? (isArabic ? 'مطلوب' : 'Required') : null,
                    ),

                    const SizedBox(height: 16),

                    // Company
                    _buildSectionTitle(isArabic ? 'الشركة' : 'Company'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _companyController,
                      decoration: _buildInputDecoration(
                        isArabic ? 'سيتم ملؤه تلقائياً' : 'Auto-filled',
                        Icons.business,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Project (from API)
                    _buildSectionTitle(isArabic ? 'المشروع' : 'Project'),
                    const SizedBox(height: 8),
                    _isLoadingProjects
                        ? Container(
                            height: 58,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                            child: const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2.5, color: Color(0xFF0B7A3E)),
                              ),
                            ),
                          )
                        : DropdownButtonFormField<String>(
                            value: _selectedProjectId,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.folder, color: Color(0xFF0B7A3E)),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            hint: Text(isArabic ? 'اختر المشروع' : 'Select project'),
                            isExpanded: true,  // Important for long text
                            isDense: true,  // Fixes overflow
                            items: _projects.map((project) {
                              final code = project['code'] ?? project['projectCode'] ?? '';
                              final name = project['name'] ?? 'Unknown';
                              final displayText = code.isNotEmpty ? '$code - $name' : name;
                              
                              return DropdownMenuItem<String>(
                                value: project['id']?.toString(),
                                child: Text(
                                  displayText,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              );
                            }).toList(),
                            onChanged: (v) => setState(() => _selectedProjectId = v),
                          ),

                    const SizedBox(height: 20),

                    // Domain
                    _buildSectionTitle(isArabic ? 'التصنيف' : 'QHSE Domain'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedDomain,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.category, color: Color(0xFF0B7A3E)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: [
                        DropdownMenuItem(value: 'safety', child: Text(isArabic ? 'السلامة' : 'Safety')),
                        DropdownMenuItem(value: 'health', child: Text(isArabic ? 'الصحة' : 'Health')),
                        DropdownMenuItem(value: 'quality', child: Text(isArabic ? 'الجودة' : 'Quality')),
                        DropdownMenuItem(value: 'environment', child: Text(isArabic ? 'البيئة' : 'Environment')),
                      ],
                      onChanged: (v) {
                        setState(() => _selectedDomain = v!);
                        _loadViolationTypes();  // Reload types when domain changes
                      },
                    ),

                    const SizedBox(height: 20),

                    // Violation Type
                    _buildSectionTitle(isArabic ? 'نوع المخالفة' : 'Violation Type'),
                    const SizedBox(height: 8),
                    _isLoadingViolationTypes
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : DropdownButtonFormField<String>(
                            value: _selectedViolationTypeId,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.warning, color: Color(0xFF0B7A3E)),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: _violationTypes.isEmpty 
                                  ? (isArabic ? 'جاري التحميل...' : 'Loading...')
                                  : (isArabic ? 'اختر نوع المخالفة' : 'Select violation type'),
                            ),
                            items: _violationTypes.map((type) {
                              final nameAr = type['nameAr'] ?? '';
                              final nameEn = type['nameEn'] ?? '';
                              final displayName = isArabic ? nameAr : nameEn;
                              
                              return DropdownMenuItem<String>(
                                value: type['id'].toString(),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 250),
                                  child: Text(
                                    displayName,
                                    style: const TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: _violationTypes.isEmpty 
                                ? null 
                                : (v) => setState(() => _selectedViolationTypeId = v),
                            validator: (v) => v == null ? (isArabic ? 'مطلوب' : 'Required') : null,
                          ),

                    const SizedBox(height: 20),

                    // Description
                    _buildSectionTitle(isArabic ? 'الوصف' : 'Description'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,  // Support Arabic and multiline
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: isArabic ? 'اكتب وصفاً تفصيلياً...' : 'Enter detailed description...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (v) => v?.trim().isEmpty ?? true ? (isArabic ? 'مطلوب' : 'Required') : null,
                    ),

                    const SizedBox(height: 20),

                    // Severity
                    _buildSectionTitle(isArabic ? 'درجة الخطورة' : 'Severity'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedSeverity,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.priority_high, color: Color(0xFF0B7A3E)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: [
                        DropdownMenuItem(value: 'low', child: Text(isArabic ? 'منخفضة' : 'Low')),
                        DropdownMenuItem(value: 'medium', child: Text(isArabic ? 'متوسطة' : 'Medium')),
                        DropdownMenuItem(value: 'high', child: Text(isArabic ? 'عالية' : 'High')),
                        DropdownMenuItem(value: 'critical', child: Text(isArabic ? 'حرجة' : 'Critical')),
                      ],
                      onChanged: (v) => setState(() => _selectedSeverity = v!),
                    ),

                    const SizedBox(height: 20),

                    // Location
                    _buildSectionTitle(isArabic ? 'الموقع (اختياري)' : 'Location (Optional)'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _locationController,
                      decoration: _buildInputDecoration(
                        isArabic ? 'مثال: الموقع A - المبنى 3' : 'e.g., Site A - Building 3',
                        Icons.location_on,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // GPS Location Capture Button
                    OutlinedButton.icon(
                      onPressed: () async {
                        // Open professional map screen
                        final LatLng? selectedLocation = await Navigator.push<LatLng>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocationPickerScreen(
                              initialLocation: _latitude != null && _longitude != null
                                  ? LatLng(_latitude!, _longitude!)
                                  : null,
                            ),
                          ),
                        );

                        if (selectedLocation != null && mounted) {
                          setState(() {
                            _latitude = selectedLocation.latitude;
                            _longitude = selectedLocation.longitude;
                          });
                        }
                      },
                      icon: Icon(
                        _latitude != null ? Icons.my_location : Icons.map,
                        color: const Color(0xFF0B7A3E),
                      ),
                      label: Text(
                        _latitude != null
                            ? (isArabic ? '📍 تم تحديد الموقع ✓' : '📍 Location captured ✓')
                            : (isArabic ? '🗺️ فتح الخريطة' : '🗺️ Open Map'),
                        style: TextStyle(
                          color: _latitude != null ? Colors.green : const Color(0xFF0B7A3E),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: _latitude != null ? Colors.green : const Color(0xFF0B7A3E),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),

                    // Show captured coordinates
                    if (_latitude != null && _longitude != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.green, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${isArabic ? 'الإحداثيات: ' : 'Coordinates: '}${_latitude!.toStringAsFixed(6)}, ${_longitude!.toStringAsFixed(6)}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Images
                    _buildSectionTitle(isArabic ? 'الصور (اختياري)' : 'Images (Optional)'),
                    const SizedBox(height: 12),
                    
                    OutlinedButton.icon(
                      onPressed: _addImage,
                      icon: const Icon(Icons.add_a_photo),
                      label: Text(isArabic ? 'إضافة صورة' : 'Add Photo'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0B7A3E),
                        side: const BorderSide(color: Color(0xFF0B7A3E)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),

                    if (_images.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: _images.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: FileImage(_images[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () => _removeImage(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close, size: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitViolation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0B7A3E),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                              )
                                children: [
                                  const Icon(Icons.send, size: 24, color: Colors.white),
                                  const SizedBox(width: 12),
                                  Text(
                                    isArabic ? 'رفع المخالفة' : 'Submit Violation',
                                    style: const TextStyle(
                                      fontSize: 18, 
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF0B7A3E)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
