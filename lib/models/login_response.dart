import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginResponse {
  final String accessToken;
  final String sessionId;
  final String xUserId;
  final String xToken;

  LoginResponse({
    required this.accessToken,
    required this.sessionId,
    required this.xUserId,
    required this.xToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'],
      sessionId: json['SessionId'],
      xUserId: json['X_UserId'],
      xToken: json['X_Token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'SessionId': sessionId,
      'X_UserId': xUserId,
      'X_Token': xToken,
    };
  }
}
