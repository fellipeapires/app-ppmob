// ignore_for_file: unused_import, unnecessary_set_literal, avoid_function_literals_in_foreach_calls

import 'dart:ffi';

import 'package:app_ppmob/src/data/database.dart';
import 'package:app_ppmob/src/model/documento_fiscal.dart';
import 'package:app_ppmob/src/model/expedidor.dart';
import 'package:app_ppmob/src/model/fiscalizacao.dart';
import 'package:app_ppmob/src/model/item_documento_fiscal.dart';
import 'package:app_ppmob/src/model/unidade_acoplada.dart';
import 'package:app_ppmob/src/shared/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class ItemDocumentoFiscalDao {
  static String tableItemDocumentoFiscalSql = '''CREATE TABLE IF NOT EXISTS $tableItemDocumentoFiscal(
      $_id INTEGER PRIMARY KEY AUTOINCREMENT,
      $_idFiscalizacao INTEGER,
      $_idExpedidor INTEGER,
      $_idDocumentoFiscal INTEGER,
      $_numeroOnu TEXT,
      $_quantidade TEXT,
      $_valorUnitario TEXT,
      $_valorTotal TEXT,
      $_classe TEXT,
      $_descricao TEXT,
      $_codRisco TEXT,
      $_status TEXT
      )''';

  static const String tableItemDocumentoFiscal = 'item_documento_fiscal';
  static const String _id = 'id';
  static const String _idFiscalizacao = 'id_fiscalizacao';
  static const String _idExpedidor = 'id_expedidor';
  static const String _idDocumentoFiscal = 'id_documento_fiscal';
  static const String _numeroOnu = 'numero_onu';
  static const String _quantidade = 'quantidade';
  static const String _valorUnitario = 'valor_unitario';
  static const String _valorTotal = 'valor_total';
  static const String _classe = 'classe';
  static const String _descricao = 'descricao';
  static const String _codRisco = 'cod_risco';
  static const String _status = 'status';

  Future<void> insert(ItemDocumentoFiscal item) async {
    final Database database = await getDatabase();
    await database.insert(
      tableItemDocumentoFiscal,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(ItemDocumentoFiscal item) async {
    final Database database = await getDatabase();
    await database.update(
      tableItemDocumentoFiscal,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [
        item.id,
      ],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<ItemDocumentoFiscal?> findById(int id) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.query(
      tableItemDocumentoFiscal,
      where: '$_id = ?',
      whereArgs: [
        id,
      ],
    );
    if (maps.isNotEmpty) {
      return ItemDocumentoFiscal().toModel(maps.first);
    } else {
      return null;
    }
  }

  Future<List<ItemDocumentoFiscal>?> findAllByIdDocumentoFiscal(int idDocumentoFiscal) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.query(
      tableItemDocumentoFiscal,
      where: "$_idDocumentoFiscal = ?",
      whereArgs: [
        idDocumentoFiscal,
      ],
    );
    if (maps.isNotEmpty) {
      List<ItemDocumentoFiscal> lista = [];
      maps.forEach((element) => {
            lista.add(ItemDocumentoFiscal().toModel(element)),
          });
      return lista;
    } else {
      return [];
    }
  }

  Future<List<ItemDocumentoFiscal>?> findAllByIdFiscalizacao(int idFiscalizacao) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.query(
      tableItemDocumentoFiscal,
      where: "$_idFiscalizacao = ? AND $_idDocumentoFiscal is null",
      whereArgs: [
        idFiscalizacao,
      ],
    );
    if (maps.isNotEmpty) {
      List<ItemDocumentoFiscal> lista = [];
      maps.forEach((element) => {
            lista.add(ItemDocumentoFiscal().toModel(element)),
          });
      return lista;
    } else {
      return [];
    }
  }

  Future<int> deleteAll() async {
    final Database database = await getDatabase();
    return await database.rawDelete('DELETE FROM $tableItemDocumentoFiscal WHERE id_documento_fiscal is null');
  }

  Future<int> deleteAllByIdDocumento(int idDocumento) async {
    final Database database = await getDatabase();
    return await database.delete(
      tableItemDocumentoFiscal,
      where: '$_idDocumentoFiscal = ?',
      whereArgs: [idDocumento],
    );
  }

  Future<int> deleteByIdFiscalizacao(int idFiscalizacao) async {
    final Database database = await getDatabase();
    return await database.delete(
      tableItemDocumentoFiscal,
      where: '$_idFiscalizacao = ?',
      whereArgs: [idFiscalizacao],
    );
  }

  Future<Map<String, dynamic>> isExisteByDocumentoFiscal(int idDocumentoFiscal) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.rawQuery(
      'SELECT COUNT(*) AS qtd FROM $tableItemDocumentoFiscal WHERE $_idDocumentoFiscal = ?',
      [idDocumentoFiscal],
    );
    return maps.first;
  }

  Future<Map<String, dynamic>> isExisteByFiscalizacao(int idFiscalizacao) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.rawQuery(
      'SELECT COUNT(*) AS qtd FROM $tableItemDocumentoFiscal WHERE $_idFiscalizacao = ?',
      [idFiscalizacao],
    );
    return maps.first;
  }
}
