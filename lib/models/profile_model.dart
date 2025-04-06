class UserProfile {
  final String fullName;
  final String contactNumber;
  final String rollNumber;
  final String semester;
  final String section;
  final String dob;
  final String address;
  final String fatherName;
  final String motherName;
  final String parentMobileNumber;
  final String collegeEmail;

  UserProfile({
    required this.fullName,
    required this.contactNumber,
    required this.rollNumber,
    required this.semester,
    required this.section,
    required this.dob,
    required this.address,
    required this.fatherName,
    required this.motherName,
    required this.parentMobileNumber,
    required this.collegeEmail,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      fullName:
          "${json['firstName']} ${json['middleName'] ?? ''} ${json['lastName'] ?? ''}"
              .trim(),
      contactNumber: json['smsMobileNumber'] ?? '',
      rollNumber: json['rollNumber'] ?? '',
      semester: json['semester'] ?? '',
      section: json['sectionName'] ?? '',
      dob: json['dob']?.split("T")[0] ?? '',
      address: json['address'] ?? '',
      fatherName: json['fatherName'] ?? '',
      motherName: json['motherName'] ?? '',
      parentMobileNumber: json['parentMobileNumber'] ?? '',
      collegeEmail: json['email'] ?? '',
    );
  }
}
