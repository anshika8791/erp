
abstract class AttendanceEvent {}

class LoadSemestersAndAttendance extends AttendanceEvent {}

class ChangeSemester extends AttendanceEvent {
  final int semesterId;
  ChangeSemester(this.semesterId);
}