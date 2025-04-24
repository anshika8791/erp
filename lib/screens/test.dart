import 'package:erp_app/bloc/final_attendance_Bloc/final_attendance_bloc.dart';
import 'package:erp_app/bloc/final_attendance_Bloc/final_attendance_event.dart';
import 'package:erp_app/bloc/final_attendance_Bloc/final_attendance_state.dart';
import 'package:erp_app/models/final_attendance_model.dart';
import 'package:erp_app/repository/final_attendance_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
//import '../blocs/attendance_bloc.dart';
import '../models/attendance_model.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  List<Map<String, String>> groupByDate(List<AttendanceEntry> entries, String subjectName) {
    final formatter = DateFormat('dd MMM yyyy');
    final Map<String, List<String>> dateToStatus = {};

    for (var e in entries.where((e) => e.subjectName == subjectName && e.absentDate != null)) {
      final date = formatter.format(DateTime.parse(e.absentDate!));
      final status = e.isAbsent ? 'A' : 'P';
      dateToStatus.putIfAbsent(date, () => []).add(status);
    }

    return dateToStatus.entries.map((e) {
      return {'date': e.key, 'status': e.value.join()};
    }).toList()
      ..sort((a, b) => formatter.parse(b['date']!).compareTo(formatter.parse(a['date']!)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AttendanceBloc(AttendanceRepository())..add(LoadSemestersAndAttendance()),
      child: Scaffold(
        appBar: AppBar(title: const Text("Subjects Attendance")),
        body: BlocBuilder<AttendanceBloc, AttendanceState>(
          builder: (context, state) {
            final bloc = context.read<AttendanceBloc>();
            final grouped = <String, List<AttendanceEntry>>{};

            for (var entry in state.attendance) {
              grouped.putIfAbsent(entry.subjectName, () => []).add(entry);
            }

            int total = state.attendance.length;
            int present = state.attendance.where((e) => !e.isAbsent).length;
            String percent = total > 0 ? (present / total * 100).toStringAsFixed(2) : "0.00";

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: DropdownButtonFormField<int>(
                    value: state.selectedSemesterId,
                    decoration: const InputDecoration(
                      labelText: "Select Semester",
                      border: OutlineInputBorder(),
                    ),
                    items: state.semesters
                        .map((sem) => DropdownMenuItem(
                              value: sem.id,
                              child: Text(sem.name),
                            ))
                        .toList(),
                    onChanged: (id) => bloc.add(ChangeSemester(id!)),
                  ),
                ),
                if (!state.isLoading)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("📊 Overall Attendance"),
                            const SizedBox(height: 8),
                            Text("Total Classes: $total"),
                            Text("Total Presents: $present"),
                            Text(
                              "Overall Percentage: $percent%",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: double.parse(percent) < 75 ? Colors.red : Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : grouped.isEmpty
                          ? const Center(child: Text("No subjects found."))
                          : ListView(
                              children: grouped.entries.map((e) {
                                final subject = e.key;
                                final entries = e.value;
                                final total = entries.length;
                                final present = entries.where((el) => !el.isAbsent).length;
                                final percent = total > 0
                                    ? (present / total * 100).toStringAsFixed(2)
                                    : "0.00";

                                final groupedByDate = groupByDate(state.attendance, subject);

                                return Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 2,
                                  child: ExpansionTile(
                                    title: Text(subject, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Text(
                                      "Present: $present / $total   ($percent%)",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: double.parse(percent) < 75 ? Colors.red : Colors.green,
                                      ),
                                    ),
                                    children: groupedByDate.isEmpty
                                        ? [const ListTile(title: Text("No attendance data."))]
                                        : groupedByDate.map((item) {
                                            final status = item['status']!;
                                            return ListTile(
                                              leading: Icon(
                                                status.contains('A')
                                                    ? Icons.cancel
                                                    : Icons.check_circle,
                                                color: status.contains('A') ? Colors.red : Colors.green,
                                              ),
                                              title: Text("${item['date']} - $status"),
                                            );
                                          }).toList(),
                                  ),
                                );
                              }).toList(),
                            ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
