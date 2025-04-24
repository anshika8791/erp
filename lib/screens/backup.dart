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

//   Map<String, Map<String, int>> subjectStats = {}; // { subjectName: { "total": x, "present": y } }
//   int overallTotal = 0;
//   int overallPresent = 0;

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
//         final List<Map<String, dynamic>> regularLectures =
//             List<Map<String, dynamic>>.from(data['attendanceData'] ?? []);
//         final List<Map<String, dynamic>> extraLectures =
//             List<Map<String, dynamic>>.from(data['extraLectures'] ?? []);

//         final Map<int, String> subjectIdToName = {};
//         for (var entry in regularLectures) {
//           int id = entry['subjectId'];
//           String name = entry['subjectName'] ?? 'Unknown Subject';
//           subjectIdToName[id] = name;
//         }

//         for (var entry in extraLectures) {
//           int id = entry['subjectId'];
//           if (entry['subjectName'] == null && subjectIdToName.containsKey(id)) {
//             entry['subjectName'] = subjectIdToName[id];
//           }
//         }

//         final combinedData = [...regularLectures, ...extraLectures];

//         final Set<String> uniqueSubjects = {};
//         subjectStats.clear();
//         overallTotal = 0;
//         overallPresent = 0;

//         for (var entry in combinedData) {
//           final subject = entry['subjectName'];
//           final isAbsent = entry['isAbsent'] == true;

//           if (subject == null) continue;

//           uniqueSubjects.add(subject);

//           subjectStats.putIfAbsent(subject, () => {"total": 0, "present": 0});
//           subjectStats[subject]!["total"] = subjectStats[subject]!["total"]! + 1;
//           if (!isAbsent) {
//             subjectStats[subject]!["present"] = subjectStats[subject]!["present"]! + 1;
//           }

//           overallTotal++;
//           if (!isAbsent) {
//             overallPresent++;
//           }
//         }

//         setState(() {
//           allAttendanceData = combinedData;
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

//   List<Map<String, String>> getGroupedAttendanceByDate(String subjectName) {
//     final DateFormat formatter = DateFormat('dd MMM yyyy');

//     final subjectData = allAttendanceData
//         .where((entry) =>
//             entry['subjectName'] == subjectName &&
//             entry['absentDate'] != null)
//         .toList();

//     final Map<String, List<String>> dateToStatusList = {};

//     for (var entry in subjectData) {
//       final date = formatter.format(DateTime.parse(entry['absentDate']));
//       final status = entry['isAbsent'] == true ? 'A' : 'P';

//       if (!dateToStatusList.containsKey(date)) {
//         dateToStatusList[date] = [];
//       }

//       dateToStatusList[date]!.add(status);
//     }

//     final groupedList = dateToStatusList.entries.map((entry) {
//       final combinedStatus = entry.value.join();
//       return {'date': entry.key, 'status': combinedStatus};
//     }).toList()
//       ..sort((a, b) => formatter.parse(b['date']!).compareTo(formatter.parse(a['date']!)));

//     return groupedList;
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
//                   String? accessToken =
//                       await secureStorage.read(key: 'accessToken');
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

//           // 🧾 Overall Summary
//           if (!isLoading && overallTotal > 0)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//               child: Card(
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 elevation: 2,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("📊 Overall Attendance", style: Theme.of(context).textTheme.titleMedium),
//                       const SizedBox(height: 8),
//                       Text("Total Classes: $overallTotal"),
//                       Text("Total Presents: $overallPresent"),
//                       Text(
//                         "Overall Percentage: ${(overallPresent / overallTotal * 100).toStringAsFixed(2)}%",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: (overallPresent / overallTotal * 100) < 75 ? Colors.red : Colors.green,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//           Expanded(
//   child: isLoading
//       ? const Center(child: CircularProgressIndicator())
//       : subjectNames.isEmpty
//           ? const Center(child: Text("No subjects found."))
//           : ListView.builder(
//               itemCount: subjectNames.length,
//               itemBuilder: (context, index) {
//                 final subject = subjectNames[index];
//                 final groupedDates = getGroupedAttendanceByDate(subject);

//                 final total = subjectStats[subject]?["total"] ?? 0;
//                 final present = subjectStats[subject]?["present"] ?? 0;
//                 final percent = total > 0
//                     ? (present / total * 100).toStringAsFixed(2)
//                     : "0.00";

//                 return Card(
//                   margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 2,
//                   child: ExpansionTile(
//                     title: Text(subject, style: const TextStyle(fontWeight: FontWeight.bold)),
//                     subtitle: Text(
//                       "Present: $present / $total   ($percent%)",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w500,
//                         color: double.parse(percent) < 75 ? Colors.red : Colors.green,
//                       ),
//                     ),
//                     children: groupedDates.isEmpty
//                         ? [
//                             const ListTile(
//                               title: Text("No attendance data."),
//                             ),
//                           ]
//                         : groupedDates.map((item) {
//                             final status = item['status'];
//                             return ListTile(
//                               leading: Icon(
//                                 status!.contains('A')
//                                     ? Icons.cancel
//                                     : Icons.check_circle,
//                                 color: status.contains('A') ? Colors.red : Colors.green,
//                               ),
//                               title: Text("${item['date']} - $status"),
//                             );
//                           }).toList(),
//                   ),
//                 );
//               },
//             ),
// ),

//         ],
//       ),
//     );
//   }
// }
