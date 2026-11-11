class PasswordResetInitiateResponse {
  final String message;
  final String email;
  final int expiresInSeconds;

  PasswordResetInitiateResponse({
    required this.message,
    required this.email,
    required this.expiresInSeconds,
  });

  factory PasswordResetInitiateResponse.fromJson(
    Map<String, dynamic> json, {
    String fallbackEmail = '',
  }) {
    final rawExpires = json['expires_in_seconds'];
    final expires = rawExpires is num
        ? rawExpires.toInt()
        : int.tryParse(rawExpires?.toString() ?? '') ?? 600;
    final parsedEmail = json['email']?.toString().trim() ?? '';
    return PasswordResetInitiateResponse(
      message: json['message']?.toString() ?? '',
      email: parsedEmail.isNotEmpty ? parsedEmail : fallbackEmail,
      expiresInSeconds: expires,
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
      message: json['message']?.toString() ?? '',
      resetToken: json['reset_token']?.toString() ?? '',
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
      message: json['message']?.toString() ?? '',
    );
  }
}
