// ignore_for_file: deprecated_member_use, unnecessary_null_comparison, unnecessary_string_interpolations, avoid_function_literals_in_foreach_calls, avoid_print, unused_local_variable, prefer_typing_uninitialized_variables, use_build_context_synchronously, prefer_if_null_operators

import 'dart:async';

import 'package:app_ppmob/app_routes.dart';
import 'package:app_ppmob/src/component/circular_progress.dart';
import 'package:app_ppmob/src/data/dao/documento_fiscal_dao.dart';
import 'package:app_ppmob/src/data/dao/expedidor_dao.dart';
import 'package:app_ppmob/src/data/dao/fiscalizacao_dao.dart';
import 'package:app_ppmob/src/data/dao/item_documento_fiscal_dao.dart';
import 'package:app_ppmob/src/model/documento_fiscal.dart';
import 'package:app_ppmob/src/model/expedidor.dart';
import 'package:app_ppmob/src/model/fiscalizacao.dart';
import 'package:app_ppmob/src/model/item_documento_fiscal.dart';
import 'package:app_ppmob/src/screen/documentos_screen/detalhe_documento_fiscal_screen.dart';
import 'package:app_ppmob/src/screen/documentos_screen/painel_documentos_screen.dart';
import 'package:app_ppmob/src/screen/questionario_screen/painel_questionario_screen.dart';
import 'package:app_ppmob/src/services/provider/appbar_drawe_provider.dart';
import 'package:app_ppmob/src/shared/constants/constants.dart';
import 'package:app_ppmob/src/shared/util/input_mask/qtd_double_input_mask.dart';
import 'package:app_ppmob/src/shared/util/input_mask/qtd_integer_input_mask.dart';
import 'package:app_ppmob/src/shared/util/utility.dart';
import 'package:app_ppmob/src/shared/widget/camera_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DocumentoFiscalScreen extends StatefulWidget {
  const DocumentoFiscalScreen({super.key});

  @override
  State<DocumentoFiscalScreen> createState() => _DocumentoFiscalScreenState();
}

class _DocumentoFiscalScreenState extends State<DocumentoFiscalScreen> {
  final loading = ValueNotifier<bool>(true);
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<DateTime?> dataSelecionada = ValueNotifier<DateTime?>(null);

  List<Expedidor> listaExpedidor = [];
  Expedidor? opcaoExpedidor;
  final TextEditingController expedidorFilterCtrl = TextEditingController();
  List<Expedidor> listaExpedidorFiltrada = [];
  bool isDropdownOpenedExpedidor = false;

  String? errorMessage;
  String? errorDialogMessage;
  String? errorItemDialogMessage;

  final TextEditingController numeroFiscalCtrl = TextEditingController();
  final TextEditingController valorCtrl = TextEditingController();

  List<DocumentoFiscal> listaDocFiscal = [];
  Fiscalizacao? fiscalizacao;
  DocumentoFiscal? documentoFiscal;

  Timer? _debounceExpedidor;

  List<ItemDocumentoFiscal> itens = [];

  bool isItem = false;
  bool isAddItem = false;

  final TextEditingController descItemCtrl = TextEditingController();
  final TextEditingController numOnuItemCtrl = TextEditingController();
  final TextEditingController codRiscoItemCtrl = TextEditingController();
  final TextEditingController classeItemCtrl = TextEditingController();
  final TextEditingController qtdItemCtrl = TextEditingController();
  final TextEditingController valorUniItemCtrl = TextEditingController();
  final TextEditingController valorTotalItemCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    initScreen();
  }

  @override
  void dispose() {
    numeroFiscalCtrl.dispose();
    valorCtrl.dispose();
    dataSelecionada.dispose();
    expedidorFilterCtrl.dispose();
    _debounceExpedidor?.cancel();
    expedidorFilterCtrl.removeListener(_onSearchChangedExpedidor);
    descItemCtrl.dispose();
    numOnuItemCtrl.dispose();
    codRiscoItemCtrl.dispose();
    classeItemCtrl.dispose();
    qtdItemCtrl.dispose();
    valorUniItemCtrl.dispose();
    valorTotalItemCtrl.dispose();
    super.dispose();
  }

  initScreen() async {
    Utility.updateTitle(context, TitleScreen.documentoFiscal);
    fiscalizacao = await findFiscalizacaoByStatus();
    await _criarDocumentoFiscal();
    documentoFiscal = await findDocumentoFiscalByIdFiscalizacao();
    listaDocFiscal = (await findAllDocFiscalByFiscalizacao())!;
    await _carregarExpedidor();
    await _deleteAllItemDocFiscal();
    setState(() {
      loading.value = false;
    });
  }

  _onSearchChangedExpedidor() {
    if (_debounceExpedidor?.isActive ?? false) _debounceExpedidor!.cancel();
    _debounceExpedidor = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        listaExpedidorFiltrada = listaExpedidor.where((expedidor) => expedidor.nome!.toLowerCase().contains(expedidorFilterCtrl.text.toLowerCase())).toList();
      });
    });
  }

  Future<void> _deleteAllItemDocFiscal() async {
    try {
      await ItemDocumentoFiscalDao().deleteAll();
    } catch (e) {
      if (kDebugMode) {
        print('_deleteAllItemDocFiscal: $e');
      }
    }
  }

  Future<void> _carregarExpedidor() async {
    listaExpedidor = (await findAllExpedidorByFiscalizacao())!;
    listaExpedidorFiltrada = listaExpedidor;
    expedidorFilterCtrl.addListener(_onSearchChangedExpedidor);
    setState(() {});
  }

  Future<Fiscalizacao?> findFiscalizacaoByStatus() async {
    try {
      final fiscalizacao = await FiscalizacaoDao().findByStatus(EstadoEntidade.pendente);
      return fiscalizacao;
    } catch (e) {
      if (kDebugMode) {
        print('findByPendente: $e');
      }
    }
    return null;
  }

  Future<List<Expedidor>?> findAllExpedidorByFiscalizacao() async {
    try {
      final List<Expedidor>? lista = await ExpedidorDao().findAllByIdFiscalizacao(fiscalizacao!.id!);
      return lista;
    } catch (e) {
      if (kDebugMode) {
        print('findAllExpedidorByFiscalizacao: $e');
      }
    }
    return [];
  }

  Future<Expedidor?> findExpedidorById(int idExpedidor) async {
    try {
      final expedidor = await ExpedidorDao().findById(idExpedidor);
      return expedidor;
    } catch (e) {
      if (kDebugMode) {
        print('findExpedidorById: $e');
      }
    }
    return null;
  }

  Future<DocumentoFiscal?> findDocumentoFiscalByIdFiscalizacao() async {
    try {
      final documentoFiscal = await DocumentoFiscalDao().findByIdFiscalizacaoKey(fiscalizacao!.id!);
      return documentoFiscal;
    } catch (e) {
      if (kDebugMode) {
        print('findDocumentoFiscalByIdFiscalizacao: $e');
      }
    }
    return null;
  }

  Future<List<DocumentoFiscal>?> findAllDocFiscalByFiscalizacao() async {
    try {
      final List<DocumentoFiscal>? lista = await DocumentoFiscalDao().findAllByIdFiscalizacao(fiscalizacao!.id!);
      return lista;
    } catch (e) {
      if (kDebugMode) {
        print('findAllDocFiscalByFiscalizacao: $e');
      }
    }
    return [];
  }

  Future<List<ItemDocumentoFiscal>?> findAllItemByIdDocumentoFiscal() async {
    try {
      final List<ItemDocumentoFiscal>? lista = await ItemDocumentoFiscalDao().findAllByIdDocumentoFiscal(documentoFiscal!.id!);
      return lista;
    } catch (e) {
      if (kDebugMode) {
        print('findAllItemByIdDocumentoFiscal: $e');
      }
    }
    return [];
  }

  Future<List<ItemDocumentoFiscal>?> findAllItemByIdDocFiscalDetalhe(int idDocFiscal) async {
    try {
      final List<ItemDocumentoFiscal>? lista = await ItemDocumentoFiscalDao().findAllByIdDocumentoFiscal(idDocFiscal);
      return lista;
    } catch (e) {
      if (kDebugMode) {
        print('findAllItemByIdDocFiscalDetalhe: $e');
      }
    }
    return [];
  }

  _criarDocumentoFiscal() async {
    setState(() {
      loading.value = true;
    });
    try {
      final isDocFiscal = await DocumentoFiscalDao().isExiste();
      if (isDocFiscal['qtd'] == 0) {
        final docFiscal = DocumentoFiscal(
          idFiscalizacao: fiscalizacao!.id!,
        );
        await DocumentoFiscalDao().insert(docFiscal);
      }
    } catch (e) {
      if (kDebugMode) {
        print('_criarDocumentoFiscal: $e');
      }
      setState(() {
        loading.value = false;
      });
    }
  }

  _salvarDocFiscal() async {
    setState(() {
      errorMessage = null;
      loading.value = true;
    });
    try {
      final docFiscal = DocumentoFiscal(
        id: documentoFiscal!.id!,
        idFiscalizacao: fiscalizacao!.id!,
        idExpedidor: opcaoExpedidor!.id,
        nomeExpedidor: opcaoExpedidor!.nome,
        numeroFiscal: numeroFiscalCtrl.text,
        dataSaida: dataSelecionada.value.toString(),
        valor: valorCtrl.text,
        status: EstadoEntidade.pendente,
      );
      await DocumentoFiscalDao().update(docFiscal);
      await _criarDocumentoFiscal();
      documentoFiscal = await findDocumentoFiscalByIdFiscalizacao();
      setState(() {
        loading.value = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('_salvarDocFiscal: $e');
      }
      setState(() {
        loading.value = false;
      });
    }
  }

  Widget txtDialogErrorMessage() {
    return errorDialogMessage != null
        ? Container(
            alignment: Alignment.center,
            child: Text(
              errorDialogMessage!,
              style: TextStyle(
                overflow: TextOverflow.clip,
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          )
        : Container();
  }

  Widget txtItemDialogErrorMessage() {
    return errorItemDialogMessage != null
        ? Container(
            alignment: Alignment.center,
            child: Text(
              errorItemDialogMessage!,
              style: TextStyle(
                overflow: TextOverflow.clip,
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          )
        : Container();
  }

  void validateIsItem() {
    if (opcaoExpedidor?.nome == null || numeroFiscalCtrl.text.trim() == '' || numeroFiscalCtrl.text == null || dataSelecionada.value == null) {
      setState(() {
        isItem = false;
      });
    } else {
      setState(() {
        isItem = true;
      });
    }
  }

  void calculateValueItem() {
    if (valorUniItemCtrl.text == null || valorUniItemCtrl.text.isEmpty || qtdItemCtrl.text == null || qtdItemCtrl.text.isEmpty) {
      valorTotalItemCtrl.text = '0';
    } else {
      valorTotalItemCtrl.text = (double.parse(valorUniItemCtrl.text) * double.parse(qtdItemCtrl.text)).toStringAsFixed(2);
    }
  }

  Future<void> deleteAllItens() async {
    try {
      await ItemDocumentoFiscalDao().deleteAllByIdDocumento(documentoFiscal!.id!);
    } catch (e) {
      if (kDebugMode) {
        print('deleteAllItensByIdFiscalizacao: $e');
      }
    }
  }

  Widget btnOpenDialog(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: FloatingActionButton(
        heroTag: 'btnDocFiscal',
        tooltip: 'Adicionar Documento Fiscal',
        splashColor: Theme.of(context).colorScheme.secondary,
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPressed: () async {
          errorMessage = null;
          dialogDocFiscal(context);
        },
        child: const FaIcon(
          FontAwesomeIcons.plus,
          // size: 50,
          color: Color(0xFF002358),
        ),
      ),
    );
  }

  void dialogDocFiscal(BuildContext context) {
    final size = MediaQuery.of(context).size;
    isDropdownOpenedExpedidor = false;
    errorDialogMessage = null;
    errorItemDialogMessage = null;
    opcaoExpedidor = Expedidor();
    expedidorFilterCtrl.clear();
    numeroFiscalCtrl.clear();
    valorCtrl.clear();
    dataSelecionada.value = null;
    itens = [];
    isAddItem = false;
    isItem = false;
    descItemCtrl.clear();
    numOnuItemCtrl.clear();
    codRiscoItemCtrl.clear();
    classeItemCtrl.clear();
    qtdItemCtrl.clear();
    valorUniItemCtrl.clear();
    valorTotalItemCtrl.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Documento Fiscal'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return isAddItem
                        ? SingleChildScrollView(
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Adicionar Item',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: SizedBox(
                                        width: size.width * 0.90,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: numOnuItemCtrl,
                                            inputFormatters: [
                                              QtdIntegerInputMask(),
                                              LengthLimitingTextInputFormatter(14),
                                            ],
                                            decoration: const InputDecoration(
                                              labelText: 'Nº Onu',
                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                            ),
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Por favor, informe o Nº Onu.';
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {
                                              numOnuItemCtrl.text = value.toUpperCase();
                                              setState(() {
                                                errorItemDialogMessage = null;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: SizedBox(
                                        width: size.width * 0.90,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: codRiscoItemCtrl,
                                            inputFormatters: [
                                              QtdIntegerInputMask(),
                                              LengthLimitingTextInputFormatter(14),
                                            ],
                                            decoration: const InputDecoration(
                                              labelText: 'Nº Risco',
                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                            ),
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Por favor, informe o Código de Risco Fiscal.';
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {
                                              codRiscoItemCtrl.text = value.toUpperCase();
                                              setState(() {
                                                errorItemDialogMessage = null;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: SizedBox(
                                        width: size.width * 0.90,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: classeItemCtrl,
                                            inputFormatters: [
                                              QtdIntegerInputMask(),
                                              LengthLimitingTextInputFormatter(14),
                                            ],
                                            decoration: const InputDecoration(
                                              labelText: 'Classe',
                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                            ),
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Por favor, informe a Classe.';
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {
                                              classeItemCtrl.text = value.toUpperCase();
                                              setState(() {
                                                errorItemDialogMessage = null;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    // Flexible(
                                    //   child: SizedBox(
                                    //     width: size.width * 0.45,
                                    //     child: Padding(
                                    //       padding: const EdgeInsets.fromLTRB(0.0, 8.0, 4.0, 8.0),
                                    //       child: TextFormField(
                                    //         keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    //         controller: valorUniItemCtrl,
                                    //         inputFormatters: [
                                    //           QtdDoubleInputMask(),
                                    //           LengthLimitingTextInputFormatter(14),
                                    //         ],
                                    //         decoration: const InputDecoration(
                                    //           labelText: 'R\$ Unitário',
                                    //           floatingLabelBehavior: FloatingLabelBehavior.always,
                                    //           border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                    //         ),
                                    //         validator: (value) {
                                    //           if (value == null || value.isEmpty) {
                                    //             return 'Por favor, informe o valor unitário.';
                                    //           }
                                    //           return null;
                                    //         },
                                    //         onChanged: (value) {
                                    //           valorUniItemCtrl.text = value.toUpperCase();
                                    //           setState(() {
                                    //             errorItemDialogMessage = null;
                                    //           });
                                    //           calculateValueItem();
                                    //         },
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    Flexible(
                                      child: SizedBox(
                                        width: size.width * 0.90,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: qtdItemCtrl,
                                            inputFormatters: [
                                              QtdDoubleInputMask(),
                                              LengthLimitingTextInputFormatter(12),
                                            ],
                                            decoration: const InputDecoration(
                                              labelText: 'Quantidade',
                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                            ),
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Por favor, informe a Quatidade.';
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {
                                              qtdItemCtrl.text = value.toUpperCase();
                                              setState(() {
                                                errorItemDialogMessage = null;
                                              });
                                              // calculateValueItem();
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: SizedBox(
                                        width: size.width * 0.90,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                          child: TextFormField(
                                            readOnly: false,
                                            keyboardType: TextInputType.number,
                                            controller: valorTotalItemCtrl,
                                            inputFormatters: [
                                              QtdDoubleInputMask(),
                                              LengthLimitingTextInputFormatter(14),
                                            ],
                                            decoration: const InputDecoration(
                                              labelText: 'R\$ Total',
                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                            ),
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Por favor, informe o valor total.';
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {
                                              valorTotalItemCtrl.text = value.toUpperCase();
                                              setState(() {
                                                errorItemDialogMessage = null;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: SizedBox(
                                        width: size.width * 0.90,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                          child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            controller: descItemCtrl,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(50),
                                            ],
                                            decoration: const InputDecoration(
                                              labelText: 'Descrição',
                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                            ),
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Por favor, informe a Descrição.';
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {
                                              descItemCtrl.text = value.toUpperCase();
                                              setState(() {
                                                errorItemDialogMessage = null;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: txtItemDialogErrorMessage(),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: SizedBox(
                                        width: size.width * 0.45,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                shadowColor: Colors.grey,
                                                elevation: 15,
                                                padding: const EdgeInsets.all(12),
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
                                              onPressed: () async {
                                                setState(() {
                                                  isAddItem = false;
                                                });
                                              },
                                              child: const Text(
                                                'Voltar',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: SizedBox(
                                        width: size.width * 0.45,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                shadowColor: Colors.grey,
                                                elevation: 15,
                                                padding: const EdgeInsets.all(12),
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
                                              onPressed: () async {
                                                try {
                                                  // if (descItemCtrl.text == null || descItemCtrl.text.isEmpty) {
                                                  //   setState(() {
                                                  //     errorItemDialogMessage = 'Por favor, informe a descrição.';
                                                  //   });
                                                  // } else
                                                  if (qtdItemCtrl.text == null || qtdItemCtrl.text.isEmpty) {
                                                    setState(() {
                                                      errorItemDialogMessage = 'Por favor, informe a quantidade.';
                                                    });
                                                  } else if (numOnuItemCtrl.text == null || numOnuItemCtrl.text.isEmpty) {
                                                    setState(() {
                                                      errorItemDialogMessage = 'Por favor, informe o Nº Onu.';
                                                    });
                                                  } else if (classeItemCtrl.text == null || classeItemCtrl.text.isEmpty) {
                                                    setState(() {
                                                      errorItemDialogMessage = 'Por favor, informe a classe.';
                                                    });
                                                  } else if (codRiscoItemCtrl.text == null || codRiscoItemCtrl.text.isEmpty) {
                                                    setState(() {
                                                      errorItemDialogMessage = 'Por favor, informe o código de risco.';
                                                    });
                                                  }
                                                  // else if (valorUniItemCtrl.text == null || valorUniItemCtrl.text.isEmpty) {
                                                  //   setState(() {
                                                  //     errorItemDialogMessage = 'Por favor, informe o valor unitário.';
                                                  //   });
                                                  // }
                                                  else if (valorTotalItemCtrl.text == null || valorTotalItemCtrl.text.isEmpty) {
                                                    setState(() {
                                                      errorItemDialogMessage = 'Por favor, informe o valor total.';
                                                    });
                                                  } else {
                                                    setState(() {
                                                      errorItemDialogMessage = null;
                                                      loading.value = true;
                                                    });
                                                    await ItemDocumentoFiscalDao().insert(ItemDocumentoFiscal(
                                                      idFiscalizacao: fiscalizacao!.id!,
                                                      idExpedidor: opcaoExpedidor!.id!,
                                                      idDocumentoFiscal: documentoFiscal?.id,
                                                      descricao: descItemCtrl.text.isEmpty ? null : descItemCtrl.text,
                                                      numeroOnu: numOnuItemCtrl.text,
                                                      codRisco: codRiscoItemCtrl.text,
                                                      classe: classeItemCtrl.text,
                                                      quantidade: qtdItemCtrl.text,
                                                      valorUnitario: valorUniItemCtrl.text.isEmpty ? null : valorUniItemCtrl.text,
                                                      valorTotal: valorTotalItemCtrl.text,
                                                      status: EstadoEntidade.pendente,
                                                    ));
                                                    itens = (await findAllItemByIdDocumentoFiscal())!;
                                                    setState(() {
                                                      loading.value = false;
                                                      isAddItem = false;
                                                    });
                                                    double total = 0.0;
                                                    itens.forEach((item) {
                                                      total += double.parse(item.valorTotal.toString());
                                                    });
                                                    setState(() {
                                                      valorCtrl.text = total.toString();
                                                    });
                                                  }
                                                } catch (e) {
                                                  if (kDebugMode) {
                                                    print('salvar item: $e');
                                                  }
                                                }
                                              },
                                              child: const Text(
                                                'Adicionar',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                            child: const Text(
                                              'Expedidor',
                                              style: TextStyle(
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isDropdownOpenedExpedidor = !isDropdownOpenedExpedidor;
                                              });
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    opcaoExpedidor?.nome != null ? '${opcaoExpedidor?.nome}' : 'Selecione um Expedidor',
                                                    style: const TextStyle(fontSize: 16),
                                                  ),
                                                  Icon(isDropdownOpenedExpedidor ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                                                ],
                                              ),
                                            ),
                                          ),
                                          if (isDropdownOpenedExpedidor)
                                            Column(
                                              children: [
                                                const SizedBox(height: 8),
                                                TextField(
                                                  controller: expedidorFilterCtrl,
                                                  onChanged: (value) => {
                                                    setState(() {
                                                      expedidorFilterCtrl;
                                                    }),
                                                  },
                                                  decoration: InputDecoration(
                                                    prefixIcon: const Icon(Icons.search),
                                                    isDense: true,
                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                                                    hintText: 'Filtrar Expedidor',
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: size.height * 0.50,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.grey),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: ListView.builder(
                                                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                                                    itemCount: listaExpedidorFiltrada.length,
                                                    itemBuilder: (context, index) {
                                                      final municipio = listaExpedidorFiltrada[index];
                                                      return ListTile(
                                                        title: Text(municipio.nome != null ? '${municipio.nome}' : ''),
                                                        onTap: () {
                                                          errorDialogMessage = null;
                                                          setState(() {
                                                            opcaoExpedidor = municipio;
                                                            isDropdownOpenedExpedidor = false;
                                                            if (!isDropdownOpenedExpedidor) {
                                                              expedidorFilterCtrl.clear();
                                                            }
                                                          });
                                                          validateIsItem();
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (!isDropdownOpenedExpedidor) SizedBox(height: size.height * 0.02),
                              if (!isDropdownOpenedExpedidor)
                                Row(
                                  children: [
                                    Flexible(
                                      child: SizedBox(
                                        width: size.width * 0.45,
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: numeroFiscalCtrl,
                                          inputFormatters: [
                                            QtdIntegerInputMask(),
                                            LengthLimitingTextInputFormatter(14),
                                          ],
                                          decoration: const InputDecoration(
                                            labelText: 'Nº Fiscal',
                                            floatingLabelBehavior: FloatingLabelBehavior.always,
                                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Por favor, informe o Nº Fiscal.';
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            numeroFiscalCtrl.text = value.toUpperCase();
                                            setState(() {
                                              errorDialogMessage = null;
                                            });
                                            validateIsItem();
                                          },
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: SizedBox(
                                        width: size.width * 0.45,
                                        child: Container(
                                            margin: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                            child: GestureDetector(
                                              onTap: () async {
                                                setState(() {
                                                  errorDialogMessage = null;
                                                });
                                                DateTime? data = await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(2000),
                                                  lastDate: DateTime(2100),
                                                  builder: (context, child) {
                                                    return Theme(
                                                      data: Theme.of(context).copyWith(
                                                        colorScheme: ColorScheme.light(
                                                          primary: Theme.of(context).colorScheme.primary,
                                                          onPrimary: Colors.white,
                                                          onSurface: Colors.black,
                                                        ),
                                                      ),
                                                      child: child!,
                                                    );
                                                  },
                                                );
                                                if (data != null) {
                                                  dataSelecionada.value = data;
                                                }
                                                if (opcaoExpedidor?.nome == null || numeroFiscalCtrl.text.trim() == '' || numeroFiscalCtrl.text == null || dataSelecionada.value == null) {
                                                  setState(() {
                                                    isItem = false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    isItem = true;
                                                  });
                                                }
                                              },
                                              child: ValueListenableBuilder<DateTime?>(
                                                valueListenable: dataSelecionada,
                                                builder: (context, value, child) {
                                                  return TextFormField(
                                                    enabled: false,
                                                    style: const TextStyle(color: Colors.black),
                                                    decoration: const InputDecoration(
                                                      labelText: 'Data de Saída',
                                                      hintText: 'Selecione a data',
                                                      prefixIcon: Icon(Icons.calendar_today),
                                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                                      labelStyle: TextStyle(color: Colors.black),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                        borderSide: BorderSide(color: Colors.black),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                        borderSide: BorderSide(color: Colors.black),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                                                      ),
                                                    ),
                                                    controller: TextEditingController(
                                                      text: value != null ? '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}' : '',
                                                    ),
                                                  );
                                                },
                                              ),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              if (!isDropdownOpenedExpedidor) SizedBox(height: size.height * 0.02),
                              if (!isDropdownOpenedExpedidor)
                                Row(
                                  children: [
                                    Flexible(
                                      child: SizedBox(
                                        width: size.width * 0.75,
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: valorCtrl,
                                          decoration: const InputDecoration(
                                            labelText: 'Valor R\$',
                                            floatingLabelBehavior: FloatingLabelBehavior.always,
                                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                          ),
                                          readOnly: true,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return '';
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            valorCtrl.text = value.toUpperCase();
                                            validateIsItem();
                                          },
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                          child: FloatingActionButton(
                                            heroTag: 'btnItem',
                                            tooltip: 'Adicionar Produto',
                                            splashColor: Theme.of(context).colorScheme.secondary,
                                            backgroundColor: isItem ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                            foregroundColor: isItem ? Colors.white : Colors.white.withOpacity(0.5),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            onPressed: () async {
                                              errorDialogMessage = null;
                                              if (isItem) {
                                                setState(() {
                                                  isAddItem = true;
                                                  errorItemDialogMessage = null;
                                                  descItemCtrl.clear();
                                                  numOnuItemCtrl.clear();
                                                  codRiscoItemCtrl.clear();
                                                  classeItemCtrl.clear();
                                                  qtdItemCtrl.clear();
                                                  valorUniItemCtrl.clear();
                                                  valorTotalItemCtrl.clear();
                                                });
                                              }
                                            },
                                            child: const Icon(Icons.add),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              if (!isDropdownOpenedExpedidor) SizedBox(height: size.height * 0.01),
                              if (!isDropdownOpenedExpedidor)
                                Expanded(
                                  child: Column(
                                    children: [
                                      SizedBox(height: size.height * 0.01),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: itens.length,
                                          itemBuilder: (context, index) {
                                            final item = itens[index];
                                            return ListTile(
                                              title: Text(item.descricao ?? 'DESCRICAO NAO INFORMADA'),
                                              subtitle: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text('Nº Onu: ${item.numeroOnu ?? ''}'),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text('Nº Risco: ${item.codRisco ?? ''}'),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text('Classe: ${item.classe ?? ''}'),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text('Qtd: ${item.quantidade ?? ''}'),
                                                      Text('Valor Total: ${item.valorTotal ?? ''}'),
                                                    ],
                                                  ),
                                                  // Row(
                                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  //   children: [
                                                  //     Text('Valor Unit: ${item.valorUnitario ?? ''}'),
                                                  //     Text('Valor Total: ${item.valorTotal ?? ''}'),
                                                  //   ],
                                                  // ),
                                                  const Divider(),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (!isDropdownOpenedExpedidor) SizedBox(height: size.height * 0.01),
                              if (!isDropdownOpenedExpedidor)
                                Row(
                                  children: [
                                    Expanded(
                                      child: txtDialogErrorMessage(),
                                    ),
                                  ],
                                ),
                              if (!isDropdownOpenedExpedidor)
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shadowColor: Colors.grey,
                                              elevation: 15,
                                              padding: const EdgeInsets.all(12),
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
                                            onPressed: () async {
                                              if (opcaoExpedidor?.nome == null) {
                                                setState(() {
                                                  errorDialogMessage = 'Por favor, informe o expedidor.';
                                                });
                                              } else if (numeroFiscalCtrl.text.trim() == '' || numeroFiscalCtrl.text == null) {
                                                setState(() {
                                                  errorDialogMessage = 'Por favor, informe o Nº fiscal.';
                                                });
                                              } else if (dataSelecionada.value == null) {
                                                setState(() {
                                                  errorDialogMessage = 'Por favor, informe a data de saída';
                                                });
                                              } else if (valorCtrl.text.trim() == '' || valorCtrl.text == null) {
                                                setState(() {
                                                  errorDialogMessage = 'Por favor, insira ao menos um produto.';
                                                });
                                              } else {
                                                setState(() {
                                                  errorDialogMessage = null;
                                                  loading.value = true;
                                                });
                                                Navigator.of(context).pop();
                                                await _salvarDocFiscal();
                                              }
                                            },
                                            child: const Text(
                                              'Salvar',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget txtErrorMessage() {
    return errorMessage != null
        ? Container(
            alignment: Alignment.center,
            child: Text(
              errorMessage!,
              style: TextStyle(
                overflow: TextOverflow.clip,
                color: Theme.of(context).colorScheme.error,
                // fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          )
        : Container();
  }

  Widget getListViewDocFiscal() {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.8,
      child: listaDocFiscal.isEmpty
          ? errorMessage != null
              ? txtErrorMessage()
              : Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Nenhum Documento fiscal cadastrado!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                )
          : ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: listaDocFiscal.length,
              itemBuilder: (context, index) {
                final elementDocFiscal = listaDocFiscal[index];
                return GestureDetector(
                  onTap: () async {
                    try {
                      final expedidor = await findExpedidorById(elementDocFiscal.idExpedidor!);
                      final listaItemDocFiscal = await findAllItemByIdDocFiscalDetalhe(elementDocFiscal.id!);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalheDocumentoFiscalScreen(
                            numeroFiscal: elementDocFiscal.numeroFiscal ?? '',
                            dataSaida: Utility.getDatePtBr(DateTime.parse(elementDocFiscal.dataSaida.toString())) ?? '',
                            valor: double.parse(elementDocFiscal.valor!).toStringAsFixed(2),
                            nomeExpedidor: expedidor?.nome ?? '',
                            cnpjExpedidor: expedidor?.cnpj ?? '',
                            enderecoExpedidor: expedidor?.endereco ?? '',
                            municipioExpedidor: expedidor?.nmMunicipio ?? '',
                            nomeTransportadora: fiscalizacao!.nomeTransportador != null && fiscalizacao!.nomeTransportador.toString().trim() != '' ? fiscalizacao!.nomeTransportador : 'PARTICULAR',
                            cnpjTransportadora: fiscalizacao!.cpfCnpjTransportador != null ? fiscalizacao!.cpfCnpjTransportador : '',
                            municipioTransportadora: fiscalizacao!.nmMunicipioTransportador != null ? fiscalizacao!.nmMunicipioTransportador : '',
                            itens: listaItemDocFiscal!.isNotEmpty ? listaItemDocFiscal : [],
                          ),
                        ),
                      );
                    } catch (e) {
                      if (kDebugMode) {
                        print('card Go Router detalheDocumentoFiscalScreen - $e');
                      }
                    }
                  },
                  child: Card(
                    elevation: 8,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        color: Colors.white54,
                        width: 3.0,
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                'Nº Fiscal: ${elementDocFiscal.numeroFiscal ?? ''}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(
                                    endIndent: MediaQuery.of(context).size.width * 0.2,
                                  ),
                                  Text(elementDocFiscal.nomeExpedidor != null ? elementDocFiscal.nomeExpedidor.toString() : ''),
                                  Text('Data Saída: ${elementDocFiscal.dataSaida != null ? Utility.getDatePtBr(DateTime.parse(elementDocFiscal.dataSaida.toString())) : ''}'),
                                  Text('Valor: ${elementDocFiscal.valor != null ? double.parse(elementDocFiscal.valor!).toStringAsFixed(2) : ''}'),
                                  const Divider(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _carregarDados() async {
    if (fiscalizacao!.id != null) {
      listaDocFiscal = (await findAllDocFiscalByFiscalizacao())!;
      setState(() {
        listaDocFiscal;
        loading.value = false;
      });
    } else {
      setState(() {
        loading.value = false;
      });
    }
  }

  bool isNextAvancar() {
    if (listaDocFiscal.isNotEmpty &&
        (fiscalizacao!.cdMunicipioFiscalizacao != null && fiscalizacao!.nmMunicipioFiscalizacao != null && fiscalizacao!.ufMunicipioFiscalizacao != null) &&
        fiscalizacao!.placaUnidadeTransporte != null &&
        fiscalizacao!.renavanUnidadeTransporte != null &&
        fiscalizacao!.marcaModeloUnidadeTransporte != null &&
        fiscalizacao!.cdMunicipioUnidadeTransporte != null &&
        fiscalizacao!.nmMunicipioUnidadeTransporte != null &&
        fiscalizacao!.ufMunicipioUnidadeTransporte != null &&
        fiscalizacao!.nomeCondutor != null &&
        fiscalizacao!.cnhCondutor != null &&
        fiscalizacao!.cpfCondutor != null &&
        (/*fiscalizacao!.categoriaVeiculo == 'Particular' ||*/ fiscalizacao!.nomeTransportador != null && fiscalizacao!.cpfCnpjTransportador != null && fiscalizacao!.nmMunicipioTransportador != null)) {
      return true;
    } else {
      return false;
    }
  }

  Widget bottomNavigationBar(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BottomAppBar(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      height: size.height * 0.07,
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            tooltip: 'Adicionar Documento Fiscal',
            splashColor: Theme.of(context).colorScheme.secondary,
            color: Theme.of(context).colorScheme.primary,
            iconSize: 30.0,
            icon: const FaIcon(
              FontAwesomeIcons.plus,
              // size: 50,
              color: Color(0xFF002358),
            ),
            onPressed: () async {
              errorMessage = null;
              await deleteAllItens();
              dialogDocFiscal(context);
            },
          ),
          CameraWidget(idFiscalizacao: fiscalizacao?.id, descricao: TitleScreen.documentoFiscal),
          IconButton(
            tooltip: TxtToolTip.btnFloatAvancarCheckList,
            splashColor: Theme.of(context).colorScheme.secondary,
            color: Theme.of(context).colorScheme.primary,
            iconSize: 30.0,
            icon: const FaIcon(
              FontAwesomeIcons.share,
              color: Color(0xFF002358),
            ),
            onPressed: () async {
              if (listaDocFiscal.isEmpty) {
                setState(() {
                  errorMessage = 'Por favor, insira ao menos um documento fiscal.';
                });
              } else {
                if (isNextAvancar()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PainelQuestionarioScreen(),
                    ),
                  );
                } else {
                  GoRouter.of(context).pushReplacement(AppRoutes.painelDocumentosScreen);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const PainelDocumentosScreen()),
          (Route<dynamic> route) => true,
        );
        return true;
      },
      child: Scaffold(
        bottomNavigationBar: !loading.value ? bottomNavigationBar(context) : null,
        appBar: AppBar(
          titleSpacing: 0,
          title: Consumer<AppbarProvider>(
            builder: (context, appBarProvider, _) {
              return appBarProvider.appBarWidget;
            },
          ),
        ),
        body: FutureBuilder<void>(
          future: _carregarDados(),
          builder: (context, snapshot) {
            if (loading.value) {
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
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (!loading.value) getListViewDocFiscal(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
