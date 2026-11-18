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
      host: 'ep-hidden-base-azm2b0td-pooler.c-3.ap-southeast-1.aws.neon.tech',
      database: 'OcarolSMS',
      username: 'neondb_owner',
      password: 'npg_riaof9UIl4nW',
      port: 5432,
    );

    final connection = await Connection.open(
      endpoint,
      settings: const ConnectionSettings(
        sslMode: SslMode.require,
      ),
    );

    return connection;
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