import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/attendance_model.dart';
import '../models/overall_attendance_model.dart';

class AttendanceRepo {
  final _secureStorage = FlutterSecureStorage();

  Future<Map<String, dynamic>> fetchSemestersAndLatestUserId() async {
    String? accessToken = await _secureStorage.read(key: 'accessToken');
    String? sessionId = await _secureStorage.read(key: 'sessionId');
    String? userId = await _secureStorage.read(key: 'xUserId');
    String? xToken = await _secureStorage.read(key: 'xToken');

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'X-Wb': '1',
      'Sessionid': sessionId!,
      'X-Contextid': '194',
      'X-Userid': userId!,
      'X_token': xToken!,
      'X-Rx': '1',
    };

    final url = 'https://erp.akgec.ac.in/api/SubjectAttendance?userFromClient=0&userId=$userId';
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      Map<int, int> semesterUserMap = {};

      for (var user in jsonData) {
        int semesterId = user['semester'];
        int userId = user['userId'];
        semesterUserMap[semesterId] = userId;
      }

      final latestSemId = semesterUserMap.keys.reduce((a, b) => a > b ? a : b);
      return {
        'semesterUserMap': semesterUserMap,
        'latestSemester': latestSemId,
      };
    } else {
      throw Exception('Failed to fetch semester-user data');
    }
  }

  Future<Map<String, dynamic>> fetchAttendanceByUserId(int userId) async {
    String? accessToken = await _secureStorage.read(key: 'accessToken');
    String? sessionId = await _secureStorage.read(key: 'sessionId');
    String? xUserId = await _secureStorage.read(key: 'xUserId');
    String? xToken = await _secureStorage.read(key: 'xToken');

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'X-Wb': '1',
      'Sessionid': sessionId!,
      'X-Contextid': '194',
      'X-Userid': xUserId!,
      'X_token': xToken!,
      'X-Rx': '1',
    };

    final attendanceUrl =
        'https://akgecerp.edumarshal.com/api/SubjectAttendance/GetPresentAbsentStudent?isDateWise=false&termId=0&userId=$userId&y=0';

    final response = await http.get(Uri.parse(attendanceUrl), headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final rawData = data['stdSubAtdDetails']['studentSubjectAttendance'][0];
      final subjects = rawData['subjects'];

      final percentage = rawData['studentPercentage'] is String
          ? double.tryParse(rawData['studentPercentage']) ?? 0.0
          : (rawData['studentPercentage']?.toDouble() ?? 0.0);

      final total = rawData['studentTotalAttendance'] is String
          ? int.tryParse(rawData['studentTotalAttendance']) ?? 0
          : (rawData['studentTotalAttendance']?.toInt() ?? 0);

      final present = rawData['studentPresentAttendance'] is String
          ? int.tryParse(rawData['studentPresentAttendance']) ?? 0
          : (rawData['studentPresentAttendance']?.toInt() ?? 0);

      return {
        'attendanceList': List<AttendanceModel>.from(subjects.map((e) => AttendanceModel.fromJson(e))),
        'overall': OverallAttendance(
          percentage: percentage,
          totalClasses: total,
          totalPresents: present,
        ),
      };
    } else {
      throw Exception('Failed to fetch attendance data');
    }
  }
}
