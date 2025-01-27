// ignore_for_file: unused_import, unnecessary_set_literal, avoid_function_literals_in_foreach_calls

import 'dart:ffi';

import 'package:app_ppmob/src/data/database.dart';
import 'package:app_ppmob/src/model/documento_fiscal.dart';
import 'package:app_ppmob/src/model/expedidor.dart';
import 'package:app_ppmob/src/model/fiscalizacao.dart';
import 'package:app_ppmob/src/model/unidade_acoplada.dart';
import 'package:app_ppmob/src/shared/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class DocumentoFiscalDao {
  static String tableDocumentoFiscalSql = '''CREATE TABLE IF NOT EXISTS $tableDocumentoFiscal(
      $_id INTEGER PRIMARY KEY AUTOINCREMENT,
      $_idFiscalizacao INTEGER,
      $_idExpedidor INTEGER,
      $_nomeExpedidor TEXT,
      $_numeroFiscal TEXT,
      $_valor TEXT,
      $_dataSaida TEXT,
      $_status TEXT
      )''';

  static const String tableDocumentoFiscal = 'documento_fiscal';
  static const String _id = 'id';
  static const String _idFiscalizacao = 'id_fiscalizacao';
  static const String _idExpedidor = 'id_expedidor';
   static const String _nomeExpedidor = 'nome_expedidor';
  static const String _numeroFiscal = 'numero_fiscal';
  static const String _dataSaida = 'data_saida';
  static const String _valor = 'valor';
  static const String _status = 'status';

  Future<void> insert(DocumentoFiscal documentoFiscal) async {
    final Database database = await getDatabase();
    await database.insert(
      tableDocumentoFiscal,
      documentoFiscal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(DocumentoFiscal documentoFiscal) async {
    final Database database = await getDatabase();
    await database.update(
      tableDocumentoFiscal,
      documentoFiscal.toMap(),
      where: 'id = ?',
      whereArgs: [
        documentoFiscal.id,
      ],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<DocumentoFiscal?> findById(int id) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.query(
      tableDocumentoFiscal,
      where: '$_id = ?',
      whereArgs: [
        id,
      ],
    );
    if (maps.isNotEmpty) {
      return DocumentoFiscal().toModel(maps.first);
    } else {
      return null;
    }
  }

  Future<DocumentoFiscal?> findByIdFiscalizacaoKey(int idFiscalizacao) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.query(
      tableDocumentoFiscal,
      where: '$_idFiscalizacao = ? AND $_valor = ? OR $_valor is null',
      whereArgs: [
        idFiscalizacao,
        '0.0',
      ],
    );
    if (maps.isNotEmpty) {
      return DocumentoFiscal().toModel(maps.first);
    } else {
      return null;
    }
  }

  Future<List<DocumentoFiscal>?> findAllByIdFiscalizacao(int idFiscalizacao) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.query(
      tableDocumentoFiscal,
      where: "$_idFiscalizacao = ? AND $_valor > ?",
      whereArgs: [
        idFiscalizacao,
        '0.0',
      ],
    );
    if (maps.isNotEmpty) {
      List<DocumentoFiscal> lista = [];
      maps.forEach((element) => {
            lista.add(DocumentoFiscal().toModel(element)),
          });
      return lista;
    } else {
      return [];
    }
  }

  Future<List<DocumentoFiscal>?> findAllByIdExpedidor(int idExpedidor) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.query(
      tableDocumentoFiscal,
      where: "$_idExpedidor = ?",
      whereArgs: [
        idExpedidor,
      ],
    );
    if (maps.isNotEmpty) {
      List<DocumentoFiscal> lista = [];
      maps.forEach((element) => {
            lista.add(DocumentoFiscal().toModel(element)),
          });
      return lista;
    } else {
      return [];
    }
  }

  Future<int> deleteAll() async {
    final Database database = await getDatabase();
    return await database.delete(tableDocumentoFiscal);
  }

    Future<int> deleteByIdFiscalizacao(int idFiscalizacao) async {
    final Database database = await getDatabase();
    return await database.delete(
      tableDocumentoFiscal,
      where: '$_idFiscalizacao = ?',
      whereArgs: [idFiscalizacao],
    );
  }


  Future<Map<String, dynamic>> isExisteByFiscalizacao(int idFiscalizacao) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.rawQuery(
      'SELECT COUNT(*) AS qtd FROM $tableDocumentoFiscal WHERE $_idFiscalizacao = ?',
      [idFiscalizacao],
    );
    return maps.first;
  }

  Future<Map<String, dynamic>> isExiste() async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.rawQuery(
      'SELECT COUNT(*) AS qtd FROM $tableDocumentoFiscal WHERE $_valor = ? OR $_valor is null',
      ['0.0'],
    );
    return maps.first;
  }
  
}
