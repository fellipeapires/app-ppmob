// ignore_for_file: unnecessary_this, prefer_collection_literals

class Usuario {
  int? id;
  late String nome;
  late String login;
  late String senha;
  late String dataCadastro;
  String? token;

  Usuario({
    this.id,
    required this.nome,
    required this.login,
    required this.senha,
    required this.dataCadastro,
    this.token,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this.id;
    map['nome'] = this.nome;
    map['login'] = this.login;
    map['senha'] = this.senha;
    map['dataCadastro'] = this.dataCadastro;
    map['token'] = this.token;
    return map;
  }

  Usuario toModel(Map<String, dynamic> data) {
    Usuario usuario = Usuario(
      id: data['id'],
      nome: data['nome'],
      login: data['login'],
      senha: data['senha'],
      dataCadastro: data['dataCadastro'],
      token: data['token'],
    );
    return usuario;
  }

  Usuario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    login = json['login'];
    senha = json['senha'];
    dataCadastro = json['dataCadastro'];
    token = json['token'];
  }
}
