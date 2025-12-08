/// Violation Enums
enum ViolationCategory { minor, semiMajor, major }

enum Severity { low, medium, high, critical }

enum CardType { yellow, red }

enum ActionTaken {
  firstWarning,
  secondWarning,
  finalWarning,
  suspension,
  termination,
  verbal,
  written,
  other,
}

/// QHSE Violation Model
class QhseViolation {
  final int id;
  final String number;
  final int domainId;
  final String? domainCode;
  final String? domainNameAr;
  final String? domainNameEn;
  final String? domainColor;
  final int violationTypeId;
  final String? violationTypeNameAr;
  final String? violationTypeNameEn;
  final int? currentStageId;
  final String? currentStageNameAr;
  final String? currentStageNameEn;
  final String? currentStageColor;
  final int projectId;
  final String? projectName;
  final String? safetySubType;
  final int? equipmentId;
  final int? driverId;
  final int? vehicleId;
  final String? discipline;
  final String location;
  final double? latitude;
  final double? longitude;
  final DateTime violationDate;
  final String? violationTime;
  final String description;
  final String? descriptionAr;
  final String? violatorId;
  final String? violatorName;
  final String? violatorEmpId;
  final String? violatorCompany;
  final String reporterId;
  final String? reporterName;
  final String? assignedToId;
  final ViolationCategory category;
  final Severity severity;
  final CardType? cardType;
  final ActionTaken? actionTaken;
  final DateTime? agreedCompletionDate;
  final DateTime? actualCompletionDate;
  final String? rootCauseAnalysis;
  final String? correctiveAction;
  final String? preventiveAction;
  final String? verificationNotes;
  final bool isExternalNCR;
  final String? externalNCRNumber;
  final String? clientReference;
  final bool isClosed;
  final DateTime? closedAt;
  final String? closedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  QhseViolation({
    required this.id,
    required this.number,
    required this.domainId,
    this.domainCode,
    this.domainNameAr,
    this.domainNameEn,
    this.domainColor,
    required this.violationTypeId,
    this.violationTypeNameAr,
    this.violationTypeNameEn,
    this.currentStageId,
    this.currentStageNameAr,
    this.currentStageNameEn,
    this.currentStageColor,
    required this.projectId,
    this.projectName,
    this.safetySubType,
    this.equipmentId,
    this.driverId,
    this.vehicleId,
    this.discipline,
    required this.location,
    this.latitude,
    this.longitude,
    required this.violationDate,
    this.violationTime,
    required this.description,
    this.descriptionAr,
    this.violatorId,
    this.violatorName,
    this.violatorEmpId,
    this.violatorCompany,
    required this.reporterId,
    this.reporterName,
    this.assignedToId,
    required this.category,
    required this.severity,
    this.cardType,
    this.actionTaken,
    this.agreedCompletionDate,
    this.actualCompletionDate,
    this.rootCauseAnalysis,
    this.correctiveAction,
    this.preventiveAction,
    this.verificationNotes,
    this.isExternalNCR = false,
    this.externalNCRNumber,
    this.clientReference,
    this.isClosed = false,
    this.closedAt,
    this.closedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory QhseViolation.fromJson(Map<String, dynamic> json) {
    return QhseViolation(
      id: json['id'] as int,
      number: json['number'] as String,
      domainId: json['domainId'] as int,
      domainCode: json['domainCode'] as String?,
      domainNameAr: json['domainNameAr'] as String?,
      domainNameEn: json['domainNameEn'] as String?,
      domainColor: json['domainColor'] as String?,
      violationTypeId: json['violationTypeId'] as int,
      violationTypeNameAr: json['violationTypeNameAr'] as String?,
      violationTypeNameEn: json['violationTypeNameEn'] as String?,
      currentStageId: json['currentStageId'] as int?,
      currentStageNameAr: json['currentStageNameAr'] as String?,
      currentStageNameEn: json['currentStageNameEn'] as String?,
      currentStageColor: json['currentStageColor'] as String?,
      projectId: json['projectId'] as int,
      projectName: json['projectName'] as String?,
      safetySubType: json['safetySubType'] as String?,
      equipmentId: json['equipmentId'] as int?,
      driverId: json['driverId'] as int?,
      vehicleId: json['vehicleId'] as int?,
      discipline: json['discipline'] as String?,
      location: json['location'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      violationDate: DateTime.parse(json['violationDate'] as String),
      violationTime: json['violationTime'] as String?,
      description: json['description'] as String,
      descriptionAr: json['descriptionAr'] as String?,
      violatorId: json['violatorId'] as String?,
      violatorName: json['violatorName'] as String?,
      violatorEmpId: json['violatorEmpId'] as String?,
      violatorCompany: json['violatorCompany'] as String?,
      reporterId: json['reporterId'] as String,
      reporterName: json['reporterName'] as String?,
      assignedToId: json['assignedToId'] as String?,
      category: _parseCategory(json['category'] as String),
      severity: _parseSeverity(json['severity'] as String),
      cardType: _parseCardType(json['cardType'] as String?),
      actionTaken: _parseActionTaken(json['actionTaken'] as String?),
      agreedCompletionDate: json['agreedCompletionDate'] != null
          ? DateTime.parse(json['agreedCompletionDate'] as String)
          : null,
      actualCompletionDate: json['actualCompletionDate'] != null
          ? DateTime.parse(json['actualCompletionDate'] as String)
          : null,
      rootCauseAnalysis: json['rootCauseAnalysis'] as String?,
      correctiveAction: json['correctiveAction'] as String?,
      preventiveAction: json['preventiveAction'] as String?,
      verificationNotes: json['verificationNotes'] as String?,
      isExternalNCR: json['isExternalNCR'] as bool? ?? false,
      externalNCRNumber: json['externalNCRNumber'] as String?,
      clientReference: json['clientReference'] as String?,
      isClosed: json['isClosed'] as bool? ?? false,
      closedAt: json['closedAt'] != null
          ? DateTime.parse(json['closedAt'] as String)
          : null,
      closedBy: json['closedBy'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'domainId': domainId,
      'violationTypeId': violationTypeId,
      'projectId': projectId,
      'safetySubType': safetySubType,
      'equipmentId': equipmentId,
      'driverId': driverId,
      'vehicleId': vehicleId,
      'discipline': discipline,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'violationDate': violationDate.toIso8601String(),
      'violationTime': violationTime,
      'description': description,
      'violatorId': violatorId,
      'violatorName': violatorName,
      'violatorEmpId': violatorEmpId,
      'violatorCompany': violatorCompany,
      'reporterId': reporterId,
      'assignedToId': assignedToId,
      'category': category.name,
      'severity': severity.name,
      'cardType': cardType?.name,
      'actionTaken': actionTaken?.name,
      'agreedCompletionDate': agreedCompletionDate?.toIso8601String(),
      'actualCompletionDate': actualCompletionDate?.toIso8601String(),
      'rootCauseAnalysis': rootCauseAnalysis,
      'correctiveAction': correctiveAction,
      'preventiveAction': preventiveAction,
      'verificationNotes': verificationNotes,
      'isExternalNCR': isExternalNCR,
      'externalNCRNumber': externalNCRNumber,
      'clientReference': clientReference,
    };
  }

  static ViolationCategory _parseCategory(String category) {
    switch (category.toLowerCase()) {
      case 'minor':
        return ViolationCategory.minor;
      case 'semi_major':
      case 'semimajor':
        return ViolationCategory.semiMajor;
      case 'major':
        return ViolationCategory.major;
      default:
        return ViolationCategory.minor;
    }
  }

  static Severity _parseSeverity(String severity) {
    switch (severity.toLowerCase()) {
      case 'low':
        return Severity.low;
      case 'medium':
        return Severity.medium;
      case 'high':
        return Severity.high;
      case 'critical':
        return Severity.critical;
      default:
        return Severity.low;
    }
  }

  static CardType? _parseCardType(String? cardType) {
    if (cardType == null) return null;
    switch (cardType.toLowerCase()) {
      case 'yellow':
        return CardType.yellow;
      case 'red':
        return CardType.red;
      default:
        return null;
    }
  }

  static ActionTaken? _parseActionTaken(String? action) {
    if (action == null) return null;
    try {
      return ActionTaken.values.firstWhere(
        (a) => a.name == action,
        orElse: () => ActionTaken.other,
      );
    } catch (e) {
      return ActionTaken.other;
    }
  }
}
