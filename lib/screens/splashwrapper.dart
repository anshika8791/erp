import 'package:erp_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:erp_app/bloc/auth_bloc/auth_state.dart';
import 'package:erp_app/screens/dashboard_screen.dart';
import 'package:erp_app/screens/home_screen.dart';
import 'package:erp_app/screens/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashWrapper extends StatelessWidget {
  const SplashWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthSuccess) {
          return const DashboardScreen(); // 👈 User is already logged in
        } else {
          return const HomeScreen(); // 👈 User must log in
        }
      },
    );
  }
}
