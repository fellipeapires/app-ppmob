// ignore_for_file: unnecessary_this, prefer_collection_literals

class DocumentoFiscal {
  int? id;
  int? idFiscalizacao;
  int? idExpedidor;
  String? nomeExpedidor;
  String? numeroFiscal;
  String? dataSaida;
  String? valor;
  String? status;

  DocumentoFiscal({
    this.id,
    this.idFiscalizacao,
    this.idExpedidor,
    this.nomeExpedidor,
    this.numeroFiscal,
    this.dataSaida,
    this.valor,
    this.status,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this.id;
    map['id_fiscalizacao'] = this.idFiscalizacao;
    map['id_expedidor'] = this.idExpedidor;
    map['nome_expedidor'] = this.nomeExpedidor;
    map['numero_fiscal'] = this.numeroFiscal;
    map['data_saida'] = this.dataSaida;
    map['valor'] = this.valor;
    map['status'] = this.status;
    return map;
  }

  DocumentoFiscal toModel(Map<String, dynamic> data) {
    DocumentoFiscal documento = DocumentoFiscal();
    documento.id = data['id'];
    documento.idFiscalizacao = data['id_fiscalizacao'];
    documento.idExpedidor = data['id_expedidor'];
    documento.nomeExpedidor = data['nome_expedidor'];
    documento.numeroFiscal = data['numero_fiscal'];
    documento.dataSaida = data['data_saida'];
    documento.valor = data['valor'];
    documento.status = data['status'];
    return documento;
  }

  DocumentoFiscal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idFiscalizacao = json['id_fiscalizacao'];
    idExpedidor = json['id_expedidor'];
    nomeExpedidor = json['nome_expedidor'];
    numeroFiscal = json['numero_fiscal'];
    dataSaida = json['data_saida'];
    valor = json['valor'];
    status = json['status'];
  }
}
