class MatchProfileModel {
  final String id;
  final String codename;
  final String? firstName;
  final String? lastName;
  final String role;
  final String? gender;
  final String subscriptionPlan;
  final DateTime? lastActive;
  final String? lastActiveDisplay;
  final int completionPercentage;
  final int? age;
  final String? city;
  final String? country;
  final String? sect;
  final String? maritalStatus;
  final String? height;
  final bool hasBoostedProfile;
  final bool photoBlurred;
  final bool isOnline;
  final String? occupation;
  final String? ethnicity;
  final String? education;
  final String? bio;
  final String? languages;

  MatchProfileModel({
    required this.id,
    required this.codename,
    this.firstName,
    this.lastName,
    required this.role,
    this.gender,
    required this.subscriptionPlan,
    this.lastActive,
    this.lastActiveDisplay,
    required this.completionPercentage,
    this.age,
    this.city,
    this.country,
    this.sect,
    this.maritalStatus,
    this.height,
    required this.hasBoostedProfile,
    required this.photoBlurred,
    this.isOnline = false,
    this.occupation,
    this.ethnicity,
    this.education,
    this.bio,
    this.languages,
  });

  factory MatchProfileModel.fromJson(Map<String, dynamic> json) {
    return MatchProfileModel(
      id: json['id'] as String,
      codename: json['codename'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      role: json['role'] as String,
      gender: json['gender'] as String?,
      subscriptionPlan: json['subscription_plan'] as String,
      lastActive: json['last_active'] != null ? DateTime.parse(json['last_active'] as String) : null,
      lastActiveDisplay: json['last_active_display'] as String?,
      completionPercentage: (json['completion_percentage'] as num?)?.toInt() ?? 0,
      age: (json['age'] as num?)?.toInt(),
      city: json['city'] as String?,
      country: json['country'] as String?,
      sect: json['sect'] as String?,
      maritalStatus: json['marital_status'] as String?,
      height: json['height'] as String?,
      hasBoostedProfile: json['has_boosted_profile'] as bool? ?? false,
      photoBlurred: json['photo_blurred'] as bool? ?? true,
      isOnline: json['is_online'] as bool? ?? false,
      occupation: json['occupation'] as String?,
      ethnicity: json['ethnicity'] as String?,
      education: json['education'] as String?,
      bio: json['bio'] as String?,
      languages: json['languages'] as String?,
    );
  }
}

class ConnectionRequestModel {
  final String id;
  final String? matchId; // ✅ Made nullable
  final String status;
  final Map<String, dynamic> otherUser;
  final DateTime requestedAt;

  ConnectionRequestModel({
    required this.id,
    this.matchId, // ✅ Made nullable
    required this.status,
    required this.otherUser,
    required this.requestedAt,
  });

  String get senderCodename => otherUser['codename'] ?? '';
  int? get senderAge => otherUser['age'];
  String? get senderHeight => otherUser['height'];
  String? get senderCity => otherUser['city'];
  
  String get receiverCodename => otherUser['codename'] ?? '';
  int? get receiverAge => otherUser['age'];
  String? get receiverHeight => otherUser['height'];
  String? get receiverCity => otherUser['city'];
  String get receiverId => otherUser['id'] ?? '';

  factory ConnectionRequestModel.fromJson(Map<String, dynamic> json) {
    return ConnectionRequestModel(
      id: json['id'] as String,
      matchId: json['match_id'] as String?, // ✅ Now handles null
      status: json['status'] as String,
      otherUser: json['other_user'] as Map<String, dynamic>,
      requestedAt: DateTime.parse(json['requested_at'] as String),
    );
  }
}

class MatchModel {
  final String id;
  final String matchId;
  final String status;
  final Map<String, dynamic> otherUser;
  final bool photosCurrentlyVisible;
  final String waliRequestStatus;
  final DateTime? acceptedAt;
  final DateTime updatedAt;

  MatchModel({
    required this.id,
    required this.matchId,
    required this.status,
    required this.otherUser,
    required this.photosCurrentlyVisible,
    required this.waliRequestStatus,
    this.acceptedAt,
    required this.updatedAt,
  });

  String get matchedUserCodename => otherUser['codename'] ?? '';
  int? get matchedUserAge => otherUser['age'];
  String? get matchedUserHeight => otherUser['height'];
  String? get matchedUserCity => otherUser['city'];
  String get matchedUserId => otherUser['id'] ?? '';

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['id'] as String,
      matchId: json['match_id'] as String,
      status: json['status'] as String,
      otherUser: json['other_user'] as Map<String, dynamic>,
      photosCurrentlyVisible: json['photos_currently_visible'] as bool? ?? false,
      waliRequestStatus: json['wali_request_status'] as String? ?? 'none',
      acceptedAt: json['accepted_at'] != null ? DateTime.parse(json['accepted_at'] as String) : null,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
