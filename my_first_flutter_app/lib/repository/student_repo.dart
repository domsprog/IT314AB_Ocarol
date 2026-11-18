import 'package:postgres/postgres.dart';
import '../core/database/database_connection.dart';
import '../models/student_model.dart';

class StudentRepository {
  Future<List<Student>> getAll() async {
    final conn = await DatabaseConnection.shared;
    final result = await conn.execute(
      'SELECT * FROM student ORDER BY last_name, first_name',
    );
    return result.map((r) => Student.fromMap(r.toColumnMap())).toList();
  }

  Future<void> create(Student s) async {
    final conn = await DatabaseConnection.shared;
    try {
      await conn.execute(
        Sql.named('''
          INSERT INTO student
            (student_number, first_name, last_name, email, course, year_level, contact_number)
          VALUES
            (@student_number, @first_name, @last_name, @email, @course, @year_level, @contact_number)
        '''),
        parameters: s.toMap(),
      );
    } on ServerException catch (e) {
      throw _friendly(e);
    }
  }

  Future<void> update(Student s) async {
    final conn = await DatabaseConnection.shared;
    try {
      await conn.execute(
        Sql.named('''
          UPDATE student SET
            student_number = @student_number, first_name = @first_name,
            last_name = @last_name, email = @email, course = @course,
            year_level = @year_level, contact_number = @contact_number
          WHERE student_id = @student_id
        '''),
        parameters: {...s.toMap(), 'student_id': s.studentId},
      );
    } on ServerException catch (e) {
      throw _friendly(e);
    }
  }

  Future<void> delete(int studentId) async {
    final conn = await DatabaseConnection.shared;
    try {
      await conn.execute(
        Sql.named('DELETE FROM student WHERE student_id = @id'),
        parameters: {'id': studentId},
      );
    } on ServerException catch (e) {
      throw _friendly(e);
    }
  }

  /// Turns Postgres error codes into messages a user can read.
  Exception _friendly(ServerException e) {
    switch (e.code) {
      case '23505': // unique_violation
        return Exception('That student number or email already exists.');
      case '23503': // foreign_key_violation
        return Exception('Cannot delete: this student has enrollments.');
      case '23514': // check_violation
        return Exception('A value is out of the allowed range.');
      default:
        return Exception(e.message);
    }
  }
}