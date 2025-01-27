// ignore_for_file: unused_import, unnecessary_set_literal, avoid_function_literals_in_foreach_calls

import 'dart:ffi';

import 'package:app_ppmob/src/data/database.dart';
import 'package:app_ppmob/src/model/fiscalizacao.dart';
import 'package:app_ppmob/src/model/unidade_acoplada.dart';
import 'package:app_ppmob/src/shared/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class UnidadeAcopladaDao {
  static String tableUnidadeAcopladaSql = '''CREATE TABLE IF NOT EXISTS $tableUnidadeAcoplada(
      $_id INTEGER PRIMARY KEY AUTOINCREMENT,
      $_idFiscalizacao INTEGER,
      $_placa TEXT,
      $_nmMunicipio TEXT,
      $_ufMunicipio TEXT,
      $_cdMunicipio TEXT,
      $_condicao TEXT,
      $_equipamentoTransporte TEXT,
      $_status TEXT
      )''';

  static const String tableUnidadeAcoplada = 'unidade_acoplada';
  static const String _id = 'id';
  static const String _idFiscalizacao = 'id_fiscalizacao';
  static const String _placa = 'placa';
  static const String _nmMunicipio = 'nm_municipio';
  static const String _ufMunicipio = 'uf_municipio';
  static const String _cdMunicipio = 'cd_municipio';
  static const String _condicao = 'nm_condicao';
  static const String _equipamentoTransporte = 'nm_equipamento_transporte';
  static const String _status = 'status';

  Future<void> insert(UnidadeAcoplada unidadeAcoplada) async {
    final Database database = await getDatabase();
    await database.insert(
      tableUnidadeAcoplada,
      unidadeAcoplada.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(UnidadeAcoplada unidadeAcoplada) async {
    final Database database = await getDatabase();
    await database.update(
      tableUnidadeAcoplada,
      unidadeAcoplada.toMap(),
      where: 'id = ?',
      whereArgs: [
        unidadeAcoplada.id,
      ],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UnidadeAcoplada?> findById(int id) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.query(
      tableUnidadeAcoplada,
      where: '$_id = ?',
      whereArgs: [
        id,
      ],
    );
    if (maps.isNotEmpty) {
      return UnidadeAcoplada().toModel(maps.first);
    } else {
      return null;
    }
  }

  Future<List<UnidadeAcoplada>?> findAllByIdFiscalizacao(int idFiscalizacao) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.query(
      tableUnidadeAcoplada,
      where: "$_idFiscalizacao = ?",
      whereArgs: [
        idFiscalizacao,
      ],
    );
    if (maps.isNotEmpty) {
      List<UnidadeAcoplada> lista = [];
      maps.forEach((element) => {
            lista.add(UnidadeAcoplada().toModel(element)),
          });
      return lista;
    } else {
      return [];
    }
  }

  Future<int> deleteAll() async {
    final Database database = await getDatabase();
    return await database.delete(tableUnidadeAcoplada);
  }

  Future<int> deleteByIdFiscalizacao(int idFiscalizacao) async {
    final Database database = await getDatabase();
    return await database.delete(
      tableUnidadeAcoplada,
      where: '$_idFiscalizacao = ?',
      whereArgs: [idFiscalizacao],
    );
  }

  Future<Map<String, dynamic>> isExiste() async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.rawQuery('SELECT COUNT(*) AS qtd FROM $tableUnidadeAcoplada');
    return maps.first;
  }
}
