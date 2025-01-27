import 'package:app_ppmob/src/data/database.dart';
import 'package:app_ppmob/src/model/configuracao.dart';
import 'package:sqflite/sqflite.dart';

class ConfiguracaoDao {
  static String tableConfiguracaoSql = '''CREATE TABLE IF NOT EXISTS $tableConfiguracao(
      $_id INTEGER PRIMARY KEY AUTOINCREMENT,
      $_isLembreMe TEXT,
      $_dataAlteracao TEXT
      )''';

  static const String tableConfiguracao = 'configuracao';
  static const String _id = 'id';
  static const String _isLembreMe = 'is_lembre_me';
  static const String _dataAlteracao = 'data_alteracao';

  Future<void> update(Configuracao configuracao) async {
    final Database database = await getDatabase();
    await database.update(
      tableConfiguracao,
      where: '$_id = ?',
      whereArgs: [
        configuracao.id,
      ],
      configuracao.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>> getConfiguracao() async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.query(
      tableConfiguracao,
    );
    return maps.first;
  }
}
