class Student {
  final int? studentId;
  final String studentNumber;
  final String firstName;
  final String lastName;
  final String email;
  final String course;
  final int yearLevel;
  final String? contactNumber;
  final DateTime? createdAt;

  const Student({
    this.studentId,
    required this.studentNumber,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.course,
    required this.yearLevel,
    this.contactNumber,
    this.createdAt,
  });

  String get fullName => '$firstName $lastName';

  factory Student.fromMap(Map<String, dynamic> m) => Student(
    studentId: m['student_id'] as int,
    studentNumber: m['student_number'] as String,
    firstName: m['first_name'] as String,
    lastName: m['last_name'] as String,
    email: m['email'] as String,
    course: m['course'] as String,
    yearLevel: m['year_level'] as int,
    contactNumber: m['contact_number'] as String?,
    createdAt: m['created_at'] as DateTime?,
  );

  Map<String, dynamic> toMap() => {
    'student_number': studentNumber,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'course': course,
    'year_level': yearLevel,
    'contact_number': contactNumber,
  };
  //Ang copywith nga method kay mo update rasa specific nga field sa students
  //niya dili na mo balik ug enter sa info
  copyWith({
    int? studentId,
    String? studentNumber,
    String? firstName,
    String? lastName,
    String? email,
    String? course,
    int? yearLevel,
    String? contactNumber,
    DateTime? createdAt,
  }) {
    return Student(
      studentId: studentId ?? this.studentId,
      studentNumber: studentNumber ?? this.studentNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      course: course ?? this.course,
      yearLevel: yearLevel ?? this.yearLevel,
      contactNumber: contactNumber ?? this.contactNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
