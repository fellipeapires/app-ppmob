// ignore_for_file: avoid_print

import 'package:app_ppmob/src/data/dao/configuracao_dao.dart';
import 'package:app_ppmob/src/data/dao/documento_fiscal_dao.dart';
import 'package:app_ppmob/src/data/dao/expedidor_dao.dart';
import 'package:app_ppmob/src/data/dao/fiscalizacao_dao.dart';
import 'package:app_ppmob/src/data/dao/foto_dao.dart';
import 'package:app_ppmob/src/data/dao/infracao_dao.dart';
import 'package:app_ppmob/src/data/dao/item_documento_fiscal_dao.dart';
import 'package:app_ppmob/src/data/dao/log_acesso_dao.dart';
import 'package:app_ppmob/src/data/dao/unidade_acoplada_dao.dart';
import 'package:app_ppmob/src/data/dao/usuario_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'appmob.db');
  return openDatabase(path, onCreate: (db, version) {
    db.execute(UsuarioDao.tableUsuarioSql);
    db.execute(FiscalizacaoDao.tableFiscalizacaoSql);
    db.execute(UnidadeAcopladaDao.tableUnidadeAcopladaSql);
    db.execute(ConfiguracaoDao.tableConfiguracaoSql);
    db.execute(ExpedidorDao.tableExpedidorSql);
    db.execute(DocumentoFiscalDao.tableDocumentoFiscalSql);
    db.execute(ItemDocumentoFiscalDao.tableItemDocumentoFiscalSql);
    db.execute(FotoDao.tableFotoSql);
    db.execute(InfracaoDao.tableInfracaoSql);
    db.execute(LogAcessoDao.tableLogAcessoSql);
    db.execute("INSERT INTO ${ConfiguracaoDao.tableConfiguracao} (is_lembre_me, data_alteracao) VALUES ('NAO', strftime('%d-%m-%Y', date('now')));");
    db.execute("INSERT INTO ${LogAcessoDao.tableLogAcesso} (login, data_alteracao) VALUES (null, strftime('%d-%m-%Y', date('now')));");
  }, version: 1);
}
