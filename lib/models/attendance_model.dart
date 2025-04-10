class SubjectAttendance {
  final String subjectName;
  final int lecture;
  final int present;
  final double percentage;

  SubjectAttendance({
    required this.subjectName,
    required this.lecture,
    required this.present,
    required this.percentage,
  });

  factory SubjectAttendance.fromJson(Map<String, dynamic> json) {
    return SubjectAttendance(
      subjectName: json['SubjectName'],
      lecture: json['Lecture'],
      present: json['Present'],
      percentage: (json['Percentage'] as num).toDouble(),
    );
  }
}
