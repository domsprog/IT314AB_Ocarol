import 'package:postgres/postgres.dart';
import '../core/database/database_connection.dart';
import '../models/schedule_model.dart';

class ScheduleRepository {
  Future<Connection> get _conn => DatabaseConnection.shared;

  static const _enrolledCount = '''
    (SELECT COUNT(*) FROM enrollment e
      WHERE e.schedule_id = sc.schedule_id
        AND e.status = 'Enrolled')::int AS enrolled_count
  ''';

  /// All schedules with their subject (for the Schedule screen).
  Future<List<Schedule>> getAll() async {
    final conn = await _conn;
    final result = await conn.execute('''
      SELECT sc.schedule_id, sc.subject_id, sub.subject_code, sub.subject_name,
             sc.day_of_week, sc.start_time::text AS start_time,
             sc.end_time::text AS end_time, sc.room, sc.slot_capacity,
             $_enrolledCount
      FROM schedule sc
      JOIN subject sub ON sub.subject_id = sc.subject_id
      ORDER BY sub.subject_code, sc.day_of_week, sc.start_time
    ''');
    return result.map((r) => Schedule.fromMap(r.toColumnMap())).toList();
  }

  /// Schedules of one subject (used by the Enrollment screen).
  Future<List<Schedule>> getBySubject(int subjectId) async {
    final conn = await _conn;
    final result = await conn.execute(
      Sql.named('''
        SELECT sc.schedule_id, sc.subject_id, sc.day_of_week,
               sc.start_time::text AS start_time,
               sc.end_time::text   AS end_time,
               sc.room, sc.slot_capacity,
               $_enrolledCount
        FROM schedule sc
        WHERE sc.subject_id = @subject_id
        ORDER BY sc.start_time
      '''),
      parameters: {'subject_id': subjectId},
    );
    return result.map((r) => Schedule.fromMap(r.toColumnMap())).toList();
  }

  Future<void> create(Schedule s) async {
    final conn = await _conn;
    try {
      await conn.execute(
        Sql.named('''
          INSERT INTO schedule
            (subject_id, day_of_week, start_time, end_time, room, slot_capacity)
          VALUES
            (@subject_id, @day_of_week, CAST(@start_time AS TIME),
             CAST(@end_time AS TIME), @room, @slot_capacity)
        '''),
        parameters: {
          'subject_id': s.subjectId,
          'day_of_week': s.dayOfWeek,
          'start_time': s.startTime,
          'end_time': s.endTime,
          'room': s.room,
          'slot_capacity': s.slotCapacity,
        },
      );
    } on ServerException catch (e) {
      throw _friendly(e);
    }
  }

  /// The subject of an existing schedule can't be changed, because students
  /// may already be enrolled under it.
  Future<void> update(Schedule s) async {
    final conn = await _conn;

    final count = await conn.execute(
      Sql.named(
        "SELECT COUNT(*)::int AS n FROM enrollment "
        "WHERE schedule_id = @id AND status = 'Enrolled'",
      ),
      parameters: {'id': s.scheduleId},
    );
    final enrolled = count.first.toColumnMap()['n'] as int;
    if (s.slotCapacity < enrolled) {
      throw Exception(
        'Capacity cannot be lower than the $enrolled student(s) already enrolled.',
      );
    }

    try {
      await conn.execute(
        Sql.named('''
          UPDATE schedule SET
            day_of_week = @day_of_week,
            start_time = CAST(@start_time AS TIME),
            end_time = CAST(@end_time AS TIME),
            room = @room,
            slot_capacity = @slot_capacity
          WHERE schedule_id = @schedule_id
        '''),
        parameters: {
          'day_of_week': s.dayOfWeek,
          'start_time': s.startTime,
          'end_time': s.endTime,
          'room': s.room,
          'slot_capacity': s.slotCapacity,
          'schedule_id': s.scheduleId,
        },
      );
    } on ServerException catch (e) {
      throw _friendly(e);
    }
  }

  Future<void> delete(int scheduleId) async {
    final conn = await _conn;
    try {
      await conn.execute(
        Sql.named('DELETE FROM schedule WHERE schedule_id = @id'),
        parameters: {'id': scheduleId},
      );
    } on ServerException catch (e) {
      throw _friendly(e);
    }
  }

  Exception _friendly(ServerException e) {
    switch (e.code) {
      case '23503': // foreign_key_violation
        return Exception(
          'Cannot delete: students are enrolled (or were enrolled) in this schedule.',
        );
      case '23514': // check_violation
        return Exception(
          'End time must be after start time, and capacity must be above 0.',
        );
      default:
        return Exception(e.message);
    }
  }
}