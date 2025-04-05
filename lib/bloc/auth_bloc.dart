import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../repository/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final response = await repository.login(event.username, event.password);
      print('Login Response: $response');

      final accessToken = response['access_token'];
      final sessionId = response['SessionId'];
      final xUserId = response['X-UserId']; // ✅ Fix: dash, not underscore
      final xToken = response['X_Token'];

      // validate
      if (accessToken == null ||
          sessionId == null ||
          xUserId == null ||
          xToken == null ||
          accessToken is! String ||
          sessionId is! String ||
          xUserId is! String ||
          xToken is! String) {
        emit(const AuthFailure("Missing or invalid login response data."));
        return;
      }

      emit(
        AuthSuccess(
          accessToken: accessToken,
          sessionId: sessionId,
          xUserId: xUserId,
          xToken: xToken,
          userId: xUserId, // userId = X-UserId in this case
        ),
      );
    } catch (e) {
      emit(AuthFailure("Login failed: ${e.toString()}"));
    }
  }
}
