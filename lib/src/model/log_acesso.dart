// ignore_for_file: unnecessary_this, prefer_collection_literals

class LogAcesso {
  int? id;
  late String login;
  late String dataAlteracao;

  LogAcesso({
    this.id,
    required this.login,
    required this.dataAlteracao,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this.id;
    map['login'] = this.login;
    map['data_alteracao'] = this.dataAlteracao;
    return map;
  }

  LogAcesso toModel(Map<String, dynamic> data) {
    LogAcesso logAcesso = LogAcesso(
      id: data['id'],
      login: data['login'],
      dataAlteracao: data['data_alteracao'],
    );
    return logAcesso;
  }

  LogAcesso.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    login = json['login'];
    dataAlteracao = json['dataAlteracao'];
  }
}
