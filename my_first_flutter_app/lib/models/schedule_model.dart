class Schedule {
  final int? scheduleId;
  final int subjectId;
  final String? subjectCode; //ma sudlan rani kung ma load na ang mga subject
  final String? subjectName;
  final String dayOfWeek;
  final String startTime; // "08:00" or "08:00:00"
  final String endTime;
  final String room;
  final int slotCapacity;
  final int enrolledCount; //Ang naka enroll sa kani nga shecdule

  const Schedule({
    this.scheduleId,
    required this.subjectId,
    this.subjectCode,
    this.subjectName,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.slotCapacity,
    this.enrolledCount = 0,
  });

  // kuha sa remaing slots sa subject
  int getSlotsLeft() {
    return slotCapacity - enrolledCount;
  }

  // Check kung full naba ang schedule
  bool isFull() {
    if (getSlotsLeft() <= 0) {
      return true;
    } else {
      return false;
    }
  }

  // Format sa time
  String getTimeRange() {
    String start = formatTime(startTime);
    String end = formatTime(endTime);

    return '$start - $end';
  }

  // Get kuha sa time pero hourse and mins ra
  static String formatTime(String time) {
    if (time.length >= 5) {
      return time.substring(0, 5);
    } else {
      return time;
    }
  }

  factory Schedule.fromMap(Map<String, dynamic> m) => Schedule(
    scheduleId: m['schedule_id'] as int,
    subjectId: m['subject_id'] as int,
    subjectCode: m['subject_code'] as String?,
    subjectName: m['subject_name'] as String?,
    dayOfWeek: m['day_of_week'] as String,
    startTime: m['start_time'] as String,
    endTime: m['end_time'] as String,
    room: m['room'] as String,
    slotCapacity: m['slot_capacity'] as int,
    enrolledCount: (m['enrolled_count'] as int?) ?? 0,
  );
}
