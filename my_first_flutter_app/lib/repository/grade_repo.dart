import 'package:postgres/postgres.dart';
import '../core/database/database_connection.dart';
import '../models/grade_model.dart';

class GradeRepository {
  Future<Connection> get _conn => DatabaseConnection.shared;

  /// All grades of one student, with the subject of each grade.
  Future<List<Grade>> getByStudent(int studentId) async {
    final conn = await _conn;
    final result = await conn.execute(
      Sql.named('''
        SELECT g.grade_id, g.enrollment_id,
               g.grade_value::float8 AS grade_value,
               g.remarks, g.date_recorded,
               e.student_id, sub.subject_code, sub.subject_name
        FROM grades g
        JOIN enrollment e ON e.enrollment_id = g.enrollment_id
        JOIN subject sub  ON sub.subject_id  = e.subject_id
        WHERE e.student_id = @student_id
        ORDER BY sub.subject_code
      '''),
      parameters: {'student_id': studentId},
    );
    return result.map((r) => Grade.fromMap(r.toColumnMap())).toList();
  }

  /// Enrollments of a student that can still be graded.
  Future<List<GradableEnrollment>> getGradableEnrollments(int studentId) async {
    final conn = await _conn;
    final result = await conn.execute(
      Sql.named('''
        SELECT e.enrollment_id, sub.subject_code, sub.subject_name
        FROM enrollment e
        JOIN subject sub ON sub.subject_id = e.subject_id
        WHERE e.student_id = @student_id
          AND e.status = 'Enrolled'
          AND NOT EXISTS (
            SELECT 1 FROM grades g WHERE g.enrollment_id = e.enrollment_id
          )
        ORDER BY sub.subject_code
      '''),
      parameters: {'student_id': studentId},
    );
    return result
        .map((r) => GradableEnrollment.fromMap(r.toColumnMap()))
        .toList();
  }

  Future<void> create(Grade g) async {
    final conn = await _conn;

    // Rule: an enrollment must exist before assigning a grade.
    final enrollment = await conn.execute(
      Sql.named('SELECT status FROM enrollment WHERE enrollment_id = @id'),
      parameters: {'id': g.enrollmentId},
    );
    if (enrollment.isEmpty) {
      throw Exception('Enrollment not found. A grade needs an existing enrollment.');
    }
    if (enrollment.first.toColumnMap()['status'] != 'Enrolled') {
      throw Exception('Cannot grade a subject the student has dropped.');
    }

    try {
      await conn.execute(
        Sql.named('''
          INSERT INTO grades (enrollment_id, grade_value, remarks)
          VALUES (@enrollment_id, CAST(@grade_value AS NUMERIC(5,2)), @remarks)
        '''),
        parameters: {
          'enrollment_id': g.enrollmentId,
          'grade_value': g.gradeValue.toStringAsFixed(2),
          'remarks': g.remarks,
        },
      );
    } on ServerException catch (e) {
      throw _friendly(e);
    }
  }

  Future<void> update(Grade g) async {
    final conn = await _conn;
    try {
      await conn.execute(
        Sql.named('''
          UPDATE grades SET
            grade_value = CAST(@grade_value AS NUMERIC(5,2)),
            remarks = @remarks,
            date_recorded = CURRENT_TIMESTAMP
          WHERE grade_id = @grade_id
        '''),
        parameters: {
          'grade_value': g.gradeValue.toStringAsFixed(2),
          'remarks': g.remarks,
          'grade_id': g.gradeId,
        },
      );
    } on ServerException catch (e) {
      throw _friendly(e);
    }
  }

  Future<void> delete(int gradeId) async {
    final conn = await _conn;
    await conn.execute(
      Sql.named('DELETE FROM grades WHERE grade_id = @id'),
      parameters: {'id': gradeId},
    );
  }

  Exception _friendly(ServerException e) {
    switch (e.code) {
      case '23505': // unique_violation
        return Exception('This enrollment already has a grade.');
      case '23503': // foreign_key_violation
        return Exception('Enrollment not found. A grade needs an existing enrollment.');
      case '23514': // check_violation
        return Exception('Grade must be between 0 and 100.');
      default:
        return Exception(e.message);
    }
  }
}