// class OverallAttendance {
//   final double percentage;
//   final int totalClasses;
//   final int totalPresents;

//   OverallAttendance({
//     required this.percentage,
//     required this.totalClasses,
//     required this.totalPresents,
//   });

//   factory OverallAttendance.fromJson(Map<String, dynamic> json) {
//     return OverallAttendance(
//       percentage: double.tryParse(json['studentPercentage'].toString()) ?? 0.0,
//       totalClasses: int.tryParse(json['studentTotalAttendance'].toString()) ?? 0,
//       totalPresents: int.tryParse(json['studentPresentAttendance'].toString()) ?? 0,
//     );
//   }
// }
