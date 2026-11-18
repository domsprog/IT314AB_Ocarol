class Enrollment {
  final int enrollmentId;
  final int studentId;
  final int subjectId;
  final int scheduleId;
  final DateTime? enrolledAt;
  final String status; // 'Enrolled' or 'Dropped'
  final String subjectCode;
  final String subjectName;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final String room;

  const Enrollment({
    required this.enrollmentId,
    required this.studentId,
    required this.subjectId,
    required this.scheduleId,
    this.enrolledAt,
    required this.status,
    required this.subjectCode,
    required this.subjectName,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.room,
  });

  bool get isEnrolled => status == 'Enrolled';

  String get timeRange {
    String start = startTime;
    String end = endTime;

    if (start.length >= 5) {
      start = start.substring(0, 5);
    }

    if (end.length >= 5) {
      end = end.substring(0, 5);
    }

    return '$start - $end';
  }

  factory Enrollment.fromMap(Map<String, dynamic> m) => Enrollment(
    enrollmentId: m['enrollment_id'] as int,
    studentId: m['student_id'] as int,
    subjectId: m['subject_id'] as int,
    scheduleId: m['schedule_id'] as int,
    enrolledAt: m['enrolled_at'] as DateTime?,
    status: m['status'] as String,
    subjectCode: m['subject_code'] as String,
    subjectName: m['subject_name'] as String,
    dayOfWeek: m['day_of_week'] as String,
    startTime: m['start_time'] as String,
    endTime: m['end_time'] as String,
    room: m['room'] as String,
  );
}
