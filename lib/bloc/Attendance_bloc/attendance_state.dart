part of 'attendance_bloc.dart';

class AttendanceState extends Equatable {
  final attendanceStatus status;
  final String errorMessage;
  final List<AttendanceModel> attendanceList;
  final Map<int, int> semesterUserMap;
  final int? selectedSemesterId;
  final OverallAttendance? overallAttendance;

  const AttendanceState({
    this.status = attendanceStatus.loading,
    this.errorMessage = '',
    this.attendanceList = const [],
    this.semesterUserMap = const {},
    this.selectedSemesterId,
    this.overallAttendance,
  });

  AttendanceState copyWith({
    attendanceStatus? status,
    String? errorMessage,
    List<AttendanceModel>? attendanceList,
    Map<int, int>? semesterUserMap,
    int? selectedSemesterId,
    OverallAttendance? overallAttendance,
  }) {
    return AttendanceState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      attendanceList: attendanceList ?? this.attendanceList,
      semesterUserMap: semesterUserMap ?? this.semesterUserMap,
      selectedSemesterId: selectedSemesterId ?? this.selectedSemesterId,
      overallAttendance: overallAttendance ?? this.overallAttendance,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, attendanceList, semesterUserMap, selectedSemesterId, overallAttendance];
}
