class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final DateTime? expiresAtUtc;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    this.expiresAtUtc,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String? ?? '',
      expiresAtUtc: json['expiresAtUtc'] == null
          ? null
          : DateTime.parse(json['expiresAtUtc'] as String),
    );
  }
}