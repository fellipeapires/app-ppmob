// ignore_for_file: unused_import

import 'package:app_ppmob/src/data/database.dart';
import 'package:app_ppmob/src/model/usuario.dart';
import 'package:app_ppmob/src/shared/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class UsuarioDao {
  static String tableUsuarioSql = '''CREATE TABLE IF NOT EXISTS $tableUsuario(
      $_id INTEGER PRIMARY KEY AUTOINCREMENT,
      $_login TEXT,
      $_senha TEXT,
      $_nome TEXT,
      $_dataCadastro TEXT,
      $_token TEXT
      )''';

  static const String tableUsuario = 'usuario';
  static const String _id = 'id';
  static const String _login = 'login';
  static const String _senha = 'senha';
  static const String _nome = 'nome';
  static const String _dataCadastro = 'dataCadastro';
  static const String _token = 'token';

  Future<void> insert(Usuario usuario) async {
    final Database database = await getDatabase();
    await database.insert(
      tableUsuario,
      usuario.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteAll() async {
    final Database database = await getDatabase();
    return await database.delete(tableUsuario);
  }

  Future<int> deletePrevios() async {
    final Database database = await getDatabase();
    return await database.delete(tableUsuario, where: "dataCadastro < date('now', 'start of day', '0 day')");
  }

  Future<Map<String, dynamic>> logar(String login, String senha) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.query(
      tableUsuario,
      where: 'login = ? AND senha = ?',
      whereArgs: [
        login,
        senha,
      ],
    );
    return maps.first;
  }

  Future<Map<String, dynamic>> validarAcesso(String login, String senha) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.rawQuery(
      'SELECT COUNT(*) AS qtd FROM $tableUsuario WHERE login = ? AND senha = ?',
      [
        login,
        senha,
      ],
    );
    return maps.first;
  }

  Future<Map<String, dynamic>> isExiste() async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.rawQuery('SELECT COUNT(*) AS qtd FROM $tableUsuario');
    return maps.first;
  }
}
