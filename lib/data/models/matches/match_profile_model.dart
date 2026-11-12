import '../../../core/constants/choice_mappings.dart';

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
  final bool isVerified;
  final bool isProfileLocked;
  final String? occupation;
  final String? ethnicity;
  final String? education;
  final String? bio;
  final String? languages;
  final List<dynamic> photos;
  final String? about;
  final String? aboutYourself;
  final String? envisionMarriage;
  final String? relationshipWithIslam;
  final String? roleAsSpouse;
  final String? envisionSpouse;
  final String? spouseReligiousStatusPref;
  final String? openToRelocateDetails;
  final String? otherPreferences;
  final int? prefAgeMin;
  final int? prefAgeMax;
  final List<String> prefMaritalStatus;
  final List<String> prefEthnicity;
  final List<String> prefCountryOfResidence;
  final List<String> preferredDress;
  final List<String> dress;
  final String? nationality;
  final String? pray5x;
  final String? openToRelocate;

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
    this.isVerified = false,
    this.isProfileLocked = false,
    this.occupation,
    this.ethnicity,
    this.education,
    this.bio,
    this.languages,
    this.photos = const [],
    this.about,
    this.aboutYourself,
    this.envisionMarriage,
    this.relationshipWithIslam,
    this.roleAsSpouse,
    this.envisionSpouse,
    this.spouseReligiousStatusPref,
    this.openToRelocateDetails,
    this.otherPreferences,
    this.prefAgeMin,
    this.prefAgeMax,
    this.prefMaritalStatus = const [],
    this.prefEthnicity = const [],
    this.prefCountryOfResidence = const [],
    this.preferredDress = const [],
    this.dress = const [],
    this.nationality,
    this.pray5x,
    this.openToRelocate,
  });

  static String? formatOfflineLastActive(
    DateTime? lastActive,
    String? lastActiveDisplay, {
    bool isOnline = false,
  }) {
    if (isOnline) return null;

    if (lastActive != null) {
      final rawDiff = DateTime.now().toUtc().difference(lastActive.toUtc());
      final diff = rawDiff.isNegative ? Duration.zero : rawDiff;
      if (diff.inHours < 24) {
        final hours = diff.inHours < 1 ? 1 : diff.inHours;
        return 'Active $hours ${hours == 1 ? 'hr' : 'hrs'} ago';
      }
      final days = diff.inDays < 1 ? 1 : diff.inDays;
      return 'Active $days ${days == 1 ? 'day' : 'days'} ago';
    }

    final display = lastActiveDisplay?.trim();
    if (display == null || display.isEmpty) return null;
    final lower = display.toLowerCase();
    if (lower == 'active now' || lower == 'online' || lower == 'offline') {
      return null;
    }
    if (RegExp(r'\b(m|min|mins|minute|minutes|just now)\b', caseSensitive: false)
            .hasMatch(lower) ||
        RegExp(r'^\d+\s*m\s+ago$', caseSensitive: false).hasMatch(lower)) {
      return 'Active 1 hr ago';
    }
    return display;
  }

  String? get offlineLastActiveLabel => formatOfflineLastActive(
        lastActive,
        lastActiveDisplay,
        isOnline: isOnline,
      );

  static bool _computeIsOnline(
    Map<String, dynamic> json,
    DateTime? lastActive,
    String? lastActiveDisplay,
  ) {
    if (json['is_online'] == true) return true;
    final display = lastActiveDisplay?.toLowerCase().trim() ?? '';
    if (display == 'active now' || display == 'online') return true;
    if (lastActive != null) {
      final diff = DateTime.now().toUtc().difference(lastActive.toUtc());
      return diff.inSeconds < 300 && diff.inMinutes > -5;
    }
    return false;
  }

  static String? _asString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is List) {
      final parts = value
          .map((e) => e?.toString().trim() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
      return parts.isEmpty ? null : parts.join(', ');
    }
    return value.toString();
  }

  static int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString().trim());
  }

  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    if (value is String && value.trim().isNotEmpty) {
      return value
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return [];
  }

  static String? _formatMappedString(
    dynamic value,
    Map<String, String> mapping,
  ) {
    if (value == null) return null;
    if (value is List) {
      final list = value
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
      if (list.isEmpty) return null;
      return ChoiceMappings.keysToDisplays(list, mapping).join(', ');
    }
    final raw = value.toString().trim();
    if (raw.isEmpty) return null;
    return ChoiceMappings.keysStringToDisplay(raw, mapping);
  }

  factory MatchProfileModel.fromJson(Map<String, dynamic> json) {
    final parsedLastActive = json['last_active'] != null
        ? DateTime.tryParse(json['last_active'].toString())
        : null;
    final parsedLastActiveDisplay = _asString(json['last_active_display']);

    return MatchProfileModel(
      id: _asString(json['id']) ?? '',
      codename: _asString(json['codename']) ?? '',
      firstName: _asString(json['first_name']),
      lastName: _asString(json['last_name']),
      role: _asString(json['role']) ?? '',
      gender: _asString(json['gender']),
      subscriptionPlan: _asString(json['subscription_plan']) ?? '',
      lastActive: parsedLastActive,
      lastActiveDisplay: parsedLastActiveDisplay,
      completionPercentage: _asInt(json['completion_percentage']) ?? 0,
      age: _asInt(json['age']),
      city: _asString(json['city']),
      country: _asString(json['country']),
      sect: _asString(json['sect']),
      maritalStatus: _asString(json['marital_status']),
      height: _asString(json['height']),
      hasBoostedProfile: json['has_boosted_profile'] as bool? ?? false,
      photoBlurred: json['photo_blurred'] as bool? ?? true,
      isOnline: _computeIsOnline(json, parsedLastActive, parsedLastActiveDisplay),
      isVerified: json['is_verified'] as bool? ?? false,
      isProfileLocked: json['is_profile_locked'] as bool? ?? false,
      occupation: _asString(json['occupation']),
      ethnicity: _formatMappedString(
        json['ethnicity'],
        ChoiceMappings.ethnicityKeyToDisplay,
      ),
      education: _asString(json['education']),
      bio: _asString(json['bio']),
      languages: _formatMappedString(
        json['languages'],
        ChoiceMappings.languageKeyToDisplay,
      ),
      photos: json['photos'] is List ? json['photos'] as List<dynamic> : [],
      about: _asString(json['about']),
      aboutYourself: _asString(json['about_yourself']),
      envisionMarriage: _asString(json['envision_marriage']),
      relationshipWithIslam: _asString(json['relationship_with_islam']),
      roleAsSpouse: _asString(json['role_as_spouse']),
      envisionSpouse: _asString(json['envision_spouse']),
      spouseReligiousStatusPref: _asString(json['spouse_religious_status_pref']),
      openToRelocateDetails: _asString(json['open_to_relocate_details']),
      otherPreferences: _asString(json['other_preferences']),
      prefAgeMin: _asInt(json['pref_age_min']),
      prefAgeMax: _asInt(json['pref_age_max']),
      prefMaritalStatus: _parseStringList(json['pref_marital_status']),
      prefEthnicity: _parseStringList(json['pref_ethnicity']),
      prefCountryOfResidence:
          _parseStringList(json['pref_country_of_residence']),
      preferredDress: _parseStringList(json['preferred_dress']),
      dress: _parseStringList(json['dress']),
      nationality: _formatMappedString(
        json['nationality'],
        ChoiceMappings.nationalityKeyToDisplay,
      ),
      pray5x: _asString(json['pray_5x']),
      openToRelocate: _asString(json['open_to_relocate']),
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

  String get senderCodename => MatchProfileModel._asString(otherUser['codename']) ?? '';
  int? get senderAge => MatchProfileModel._asInt(otherUser['age']);
  String? get senderHeight => MatchProfileModel._asString(otherUser['height']);
  String? get senderCity => MatchProfileModel._asString(otherUser['city']);
  String? get senderEthnicity => MatchProfileModel._formatMappedString(
        otherUser['ethnicity'],
        ChoiceMappings.ethnicityKeyToDisplay,
      );
  String? get senderCountry => MatchProfileModel._asString(otherUser['country']);

  String get receiverCodename => MatchProfileModel._asString(otherUser['codename']) ?? '';
  int? get receiverAge => MatchProfileModel._asInt(otherUser['age']);
  String? get receiverHeight => MatchProfileModel._asString(otherUser['height']);
  String? get receiverCity => MatchProfileModel._asString(otherUser['city']);
  String? get receiverEthnicity => MatchProfileModel._formatMappedString(
        otherUser['ethnicity'],
        ChoiceMappings.ethnicityKeyToDisplay,
      );
  String? get receiverCountry => MatchProfileModel._asString(otherUser['country']);
  String get senderId => MatchProfileModel._asString(otherUser['id']) ?? '';
  String get receiverId => MatchProfileModel._asString(otherUser['id']) ?? '';
  bool get isOtherUserVerified => otherUser['is_verified'] == true;
  DateTime? get otherUserLastActive => otherUser['last_active'] != null
      ? DateTime.tryParse(otherUser['last_active'].toString())
      : null;
  String? get otherUserLastActiveDisplay =>
      MatchProfileModel._asString(otherUser['last_active_display']);
  bool get isOtherUserOnline {
    if (otherUser['is_online'] == true) return true;
    final display = otherUserLastActiveDisplay?.toLowerCase().trim() ?? '';
    if (display == 'active now' || display == 'online') return true;
    final dt = otherUserLastActive;
    if (dt != null) {
      final diff = DateTime.now().toUtc().difference(dt.toUtc());
      return diff.inSeconds < 300 && diff.inMinutes > -5;
    }
    return false;
  }

  String? get otherUserOfflineLastActiveLabel =>
      MatchProfileModel.formatOfflineLastActive(
        otherUserLastActive,
        otherUserLastActiveDisplay,
        isOnline: isOtherUserOnline,
      );
  List<dynamic> get otherUserPhotos =>
      otherUser['photos'] is List ? otherUser['photos'] as List<dynamic> : [];

  factory ConnectionRequestModel.fromJson(Map<String, dynamic> json) {
    final other = json['other_user'];
    return ConnectionRequestModel(
      id: MatchProfileModel._asString(json['id']) ?? '',
      matchId: MatchProfileModel._asString(json['match_id']),
      status: MatchProfileModel._asString(json['status']) ?? '',
      otherUser: other is Map
          ? Map<String, dynamic>.from(other)
          : <String, dynamic>{},
      requestedAt: DateTime.tryParse(json['requested_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}

class MatchModel {
  final String id;
  final String matchId;
  final String status;
  final Map<String, dynamic> otherUser;
  final bool photosCurrentlyVisible;
  final String photoRequestStatus;
  final bool photoRequestedByOtherUser;
  final String waliRequestStatus;
  final String secondPhotoRequestStatus;
  final int photoViewCount;
  final DateTime? acceptedAt;
  final DateTime updatedAt;

  MatchModel({
    required this.id,
    required this.matchId,
    required this.status,
    required this.otherUser,
    required this.photosCurrentlyVisible,
    required this.photoRequestStatus,
    required this.photoRequestedByOtherUser,
    required this.waliRequestStatus,
    required this.secondPhotoRequestStatus,
    required this.photoViewCount,
    this.acceptedAt,
    required this.updatedAt,
  });

  MatchModel copyWith({
    String? id,
    String? matchId,
    String? status,
    Map<String, dynamic>? otherUser,
    bool? photosCurrentlyVisible,
    String? photoRequestStatus,
    bool? photoRequestedByOtherUser,
    String? waliRequestStatus,
    String? secondPhotoRequestStatus,
    int? photoViewCount,
    DateTime? acceptedAt,
    DateTime? updatedAt,
  }) {
    return MatchModel(
      id: id ?? this.id,
      matchId: matchId ?? this.matchId,
      status: status ?? this.status,
      otherUser: otherUser ?? this.otherUser,
      photosCurrentlyVisible: photosCurrentlyVisible ?? this.photosCurrentlyVisible,
      photoRequestStatus: photoRequestStatus ?? this.photoRequestStatus,
      photoRequestedByOtherUser: photoRequestedByOtherUser ?? this.photoRequestedByOtherUser,
      waliRequestStatus: waliRequestStatus ?? this.waliRequestStatus,
      secondPhotoRequestStatus: secondPhotoRequestStatus ?? this.secondPhotoRequestStatus,
      photoViewCount: photoViewCount ?? this.photoViewCount,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get matchedUserCodename =>
      MatchProfileModel._asString(otherUser['codename']) ?? '';
  int? get matchedUserAge => MatchProfileModel._asInt(otherUser['age']);
  String? get matchedUserHeight =>
      MatchProfileModel._asString(otherUser['height']);
  String? get matchedUserCity => MatchProfileModel._asString(otherUser['city']);
  String? get matchedUserEthnicity => MatchProfileModel._formatMappedString(
        otherUser['ethnicity'],
        ChoiceMappings.ethnicityKeyToDisplay,
      );
  String? get matchedUserCountry =>
      MatchProfileModel._asString(otherUser['country']);
  String get matchedUserId =>
      MatchProfileModel._asString(otherUser['id']) ?? '';
  bool get isOtherUserVerified => otherUser['is_verified'] == true;
  DateTime? get otherUserLastActive => otherUser['last_active'] != null
      ? DateTime.tryParse(otherUser['last_active'].toString())
      : null;
  String? get otherUserLastActiveDisplay =>
      MatchProfileModel._asString(otherUser['last_active_display']);
  bool get isOtherUserOnline {
    if (otherUser['is_online'] == true) return true;
    final display = otherUserLastActiveDisplay?.toLowerCase().trim() ?? '';
    if (display == 'active now' || display == 'online') return true;
    final dt = otherUserLastActive;
    if (dt != null) {
      final diff = DateTime.now().toUtc().difference(dt.toUtc());
      return diff.inSeconds < 300 && diff.inMinutes > -5;
    }
    return false;
  }

  String? get otherUserOfflineLastActiveLabel =>
      MatchProfileModel.formatOfflineLastActive(
        otherUserLastActive,
        otherUserLastActiveDisplay,
        isOnline: isOtherUserOnline,
      );
  List<dynamic> get matchedUserPhotos =>
      otherUser['photos'] is List ? otherUser['photos'] as List<dynamic> : [];
  Map<String, dynamic>? get waliDetails => otherUser['wali_details'] is Map
      ? Map<String, dynamic>.from(otherUser['wali_details'] as Map)
      : null;
  String? get waliName =>
      waliDetails?['wali_name']?.toString() ??
      otherUser['wali_name']?.toString();
  String? get waliRelation =>
      waliDetails?['wali_relation']?.toString() ??
      otherUser['wali_relation']?.toString();
  String? get waliNumber =>
      waliDetails?['wali_number']?.toString() ??
      otherUser['wali_phone']?.toString();
  bool get isWaliApproved {
    if (!isActiveConnection) return false;
    final waliStatus = waliRequestStatus.toLowerCase();
    final matchStatus = status.toLowerCase();
    return waliStatus == 'accepted' ||
        waliStatus == 'approved' ||
        matchStatus == 'wali_accepted' ||
        matchStatus == 'in_discussion';
  }

  bool get isDiscussionLocked {
    if (!isActiveConnection) return false;
    final matchStatus = status.toLowerCase();
    return isWaliApproved ||
        matchStatus == 'wali_accepted' ||
        matchStatus == 'in_discussion';
  }

  bool get isActiveConnection => !const {
        'pending',
        'declined',
        'cancelled',
        'dropped',
      }.contains(status.toLowerCase());

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    final other = json['other_user'];
    return MatchModel(
      id: MatchProfileModel._asString(json['id']) ?? '',
      matchId: MatchProfileModel._asString(json['match_id']) ?? '',
      status: MatchProfileModel._asString(json['status']) ?? '',
      otherUser: other is Map
          ? Map<String, dynamic>.from(other)
          : <String, dynamic>{},
      photosCurrentlyVisible: json['photos_currently_visible'] as bool? ?? false,
      photoRequestStatus:
          MatchProfileModel._asString(json['photo_request_status']) ?? 'none',
      photoRequestedByOtherUser:
          json['photo_requested_by_other_user'] as bool? ?? false,
      waliRequestStatus:
          MatchProfileModel._asString(json['wali_request_status']) ?? 'none',
      secondPhotoRequestStatus:
          MatchProfileModel._asString(json['second_photo_request_status']) ??
              'none',
      photoViewCount: MatchProfileModel._asInt(json['photo_view_count']) ?? 0,
      acceptedAt: json['accepted_at'] != null
          ? DateTime.tryParse(json['accepted_at'].toString())
          : null,
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
