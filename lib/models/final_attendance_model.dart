class AttendanceEntry {
  final String subjectName;
  final bool isAbsent;
  final String? absentDate;

  AttendanceEntry({
    required this.subjectName,
    required this.isAbsent,
    this.absentDate,
  });

  factory AttendanceEntry.fromJson(Map<String, dynamic> json) {
    return AttendanceEntry(
      subjectName: json['subjectName'] ?? 'Unknown Subject',
      isAbsent: json['isAbsent'] == true,
      absentDate: json['absentDate'],
    );
  }
}
