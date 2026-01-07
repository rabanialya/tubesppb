// lib/models/password_reset_token.dart

class PasswordResetToken {
  final String email;
  final String token;
  final DateTime createdAt;

  PasswordResetToken({
    required this.email,
    required this.token,
    required this.createdAt,
  });

  // Convert dari JSON (dari Supabase)
  factory PasswordResetToken.fromJson(Map<String, dynamic> json) {
    return PasswordResetToken(
      email: json['email'] as String,
      token: json['token'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // Convert ke JSON (untuk insert ke Supabase)
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'token': token,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Check apakah token sudah expired (lebih dari 15 menit)
  bool isExpired() {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inMinutes > 15;
  }
}