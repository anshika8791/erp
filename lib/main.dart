
import 'package:erp_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:erp_app/bloc/profile_bloc/profile_event.dart';
import 'package:erp_app/screens/splashwrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp_app/repository/auth_repository.dart';
import 'package:erp_app/screens/splash_screen.dart';
import 'package:erp_app/bloc/auth_bloc/auth_event.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository = AuthRepository();

   MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(authRepository)..add(CheckAuthStatus()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
