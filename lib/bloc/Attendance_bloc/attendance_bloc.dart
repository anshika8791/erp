import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/attendance_model.dart';
import '../../models/overall_attendance_model.dart';
import '../../repository/attendance_repo.dart';
import '../../screens/enums.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceRepo repo = AttendanceRepo();

  AttendanceBloc() : super(const AttendanceState()) {
    on<FetchInitialAttendanceEvent>(_onFetchInitial);
    on<FetchAttendanceForSemesterEvent>(_onFetchForSemester);
  }

  Future<void> _onFetchInitial(
    FetchInitialAttendanceEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(state.copyWith(status: attendanceStatus.loading));
    try {
      final semData = await repo.fetchSemestersAndLatestUserId();
      final semesterMap = semData['semesterUserMap'] as Map<int, int>;
      final latestSemId = semData['latestSemester'] as int;

      final result = await repo.fetchAttendanceByUserId(semesterMap[latestSemId]!);

      emit(state.copyWith(
        status: attendanceStatus.loaded,
        attendanceList: result['attendanceList'],
        overallAttendance: result['overall'],
        semesterUserMap: semesterMap,
        selectedSemesterId: latestSemId,
      ));
    } catch (e) {
      emit(state.copyWith(status: attendanceStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onFetchForSemester(
    FetchAttendanceForSemesterEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(state.copyWith(status: attendanceStatus.loading));
    try {
      final result = await repo.fetchAttendanceByUserId(event.userId);
      emit(state.copyWith(
        status: attendanceStatus.loaded,
        attendanceList: result['attendanceList'],
        overallAttendance: result['overall'],
        selectedSemesterId: event.semesterId,
      ));
    } catch (e) {
      emit(state.copyWith(status: attendanceStatus.error, errorMessage: e.toString()));
    }
  }
}
