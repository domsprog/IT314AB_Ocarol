import 'package:postgres/postgres.dart';
import '../core/database/database_connection.dart';
import '../models/enrollment_model.dart';


class EnrollmentException implements Exception {
  final String message;
  EnrollmentException(this.message);
  @override
  String toString() => message;
}

class EnrollmentRepository {
  Future<Connection> get _conn => DatabaseConnection.shared;

  Future<List<Enrollment>> getByStudent(int studentId) async {
    final conn = await _conn;
    final result = await conn.execute(
      Sql.named('''
        SELECT e.enrollment_id, e.student_id, e.subject_id, e.schedule_id,
               e.enrolled_at, e.status,
               s.subject_code, s.subject_name,
               sc.day_of_week, sc.start_time::text AS start_time,
               sc.end_time::text AS end_time, sc.room
        FROM enrollment e
        JOIN subject  s  ON s.subject_id   = e.subject_id
        JOIN schedule sc ON sc.schedule_id = e.schedule_id
        WHERE e.student_id = @student_id
        ORDER BY e.enrolled_at DESC
      '''),
      parameters: {'student_id': studentId},
    );
    return result.map((r) => Enrollment.fromMap(r.toColumnMap())).toList();
  }

  Future<void> enroll({
    required int studentId,
    required int subjectId,
    required int scheduleId,
  }) async {
    final conn = await _conn;
    try {
      await conn.runTx((tx) async {
        
        final sched = await tx.execute(
          Sql.named(
            'SELECT subject_id, slot_capacity FROM schedule '
            'WHERE schedule_id = @id FOR UPDATE',
          ),
          parameters: {'id': scheduleId},
        );
        if (sched.isEmpty) throw EnrollmentException('Schedule not found.');
        final sc = sched.first.toColumnMap();

        if (sc['subject_id'] != subjectId) {
          throw EnrollmentException(
            'That schedule does not belong to the selected subject.',
          );
        }

        final taken = await tx.execute(
          Sql.named(
            "SELECT COUNT(*)::int AS n FROM enrollment "
            "WHERE schedule_id = @id AND status = 'Enrolled'",
          ),
          parameters: {'id': scheduleId},
        );
        if ((taken.first.toColumnMap()['n'] as int) >=
            (sc['slot_capacity'] as int)) {
          throw EnrollmentException('No slots left for this schedule.');
        }

        final existing = await tx.execute(
          Sql.named(
            'SELECT enrollment_id, status FROM enrollment '
            'WHERE student_id = @student AND subject_id = @subject',
          ),
          parameters: {'student': studentId, 'subject': subjectId},
        );
        if (existing.isNotEmpty &&
            existing.first.toColumnMap()['status'] == 'Enrolled') {
          throw EnrollmentException(
            'This student is already enrolled in that subject.',
          );
        }

        final conflict = await tx.execute(
          Sql.named('''
            SELECT sub.subject_code, sc2.day_of_week,
                   sc2.start_time::text AS start_time,
                   sc2.end_time::text   AS end_time
            FROM enrollment e
            JOIN schedule sc2 ON sc2.schedule_id = e.schedule_id
            JOIN subject  sub ON sub.subject_id  = e.subject_id
            JOIN schedule target ON target.schedule_id = @schedule
            WHERE e.student_id = @student
              AND e.status = 'Enrolled'
              AND sc2.day_of_week = target.day_of_week
              AND sc2.start_time < target.end_time
              AND sc2.end_time   > target.start_time
            LIMIT 1
          '''),
          parameters: {'student': studentId, 'schedule': scheduleId},
        );
        if (conflict.isNotEmpty) {
          final c = conflict.first.toColumnMap();
          String hm(String t) => t.substring(0, 5);
          throw EnrollmentException(
            'Schedule conflict with ${c['subject_code']} '
            '(${c['day_of_week']} ${hm(c['start_time'] as String)}'
            '-${hm(c['end_time'] as String)}).',
          );
        }

        if (existing.isEmpty) {
          await tx.execute(
            Sql.named(
              'INSERT INTO enrollment (student_id, subject_id, schedule_id) '
              'VALUES (@student, @subject, @schedule)',
            ),
            parameters: {
              'student': studentId,
              'subject': subjectId,
              'schedule': scheduleId,
            },
          );
        } else {

          await tx.execute(
            Sql.named(
              "UPDATE enrollment SET status = 'Enrolled', "
              'schedule_id = @schedule, enrolled_at = CURRENT_TIMESTAMP '
              'WHERE enrollment_id = @id',
            ),
            parameters: {
              'schedule': scheduleId,
              'id': existing.first.toColumnMap()['enrollment_id'],
            },
          );
        }
      });
    } on ServerException catch (e) {
      if (e.code == '23505') {
        throw EnrollmentException(
          'This student is already enrolled in that subject.',
        );
      }
      rethrow;
    }
  }

  Future<void> drop(int enrollmentId) async {
    final conn = await _conn;
    await conn.execute(
      Sql.named(
        "UPDATE enrollment SET status = 'Dropped' WHERE enrollment_id = @id",
      ),
      parameters: {'id': enrollmentId},
    );
  }
}