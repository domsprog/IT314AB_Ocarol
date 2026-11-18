import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:postgres/postgres.dart';
class DatabaseConnection {
  static Connection? _shared;

  static Future<Connection> get shared async {
    final existing = _shared;
    if (existing != null && existing.isOpen) return existing;
    _shared = await connect();
    return _shared!;
  }

 static Future<Connection> connect() async {
  final endpoint = Endpoint(
    host: dotenv.env['NEON_HOST']!,
    database: dotenv.env['NEON_DB']!,
    username: dotenv.env['NEON_USER']!,
    password: dotenv.env['NEON_PASSWORD']!,
    port: int.parse(dotenv.env['NEON_PORT'] ?? '5432'),
  );

  return Connection.open(
    endpoint,
    settings: const ConnectionSettings(sslMode: SslMode.require),
  );
}

  static Future<void> testConnection() async {
    Connection? connection;

    try {
      print('Connecting to Neon PostgreSQL...');

      connection = await connect();

      final result = await connection.execute(
        'SELECT current_database(), current_user',
      );

      print('Connected successfully!');
      print('Database information: $result');
    } catch (e) {
      print('Connection failed: $e');
    } finally {
      await connection?.close();
      print('Connection closed.');
    }
  }
}