import 'package:postgres/postgres.dart';
import '../core/database/database_connection.dart';
import '../models/subject_model.dart';

class SubjectRepository {
  Future<Connection> get _conn => DatabaseConnection.shared;

  Future<List<Subject>> getAll() async {
    final conn = await _conn;
    final result = await conn.execute(
      'SELECT * FROM subject ORDER BY subject_code',
    );
    return result.map((r) => Subject.fromMap(r.toColumnMap())).toList();
  }

  Future<void> create(Subject s) async {
    final conn = await _conn;
    try {
      await conn.execute(
        Sql.named('''
          INSERT INTO subject (subject_code, subject_name, units, description)
          VALUES (@subject_code, @subject_name, @units, @description)
        '''),
        parameters: s.toMap(),
      );
    } on ServerException catch (e) {
      throw _friendly(e);
    }
  }

  Future<void> update(Subject s) async {
    final conn = await _conn;
    try {
      await conn.execute(
        Sql.named('''
          UPDATE subject SET
            subject_code = @subject_code,
            subject_name = @subject_name,
            units = @units,
            description = @description
          WHERE subject_id = @subject_id
        '''),
        parameters: {...s.toMap(), 'subject_id': s.subjectId},
      );
    } on ServerException catch (e) {
      throw _friendly(e);
    }
  }

  Future<void> delete(int subjectId) async {
    final conn = await _conn;
    try {
      await conn.execute(
        Sql.named('DELETE FROM subject WHERE subject_id = @id'),
        parameters: {'id': subjectId},
      );
    } on ServerException catch (e) {
      throw _friendly(e);
    }
  }

  /// Turns Postgres error codes into messages a user can read.
  Exception _friendly(ServerException e) {
    switch (e.code) {
      case '23505': // unique_violation
        return Exception('That subject code already exists.');
      case '23503': // foreign_key_violation
        return Exception(
          'Cannot delete: this subject still has schedules or enrollments.',
        );
      case '23514': // check_violation
        return Exception('Units must be between 1 and 6.');
      default:
        return Exception(e.message);
    }
  }
}