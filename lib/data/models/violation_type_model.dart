/// Violation Type Model
class ViolationType {
  final int id;
  final String code;
  final String nameEn;
  final String nameAr;
  final int domainId;
  final String? domainCode;
  final String? subCategory; // for safety: 'safety', 'equipment', 'driver'
  final String? defaultSeverity; // low, medium, high, critical
  final String? defaultCategory; // minor, semi_major, major
  final String? description;
  final String? descriptionAr;
  final bool isActive;
  final int sortOrder;

  ViolationType({
    required this.id,
    required this.code,
    required this.nameEn,
    required this.nameAr,
    required this.domainId,
    this.domainCode,
    this.subCategory,
    this.defaultSeverity,
    this.defaultCategory,
    this.description,
    this.descriptionAr,
    this.isActive = true,
    this.sortOrder = 0,
  });

  String getName(String locale) {
    return locale == 'ar' ? nameAr : nameEn;
  }

  factory ViolationType.fromJson(Map<String, dynamic> json) {
    return ViolationType(
      id: json['id'] as int,
      code: json['code'] as String,
      nameEn: json['nameEn'] as String,
      nameAr: json['nameAr'] as String,
      domainId: json['domainId'] as int,
      domainCode: json['domainCode'] as String?,
      subCategory: json['subCategory'] as String?,
      defaultSeverity: json['defaultSeverity'] as String?,
      defaultCategory: json['defaultCategory'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['descriptionAr'] as String?,
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
      'domainId': domainId,
      'domainCode': domainCode,
      'subCategory': subCategory,
      'defaultSeverity': defaultSeverity,
      'defaultCategory': defaultCategory,
      'description': description,
      'descriptionAr': descriptionAr,
      'isActive': isActive,
      'sortOrder': sortOrder,
    };
  }
}
