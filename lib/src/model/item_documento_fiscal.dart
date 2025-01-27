// ignore_for_file: unnecessary_this, prefer_collection_literals

class ItemDocumentoFiscal {
  int? id;
  int? idFiscalizacao;
  int? idExpedidor;
  int? idDocumentoFiscal;
  String? numeroOnu;
  String? quantidade;
  String? valorUnitario;
  String? valorTotal;
  String? classe;
  String? descricao;
  String? codRisco;
  String? status;

  ItemDocumentoFiscal({
    this.id,
    this.idFiscalizacao,
    this.idExpedidor,
    this.idDocumentoFiscal,
    this.numeroOnu,
    this.quantidade,
    this.valorUnitario,
    this.valorTotal,
    this.classe,
    this.descricao,
    this.codRisco,
    this.status,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this.id;
    map['id_fiscalizacao'] = this.idFiscalizacao;
    map['id_expedidor'] = this.idExpedidor;
    map['id_documento_fiscal'] = this.idDocumentoFiscal;
    map['numero_onu'] = this.numeroOnu;
    map['quantidade'] = this.quantidade;
    map['valor_unitario'] = this.valorUnitario;
    map['valor_total'] = this.valorTotal;
    map['classe'] = this.classe;
    map['descricao'] = this.descricao;
    map['cod_risco'] = this.codRisco;
    map['status'] = this.status;
    return map;
  }

  ItemDocumentoFiscal toModel(Map<String, dynamic> data) {
    ItemDocumentoFiscal item = ItemDocumentoFiscal();
    item.id = data['id'];
    item.idFiscalizacao = data['id_fiscalizacao'];
    item.idExpedidor = data['id_expedidor'];
    item.idDocumentoFiscal = data['id_documento_fiscal'];
    item.numeroOnu = data['numero_onu'];
    item.quantidade = data['quantidade'];
    item.valorUnitario = data['valor_unitario'];
    item.valorTotal = data['valor_total'];
    item.classe = data['classe'];
    item.descricao = data['descricao'];
    item.codRisco = data['cod_risco'];
    item.status = data['status'];
    return item;
  }

  ItemDocumentoFiscal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idFiscalizacao = json['id_fiscalizacao'];
    idExpedidor = json['id_expedidor'];
    idDocumentoFiscal = json['id_documento_fiscal'];
    numeroOnu = json['numero_onu'];
    quantidade = json['quantidade'];
    valorUnitario = json['valor_unitario'];
    valorTotal = json['valor_total'];
    classe = json['classe'];
    descricao = json['descricao'];
    codRisco = json['cod_risco'];
    status = json['status'];
  }
}
