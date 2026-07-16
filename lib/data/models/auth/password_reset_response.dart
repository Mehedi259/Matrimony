class PasswordResetInitiateResponse {
  final String message;
  final String email;
  final int expiresInSeconds;

  PasswordResetInitiateResponse({
    required this.message,
    required this.email,
    required this.expiresInSeconds,
  });

  factory PasswordResetInitiateResponse.fromJson(Map<String, dynamic> json) {
    return PasswordResetInitiateResponse(
      message: json['message'],
      email: json['email'],
      expiresInSeconds: json['expires_in_seconds'],
    );
  }
}

class PasswordResetVerifyResponse {
  final String message;
  final String resetToken;

  PasswordResetVerifyResponse({
    required this.message,
    required this.resetToken,
  });

  factory PasswordResetVerifyResponse.fromJson(Map<String, dynamic> json) {
    return PasswordResetVerifyResponse(
      message: json['message'],
      resetToken: json['reset_token'],
    );
  }
}

class PasswordResetConfirmResponse {
  final String message;

  PasswordResetConfirmResponse({
    required this.message,
  });

  factory PasswordResetConfirmResponse.fromJson(Map<String, dynamic> json) {
    return PasswordResetConfirmResponse(
      message: json['message'],
    );
  }
}
