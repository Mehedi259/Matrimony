class RegisterInitiateResponse {
  final String message;
  final String email;
  final int expiresInSeconds;

  RegisterInitiateResponse({
    required this.message,
    required this.email,
    required this.expiresInSeconds,
  });

  factory RegisterInitiateResponse.fromJson(Map<String, dynamic> json) {
    return RegisterInitiateResponse(
      message: json['message'],
      email: json['email'],
      expiresInSeconds: json['expires_in_seconds'],
    );
  }
}

class RegisterVerifyResponse {
  final String message;
  final String accessToken;
  final String refreshToken;
  final Map<String, dynamic> user;

  RegisterVerifyResponse({
    required this.message,
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory RegisterVerifyResponse.fromJson(Map<String, dynamic> json) {
    return RegisterVerifyResponse(
      message: json['message'],
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      user: json['user'],
    );
  }
}
