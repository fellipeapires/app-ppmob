// ignore_for_file: unnecessary_this, prefer_collection_literals

class Configuracao {
  int? id;
  late String isLembreMe;
  late String dataAlteracao;

  Configuracao({
    this.id,
    required this.isLembreMe,
    required this.dataAlteracao,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this.id;
    map['is_lembre_me'] = this.isLembreMe;
    map['data_alteracao'] = this.dataAlteracao;
    return map;
  }

  Configuracao toModel(Map<String, dynamic> data) {
    Configuracao configuracao = Configuracao(
      id: data['id'],
      isLembreMe: data['is_lembre_me'],
      dataAlteracao: data['data_alteracao'],
    );
    return configuracao;
  }

  Configuracao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isLembreMe = json['isLembreMe'];
    dataAlteracao = json['dataAlteracao'];
  }
}
