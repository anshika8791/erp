import 'package:erp_app/bloc/profile_bloc/profile_bloc.dart';
import 'package:erp_app/bloc/profile_bloc/profile_state.dart';
import 'package:erp_app/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _buildProfileItem(String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: ListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
        leading: const Icon(Icons.person),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Profile"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            UserProfile profile = state.profile;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.deepPurple,
                    child: const Icon(
                      Icons.account_circle,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profile.fullName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    profile.collegeEmail,
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 20),
                  _buildProfileItem("Roll Number", profile.rollNumber),
                  _buildProfileItem("Semester", profile.semester),
                  _buildProfileItem("Section", profile.section),
                  _buildProfileItem("DOB", profile.dob),
                  _buildProfileItem("Contact Number", profile.contactNumber),
                  _buildProfileItem("Address", profile.address),
                  _buildProfileItem("Father's Name", profile.fatherName),
                  _buildProfileItem("Mother's Name", profile.motherName),
                  _buildProfileItem(
                    "Parent Mobile",
                    profile.parentMobileNumber,
                  ),
                ],
              ),
            );
          } else if (state is ProfileError) {
            return Center(child: Text('Error to load profile'));
          }
          return const Center(child: Text("Press a button to load profile"));
        },
      ),
    );
  }
}
