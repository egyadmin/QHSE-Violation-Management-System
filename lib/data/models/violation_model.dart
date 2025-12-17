class Violation {
  final String id;
  final String title;
  final String description;
  final String qhseDomain; // safety, health, quality, environment
  final String severity; // low, medium, high, critical
  final String status; // pending, under_review, approved, rejected, closed
  final String? projectId;
  final String? projectName;
  final String? location;
  final double? latitude;  // GPS latitude
  final double? longitude; // GPS longitude
  final String reportedBy;
  final String? reportedByName;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String> attachments;
  final Map<String, dynamic>? metadata;

  Violation({
    required this.id,
    required this.title,
    required this.description,
    required this.qhseDomain,
    required this.severity,
    required this.status,
    this.projectId,
    this.projectName,
    this.location,
    this.latitude,
    this.longitude,
    required this.reportedBy,
    this.reportedByName,
    required this.createdAt,
    this.updatedAt,
    this.attachments = const [],
    this.metadata,
  });

  factory Violation.fromJson(Map<String, dynamic> json) {
    // Map backend domain ID to domain name
    String getDomainName(int? domainId) {
      switch (domainId) {
        case 1: return 'safety';
        case 2: return 'health';
        case 3: return 'quality';
        case 4: return 'environment';
        default: return 'safety';
      }
    }
    
    return Violation(
      id: (json['id'] ?? json['_id'] ?? '0').toString(),
      // Backend uses 'number' not 'title'
      title: json['title'] as String? ?? json['number'] as String? ?? '',
      description: json['description'] as String? ?? '',
      // Backend uses domainId (number) not qhseDomain (string)
      qhseDomain: json['qhseDomain'] as String? ?? 
                  json['domain'] as String? ?? 
                  (json['domainId'] != null ? getDomainName(json['domainId'] as int?) : 'safety'),
      severity: json['severity'] as String? ?? 'medium',
      // Backend might not have status field
      status: json['status'] as String? ?? 
              (json['isClosed'] == true ? 'closed' : 'pending'),
      projectId: (json['projectId'] ?? '').toString(),
      projectName: json['projectName'] as String?,
      location: json['location'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      // Backend uses reporterId not reportedBy
      reportedBy: (json['reportedBy'] ?? json['reporterId'] ?? json['createdBy'] ?? '0').toString(),
      // Backend uses violatorName
      reportedByName: json['reportedByName'] as String? ?? json['violatorName'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      attachments: json['attachments'] != null
          ? List<String>.from(json['attachments'] as List)
          : [],
      metadata: json,  // Store full JSON as metadata for debugging
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'qhseDomain': qhseDomain,
      'severity': severity,
      'status': status,
      if (projectId != null) 'projectId': projectId,
      if (projectName != null) 'projectName': projectName,
      if (location != null) 'location': location,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'reportedBy': reportedBy,
      if (reportedByName != null) 'reportedByName': reportedByName,
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      'attachments': attachments,
      if (metadata != null) 'metadata': metadata,
    };
  }

  Violation copyWith({
    String? id,
    String? title,
    String? description,
    String? qhseDomain,
    String? severity,
    String? status,
    String? projectId,
    String? projectName,
    String? location,
    double? latitude,
    double? longitude,
    String? reportedBy,
    String? reportedByName,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? attachments,
    Map<String, dynamic>? metadata,
  }) {
    return Violation(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      qhseDomain: qhseDomain ?? this.qhseDomain,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      reportedBy: reportedBy ?? this.reportedBy,
      reportedByName: reportedByName ?? this.reportedByName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      attachments: attachments ?? this.attachments,
      metadata: metadata ?? this.metadata,
    );
  }
}
