class UserModel {
  final String id;
  final String codename;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final String? gender;
  final String? profilePicture;
  final String subscriptionPlan;
  final DateTime? subscriptionStart;
  final DateTime? subscriptionEnd;
  final String provider;
  final bool isActive;
  final bool isPrivateMatchmakingClient;
  final DateTime? lastActive;
  final String? lastActiveDisplay;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double profileCompletionPercentage;

  UserModel({
    required this.id,
    required this.codename,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    this.gender,
    this.profilePicture,
    required this.subscriptionPlan,
    this.subscriptionStart,
    this.subscriptionEnd,
    required this.provider,
    required this.isActive,
    required this.isPrivateMatchmakingClient,
    this.lastActive,
    this.lastActiveDisplay,
    required this.createdAt,
    required this.updatedAt,
    this.profileCompletionPercentage = 0.0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      codename: json['codename'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      role: json['role'],
      gender: json['gender'],
      profilePicture: json['profile_picture'],
      subscriptionPlan: json['subscription_plan'],
      subscriptionStart: json['subscription_start'] != null
          ? DateTime.parse(json['subscription_start'])
          : null,
      subscriptionEnd: json['subscription_end'] != null
          ? DateTime.parse(json['subscription_end'])
          : null,
      provider: json['provider'],
      isActive: json['is_active'],
      isPrivateMatchmakingClient: json['is_private_matchmaking_client'],
      lastActive: json['last_active'] != null
          ? DateTime.parse(json['last_active'])
          : null,
      lastActiveDisplay: json['last_active_display'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      profileCompletionPercentage: (json['profile_completion_percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codename': codename,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'role': role,
      'gender': gender,
      'profile_picture': profilePicture,
      'subscription_plan': subscriptionPlan,
      'subscription_start': subscriptionStart?.toIso8601String(),
      'subscription_end': subscriptionEnd?.toIso8601String(),
      'provider': provider,
      'is_active': isActive,
      'is_private_matchmaking_client': isPrivateMatchmakingClient,
      'last_active': lastActive?.toIso8601String(),
      'last_active_display': lastActiveDisplay,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'profile_completion_percentage': profileCompletionPercentage,
    };
  }

  UserModel copyWith({
    String? id,
    String? codename,
    String? firstName,
    String? lastName,
    String? email,
    String? role,
    String? gender,
    String? profilePicture,
    String? subscriptionPlan,
    DateTime? subscriptionStart,
    DateTime? subscriptionEnd,
    String? provider,
    bool? isActive,
    bool? isPrivateMatchmakingClient,
    DateTime? lastActive,
    String? lastActiveDisplay,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? profileCompletionPercentage,
  }) {
    return UserModel(
      id: id ?? this.id,
      codename: codename ?? this.codename,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      role: role ?? this.role,
      gender: gender ?? this.gender,
      profilePicture: profilePicture ?? this.profilePicture,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      subscriptionStart: subscriptionStart ?? this.subscriptionStart,
      subscriptionEnd: subscriptionEnd ?? this.subscriptionEnd,
      provider: provider ?? this.provider,
      isActive: isActive ?? this.isActive,
      isPrivateMatchmakingClient: isPrivateMatchmakingClient ?? this.isPrivateMatchmakingClient,
      lastActive: lastActive ?? this.lastActive,
      lastActiveDisplay: lastActiveDisplay ?? this.lastActiveDisplay,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      profileCompletionPercentage: profileCompletionPercentage ?? this.profileCompletionPercentage,
    );
  }
}
