class BasicInfoModel {
  final String id;
  final List<String> howFound;
  final String? phone;
  final String? dateOfBirth;
  final String? city;
  final String? country;
  final String? sect;
  final String? maritalStatus;
  final List<String> ethnicity;
  final List<String> nationality;
  final bool? hasChildren;
  final String? childrenCount;
  final String? height;
  final String? weight;
  final String? pray5x;
  final String? openToRelocate;
  final String? employment;
  final String? education;
  final String? income;
  final String? frame;
  final List<String> languagesSpoken;
  final String? preferredDress;
  final int? prefAgeMin;
  final int? prefAgeMax;
  final List<String> prefMaritalStatus;
  final List<String> prefEthnicity;
  final List<String> prefCountryOfResidence;
  final String? relationshipWithIslam;
  final String? roleAsSpouse;
  final String? aboutYourself;
  final String? envisionSpouse;
  final String? envisionMarriage;
  final String? spouseReligiousStatusPref;
  final String? openToRelocateDetails;
  final String? healthConcerns;
  final String? otherPreferences;
  final int completionPercentage;
  final int? age;
  final List<PhotoModel> photos;
  final DateTime createdAt;
  final DateTime updatedAt;

  BasicInfoModel({
    required this.id,
    required this.howFound,
    this.phone,
    this.dateOfBirth,
    this.city,
    this.country,
    this.sect,
    this.maritalStatus,
    required this.ethnicity,
    required this.nationality,
    this.hasChildren,
    this.childrenCount,
    this.height,
    this.weight,
    this.pray5x,
    this.openToRelocate,
    this.employment,
    this.education,
    this.income,
    this.frame,
    required this.languagesSpoken,
    this.preferredDress,
    this.prefAgeMin,
    this.prefAgeMax,
    required this.prefMaritalStatus,
    required this.prefEthnicity,
    required this.prefCountryOfResidence,
    this.relationshipWithIslam,
    this.roleAsSpouse,
    this.aboutYourself,
    this.envisionSpouse,
    this.envisionMarriage,
    this.spouseReligiousStatusPref,
    this.openToRelocateDetails,
    this.healthConcerns,
    this.otherPreferences,
    required this.completionPercentage,
    this.age,
    required this.photos,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BasicInfoModel.fromJson(Map<String, dynamic> json) {
    return BasicInfoModel(
      id: json['id'],
      howFound: (json['how_found'] as List?)?.map((e) => e.toString()).toList() ?? [],
      phone: json['phone'],
      dateOfBirth: json['date_of_birth'],
      city: json['city'],
      country: json['country'],
      sect: json['sect'],
      maritalStatus: json['marital_status'],
      ethnicity: (json['ethnicity'] as List?)?.map((e) => e.toString()).toList() ?? [],
      nationality: (json['nationality'] as List?)?.map((e) => e.toString()).toList() ?? [],
      hasChildren: json['has_children'],
      childrenCount: json['children_count'],
      height: json['height'],
      weight: json['weight'],
      pray5x: json['pray_5x'],
      openToRelocate: json['open_to_relocate'],
      employment: json['employment'],
      education: json['education'],
      income: json['income'],
      frame: json['frame'],
      languagesSpoken: (json['languages_spoken'] as List?)?.map((e) => e.toString()).toList() ?? [],
      preferredDress: json['preferred_dress'],
      prefAgeMin: json['pref_age_min'],
      prefAgeMax: json['pref_age_max'],
      prefMaritalStatus: (json['pref_marital_status'] as List?)?.map((e) => e.toString()).toList() ?? [],
      prefEthnicity: (json['pref_ethnicity'] as List?)?.map((e) => e.toString()).toList() ?? [],
      prefCountryOfResidence: (json['pref_country_of_residence'] as List?)?.map((e) => e.toString()).toList() ?? [],
      relationshipWithIslam: json['relationship_with_islam'],
      roleAsSpouse: json['role_as_spouse'],
      aboutYourself: json['about_yourself'],
      envisionSpouse: json['envision_spouse'],
      envisionMarriage: json['envision_marriage'],
      spouseReligiousStatusPref: json['spouse_religious_status_pref'],
      openToRelocateDetails: json['open_to_relocate_details'],
      healthConcerns: json['health_concerns'],
      otherPreferences: json['other_preferences'],
      completionPercentage: json['completion_percentage'] ?? 0,
      age: json['age'],
      photos: (json['photos'] as List?)?.map((e) => PhotoModel.fromJson(e)).toList() ?? [],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'how_found': howFound,
      'phone': phone,
      'date_of_birth': dateOfBirth,
      'city': city,
      'country': country,
      'sect': sect,
      'marital_status': maritalStatus,
      'ethnicity': ethnicity,
      'nationality': nationality,
      'has_children': hasChildren,
      'children_count': childrenCount,
      'height': height,
      'weight': weight,
      'pray_5x': pray5x,
      'open_to_relocate': openToRelocate,
      'employment': employment,
      'education': education,
      'income': income,
      'frame': frame,
      'languages_spoken': languagesSpoken,
      'preferred_dress': preferredDress,
      'pref_age_min': prefAgeMin,
      'pref_age_max': prefAgeMax,
      'pref_marital_status': prefMaritalStatus,
      'pref_ethnicity': prefEthnicity,
      'pref_country_of_residence': prefCountryOfResidence,
      'relationship_with_islam': relationshipWithIslam,
      'role_as_spouse': roleAsSpouse,
      'about_yourself': aboutYourself,
      'envision_spouse': envisionSpouse,
      'envision_marriage': envisionMarriage,
      'spouse_religious_status_pref': spouseReligiousStatusPref,
      'open_to_relocate_details': openToRelocateDetails,
      'health_concerns': healthConcerns,
      'other_preferences': otherPreferences,
      'completion_percentage': completionPercentage,
      'age': age,
      'photos': photos.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class PhotoModel {
  final String id;
  final String imageUrl;
  final bool isPrimary;
  final DateTime uploadedAt;

  PhotoModel({
    required this.id,
    required this.imageUrl,
    required this.isPrimary,
    required this.uploadedAt,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['id'].toString(),
      imageUrl: json['image'] ?? json['image_url'] ?? '',
      isPrimary: json['is_primary'] ?? false,
      uploadedAt: DateTime.parse(json['created_at'] ?? json['uploaded_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': imageUrl,
      'is_primary': isPrimary,
      'created_at': uploadedAt.toIso8601String(),
    };
  }
}
