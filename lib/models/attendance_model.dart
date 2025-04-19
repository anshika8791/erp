class AttendanceModel {
  String? name;
  int? totalLeactures;
  int? presentLeactures;
  int? absentLeactures;
  double? percentageAttendance;

  AttendanceModel({
    this.name,
    this.totalLeactures,
    this.presentLeactures,
    this.absentLeactures,
    this.percentageAttendance,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      name: json['name'],
      totalLeactures: json['totalLeactures'],
      presentLeactures: json['presentLeactures'],
      absentLeactures: json['absentLeactures'],
      percentageAttendance: json['percentageAttendance']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'totalLeactures': totalLeactures,
      'presentLeactures': presentLeactures,
      'absentLeactures': absentLeactures,
      'percentageAttendance': percentageAttendance,
    };
  }
}
