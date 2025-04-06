import 'dart:ui';
import 'package:erp_app/bloc/profile_bloc/profile_bloc.dart';
import 'package:erp_app/bloc/profile_bloc/profile_state.dart';
import 'package:erp_app/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _buildProfileItem(
    String label,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.2),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Student Profile",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.purpleAccent),
            );
          } else if (state is ProfileLoaded) {
            UserProfile profile = state.profile;
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0F0C29),
                    Color(0xFF302B63),
                    Color(0xFF24243E),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 120, bottom: 20),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.deepPurpleAccent,
                        child: Icon(
                          Icons.account_circle,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        profile.fullName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        profile.collegeEmail,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 30),

                      _buildProfileItem(
                        "Roll Number",
                        profile.rollNumber,
                        Icons.badge,
                        Colors.indigoAccent,
                      ),
                      _buildProfileItem(
                        "Semester",
                        profile.semester,
                        Icons.school,
                        Colors.tealAccent,
                      ),
                      _buildProfileItem(
                        "Section",
                        profile.section,
                        Icons.group,
                        Colors.deepPurpleAccent,
                      ),
                      _buildProfileItem(
                        "DOB",
                        profile.dob,
                        Icons.cake,
                        Colors.pinkAccent,
                      ),
                      _buildProfileItem(
                        "Contact",
                        profile.contactNumber,
                        Icons.phone,
                        Colors.greenAccent,
                      ),
                      _buildProfileItem(
                        "Address",
                        profile.address,
                        Icons.home,
                        Colors.orangeAccent,
                      ),
                      _buildProfileItem(
                        "Father's Name",
                        profile.fatherName,
                        FontAwesomeIcons.person,
                        Colors.cyan,
                      ),
                      _buildProfileItem(
                        "Mother's Name",
                        profile.motherName,
                        FontAwesomeIcons.personDress,
                        Colors.amber,
                      ),
                      _buildProfileItem(
                        "Parent Mobile",
                        profile.parentMobileNumber,
                        Icons.phone_android,
                        Colors.redAccent,
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is ProfileError) {
            return const Center(
              child: Text(
                'Failed to load profile',
                style: TextStyle(color: Colors.redAccent),
              ),
            );
          }
          return const Center(
            child: Text("Loading...", style: TextStyle(color: Colors.white)),
          );
        },
      ),
    );
  }
}
