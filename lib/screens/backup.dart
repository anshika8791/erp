// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:intl/intl.dart';

// class Test extends StatefulWidget {
//   const Test({super.key});

//   @override
//   State<Test> createState() => _TestState();
// }

// class _TestState extends State<Test> {
//   final secureStorage = FlutterSecureStorage();
//   bool isLoading = true;

//   List<Map<String, dynamic>> allAttendanceData = [];
//   List<String> subjectNames = [];

//   List<Map<String, dynamic>> semesters = [];
//   Map<int, int> semesterUserIds = {};
//   int selectedTermId = 1;

//   @override
//   void initState() {
//     super.initState();
//     fetchSemestersAndAttendance();
//   }

//   Future<void> fetchSemestersAndAttendance() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       String? accessToken = await secureStorage.read(key: 'accessToken');
//       String? sessionId = await secureStorage.read(key: 'sessionId');
//       String? userId = await secureStorage.read(key: 'xUserId');
//       String? xToken = await secureStorage.read(key: 'xToken');

//       final headers = {
//         'Authorization': 'Bearer $accessToken',
//         'X-Wb': '1',
//         'Sessionid': sessionId!,
//         'X-Contextid': '194',
//         'X-Userid': userId!,
//         'X_token': xToken!,
//         'X-Rx': '1',
//       };

//       final testUrl =

//           'https://erp.akgec.ac.in/api/SubjectAttendance?userFromClient=0&userId=$userId';
//       final testResponse = await http.get(Uri.parse(testUrl), headers: headers);

//       if (testResponse.statusCode == 200) {
//         final List<dynamic> jsonData = json.decode(testResponse.body);
//         final List<Map<String, dynamic>> userList =
//             List<Map<String, dynamic>>.from(jsonData);

//         final Set<int> uniqueSemesterIds = {};
//         final List<Map<String, dynamic>> dynamicSemesters = [];

//         for (var item in userList) {
//           int semester = item['semester'];
//           int userIdFromApi = item['userId'];

//           if (!uniqueSemesterIds.contains(semester)) {
//             uniqueSemesterIds.add(semester);
//             dynamicSemesters.add({
//               'id': semester,
//               'name': 'Semester $semester',
//             });
//             semesterUserIds[semester] = userIdFromApi;
//           }
//         }

//         if (dynamicSemesters.isNotEmpty) {
//           dynamicSemesters.sort((a, b) => b['id'].compareTo(a['id']));
//           selectedTermId = dynamicSemesters.first['id'];
//         }

//         setState(() {
//           semesters = dynamicSemesters;
//         });

//         await fetchAttendanceData(headers);
//       }
//     } catch (e) {
//       print("🔥 Error fetching data: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> fetchAttendanceData(Map<String, String> headers) async {
//     try {
//       final actualUserId = semesterUserIds[selectedTermId]?.toString() ?? '';
//       final attendanceUrl =
//           'https://akgecerp.edumarshal.com/api/SubjectAttendance/GetPresentAbsentStudent?isDateWise=false&termId=0&userId=$actualUserId&y=0';
//       final attendanceResponse = await http.get(
//         Uri.parse(attendanceUrl),
//         headers: headers,
//       );

//       if (attendanceResponse.statusCode == 200) {
//         final data = json.decode(attendanceResponse.body);
//         final attendanceData = List<Map<String, dynamic>>.from(
//           data['attendanceData'],
//         );

//         final Set<String> uniqueSubjects = {};

//         for (var entry in attendanceData) {
//           final subjectName = entry['subjectName'] ?? 'Unknown Subject';
//           uniqueSubjects.add(subjectName);
//         }

//         setState(() {
//           allAttendanceData = attendanceData;
//           subjectNames = uniqueSubjects.toList();
//           isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load attendance');
//       }
//     } catch (e) {
//       print("🔥 Error fetching attendance: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   List<Map<String, String>> getDateStatusListForSubject(String subjectName) {
//     final DateFormat formatter = DateFormat('dd MMM yyyy');

//     final subjectData = allAttendanceData
//         .where((entry) => entry['subjectName'] == subjectName && entry['absentDate'] != null)
//         .toList();

//     final List<Map<String, String>> dateStatusList = subjectData.map((entry) {
//       final date = formatter.format(DateTime.parse(entry['absentDate']));
//       final status = entry['isAbsent'] == true ? 'Absent' : 'Present';
//       return {'date': date, 'status': status};
//     }).toList()
//       ..sort((a, b) => formatter.parse(b['date']!).compareTo(formatter.parse(a['date']!)));

//     return dateStatusList;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Subjects Attendance")),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: DropdownButtonFormField<int>(
//               value: selectedTermId,
//               decoration: const InputDecoration(
//                 labelText: "Select Semester",
//                 border: OutlineInputBorder(),
//               ),
//               items: semesters
//                   .map((sem) => DropdownMenuItem<int>(
//                         value: sem['id'],
//                         child: Text(sem['name']),
//                       ))
//                   .toList(),
//               onChanged: (value) async {
//                 if (value != null) {
//                   setState(() {
//                     selectedTermId = value;
//                     isLoading = true;
//                   });
//                   String? accessToken = await secureStorage.read(key: 'accessToken');
//                   String? sessionId = await secureStorage.read(key: 'sessionId');
//                   String? userId = await secureStorage.read(key: 'xUserId');
//                   String? xToken = await secureStorage.read(key: 'xToken');

//                   final headers = {
//                     'Authorization': 'Bearer $accessToken',
//                     'X-Wb': '1',
//                     'Sessionid': sessionId!,
//                     'X-Contextid': '194',
//                     'X-Userid': userId!,
//                     'X_token': xToken!,
//                     'X-Rx': '1',
//                   };

//                   await fetchAttendanceData(headers);
//                 }
//               },
//             ),
//           ),
//           Expanded(
//             child: isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : subjectNames.isEmpty
//                     ? const Center(child: Text("No subjects found."))
//                     : ListView.builder(
//                         itemCount: subjectNames.length,
//                         itemBuilder: (context, index) {
//                           final subject = subjectNames[index];
//                           final dateStatusList = getDateStatusListForSubject(subject);

//                           return ExpansionTile(
//                             title: Text(subject),
//                             children: dateStatusList.isEmpty
//                                 ? [
//                                     const ListTile(
//                                       title: Text("No attendance data."),
//                                     ),
//                                   ]
//                                 : dateStatusList.map((item) {
//                                     final status = item['status'];
//                                     return ListTile(
//                                       leading: Icon(
//                                         status == 'Absent'
//                                             ? Icons.cancel
//                                             : Icons.check_circle,
//                                         color: status == 'Absent' ? Colors.red : Colors.green,
//                                       ),
//                                       title: Text("${item['date']} - $status"),
//                                     );
//                                   }).toList(),
//                           );
//                         },
//                       ),
//           ),
//         ],
//       ),
//     );
//   }
// }
