// ignore_for_file: use_build_context_synchronously, unnecessary_set_literal, unused_local_variable, deprecated_member_use, prefer_interpolation_to_compose_strings, avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:app_ppmob/app_routes.dart';
import 'package:app_ppmob/src/component/circular_progress.dart';
import 'package:app_ppmob/src/data/dao/configuracao_dao.dart';
import 'package:app_ppmob/src/data/dao/log_acesso_dao.dart';
import 'package:app_ppmob/src/data/dao/usuario_dao.dart';
import 'package:app_ppmob/src/model/configuracao.dart';
import 'package:app_ppmob/src/model/log_acesso.dart';
import 'package:app_ppmob/src/model/usuario.dart';
import 'package:app_ppmob/src/services/login_service.dart';
import 'package:app_ppmob/src/shared/constants/constants.dart';
import 'package:app_ppmob/src/shared/util/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  late Map<String, dynamic> infoApp = {};
  Map<String, dynamic>? configuracao;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController loginCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final loading = ValueNotifier<bool>(false);
  bool isObscure = true;
  String? errorMessage;
  bool _isLembreMe = false;

  @override
  void initState() {
    super.initState();
    _getVersaoApp();
    _deleteUserPrevios();
    _getConfigurtacao();
    _getLogAcesso();
  }

  _getVersaoApp() async {
    infoApp = await Utility.getInfoApp();
    setState(() {
      infoApp;
    });
  }

  _getConfigurtacao() async {
    try {
      configuracao = await ConfiguracaoDao().getConfiguracao();
      setState(() {
        _isLembreMe = configuracao!['is_lembre_me'] == 'NAO' ? false : true;
      });
    } catch (e) {
      if (kDebugMode) {
        print('ERRO: (_getConfigurtacao()) - $e');
      }
    }
  }

  _getLogAcesso() async {
    try {
      var isLog = await LogAcessoDao().isExiste();
      if (isLog['qtd'] > 0 && _isLembreMe) {
        var logAcesso = await LogAcessoDao().getLogAcesso();
        setState(() {
          loginCtrl.text = logAcesso['login'];
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('ERRO: (_getLogAcesso()) - $e');
      }
    }
  }

  _deleteUserPrevios() async {
    try {
      await UsuarioDao().deletePrevios();
    } catch (e) {
      if (kDebugMode) {
        print('ERRO: _deleteUserPrevios - $e');
      }
    }
  }

  Future<void> _login(BuildContext context) async {
    setState(() {
      loading.value = true;
      errorMessage = '';
    });
    if (loginCtrl.text.isEmpty || loginCtrl.text.trim() == '' || passwordCtrl.text.isEmpty || passwordCtrl.text.trim() == '') {
      setState(() {
        loading.value = false;
        errorMessage = '• Usuário ou senha não podem ser vazios!';
      });
      return;
    }
    String username = loginCtrl.text.trim();
    String password = passwordCtrl.text.trim();
    if (!(await Utility.isInternet())) {
      _loginOff(context, username, password, '');
    } else {
      _loginOn(context, username, password);
    }
  }

  Future<void> _loginOff(BuildContext context, String username, String password, String message) async {
    setState(() {
      loading.value = true;
      errorMessage = message;
    });
    try {
      var isExiste = await UsuarioDao().isExiste();
      if (isExiste['qtd'] > 0) {
        var isValido = await UsuarioDao().validarAcesso(username, password);
        if (isValido['qtd'] > 0) {
          var usuario = await UsuarioDao().logar(username, password);
          Utility.setUserNameProvider(context, username);
          Utility.setStatusUserProvider(context, '(offline)');
          if (usuario['token'] != null) {
            _saveToken(usuario['token']);
          }

          if (_isLembreMe) {
            var log = await LogAcessoDao().getLogAcesso();
            LogAcesso logAcesso = LogAcesso(id: log['id'], login: username, dataAlteracao: Utility.getDate());
            LogAcessoDao().update(logAcesso);
          }

          GoRouter.of(context).pushReplacement(AppRoutes.homeScreen);
          setState(() {
            loading.value = false;
          });
        } else {
          setState(() {
            loading.value = false;
            errorMessage = '• Credenciais inválidas.';
          });
        }
      } else {
        setState(() {
          loading.value = false;
          errorMessage = message + '• Acesso offline disponível após o primeiro login online!';
        });
      }
    } catch (e) {
      setState(() {
        loading.value = false;
        errorMessage = message + '• Erro durante a autenticação.';
      });
      if (context.mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _loginOn(BuildContext context, String username, String password) async {
    setState(() {
      loading.value = true;
      errorMessage = '';
    });
    try {
      final token = await LoginApiService.login(username, password);
      if (token != null) {
        _saveToken(token);

        Utility.setUserNameProvider(context, username);
        Utility.setStatusUserProvider(context, '');

        // var response = await SincronismoService().sincronizarAll(username);
        // if (response && kDebugMode) {
        //   print('Sincronismo finalizado!');
        // }

        if (_isLembreMe) {
            var log = await LogAcessoDao().getLogAcesso();
            LogAcesso logAcesso = LogAcesso(id: log['id'], login: username, dataAlteracao: Utility.getDate());
            LogAcessoDao().update(logAcesso);
          }

        if (context.mounted) {
          var timer = Timer(
              const Duration(seconds: 2),
              () async => {
                    GoRouter.of(context).pushReplacement(AppRoutes.homeScreen),
                    setState(() {
                      loading.value = false;
                    }),
                  });
          try {
            await UsuarioDao().deleteAll();
            await UsuarioDao().insert(Usuario(nome: username, login: username, senha: password, dataCadastro: Utility.getDate(), token: token));
          } catch (e) {
            if (kDebugMode) {
              print('ERRO: (insertUsuario) $e');
            }
            setState(() {
              loading.value = false;
              errorMessage = '• Erro ao cadastrar usuário off line.';
            });
          }
        }
      } else {
        setState(() {
          loading.value = false;
          errorMessage = '• Erro ao obter o token de acesso. Possível instabilidade na conexão.';
        });
        const message = '• Erro ao obter o token de acesso. Possível instabilidade na conexão.\n\n';
        _loginOff(context, username, password, message);
      }
    } catch (e) {
      setState(() {
        loading.value = false;
      });
      if (e is http.ClientException) {
        setState(() {
          errorMessage = '• Erro durante a autenticação. Tente novamente mais tarde.';
        });
      } else if (e is http.Response) {
        if (e.statusCode == 401) {
          try {
            final decodedBody = json.decode(utf8.decode(e.bodyBytes));
            setState(() {
              errorMessage = decodedBody['message'] ?? '• Credenciais inválidas.';
            });
          } catch (error) {
            setState(() {
              errorMessage = '• Erro durante a autenticação.';
            });
          }
        } else {
          setState(() {
            errorMessage = '• Erro durante a autenticação.';
          });
        }
      } else {
        setState(() {
          errorMessage = '• Credenciais inválidas.';
        });
      }
      if (context.mounted) {
        setState(() {});
      }
    }
  }

  void _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('jwtToken', token);
  }

  Widget imageLogo(BuildContext context) {
    return Image.asset(
      ImagensAssets.imagemLogo,
      fit: BoxFit.fitWidth,
      width: MediaQuery.sizeOf(context).width,
    );
  }

  Widget fieldUserName() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: loginCtrl,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.person),
        labelText: 'Usuário',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira seu usuário';
        }
        return null;
      },
      onChanged: (value) {
        loginCtrl.text = value.toUpperCase();
      },
    );
  }

  Widget fieldPassword() {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 8.0, 0),
          child: Icon(Icons.lock),
        ),
        labelText: 'Senha',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        alignLabelWithHint: true,
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        suffixIcon: IconButton(
          icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              isObscure = !isObscure;
            });
          },
        ),
      ),
      obscureText: isObscure,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira sua senha';
        }
        return null;
      },
      onSaved: (value) {
        passwordCtrl.text = value!;
      },
    );
  }

  Widget switchLembreMe() {
    return SwitchListTile(
      title: const Text(
        'Lembrar - me',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      value: _isLembreMe,
      onChanged: (bool value) async {
        setState(() {
          _isLembreMe = value;
          loading.value = true;
        });
        await ConfiguracaoDao().update(
          Configuracao(
            id: configuracao!['id'],
            isLembreMe: _isLembreMe ? 'SIM' : 'NAO',
            dataAlteracao: Utility.getDate(),
          ),
        );
        setState(() {
          loading.value = false;
        });
      },
    );
  }

  Widget btnAcessar() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.grey,
        elevation: 15,
        padding: const EdgeInsets.all(15),
        backgroundColor: Theme.of(context).colorScheme.primary,
        minimumSize: const Size(88, 36.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.0,
          ),
        ),
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          _login(context);
        }
      },
      child: const Text(
        'Acessar',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget messageError(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 15.0, 0.8, 0),
        child: Text(
          errorMessage!.toUpperCase(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: ValueListenableBuilder(
            valueListenable: loading,
            builder: (context, value, child) {
              if (value) {
                return const CircularProgressComponent();
              } else {
                return SingleChildScrollView(
                  child: SizedBox(
                    height: size.height,
                    width: size.width,
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            imageLogo(context),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32.0,
                                vertical: 40.0,
                              ),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    fieldUserName(),
                                    const SizedBox(height: 20),
                                    fieldPassword(),
                                    const SizedBox(height: 10),
                                    switchLembreMe(),
                                    const SizedBox(height: 10),
                                    btnAcessar(),
                                    errorMessage != null ? messageError(context) : Container(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Center(
                              child: Text('Versão ${infoApp['version']}'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
}
