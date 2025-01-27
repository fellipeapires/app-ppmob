// ignore_for_file: unused_import, unnecessary_set_literal, avoid_function_literals_in_foreach_calls

import 'dart:ffi';

import 'package:app_ppmob/src/data/database.dart';
import 'package:app_ppmob/src/model/expedidor.dart';
import 'package:app_ppmob/src/model/fiscalizacao.dart';
import 'package:app_ppmob/src/model/unidade_acoplada.dart';
import 'package:app_ppmob/src/shared/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class ExpedidorDao {
  static String tableExpedidorSql = '''CREATE TABLE IF NOT EXISTS $tableExpedidor(
      $_id INTEGER PRIMARY KEY AUTOINCREMENT,
      $_idFiscalizacao INTEGER,
      $_nome TEXT,
      $_cnpj TEXT,
      $_endereco TEXT,
      $_nmMunicipio TEXT,
      $_ufMunicipio TEXT,
      $_cdMunicipio TEXT,
      $_status TEXT
      )''';

  static const String tableExpedidor = 'expedidor';
  static const String _id = 'id';
  static const String _idFiscalizacao = 'id_fiscalizacao';
  static const String _nome = 'nome';
  static const String _cnpj = 'cnpj';
  static const String _endereco = 'endereco';
  static const String _nmMunicipio = 'nm_municipio';
  static const String _ufMunicipio = 'uf_municipio';
  static const String _cdMunicipio = 'cd_municipio';
  static const String _status = 'status';

  Future<void> insert(Expedidor expedidor) async {
    final Database database = await getDatabase();
    await database.insert(
      tableExpedidor,
      expedidor.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(Expedidor expedidor) async {
    final Database database = await getDatabase();
    await database.update(
      tableExpedidor,
      expedidor.toMap(),
      where: 'id = ?',
      whereArgs: [
        expedidor.id,
      ],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Expedidor?> findById(int id) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.query(
      tableExpedidor,
      where: '$_id = ?',
      whereArgs: [
        id,
      ],
    );
    if (maps.isNotEmpty) {
      return Expedidor().toModel(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Expedidor>?> findAllByIdFiscalizacao(int idFiscalizacao) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.query(
      tableExpedidor,
      where: "$_idFiscalizacao = ?",
      whereArgs: [
        idFiscalizacao,
      ],
    );
    if (maps.isNotEmpty) {
      List<Expedidor> lista = [];
      maps.forEach((element) => {
            lista.add(Expedidor().toModel(element)),
          });
      return lista;
    } else {
      return [];
    }
  }

  Future<int> deleteAll() async {
    final Database database = await getDatabase();
    return await database.delete(tableExpedidor);
  }

  Future<int> deleteByIdFiscalizacao(int idFiscalizacao) async {
    final Database database = await getDatabase();
    return await database.delete(
      tableExpedidor,
      where: '$_idFiscalizacao = ?',
      whereArgs: [idFiscalizacao],
    );
  }

  Future<Map<String, dynamic>> isExiste(int idFiscalizacao) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.rawQuery(
      'SELECT COUNT(*) AS qtd FROM $tableExpedidor WHERE $_idFiscalizacao = ?',
      [idFiscalizacao],
    );
    return maps.first;
  }
}
