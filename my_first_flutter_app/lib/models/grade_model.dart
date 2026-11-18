class Grade {
  static const double passingGrade = 75; // change this if your school differs

  final int? gradeId;
  final int enrollmentId;
  final double gradeValue;
  final String? remarks;
  final DateTime? dateRecorded;

  // Filled in when the grade is loaded together with its enrollment
  final int? studentId;
  final String? subjectCode;
  final String? subjectName;

  const Grade({
    this.gradeId,
    required this.enrollmentId,
    required this.gradeValue,
    this.remarks,
    this.dateRecorded,
    this.studentId,
    this.subjectCode,
    this.subjectName,
  });

  // Check kung pasado ang grade
  bool isPassing() {
    if (gradeValue >= passingGrade) {
      return true;
    } else {
      return false;
    }
  }

  // Remarks nga gamiton kung wala gi-type ang user
  static String autoRemarks(double value) =>
      value >= passingGrade ? 'Passed' : 'Failed';

  factory Grade.fromMap(Map<String, dynamic> m) => Grade(
    gradeId: m['grade_id'] as int,
    enrollmentId: m['enrollment_id'] as int,
    gradeValue: (m['grade_value'] as num).toDouble(),
    remarks: m['remarks'] as String?,
    dateRecorded: m['date_recorded'] as DateTime?,
    studentId: m['student_id'] as int?,
    subjectCode: m['subject_code'] as String?,
    subjectName: m['subject_name'] as String?,
  );
}

class GradableEnrollment {
  final int enrollmentId;
  final String subjectCode;
  final String subjectName;

  const GradableEnrollment({
    required this.enrollmentId,
    required this.subjectCode,
    required this.subjectName,
  });

  String getLabel() => '$subjectCode - $subjectName';

  factory GradableEnrollment.fromMap(Map<String, dynamic> m) =>
      GradableEnrollment(
        enrollmentId: m['enrollment_id'] as int,
        subjectCode: m['subject_code'] as String,
        subjectName: m['subject_name'] as String,
      );
}
