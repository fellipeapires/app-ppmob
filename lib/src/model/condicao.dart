// ignore_for_file: unnecessary_this, prefer_collection_literals

class Condicao {
  String? nmCondicao;

  Condicao({
    this.nmCondicao,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    map['nm_condicao'] = this.nmCondicao;
    return map;
  }

  Condicao toModel(Map<String, dynamic> data) {
    Condicao condicao = Condicao(nmCondicao: data['nm_condicao']);
    return condicao;
  }

  Condicao.fromJson(Map<String, dynamic> json) {
    nmCondicao = json['nmcondicao'];
  }
}
