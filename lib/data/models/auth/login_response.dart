import '../user_model.dart';

class LoginResponse {
  final String message;
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  LoginResponse({
    required this.message,
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      user: UserModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'user': user.toJson(),
    };
  }
}
