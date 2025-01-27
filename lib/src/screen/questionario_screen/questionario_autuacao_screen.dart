// ignore_for_file: avoid_print, deprecated_member_use, unnecessary_set_literal, avoid_function_literals_in_foreach_calls, must_be_immutable

import 'package:app_ppmob/src/model/infracao.dart';
import 'package:app_ppmob/src/screen/questionario_screen/painel_questionario_screen.dart';
import 'package:app_ppmob/src/services/infracao_service.dart';
import 'package:app_ppmob/src/services/provider/appbar_drawe_provider.dart';
import 'package:app_ppmob/src/shared/constants/constants.dart';
import 'package:app_ppmob/src/shared/util/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionarioAutuacaoScreen extends StatefulWidget {
  String? categoria;

  QuestionarioAutuacaoScreen({
    super.key,
    required this.categoria,
  });

  @override
  QuestionarioAutuacaoScreenState createState() => QuestionarioAutuacaoScreenState();
}

class QuestionarioAutuacaoScreenState extends State<QuestionarioAutuacaoScreen> {
  Map<String, bool> infracoes = {};
  List<Infracao> listaInfracao = [];
  String categoria = '';

  @override
  void initState() {
    super.initState();
    initScreen();
  }

  initScreen() async {
    Utility.updateTitle(context, TitleScreen.questionarioAutuacao);
    await _carregarInfracoes();
    await _carregarCheckListInfracoes();
    categoria = listaInfracao.isNotEmpty ? listaInfracao[0].categoria! : '';
  }

  Future<void> _carregarInfracoes() async {
    final infracaoService = InfracaoService();
    listaInfracao = await infracaoService.getInfracoesByCategoria(widget.categoria!.toString().toUpperCase());
    setState(() {});
  }

  Future<void> _carregarCheckListInfracoes() async {
    infracoes.clear();
    listaInfracao.forEach((element) {
      infracoes.addEntries([
        MapEntry('${element.resumo!}_OK', false),
        MapEntry('${element.resumo!}_Transportador', false),
        MapEntry('${element.resumo!}_Expedidor', false),
      ]);
    });
    setState(() {});
  }

  Widget checkListDocumentos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título antes da lista
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            categoria,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: listaInfracao.length,
            itemBuilder: (context, index) {
              final infracao = listaInfracao[index];
              final isTransportadorDisabled = infracao.enquadramentoTransp == 'Não há enquadramento para o transportador';
              final isExpedidorDisabled = infracao.enquadramentoExp == 'Não há enquadramento para o expedidor';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  Text(
                    infracao.resumo ?? 'Informativo',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text(
                            'OK',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          value: infracoes['${infracao.resumo!}_OK'] ?? false,
                          onChanged: (bool? value) {
                            setState(() {
                              infracoes['${infracao.resumo!}_OK'] = value ?? false;
                              if (value == true) {
                                infracoes['${infracao.resumo!}_Transportador'] = false;
                                infracoes['${infracao.resumo!}_Expedidor'] = false;
                              }
                            });
                            if (kDebugMode) {
                              print('------------------------------------------------------------------------------------------------------');
                              print(infracoes);
                              print('------------------------------------------------------------------------------------------------------');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          title: Text(
                            'Transportador    ${isTransportadorDisabled ? 'Não há enquadramento' : infracao.enquadramentoTransp!}   ${infracao.codTransportador! == 'Não há enquadramento para o transportador' ? '' : infracao.codTransportador!}',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          value: infracoes['${infracao.resumo!}_Transportador'] ?? false,
                          onChanged: isTransportadorDisabled
                              ? null
                              : (bool? value) {
                                  setState(() {
                                    infracoes['${infracao.resumo!}_Transportador'] = value ?? false;
                                    if (value == true) {
                                      infracoes['${infracao.resumo!}_OK'] = false;
                                    }
                                  });
                                  if (kDebugMode) {
                                    print('------------------------------------------------------------------------------------------------------');
                                    print(infracoes);
                                    print('------------------------------------------------------------------------------------------------------');
                                  }
                                },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          title: Text(
                            'Expedidor          ${isExpedidorDisabled ? 'Não há enquadramento' : infracao.enquadramentoExp!}   ${infracao.codExpedidor! == 'Não há enquadramento para o expedidor' ? '' : infracao.codExpedidor!}',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          value: infracoes['${infracao.resumo!}_Expedidor'] ?? false,
                          onChanged: isExpedidorDisabled
                              ? null
                              : (bool? value) {
                                  setState(() {
                                    infracoes['${infracao.resumo!}_Expedidor'] = value ?? false;
                                    if (value == true) {
                                      infracoes['${infracao.resumo!}_OK'] = false;
                                    }
                                  });
                                  if (kDebugMode) {
                                    print('------------------------------------------------------------------------------------------------------');
                                    print(infracoes);
                                    print('------------------------------------------------------------------------------------------------------');
                                  }
                                },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const PainelQuestionarioScreen()),
          (Route<dynamic> route) => true,
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Consumer<AppbarProvider>(
            builder: (context, appBarProvider, _) {
              return appBarProvider.appBarWidget;
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: checkListDocumentos(),
        ),
      ),
    );
  }
}
