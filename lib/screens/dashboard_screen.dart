import 'package:erp_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:erp_app/bloc/auth_bloc/auth_state.dart';
import 'package:erp_app/bloc/profile_bloc/profile_bloc.dart';
import 'package:erp_app/bloc/profile_bloc/profile_event.dart';

import 'package:erp_app/drawer/assignment_screen.dart';
import 'package:erp_app/drawer/calendar_screen.dart';
import 'package:erp_app/drawer/eidentity_screen.dart';
import 'package:erp_app/drawer/profile_screen.dart';
import 'package:erp_app/models/login_response.dart';
import 'package:erp_app/repository/profile_repository.dart';
import 'package:erp_app/screens/attendance_info.dart';
import 'package:erp_app/screens/home_screen.dart';
import 'package:erp_app/screens/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 4,
        title: const Text(
          'Flux ERP Dashboard 🚀',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      drawer: _buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Welcome to Flux ERP 👋",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                children: [
                  _dashboardCard(
                    icon: Icons.person,
                    label: 'Profile',
                    color: Colors.cyanAccent,
                    onTap: () {
                      final authState =
                          BlocProvider.of<AuthBloc>(context).state;
                      if (authState is AuthSuccess) {
                        final loginResponse = LoginResponse(
                          accessToken: authState.accessToken,
                          sessionId: authState.sessionId,
                          xUserId: authState.xUserId,
                          xToken: authState.xToken,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => BlocProvider(
                                  create:
                                      (_) => ProfileBloc(
                                        profileRepository: ProfileRepository(),
                                        loginResponse: loginResponse,
                                      )..add(FetchProfile()),
                                  child: const ProfileScreen(),
                                ),
                          ),
                        );
                      }
                    },
                  ),
                  _dashboardCard(
                    icon: Icons.assignment_turned_in,
                    label: 'Assignment',
                    color: Colors.tealAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AssignmentScreen(),
                        ),
                      );
                    },
                  ),
                  _dashboardCard(
                    icon: Icons.badge_outlined,
                    label: 'E-Identity',
                    color: Colors.pinkAccent.shade100,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EIdentityScreen(),
                        ),
                      );
                    },
                  ),
                  _dashboardCard(
                    icon: Icons.calendar_today_rounded,
                    label: 'Calendar',
                    color: Colors.amberAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CalendarScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1E1E1E),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.flash_on_rounded, size: 50, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  'Flux ERP Menu',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ],
            ),
          ),
          _drawerItem('Dashboard', Icons.dashboard, () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DashboardScreen()),
            );
          }),
          _drawerItem('Profile', Icons.person, () {
            final authState = BlocProvider.of<AuthBloc>(context).state;
            if (authState is AuthSuccess) {
              final loginResponse = LoginResponse(
                accessToken: authState.accessToken,
                sessionId: authState.sessionId,
                xUserId: authState.xUserId,
                xToken: authState.xToken,
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => BlocProvider(
                        create:
                            (_) => ProfileBloc(
                              profileRepository: ProfileRepository(),
                              loginResponse: loginResponse,
                            )..add(FetchProfile()),
                        child: const ProfileScreen(),
                      ),
                ),
              );
            }
          }),


          _drawerItem('Assignment', Icons.assignment, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AssignmentScreen()),
            );
          }),
          _drawerItem('Attendance', Icons.assignment, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Test()),
            );
          }),
          _drawerItem('E-Identity', Icons.badge, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EIdentityScreen()),
            );
          }),
          _drawerItem('Calendar', Icons.calendar_month, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CalendarScreen()),
            );
          }),
          _drawerItem('Sign Out', Icons.logout, () async {
            final storage = FlutterSecureStorage();

// Delete one item (e.g., access token)
          await storage.delete(key: 'accessToken');
          await storage.delete(key: 'sessionId');
          await storage.delete(key: 'xUserId');
          await storage.delete(key: 'xToken');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (Route<dynamic> route) => false,
            );
          }),
        ],
      ),
    );
  }

  ListTile _drawerItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurpleAccent),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context); // Close drawer
        onTap();
      },
    );
  }

  Widget _dashboardCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.6),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 14),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
