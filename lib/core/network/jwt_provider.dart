import 'package:flutter_riverpod/flutter_riverpod.dart';

class JwtProvider extends Notifier<String?> {
@override
  String? build() => null; // App boots with null in RAM

  void setToken(String? token) => state = token;
  void clearToken() => state = null;
}

final jwtProvider = NotifierProvider<JwtProvider, String?>(() => JwtProvider());