import 'package:erp_app/bloc/final_attendance_Bloc/final_attendance_bloc.dart';
import 'package:erp_app/bloc/final_attendance_Bloc/final_attendance_event.dart';
import 'package:erp_app/bloc/final_attendance_Bloc/final_attendance_state.dart';
import 'package:erp_app/models/final_attendance_model.dart';
import 'package:erp_app/repository/final_attendance_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:erp_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:erp_app/bloc/auth_bloc/auth_state.dart';
import 'package:erp_app/bloc/profile_bloc/profile_bloc.dart';
import 'package:erp_app/bloc/profile_bloc/profile_event.dart';
import 'package:erp_app/bloc/profile_bloc/profile_state.dart';
import 'package:erp_app/drawer/assignment_screen.dart';
import 'package:erp_app/drawer/calendar_screen.dart';
import 'package:erp_app/drawer/eidentity_screen.dart';
import 'package:erp_app/drawer/profile_screen.dart';
import 'package:erp_app/models/login_response.dart';
import 'package:erp_app/models/profile_model.dart';
import 'package:erp_app/repository/profile_repository.dart';
import 'package:erp_app/screens/home_screen.dart';
import 'package:erp_app/screens/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:erp_app/bloc/final_attendance_Bloc/final_attendance_bloc.dart';
import 'package:erp_app/bloc/final_attendance_Bloc/final_attendance_event.dart';
import 'package:erp_app/bloc/final_attendance_Bloc/final_attendance_state.dart';
import 'package:erp_app/screens/dashboard_screen.dart';
import 'package:erp_app/screens/att_calender.dart';
import 'package:erp_app/screens/splashwrapper.dart';
//import '../blocs/attendance_bloc.dart';
import '../models/attendance_model.dart';
import 'package:fl_chart/fl_chart.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  List<Map<String, String>> groupByDate(
    List<AttendanceEntry> entries,
    String subjectName,
  ) {
    final formatter = DateFormat('dd MMM yyyy');
    final Map<String, List<String>> dateToStatus = {};

    for (var e in entries.where(
      (e) => e.subjectName == subjectName && e.absentDate != null,
    )) {
      final date = formatter.format(DateTime.parse(e.absentDate!));
      final status = e.isAbsent ? 'A' : 'P';
      dateToStatus.putIfAbsent(date, () => []).add(status);
    }

    return dateToStatus.entries.map((e) {
        return {'date': e.key, 'status': e.value.join()};
      }).toList()
      ..sort(
        (a, b) =>
            formatter.parse(b['date']!).compareTo(formatter.parse(a['date']!)),
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              AttendanceBloc(AttendanceRepository())
                ..add(LoadSemestersAndAttendance()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Dashboard", style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF2C2C2C),
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
        ),
        backgroundColor: Colors.black26,
        drawer: _buildDrawer(context),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              UserProfile profile = state.profile;
              return BlocBuilder<AttendanceBloc, AttendanceState>(
                builder: (context, state) {
                  final bloc = context.read<AttendanceBloc>();
                  final grouped = <String, List<AttendanceEntry>>{};

                  for (var entry in state.attendance) {
                    grouped.putIfAbsent(entry.subjectName, () => []).add(entry);
                  }

                  int total = state.attendance.length;
                  int present =
                      state.attendance.where((e) => !e.isAbsent).length;
                  String percent =
                      total > 0
                          ? (present / total * 100).toStringAsFixed(2)
                          : "0.00";
                  int allowedMisses =
                      ((present / 0.75).ceil() - total)
                          .clamp(0, double.infinity)
                          .toInt();

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 16,
                      ), // prevent overflow on bottom
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Hello, ${profile.fullName}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        profile.collegeEmail,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14, // slightly reduced
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Theme(
                                  data: Theme.of(
                                    context,
                                  ).copyWith(canvasColor: Colors.grey[850]),
                                  child: SizedBox(
                                    width: 140, // adjusted to fit in one line
                                    child: DropdownButtonFormField<int>(
                                      value: state.selectedSemesterId,
                                      decoration: const InputDecoration(
                                        labelText: "Sem",
                                        border: OutlineInputBorder(),

                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical:
                                              8, // slightly smaller height
                                        ),
                                      ),

                                      items:
                                          state.semesters
                                              .map(
                                                (sem) => DropdownMenuItem(
                                                  value: sem.id,
                                                  child: Text(
                                                    sem.name,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                      onChanged:
                                          (id) => bloc.add(ChangeSemester(id!)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          if (!state.isLoading)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 15,
                                color: Color(0xFF2C2C2C),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 📊 Text info
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "📊 Overall Attendance",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              "Total Classes: $total",
                                              style: TextStyle(
                                                color: Colors.white70,
                                              ),
                                            ),
                                            Text(
                                              "Total Presents: $present",
                                              style: TextStyle(
                                                color: Colors.white70,
                                              ),
                                            ),
                                            Text(
                                              "Overall Percentage: $percent%",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    double.parse(percent) < 75
                                                        ? Colors.red
                                                        : Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      SizedBox(
                                        width: 120,
                                        height: 120,
                                        child: PieChart(
                                          PieChartData(
                                            sections: [
                                              PieChartSectionData(
                                                value: present.toDouble(),
                                                color: Colors.green,
                                                title:
                                                    '${((present / total) * 100).toStringAsFixed(1)}%',
                                                radius: 50,
                                                titleStyle: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              PieChartSectionData(
                                                value:
                                                    (total - present)
                                                        .toDouble(),
                                                color: Colors.red,
                                                title:
                                                    '${(((total - present) / total) * 100).toStringAsFixed(1)}%',
                                                radius: 50,
                                                titleStyle: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                            sectionsSpace: 2,
                                            centerSpaceRadius: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Your Statistics",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 1),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  // Orange Card
                                  SizedBox(
                                    width: 200,
                                    height: 200,
                                    child: Card(
                                      color: Colors.orange,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Spacer(),
                                            Image.asset(
                                              'assets/org.png',
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.contain,
                                            ),
                                            const SizedBox(height: 10),
                                            const Text(
                                              'Organization',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            const Text(
                                              'AKGEC, Ghaziabad',
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // Blue Card
                                  SizedBox(
                                    width: 200,
                                    height: 200,
                                    child: Card(
                                      color: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Spacer(),
                                            ClipOval(
                                              child: Image.asset(
                                                'assets/course1.jpg',
                                                height: 50,
                                                width: 50,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            const Text(
                                              'Course',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            const Text(
                                              'B.Tech.',
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // Green Card (New)
                                  SizedBox(
                                    width: 200,
                                    height: 200,
                                    child: Card(
                                      color: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Spacer(),
                                            Icon(
                                              Icons.check_circle,
                                              size: 50,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(height: 10),
                                            const Text(
                                              'Above 75% :)',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'You can miss\n$allowedMisses class${allowedMisses == 1 ? '' : 'es'}',
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "All Subjects",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          state.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : grouped.isEmpty
                              ? const Center(child: Text("No subjects found."))
                              : ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children:
                                    grouped.entries.map((e) {
                                      final subject = e.key;
                                      final entries = e.value;
                                      final total = entries.length;
                                      final present =
                                          entries
                                              .where((el) => !el.isAbsent)
                                              .length;
                                      final percent =
                                          total > 0
                                              ? (present / total * 100)
                                                  .toStringAsFixed(2)
                                              : "0.00";

                                      final groupedByDate = groupByDate(
                                        state.attendance,
                                        subject,
                                      );

                                      return Card(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        elevation: 15,
                                        color: Color(0xFF2C2C2C),
                                        child: ExpansionTile(
                                          title: Text(
                                            subject,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "Present: $present / $total   ($percent%)",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  double.parse(percent) < 75
                                                      ? Colors.red
                                                      : Colors.green,
                                            ),
                                          ),
                                          children: [
                                            ListTile(
                                              leading: Icon(
                                                Icons.calendar_today,
                                                color: Colors.white,
                                              ),
                                              title: Text(
                                                'View Attendance Calendar',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => AttendanceCalendarScreen(
                                                          subject: subject,
                                                          attendanceData:
                                                              state.attendance
                                                                  .map(
                                                                    (entry) => {
                                                                      'date':
                                                                          entry
                                                                              .absentDate,
                                                                      'status':
                                                                          entry.isAbsent
                                                                              ? 'Absent'
                                                                              : 'Present',
                                                                      'subject':
                                                                          entry
                                                                              .subjectName,
                                                                    },
                                                                  )
                                                                  .toList(),
                                                        ),
                                                  ),
                                                );
                                              },
                                            ),
                                            if (groupedByDate.isEmpty)
                                              const ListTile(
                                                title: Text(
                                                  "No attendance data.",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                            else
                                              ...groupedByDate.map((item) {
                                                final status = item['status']!;
                                                return ListTile(
                                                  leading: Icon(
                                                    status.contains('A')
                                                        ? Icons.cancel
                                                        : Icons.check_circle,
                                                    color:
                                                        status.contains('A')
                                                            ? Colors.red
                                                            : Colors.green,
                                                  ),
                                                  title: Text(
                                                    "${item['date']} - $status",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                              ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

Drawer _buildDrawer(BuildContext context) {
  return Drawer(
    child: Container(
      color: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey, Colors.black54],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const DrawerHeader(
              decoration: BoxDecoration(color: Colors.transparent),

              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
          ),

          _drawerItem(context, 'Profile', Icons.person, () {
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
          _drawerItem(context, 'Assignment', Icons.assignment, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AssignmentScreen()),
            );
          }),

          _drawerItem(context, 'E-Identity', Icons.badge, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EIdentityScreen()),
            );
          }),
          _drawerItem(context, 'Calendar', Icons.calendar_month, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CalendarScreen()),
            );
          }),
          _drawerItem(context, 'Sign Out', Icons.logout, () async {
            final storage = FlutterSecureStorage();

            // Delete the stored session and authentication data
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
    ),
  );
}

ListTile _drawerItem(
  BuildContext context,
  String title,
  IconData icon,
  VoidCallback onTap,
) {
  return ListTile(
    leading: Icon(icon, color: Colors.white),
    title: Text(title, style: TextStyle(color: Colors.white)),
    onTap: () {
      Navigator.pop(context);
      onTap();
    },
  );
}
