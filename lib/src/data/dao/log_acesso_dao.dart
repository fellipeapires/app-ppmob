import 'package:app_ppmob/src/data/database.dart';
import 'package:app_ppmob/src/model/log_acesso.dart';
import 'package:sqflite/sqflite.dart';

class LogAcessoDao {
  static String tableLogAcessoSql = '''CREATE TABLE IF NOT EXISTS $tableLogAcesso(
      $_id INTEGER PRIMARY KEY AUTOINCREMENT,
      $_login TEXT,
      $_dataAlteracao TEXT
      )''';

  static const String tableLogAcesso = 'log_acesso';
  static const String _id = 'id';
  static const String _login = 'login';
  static const String _dataAlteracao = 'data_alteracao';

  Future<void> update(LogAcesso logAcesso) async {
    final Database database = await getDatabase();
    await database.update(
      tableLogAcesso,
      where: '$_id = ?',
      whereArgs: [
        logAcesso.id,
      ],
      logAcesso.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>> getLogAcesso() async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.query(
      tableLogAcesso,
    );
    return maps.first;
  }

  Future<Map<String, dynamic>> isExiste() async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.rawQuery('SELECT COUNT(*) AS qtd FROM $tableLogAcesso WHERE login IS NOT NULL');
    return maps.first;
  }
}
