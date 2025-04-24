import 'dart:ui';
import 'package:erp_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:erp_app/bloc/auth_bloc/auth_event.dart';
import 'package:erp_app/bloc/auth_bloc/auth_state.dart';
import 'package:erp_app/screens/dashboard_screen.dart';
import 'package:erp_app/screens/forgot_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    if (username.isNotEmpty && password.isNotEmpty) {
      const FlutterSecureStorage secureStorage = FlutterSecureStorage();
      secureStorage.write(key: 'stored_username', value: username);
      secureStorage.write(key: 'stored_password', value: password);
      context.read<AuthBloc>().add(
        LoginRequested(username: username, password: password),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter both username and password"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 0, 0),
      body: Stack(
        children: [
          // Lottie animation background
          Positioned.fill(
            child: Lottie.asset(
              'assets/loginback.json', // replace with your Lottie file path
              fit: BoxFit.cover,
              repeat: true,
            ),
          ),

          // Blurred form container
          Positioned.fill(
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: BlocConsumer<AuthBloc, AuthState>(
                          listener: (context, state) {
                            if (state is AuthSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Login Successful"),
                                ),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const DashboardScreen(),
                                ),
                              );
                            } else if (state is AuthFailure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.errorMessage)),
                              );
                            }
                          },
                          builder: (context, state) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 20),
                                const Text(
                                  "Flux ERP",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Welcome back 👋",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                TextField(
                                  controller: _usernameController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                    ),
                                    hintText: 'Username',
                                    hintStyle: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFF2A2A2A),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Colors.grey,
                                    ),
                                    hintText: 'Password',
                                    hintStyle: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFF2A2A2A),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed:
                                        state is AuthLoading
                                            ? null
                                            : _handleLogin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF4CAF50),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child:
                                        state is AuthLoading
                                            ? const CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                            : const Text(
                                              'SIGN IN',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => const ForgotPasswordScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
