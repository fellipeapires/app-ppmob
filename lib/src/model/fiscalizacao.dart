// ignore_for_file: unnecessary_this, prefer_collection_literals

class Fiscalizacao {
  int? id;
  String? nmMunicipioFiscalizacao;
  String? ufMunicipioFiscalizacao;
  String? cdMunicipioFiscalizacao;
  String? sgRodovia;
  String? km;
  String? placaUnidadeTransporte;
  String? renavanUnidadeTransporte;
  String? marcaModeloUnidadeTransporte;
  String? nmMunicipioUnidadeTransporte;
  String? ufMunicipioUnidadeTransporte;
  String? cdMunicipioUnidadeTransporte;
  String? condicaoUnidadeTransporte;
  String? equipamentoUnidadeTransporte;
  String? tipoPessoaTransportador;
  String? nomeTransportador;
  String? cpfCnpjTransportador;
  String? nmMunicipioTransportador;
  String? ufMunicipioTransportador;
  String? cdMunicipioTransportador;
  String? nomeCondutor;
  String? cnhCondutor;
  String? cpfCondutor;
  String? status;
  String? sincronizado;
  String? dataCadastro;

  Fiscalizacao({
    this.id,
    this.nmMunicipioFiscalizacao,
    this.ufMunicipioFiscalizacao,
    this.cdMunicipioFiscalizacao,
    this.sgRodovia,
    this.km,
    this.placaUnidadeTransporte,
    this.renavanUnidadeTransporte,
    this.marcaModeloUnidadeTransporte,
    this.nmMunicipioUnidadeTransporte,
    this.ufMunicipioUnidadeTransporte,
    this.cdMunicipioUnidadeTransporte,
    this.tipoPessoaTransportador,
    this.nomeTransportador,
    this.cpfCnpjTransportador,
    this.nmMunicipioTransportador,
    this.ufMunicipioTransportador,
    this.cdMunicipioTransportador,
    this.condicaoUnidadeTransporte,
    this.equipamentoUnidadeTransporte,
    this.nomeCondutor,
    this.cnhCondutor,
    this.cpfCondutor,
    this.status,
    this.sincronizado,
    this.dataCadastro,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this.id;
    map['nm_municipio_fiscalizacao'] = this.nmMunicipioFiscalizacao;
    map['uf_municipio_fiscalizacao'] = this.ufMunicipioFiscalizacao;
    map['cd_municipio_fiscalizacao'] = this.cdMunicipioFiscalizacao;
    map['sg_rodovia'] = this.sgRodovia;
    map['km'] = this.km;
    map['placa_unidade_transporte'] = this.placaUnidadeTransporte;
    map['renavan_unidade_transporte'] = this.renavanUnidadeTransporte;
    map['marca_modelo_unidade_transporte'] = this.marcaModeloUnidadeTransporte;
    map['nm_municipio_unidade_transporte'] = this.nmMunicipioUnidadeTransporte;
    map['uf_municipio_unidade_transporte'] = this.ufMunicipioUnidadeTransporte;
    map['cd_municipio_unidade_transporte'] = this.cdMunicipioUnidadeTransporte;
    map['condicao_unidade_transporte'] = this.condicaoUnidadeTransporte;
    map['nm_equipamento_unidade_transporte'] = this.equipamentoUnidadeTransporte;
    map['tipo_pessoa_transportador'] = this.tipoPessoaTransportador;
    map['nome_transportador'] = this.nomeTransportador;
    map['cnpj_transportador'] = this.cpfCnpjTransportador;
    map['nm_municipio_transportador'] = this.nmMunicipioTransportador;
    map['uf_municipio_transportador'] = this.ufMunicipioTransportador;
    map['cd_municipio_transportador'] = this.cdMunicipioTransportador;
    map['nome_condutor'] = this.nomeCondutor;
    map['cnh_condutor'] = this.cnhCondutor;
    map['cpf_condutor'] = this.cpfCondutor;
    map['status'] = this.status;
    map['sincronizado'] = this.sincronizado;
    map['data_cadastro'] = this.dataCadastro;
    return map;
  }

  Fiscalizacao toModel(Map<String, dynamic> data) {
    final Fiscalizacao fiscalizacao = Fiscalizacao();
    fiscalizacao.id = data['id'];
    fiscalizacao.nmMunicipioFiscalizacao = data['nm_municipio_fiscalizacao'];
    fiscalizacao.ufMunicipioFiscalizacao = data['uf_municipio_fiscalizacao'];
    fiscalizacao.cdMunicipioFiscalizacao = data['cd_municipio_fiscalizacao'];
    fiscalizacao.sgRodovia = data['sg_rodovia'];
    fiscalizacao.km = data['km'];
    fiscalizacao.placaUnidadeTransporte = data['placa_unidade_transporte'];
    fiscalizacao.renavanUnidadeTransporte = data['renavan_unidade_transporte'];
    fiscalizacao.marcaModeloUnidadeTransporte = data['marca_modelo_unidade_transporte'];
    fiscalizacao.nmMunicipioUnidadeTransporte = data['nm_municipio_unidade_transporte'];
    fiscalizacao.ufMunicipioUnidadeTransporte = data['uf_municipio_unidade_transporte'];
    fiscalizacao.cdMunicipioUnidadeTransporte = data['cd_municipio_unidade_transporte'];
    fiscalizacao.condicaoUnidadeTransporte = data['condicao_unidade_transporte'];
    fiscalizacao.equipamentoUnidadeTransporte = data['nm_equipamento_unidade_transporte'];
    fiscalizacao.tipoPessoaTransportador = data['tipo_pessoa_transportador'];
    fiscalizacao.nomeTransportador = data['nome_transportador'];
    fiscalizacao.cpfCnpjTransportador = data['cnpj_transportador'];
    fiscalizacao.nmMunicipioTransportador = data['nm_municipio_transportador'];
    fiscalizacao.ufMunicipioTransportador = data['uf_municipio_transportador'];
    fiscalizacao.cdMunicipioTransportador = data['cd_municipio_transportador'];
    fiscalizacao.nomeCondutor = data['nome_condutor'];
    fiscalizacao.cnhCondutor = data['cnh_condutor'];
    fiscalizacao.cpfCondutor = data['cpf_condutor'];
    fiscalizacao.status = data['status'];
    fiscalizacao.sincronizado = data['sincronizado'];
    fiscalizacao.dataCadastro = data['data_cadastro'];
    return fiscalizacao;
  }

  Fiscalizacao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nmMunicipioFiscalizacao = json['nm_municipio_fiscalizacao'];
    ufMunicipioFiscalizacao = json['uf_municipio_fiscalizacao'];
    cdMunicipioFiscalizacao = json['cd_municipio_fiscalizacao'];
    sgRodovia = json['sg_rodovia'];
    km = json['km'];
    placaUnidadeTransporte = json['placa_unidade_transporte'];
    renavanUnidadeTransporte = json['renavan_unidade_transporte'];
    marcaModeloUnidadeTransporte = json['marca_modelo_unidade_transporte'];
    nmMunicipioUnidadeTransporte = json['nm_municipio_unidade_transporte'];
    ufMunicipioUnidadeTransporte = json['uf_municipio_unidade_transporte'];
    cdMunicipioUnidadeTransporte = json['cd_municipio_unidade_transporte'];
    condicaoUnidadeTransporte = json['condicao_unidade_transporte'];
    equipamentoUnidadeTransporte = json['nm_equipamento_unidade_transporte'];
    tipoPessoaTransportador = json['tipo_pessoa_transportador'];
    nomeTransportador = json['nome_transportador'];
    cpfCnpjTransportador = json['cnpj_transportador'];
    nmMunicipioTransportador = json['nm_municipio_transportador'];
    ufMunicipioTransportador = json['uf_municipio_transportador'];
    cdMunicipioTransportador = json['cd_municipio_transportador'];
    nomeCondutor = json['nome_condutor'];
    cnhCondutor = json['cnh_condutor'];
    cpfCondutor = json['cpf_condutor'];
    status = json['status'];
    sincronizado = json['sincronizado'];
    dataCadastro = json['data_cadastro'];
  }
}
