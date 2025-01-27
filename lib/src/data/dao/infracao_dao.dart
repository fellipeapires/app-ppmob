// ignore_for_file: unused_import, unnecessary_set_literal, avoid_function_literals_in_foreach_calls

import 'dart:ffi';

import 'package:app_ppmob/src/data/database.dart';
import 'package:app_ppmob/src/model/fiscalizacao.dart';
import 'package:app_ppmob/src/model/infracao.dart';
import 'package:app_ppmob/src/model/unidade_acoplada.dart';
import 'package:app_ppmob/src/shared/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class InfracaoDao {
  static String tableInfracaoSql = '''CREATE TABLE IF NOT EXISTS $tableInfracao(
      $_id INTEGER PRIMARY KEY AUTOINCREMENT,
      $_idFiscalizacao INTEGER,
      $_codigo TEXT,
      $_categoria TEXT,
      $_enquadTransp TEXT,
      $_enquadExp TEXT
      )''';

  static const String tableInfracao = 'infracao';
  static const String _id = 'id';
  static const String _idFiscalizacao = 'id_fiscalizacao';
  static const String _codigo = 'codigo';
  static const String _categoria = 'categoria';
  static const String _enquadTransp = 'enquadramento_transportador';
  static const String _enquadExp = 'enquad_expedidor';

  Future<void> insert(Infracao infracao) async {
    final Database database = await getDatabase();
    await database.insert(
      tableInfracao,
      infracao.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(Infracao infracao) async {
    final Database database = await getDatabase();
    await database.update(
      tableInfracao,
      infracao.toMap(),
      where: 'id = ?',
      whereArgs: [
        infracao.id,
      ],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Infracao?> findById(int id) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.query(
      tableInfracao,
      where: '$_id = ?',
      whereArgs: [
        id,
      ],
    );
    if (maps.isNotEmpty) {
      return Infracao().toModel(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Infracao>?> findAllByIdFiscalizacao(int idFiscalizacao) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.query(
      tableInfracao,
      where: "$_idFiscalizacao = ?",
      whereArgs: [
        idFiscalizacao,
      ],
    );
    if (maps.isNotEmpty) {
      List<Infracao> lista = [];
      maps.forEach((element) => {
            lista.add(Infracao().toModel(element)),
          });
      return lista;
    } else {
      return [];
    }
  }

  Future<int> deleteAll() async {
    final Database database = await getDatabase();
    return await database.delete(tableInfracao);
  }

  Future<int> deleteById(int id) async {
    final Database database = await getDatabase();
    return await database.delete(
      tableInfracao,
      where: '$_id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteByIdFiscalizacao(int idFiscalizacao) async {
    final Database database = await getDatabase();
    return await database.delete(
      tableInfracao,
      where: '$_idFiscalizacao = ?',
      whereArgs: [idFiscalizacao],
    );
  }

  Future<Map<String, dynamic>> isExiste(int idFiscalizacao) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.rawQuery(
      'SELECT COUNT(*) AS qtd FROM $tableInfracao WHERE $_idFiscalizacao = ?',
      [idFiscalizacao],
    );
    return maps.first;
  }
}
