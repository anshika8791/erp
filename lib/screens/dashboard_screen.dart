import 'package:erp_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:erp_app/bloc/auth_bloc/auth_state.dart';
import 'package:erp_app/bloc/profile_bloc/profile_bloc.dart';
import 'package:erp_app/bloc/profile_bloc/profile_event.dart';

import 'package:erp_app/drawer/assignment_screen.dart';
import 'package:erp_app/drawer/calendar_screen.dart';
import 'package:erp_app/drawer/eidentity_screen.dart';
import 'package:erp_app/drawer/profile_screen.dart';
import 'package:erp_app/models/login_response.dart'; // ✅ Add this import
import 'package:erp_app/repository/profile_repository.dart';
import 'package:erp_app/screens/attendance_info.dart';
import 'package:erp_app/screens/home_screen.dart';
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
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple,
      ),
      drawer: _buildDrawer(context),
      body: const Center(child: Text("Welcome to Dashboard")),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.purple),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
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
              MaterialPageRoute(builder: (_) => const AttendanceInfo()),
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
      leading: Icon(icon, color: Colors.purple),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        onTap();
      },
    );
  }
}
