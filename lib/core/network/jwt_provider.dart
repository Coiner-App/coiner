import 'package:flutter_riverpod/flutter_riverpod.dart';

class JwtProvider extends Notifier<String?> {
@override
  String? build() => null; // We initialize it in the main.dart with an override

  void setToken(String? token) => state = token;
  void clearToken() => state = null;
}

final jwtProvider = NotifierProvider<JwtProvider, String?>(() => JwtProvider());