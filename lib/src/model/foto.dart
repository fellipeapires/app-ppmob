// ignore_for_file: unnecessary_this, prefer_collection_literals

class Foto {
  int? id;
  int? idFiscalizacao;
  String? nome;
  String? descricao;
  String? dataFoto;
  String? sincronizado;
  String? imagem;

  Foto({
    this.id,
    this.idFiscalizacao,
    this.nome,
    this.descricao,
    this.dataFoto,
    this.sincronizado,
    this.imagem,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this.id;
    map['id_fiscalizacao'] = this.idFiscalizacao;
    map['nome'] = this.nome;
    map['descricao'] = this.descricao;
    map['data_foto'] = this.dataFoto;
    map['sincronizado'] = this.sincronizado;
    map['imagem'] = this.imagem;
    return map;
  }

  Foto toModel(Map<String, dynamic> data) {
    Foto foto = Foto();
    foto.id = data['id'];
    foto.idFiscalizacao = data['id_fiscalizacao'];
    foto.nome = data['nome'];
    foto.descricao = data['descricao'];
    foto.dataFoto = data['data_foto'];
    foto.sincronizado = data['sincronizado'];
    foto.imagem = data['imagem'];
    return foto;
  }

  Foto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idFiscalizacao = json['id_fiscalizacao'];
    nome = json['nome'];
    descricao = json['descricao'];
    dataFoto = json['data_foto'];
    sincronizado = json['sincronizado'];
    imagem = json['imagem'];
  }
}
