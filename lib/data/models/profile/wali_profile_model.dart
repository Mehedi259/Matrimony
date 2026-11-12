class WaliProfileModel {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? waliName;
  final List<String>? howFound;
  final String? gender;
  final String? relationToSister;
  final String? phone;
  final int completionPercentage;

  const WaliProfileModel({
    this.id,
    this.firstName,
    this.lastName,
    this.waliName,
    this.howFound,
    this.gender,
    this.relationToSister,
    this.phone,
    this.completionPercentage = 0,
  });

  factory WaliProfileModel.fromJson(Map<String, dynamic> json) {
    final rawHowFound = json['how_found'];
    return WaliProfileModel(
      id: json['id']?.toString(),
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      waliName: json['wali_name']?.toString(),
      howFound: rawHowFound is List
          ? rawHowFound.map((e) => e.toString()).toList()
          : null,
      gender: json['gender']?.toString(),
      relationToSister: json['relation_to_sister']?.toString(),
      phone: json['phone']?.toString(),
      completionPercentage:
          (json['completion_percentage'] as num?)?.toInt() ?? 0,
    );
  }
}

