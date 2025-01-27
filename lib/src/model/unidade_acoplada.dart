// ignore_for_file: unnecessary_this, prefer_collection_literals

class UnidadeAcoplada {
  int? id;
  int? idFiscalizacao;
  String? placa;
  String? nmMunicipio;
  String? ufMunicipio;
  String? cdMunicipio;
  String? condicao;
  String? equipamentoTransporte;
  String? status;

  UnidadeAcoplada({
    this.id,
    this.idFiscalizacao,
    this.placa,
    this.nmMunicipio,
    this.ufMunicipio,
    this.cdMunicipio,
    this.condicao,
    this.equipamentoTransporte,
    this.status,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this.id;
    map['id_fiscalizacao'] = this.idFiscalizacao;
    map['placa'] = this.placa;
    map['nm_municipio'] = this.nmMunicipio;
    map['uf_municipio'] = this.ufMunicipio;
    map['cd_municipio'] = this.cdMunicipio;
    map['nm_condicao'] = this.condicao;
    map['nm_equipamento_transporte'] = this.equipamentoTransporte;
    map['status'] = this.status;
    return map;
  }

  UnidadeAcoplada toModel(Map<String, dynamic> data) {
    UnidadeAcoplada unidadeAcoplada = UnidadeAcoplada();
    unidadeAcoplada.id = data['id'];
    unidadeAcoplada.idFiscalizacao = data['id_fiscalizacao'];
    unidadeAcoplada.placa = data['placa'];
    unidadeAcoplada.nmMunicipio = data['nm_municipio'];
    unidadeAcoplada.ufMunicipio = data['uf_municipio'];
    unidadeAcoplada.cdMunicipio = data['cd_municipio'];
    unidadeAcoplada.condicao = data['nm_condicao'];
    unidadeAcoplada.equipamentoTransporte = data['nm_equipamento_transporte'];
    unidadeAcoplada.status = data['status'];
    return unidadeAcoplada;
  }

  UnidadeAcoplada.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idFiscalizacao = json['id_fiscalizacao'];
    placa = json['placa'];
    nmMunicipio = json['nm_municipio'];
    ufMunicipio = json['uf_municipio'];
    cdMunicipio = json['cd_municipio'];
    condicao = json['nm_condicao'];
    equipamentoTransporte = json['nm_equipamento_transporte'];
    status = json['status'];
  }
}
