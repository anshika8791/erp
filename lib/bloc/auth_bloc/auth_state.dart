import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String accessToken;
  final String sessionId;
  final String xUserId;
  final String xToken;
  final String userId;

  const AuthSuccess({
    required this.accessToken,
    required this.sessionId,
    required this.xUserId,
    required this.xToken,
    required this.userId,
  });
  

  @override
  List<Object> get props => [accessToken, sessionId, xUserId, xToken, userId];
  
}

class AuthFailure extends AuthState {
  final String errorMessage;

  const AuthFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
