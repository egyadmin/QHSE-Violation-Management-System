/// QHSE Domain Model (Safety, Health, Quality, Environment)
class ViolationDomain {
  final int id;
  final String code;
  final String nameEn;
  final String nameAr;
  final String color;
  final String? icon;
  final String? description;
  final String? descriptionAr;
  final int workflowStagesCount;
  final bool isActive;
  final int sortOrder;

  ViolationDomain({
    required this.id,
    required this.code,
    required this.nameEn,
    required this.nameAr,
    required this.color,
    this.icon,
    this.description,
    this.descriptionAr,
    required this.workflowStagesCount,
    this.isActive = true,
    this.sortOrder = 0,
  });

  String getName(String locale) {
    return locale == 'ar' ? nameAr : nameEn;
  }

  factory ViolationDomain.fromJson(Map<String, dynamic> json) {
    return ViolationDomain(
      id: json['id'] as int,
      code: json['code'] as String,
      nameEn: json['nameEn'] as String,
      nameAr: json['nameAr'] as String,
      color: json['color'] as String,
      icon: json['icon'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['descriptionAr'] as String?,
      workflowStagesCount: json['workflowStagesCount'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      sortOrder: json['sortOrder'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'nameEn': nameEn,
      'nameAr': nameAr,
      'color': color,
      'icon': icon,
      'description': description,
      'descriptionAr': descriptionAr,
      'workflowStagesCount': workflowStagesCount,
      'isActive': isActive,
      'sortOrder': sortOrder,
    };
  }
}
