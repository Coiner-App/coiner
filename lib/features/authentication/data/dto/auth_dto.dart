import 'package:equatable/equatable.dart';

class AuthDto extends Equatable {
  final String userId;
  final String accessToken;
  final String refreshToken;
  final int expiresAfter; // in seconds

  const AuthDto({required this.userId, required this.accessToken, required this.refreshToken, required this.expiresAfter});

  factory AuthDto.fromJson(Map<String, dynamic> json) {
    return AuthDto(
      userId: json['user_id'] as String,
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresAfter: json['expires_after'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_after': expiresAfter,
    };
  }

  @override
  List<Object?> get props => [userId, accessToken, refreshToken, expiresAfter];
}