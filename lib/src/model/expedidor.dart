// ignore_for_file: unnecessary_this, prefer_collection_literals

class Expedidor {
  int? id;
  int? idFiscalizacao;
  String? nome;
  String? cnpj;
  String? endereco;
  String? nmMunicipio;
  String? ufMunicipio;
  String? cdMunicipio;
  String? status;

  Expedidor({
    this.id,
    this.idFiscalizacao,
    this.nome,
    this.cnpj,
    this.endereco,
    this.nmMunicipio,
    this.ufMunicipio,
    this.cdMunicipio,
    this.status,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this.id;
    map['id_fiscalizacao'] = this.idFiscalizacao;
    map['nome'] = this.nome;
    map['cnpj'] = this.cnpj;
    map['endereco'] = this.endereco;
    map['nm_municipio'] = this.nmMunicipio;
    map['uf_municipio'] = this.ufMunicipio;
    map['cd_municipio'] = this.cdMunicipio;
    map['status'] = this.status;
    return map;
  }

  Expedidor toModel(Map<String, dynamic> data) {
    Expedidor expedidor = Expedidor();
    expedidor.id = data['id'];
    expedidor.idFiscalizacao = data['id_fiscalizacao'];
    expedidor.nome = data['nome'];
    expedidor.cnpj = data['cnpj'];
    expedidor.endereco = data['endereco'];
    expedidor.nmMunicipio = data['nm_municipio'];
    expedidor.ufMunicipio = data['uf_municipio'];
    expedidor.cdMunicipio = data['cd_municipio'];
    expedidor.status = data['status'];
    return expedidor;
  }

  Expedidor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idFiscalizacao = json['id_fiscalizacao'];
    nome = json['nome'];
    cnpj = json['cnpj'];
    endereco = json['endereco'];
    nmMunicipio = json['nm_municipio'];
    ufMunicipio = json['uf_municipio'];
    cdMunicipio = json['cd_municipio'];
    status = json['status'];
  }
}
