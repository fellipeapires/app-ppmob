// ignore_for_file: unnecessary_this, prefer_collection_literals

class Infracao {
  int? id;
  int? idFiscalizacao;
  String? codigo;
  String? categoria;
  String? resumo;
  String? detalhado;
  String? tipoInfrator;
  String? enquadramentoTransp;
  String? codTransportador;
  String? enquadramentoExp;
  String? codExpedidor;

  Infracao({
    this.id,
    this.idFiscalizacao,
    this.codigo,
    this.categoria,
    this.resumo,
    this.detalhado,
    this.tipoInfrator,
    this.enquadramentoTransp,
    this.codTransportador,
    this.enquadramentoExp,
    this.codExpedidor,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this.id;
    map['id_fiscalizacao'] = this.idFiscalizacao;
    map['codigo'] = this.codigo;
    map['categoria'] = this.categoria;
    map['resumo'] = this.resumo;
    map['detalhado'] = this.detalhado;
    map['tipoInfrator'] = this.tipoInfrator;
    map['enquadramentoTransp'] = this.enquadramentoTransp;
    map['codTransportador'] = this.codTransportador;
    map['enquadramentoExp'] = this.enquadramentoExp;
    map['codExpedidor'] = this.codExpedidor;
    return map;
  }

  Infracao toModel(Map<String, dynamic> data) {
    Infracao infracao = Infracao();
    infracao.id = data['id'];
    infracao.idFiscalizacao = data['id_fiscalizacao'];
    infracao.codigo = data['codigo'];
    infracao.categoria = data['categoria'];
    infracao.resumo = data['resumo'];
    infracao.detalhado = data['detalhado'];
    infracao.tipoInfrator = data['tipoInfrator'];
    infracao.enquadramentoTransp = data['enquadramentoTransp'];
    infracao.codTransportador = data['codTransportador'];
    infracao.enquadramentoExp = data['enquadramentoExp'];
    infracao.codExpedidor = data['codExpedidor'];
    return infracao;
  }

  Infracao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idFiscalizacao = json['id_fiscalizacao'];
    codigo = json['codigo'];
    categoria = json['categoria'];
    resumo = json['resumo'];
    detalhado = json['detalhado'];
    tipoInfrator = json['tipoInfrator'];
    enquadramentoTransp = json['enquadramentoTransp'];
    codTransportador = json['codTransportador'];
    enquadramentoExp = json['enquadramentoExp'];
    codExpedidor = json['codExpedidor'];
  }
}
