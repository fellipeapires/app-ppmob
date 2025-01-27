// ignore_for_file: unused_import, unnecessary_set_literal, avoid_function_literals_in_foreach_calls

import 'dart:ffi';

import 'package:app_ppmob/src/data/database.dart';
import 'package:app_ppmob/src/model/fiscalizacao.dart';
import 'package:app_ppmob/src/model/foto.dart';
import 'package:app_ppmob/src/model/unidade_acoplada.dart';
import 'package:app_ppmob/src/shared/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class FotoDao {
  static String tableFotoSql = '''CREATE TABLE IF NOT EXISTS $tableFoto(
      $_id INTEGER PRIMARY KEY AUTOINCREMENT,
      $_idFiscalizacao INTEGER,
      $_nome TEXT,
      $_descricao TEXT,
      $_dataFoto TEXT,
      $_sincronizado TEXT,
      $_imagem TEXT
      )''';

  static const String tableFoto = 'foto';
  static const String _id = 'id';
  static const String _idFiscalizacao = 'id_fiscalizacao';
  static const String _nome = 'nome';
  static const String _descricao = 'descricao';
  static const String _dataFoto = 'data_foto';
  static const String _sincronizado = 'sincronizado';
  static const String _imagem = 'imagem';

  Future<void> insert(Foto foto) async {
    final Database database = await getDatabase();
    await database.insert(
      tableFoto,
      foto.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(Foto foto) async {
    final Database database = await getDatabase();
    await database.update(
      tableFoto,
      foto.toMap(),
      where: 'id = ?',
      whereArgs: [
        foto.id,
      ],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Foto?> findById(int id) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.query(
      tableFoto,
      where: '$_id = ?',
      whereArgs: [
        id,
      ],
    );
    if (maps.isNotEmpty) {
      return Foto().toModel(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Foto>?> findAllByIdFiscalizacao(int idFiscalizacao) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.query(
      tableFoto,
      where: "$_idFiscalizacao = ?",
      whereArgs: [
        idFiscalizacao,
      ],
    );
    if (maps.isNotEmpty) {
      List<Foto> lista = [];
      maps.forEach((element) => {
            lista.add(Foto().toModel(element)),
          });
      return lista;
    } else {
      return [];
    }
  }

  Future<int> deleteAll() async {
    final Database database = await getDatabase();
    return await database.delete(tableFoto);
  }

  Future<int> deleteById(int id) async {
    final Database database = await getDatabase();
    return await database.delete(
      tableFoto,
      where: '$_id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteByIdFiscalizacao(int idFiscalizacao) async {
    final Database database = await getDatabase();
    return await database.delete(
      tableFoto,
      where: '$_idFiscalizacao = ?',
      whereArgs: [idFiscalizacao],
    );
  }

  Future<Map<String, dynamic>> isExiste(int idFiscalizacao) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.rawQuery(
      'SELECT COUNT(*) AS qtd FROM $tableFoto WHERE $_idFiscalizacao = ?',
      [idFiscalizacao],
    );
    return maps.first;
  }
}
