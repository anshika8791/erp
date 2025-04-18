// import 'package:erp_app/screens/enums.dart';
// import 'package:erp_app/screens/test.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../bloc/Attendance_bloc/attendance_bloc.dart';


// class AttendanceInfo extends StatefulWidget {
//   const AttendanceInfo({super.key});

//   @override
//   State<AttendanceInfo> createState() => _AttendanceInfoState();
// }

// class _AttendanceInfoState extends State<AttendanceInfo> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<AttendanceBloc>().add(FetchInitialAttendanceEvent());
//   }

//   @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(title: const Text('Attendance Info')),
//     body: BlocBuilder<AttendanceBloc, AttendanceState>(
//       builder: (context, state) {
//         if (state.status == attendanceStatus.loading) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (state.status == attendanceStatus.error) {
//           return Center(child: Text(state.errorMessage));
//         }

//         final overall = state.overallAttendance;

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Semester dropdown and test button
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: DropdownButton<int>(
//                       value: state.selectedSemesterId,
//                       isExpanded: true,
//                       items: state.semesterUserMap.keys.map((semId) {
//                         return DropdownMenuItem(
//                           value: semId,
//                           child: Text('Semester $semId'),
//                         );
//                       }).toList(),
//                       onChanged: (semId) {
//                         if (semId != null) {
//                           final userId = state.semesterUserMap[semId]!;
//                           context
//                               .read<AttendanceBloc>()
//                               .add(FetchAttendanceForSemesterEvent(semId, userId));
//                         }
//                       },
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const Test()),
//                       );
//                     },
//                     child: const Text('Check Datewise'),
//                   ),
//                 ],
//               ),
//             ),

//             // Overall attendance summary
//             if (overall != null)
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Overall Attendance: ${overall.percentage.toStringAsFixed(2)}%',
//                       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 4),
//                     Text('Total Classes: ${overall.totalClasses}', style: const TextStyle(fontSize: 16)),
//                     Text('Total Presents: ${overall.totalPresents}', style: const TextStyle(fontSize: 16)),
//                   ],
//                 ),
//               ),

//             const Divider(),

//             // Subject-wise attendance list
//             Expanded(
//               child: ListView.builder(
//                 itemCount: state.attendanceList.length,
//                 itemBuilder: (context, index) {
//                   final att = state.attendanceList[index];
//                   return ListTile(
//                     title: Text(att.name ?? ''),
//                     subtitle: Text(
//                       'Attendance: ${att.percentageAttendance?.toStringAsFixed(2)}% '
//                       '(${att.presentLeactures} / ${att.totalLeactures})',
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     ),
//   );
// }

// }