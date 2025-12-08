import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../data/services/qhse_service.dart';

/// Projects dashboard screen with dynamic region data from API
class ProjectsListScreen extends StatefulWidget {
  const ProjectsListScreen({super.key});

  @override
  State<ProjectsListScreen> createState() => _ProjectsListScreenState();
}

class _ProjectsListScreenState extends State<ProjectsListScreen> {
  final QHSEService _qhseService = QHSEService();
  
  // Data State
  bool _isLoading = true;
  Map<String, dynamic> _apiData = {};
  List<dynamic> _apiRegions = [];
  int _selectedRegionIndex = 0; // Default to first region
  
  // Static Style Config for Regions (for colors and icons)
  final Map<String, Map<String, dynamic>> _regionStyles = {
    'riyadh': {'color': Color(0xFFE8F0FE), 'accent': Color(0xFF1976D2), 'icon': Icons.location_city},
    'makkah': {'color': Color(0xFFFFF3E0), 'accent': Color(0xFFE65100), 'icon': Icons.mosque},
    'jeddah': {'color': Color(0xFFFFF3E0), 'accent': Color(0xFFE65100), 'icon': Icons.mosque},
    'madinah': {'color': Color(0xFFE8F5E9), 'accent': Color(0xFF2E7D32), 'icon': Icons.place},
    'eastern': {'color': Color(0xFFE3F2FD), 'accent': Color(0xFF1565C0), 'icon': Icons.water},
    'dammam': {'color': Color(0xFFE3F2FD), 'accent': Color(0xFF1565C0), 'icon': Icons.water},
    'qassim': {'color': Color(0xFFFFF8E1), 'accent': Color(0xFFF9A825), 'icon': Icons.agriculture},
    'asir': {'color': Color(0xFFF1F8E9), 'accent': Color(0xFF558B2F), 'icon': Icons.landscape},
    'aseer': {'color': Color(0xFFF1F8E9), 'accent': Color(0xFF558B2F), 'icon': Icons.landscape},
    'tabuk': {'color': Color(0xFFE1F5FE), 'accent': Color(0xFF0277BD), 'icon': Icons.terrain},
    'northern': {'color': Color(0xFFE0F7FA), 'accent': Color(0xFF00ACC1), 'icon': Icons.ac_unit},
    'default': {'color': Color(0xFFF5F5F5), 'accent': Color(0xFF616161), 'icon': Icons.location_on},
  };

  @override
  void initState() {
    super.initState();
    _loadProjectsByRegion();
  }

  Future<void> _loadProjectsByRegion() async {
    try {
      final data = await _qhseService.getProjectsByRegion();
      if (mounted) {
        setState(() {
          _apiData = data;
          _apiRegions = (data['regions'] as List? ?? []);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Map<String, dynamic> _getRegionStyle(String regionName) {
    final lowerName = regionName.toLowerCase();
    for (var key in _regionStyles.keys) {
      if (lowerName.contains(key)) {
        return _regionStyles[key]!;
      }
    }
    return _regionStyles['default']!;
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    
    // Safety check for empty data
    final hasData = _apiRegions.isNotEmpty;
    final totalProjects = _apiData['totalProjects'] ?? 0;
    final totalRegions = _apiData['totalRegions'] ?? 0;
    
    // Get currently selected region data safely
    final selectedRegionData = hasData ? _apiRegions[_selectedRegionIndex] : null;
    final selectedProjects = hasData ? (selectedRegionData['projects'] as List? ?? []) : [];
    final selectedRegionName = hasData ? (selectedRegionData['region'] as String? ?? '') : '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(Icons.folder_open_outlined, color: Color(0xFF1976D2), size: 28),
            const SizedBox(width: 8),
            Text(
              isArabic ? 'المشاريع النشطة' : 'Active Projects',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isArabic ? 'إنشاء مشروع جديد قريباً' : 'New Project creation coming soon')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.add, size: 18),
                  const SizedBox(width: 4),
                  Text(isArabic ? 'مشروع جديد' : 'New Project'),
                ],
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadProjectsByRegion,
              child: hasData 
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subtitle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text(
                        isArabic 
                            ? '$totalProjects مشروع نشط في $totalRegions مناطق'
                            : '$totalProjects active projects in $totalRegions regions',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                    
                    // Horizontal Regions List
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        scrollDirection: Axis.horizontal,
                        itemCount: _apiRegions.length,
                        itemBuilder: (context, index) {
                          final region = _apiRegions[index];
                          final isSelected = _selectedRegionIndex == index;
                          return _buildRegionCard(region, isSelected, index, isArabic);
                        },
                      ),
                    ),
                    
                    const Divider(height: 32),
                    
                    // Projects List Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              selectedRegionName, // Use dynamic name from API
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              // We need to cast dynamic list to map for search delegate
                              final projectsList = selectedProjects.map((e) => e as Map<String, dynamic>).toList();
                              showSearch(
                                context: context,
                                delegate: ProjectSearchDelegate(projectsList, isArabic),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // Selected Projects List
                    Expanded(
                      child: selectedProjects.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.folder_off_outlined, size: 60, color: Colors.grey[300]),
                                  const SizedBox(height: 16),
                                  Text(
                                    isArabic ? 'لا توجد مشاريع في هذه المنطقة' : 'No projects in this region',
                                    style: TextStyle(color: Colors.grey[500]),
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.all(20),
                              itemCount: selectedProjects.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                return _buildProjectItem(selectedProjects[index], isArabic);
                              },
                            ),
                    ),
                  ],
                )
                : Center(
                    child: Text(
                      isArabic ? 'لا توجد بيانات متاحة' : 'No data available',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
            ),
    );
  }

  Widget _buildRegionCard(
    Map<String, dynamic> regionData,
    bool isSelected,
    int index,
    bool isArabic,
  ) {
    final regionName = regionData['region'] as String? ?? 'Unknown';
    final count = regionData['projectCount'] as int? ?? 0;
    
    // Get style based on name
    final style = _getRegionStyle(regionName);
    final bgColor = style['color'] as Color;
    final accentColor = style['accent'] as Color;
    final icon = style['icon'] as IconData;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRegionIndex = index;
        });
      },
      child: Container(
        width: 200, 
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor, 
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? accentColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: accentColor,
              size: 24,
            ),
            const SizedBox(height: 12),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              regionName,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                height: 1.3,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectItem(dynamic projectData, bool isArabic) {
    // Safely cast or access dynamic map
    final project = projectData as Map<String, dynamic>;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.folder_outlined,
            color: Color(0xFF1976D2),
            size: 24,
          ),
        ),
        title: Text(
          project['name'] as String? ?? (isArabic ? 'مشروع' : 'Project'),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Icon(Icons.qr_code, size: 14, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  project['code'] as String? ?? project['projectCode'] as String? ?? 'N/A',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: () => _showProjectDetails(project, isArabic),
      ),
    );
  }

  void _showProjectDetails(Map<String, dynamic> project, bool isArabic) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(project['name'] as String? ?? 'Project'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
              Icons.code,
              isArabic ? 'كود المشروع' : 'Project Code',
              project['code'] as String? ?? project['projectCode'] as String? ?? 'N/A',
            ),
            _buildDetailRow(
              Icons.business,
              isArabic ? 'العميل' : 'Client',
              project['client'] as String? ?? project['company'] as String? ?? 'N/A',
            ),
            _buildDetailRow(
              Icons.location_on,
              isArabic ? 'الموقع' : 'Location',
              project['location'] as String? ?? (isArabic ? 'المنطقة الحالية' : 'Current Region'),
            ),
            _buildDetailRow(
              Icons.info_outline,
              isArabic ? 'الحالة' : 'Status',
              project['status'] as String? ?? 'Active',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isArabic ? 'إغلاق' : 'Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF1976D2)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Search delegate for projects
class ProjectSearchDelegate extends SearchDelegate<Map<String, dynamic>?> {
  final List<Map<String, dynamic>> projects;
  final bool isArabic;

  ProjectSearchDelegate(this.projects, this.isArabic);

  @override
  String get searchFieldLabel => isArabic ? 'بحث عن مشروع...' : 'Search projects...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = projects.where((project) {
      final name = (project['name'] as String? ?? '').toLowerCase();
      final code = (project['code'] as String? ?? '').toLowerCase();
      final search = query.toLowerCase();
      
      return name.contains(search) || code.contains(search);
    }).toList();

    if (results.isEmpty) {
      return Center(
        child: Text(
          isArabic ? 'لا توجد نتائج' : 'No results found',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final project = results[index];
        return ListTile(
          leading: const Icon(Icons.folder, color: Color(0xFF1976D2)),
          title: Text(project['name'] as String? ?? 'Project'),
          subtitle: Text(project['code'] as String? ?? ''),
          onTap: () => close(context, project),
        );
      },
    );
  }
}
