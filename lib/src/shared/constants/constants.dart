class ImagensAssets {
  static const String imagemSplash = 'assets/images/image_splash.png';
  static const String imagemLogo = 'assets/images/image_login.png';
  static const String imagemBtn = 'assets/images/background_btn_nova_fiscalizacao.jpg';
}

class Endpoint {
  // static const String baseUrl = "https://fiscaldes.deinfra.sc.gov.br/fiscal";
  static const String baseUrl = "https://fiscalizacaoapphml.sie.sc.gov.br/fiscal";
  // static const String baseUrl = "https://fxd.sie.sc.gov.br/fiscal";
  static const String authenticate = "$baseUrl/api/v1/users/authenticate";
}

class Mocks {
  static const String estados = "assets/mocks/estados_br.json";
  static const String municipios = "assets/mocks/municipios.json";
  static const String rodoviaTrecho = "assets/mocks/eacttrecho.json";
  static const String rodovia = "assets/mocks/rodovias.json";
  static const String condicao = "assets/mocks/condicao.json";
  static const String equipamentoTransporte = "assets/mocks/equipamento_transporte.json";
  static const String coordenadasRodovias = "assets/mocks/coordenadas_rodovia.json";
  static const String infracao = "assets/mocks/infracao.json";
}

class EstadoEntidade {
  static const String naoSincronizado = 'NAO';
  static const String sincronizado = 'SIM';
  static const String pendente = 'PENDENTE';
  static const String finalizado = 'FINALIZADO';
  static const String desprezado = 'DESPREZADO';
}

class TitleScreen {
  static const String home = 'Talonário';
  static const String painelDocumentos = 'Dados da Autuação';
  static const String localFiscalizacao = 'Local da Fiscalização';
  static const String transportador = 'Transportador/Unid. Trans.';
  static const String condutor = 'Condutor';
  static const String expedidor = 'Expedidor';
  static const String documentoFiscal = 'Documento Fiscal';
  static const String detalheDocumentoFiscal = 'Detalhe Documento Fiscal';
  static const String foto = 'Fotos Registradas';
  static const String leitorQrCodeCnh = 'Leitor de QR Code - CNH';
  static const String painelQuestionario = 'Categorias do Questionário';
  static const String questionarioAutuacao = 'Questionário da Autuação';

  static const String documentosQuestionario = 'Documentos';
  static const String veiculoQuestionario = 'Veiculo ou Equipamento de Transporte';
  static const String sinalizacaoVeiculoQuestionario = 'Sinalizacao do Veiculo e Equipamento de Transporte';
  static const String embalagensQuestionario = 'Embalagens';
  static const String epiQuestionario = 'Epi';
  static const String condicoesApresentadasQuestionario = 'Condicoes Apresentadas nas Operacoes de Transporte';
  static const String incompatibilidadeQuestionario = 'Incompatibilidade no Transporte';
  static const String situacaoEmergenciaQuestionario = 'Situacao de Emergencia';
}

class TitleBtnPainel {
  static const String documentosQuestionario = 'Documentos';
  static const String veiculoQuestionario = 'Veiculo ou Equip de Transp';
  static const String sinalizacaoVeiculoQuestionario = 'Sinalização Veículo e Equip de Transp.';
  static const String embalagensQuestionario = 'Embalagens';
  static const String epiQuestionario = 'Epi';
  static const String condicoesApresentadasQuestionario = 'Cond. nas Operações de Transporte';
  static const String incompatibilidadeQuestionario = 'Incompatibilidade no Transporte';
  static const String situacaoEmergenciaQuestionario = 'Situação de Emergência';
}

class TxtToolTip {
  static const String btnFloatAvancar = 'Salvar e avançar para tela';
  static const String btnFloatAvancarCheckList = 'Avançar para a tela checklist de infrações';
  static const String btnFloatImage = 'Visualizar fotos registradas';
  static const String btnFloatQrCode = 'Ler QR Code';
  static const String btnfinalizarCheckList = 'Salvar e finalizar inspeção';
}
