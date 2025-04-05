// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp_app/bloc/auth_bloc.dart';
import 'package:erp_app/repository/auth_repository.dart';
import 'package:erp_app/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(AuthRepository()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EduMarshal',
        home: const SplashScreen(),
      ),
    );
  }
}
