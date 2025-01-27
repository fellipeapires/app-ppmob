// ignore_for_file: unused_import

import 'package:app_ppmob/src/data/database.dart';
import 'package:app_ppmob/src/model/fiscalizacao.dart';
import 'package:app_ppmob/src/shared/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class FiscalizacaoDao {
  static String tableFiscalizacaoSql = '''CREATE TABLE IF NOT EXISTS $tableFiscalizacao(
      $_id INTEGER PRIMARY KEY AUTOINCREMENT,
      $_nmMunicipioFiscalizacao TEXT,
      $_ufMunicipioFiscalizacao TEXT,
      $_cdMunicipioFiscalizacao TEXT,
      $_sgrodovia TEXT,
      $_km TEXT,
      $_placaUnidadeTransporte TEXT,
      $_renavanUnidadeTransporte TEXT,
      $_marcaModeloUnidadeTransporte TEXT,
      $_nmMunicipioUnidadeTransporte TEXT,
      $_ufMunicipioUnidadeTransporte TEXT,
      $_cdMunicipioUnidadeTransporte TEXT,
       $_condicaoUnidadeTransporte TEXT,
      $_equipamentoUnidadeTransporte TEXT,
      $_tipoPessoaTransportador TEXT,
      $_nomeTransportador TEXT,
      $_cnpjTransportador TEXT,
      $_nmMunicipioTransportador TEXT,
      $_ufMunicipioTransportador TEXT,
      $_cdMunicipioTransportador TEXT,
      $_nomeCondutor TEXT,
      $_cnhCondutor TEXT,
      $_cpfCondutor TEXT,
      $_dataCadastro TEXT,
      $_sincronizado TEXT,
      $_status TEXT
      )''';

  static const String tableFiscalizacao = 'fiscalizacao';
  static const String _id = 'id';
  static const String _nmMunicipioFiscalizacao = 'nm_municipio_fiscalizacao';
  static const String _ufMunicipioFiscalizacao = 'uf_municipio_fiscalizacao';
  static const String _cdMunicipioFiscalizacao = 'cd_municipio_fiscalizacao';
  static const String _sgrodovia = 'sg_rodovia';
  static const String _km = 'km';
  static const String _placaUnidadeTransporte = 'placa_unidade_transporte';
  static const String _renavanUnidadeTransporte = 'renavan_unidade_transporte';
  static const String _marcaModeloUnidadeTransporte = 'marca_modelo_unidade_transporte';
  static const String _nmMunicipioUnidadeTransporte = 'nm_municipio_unidade_transporte';
  static const String _ufMunicipioUnidadeTransporte = 'uf_municipio_unidade_transporte';
  static const String _cdMunicipioUnidadeTransporte = 'cd_municipio_unidade_transporte';
  static const String _condicaoUnidadeTransporte = 'condicao_unidade_transporte';
  static const String _equipamentoUnidadeTransporte = 'nm_equipamento_unidade_transporte';
  static const String _tipoPessoaTransportador = 'tipo_pessoa_transportador';
  static const String _nomeTransportador = 'nome_transportador';
  static const String _cnpjTransportador = 'cnpj_transportador';
  static const String _nmMunicipioTransportador = 'nm_municipio_transportador';
  static const String _ufMunicipioTransportador = 'uf_municipio_transportador';
  static const String _cdMunicipioTransportador = 'cd_municipio_transportador';
  static const String _nomeCondutor = 'nome_condutor';
  static const String _cnhCondutor = 'cnh_condutor';
  static const String _cpfCondutor = 'cpf_condutor';
  static const String _dataCadastro = 'data_cadastro';
  static const String _sincronizado = 'sincronizado';
  static const String _status = 'status';

  Future<void> insert(Fiscalizacao fiscalizacao) async {
    final Database database = await getDatabase();
    await database.insert(
      tableFiscalizacao,
      fiscalizacao.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(Fiscalizacao fiscalizacao) async {
    final Database database = await getDatabase();
    await database.update(
      tableFiscalizacao,
      fiscalizacao.toMap(),
      where: 'id = ?',
      whereArgs: [
        fiscalizacao.id,
      ],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Fiscalizacao?> findById(int id) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.query(
      tableFiscalizacao,
      where: '$_id = ?',
      whereArgs: [
        id,
      ],
    );
    if (maps.isNotEmpty) {
      return Fiscalizacao().toModel(maps.first);
    } else {
      return null;
    }
  }

  Future<Fiscalizacao?> findByStatus(String status) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.query(
      tableFiscalizacao,
      where: '$_status = ?',
      whereArgs: [
        status,
      ],
    );
    if (maps.isNotEmpty) {
      return Fiscalizacao().toModel(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteAll() async {
    final Database database = await getDatabase();
    return await database.delete(tableFiscalizacao);
  }

  Future<int> deleteById(int id) async {
    final Database database = await getDatabase();
    return await database.delete(
      tableFiscalizacao,
      where: '$_id = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, dynamic>> isExiste() async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database.rawQuery('SELECT COUNT(*) AS qtd FROM $tableFiscalizacao');
    return maps.first;
  }
}
