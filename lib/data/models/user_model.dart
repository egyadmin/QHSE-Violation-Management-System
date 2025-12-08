/// User Roles Enum
enum UserRole {
  user,              // مستخدم عادي
  admin,             // مدير النظام
  ceo,               // الرئيس التنفيذي
  safetyOfficer,     // مسؤول السلامة
  qualityOfficer,    // مسؤول الجودة
  healthOfficer,     // مسؤول الصحة المهنية
  environmentOfficer, // مسؤول البيئة
  safetyManager,     // مدير السلامة
  qualityManager,    // مدير الجودة
  healthManager,     // مدير الصحة المهنية
  environmentManager, // مدير البيئة
  projectManager,    // مدير المشروع
  hseManager,        // مدير HSE
}

/// User Model
class User {
  final String id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? profileImageUrl;
  final UserRole role;
  final String? department;
  final String? position;
  final String? empId;
  final String? badgeNumber;
  final String? company;
  final String? phone;
  final String? region;
  final String? location;
  final String? workSite;
  final String? oracleId;
  final String? managerId;
  final String? managerName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastSignedIn;

  User({
    required this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.profileImageUrl,
    required this.role,
    this.department,
    this.position,
    this.empId,
    this.badgeNumber,
    this.company,
    this.phone,
    this.region,
    this.location,
    this.workSite,
    this.oracleId,
    this.managerId,
    this.managerName,
    required this.createdAt,
    required this.updatedAt,
    this.lastSignedIn,
  });

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
  
  String get displayName {
    if (fullName.isNotEmpty) return fullName;
    if (email != null) return email!.split('@').first;
    return empId ?? 'User';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['id'] ?? '0').toString(),
      email: json['email'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      role: _parseRole(json['role'] as String?),
      department: json['department'] as String?,
      position: json['position'] as String?,
      empId: json['empId'] as String?,
      badgeNumber: json['badgeNumber'] as String?,
      company: json['company'] as String?,
      phone: json['phone'] as String?,
      region: json['region'] as String?,
      location: json['location'] as String?,
      workSite: json['workSite'] as String?,
      oracleId: json['oracleId'] as String?,
      managerId: json['managerId'] as String?,
      managerName: json['managerName'] as String?,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      lastSignedIn: json['lastSignedIn'] != null
          ? DateTime.parse(json['lastSignedIn'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'profileImageUrl': profileImageUrl,
      'role': role.name,
      'department': department,
      'position': position,
      'empId': empId,
      'badgeNumber': badgeNumber,
      'company': company,
      'phone': phone,
      'region': region,
      'location': location,
      'workSite': workSite,
      'oracleId': oracleId,
      'managerId': managerId,
      'managerName': managerName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastSignedIn': lastSignedIn?.toIso8601String(),
    };
  }

  static UserRole _parseRole(String? roleStr) {
    if (roleStr == null) return UserRole.user;
    
    try {
      return UserRole.values.firstWhere(
        (role) => role.name == roleStr,
        orElse: () => UserRole.user,
      );
    } catch (e) {
      return UserRole.user;
    }
  }

  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? profileImageUrl,
    UserRole? role,
    String? department,
    String? position,
    String? empId,
    String? badgeNumber,
    String? company,
    String? phone,
    String? region,
    String? location,
    String? workSite,
    String? oracleId,
    String? managerId,
    String? managerName,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSignedIn,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      department: department ?? this.department,
      position: position ?? this.position,
      empId: empId ?? this.empId,
      badgeNumber: badgeNumber ?? this.badgeNumber,
      company: company ?? this.company,
      phone: phone ?? this.phone,
      region: region ?? this.region,
      location: location ?? this.location,
      workSite: workSite ?? this.workSite,
      oracleId: oracleId ?? this.oracleId,
      managerId: managerId ?? this.managerId,
      managerName: managerName ?? this.managerName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSignedIn: lastSignedIn ?? this.lastSignedIn,
    );
  }
}
