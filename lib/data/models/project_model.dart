/// Project Status Enum
enum ProjectStatus {
  active,
  onHold,
  completed,
  cancelled,
}

/// Project Model
class Project {
  final int id;
  final String name;
  final String? nameAr;
  final String? nameEn;
  final String code;
  final String? location;
  final String? region;
  final String? description;
  final String? managerId;
  final String? managerEmpId;
  final String? managerName;
  final String? managerEmail;
  final String? managerPhone;
  final ProjectStatus status;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Project({
    required this.id,
    required this.name,
    this.nameAr,
    this.nameEn,
    required this.code,
    this.location,
    this.region,
    this.description,
    this.managerId,
    this.managerEmpId,
    this.managerName,
    this.managerEmail,
    this.managerPhone,
    required this.status,
    this.startDate,
    this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  String getName(String locale) {
    if (locale == 'ar' && nameAr != null) return nameAr!;
    if (locale == 'en' && nameEn != null) return nameEn!;
    return name;
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as int,
      name: json['name'] as String,
      nameAr: json['nameAr'] as String?,
      nameEn: json['nameEn'] as String?,
      code: json['code'] as String,
      location: json['location'] as String?,
      region: json['region'] as String?,
      description: json['description'] as String?,
      managerId: json['managerId'] as String?,
      managerEmpId: json['managerEmpId'] as String?,
      managerName: json['managerName'] as String?,
      managerEmail: json['managerEmail'] as String?,
      managerPhone: json['managerPhone'] as String?,
      status: _parseStatus(json['status'] as String? ?? 'active'),
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'code': code,
      'location': location,
      'region': region,
      'description': description,
      'managerId': managerId,
      'managerEmpId': managerEmpId,
      'managerName': managerName,
      'managerEmail': managerEmail,
      'managerPhone': managerPhone,
      'status': status.name,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static ProjectStatus _parseStatus(String status) {
    switch (status.toLowerCase().replaceAll('_', '')) {
      case 'active':
        return ProjectStatus.active;
      case 'onhold':
        return ProjectStatus.onHold;
      case 'completed':
        return ProjectStatus.completed;
      case 'cancelled':
        return ProjectStatus.cancelled;
      default:
        return ProjectStatus.active;
    }
  }
}
