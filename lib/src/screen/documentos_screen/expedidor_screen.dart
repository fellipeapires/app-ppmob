// ignore_for_file: unnecessary_null_comparison, deprecated_member_use

import 'dart:async';

import 'package:app_ppmob/app_routes.dart';
import 'package:app_ppmob/src/component/circular_progress.dart';
import 'package:app_ppmob/src/data/dao/expedidor_dao.dart';
import 'package:app_ppmob/src/data/dao/fiscalizacao_dao.dart';
import 'package:app_ppmob/src/model/expedidor.dart';
import 'package:app_ppmob/src/model/fiscalizacao.dart';
import 'package:app_ppmob/src/model/municipio.dart';
import 'package:app_ppmob/src/screen/documentos_screen/painel_documentos_screen.dart';
import 'package:app_ppmob/src/services/municipio_service.dart';
import 'package:app_ppmob/src/services/provider/appbar_drawe_provider.dart';
import 'package:app_ppmob/src/shared/constants/constants.dart';
import 'package:app_ppmob/src/shared/util/utility.dart';
import 'package:app_ppmob/src/shared/widget/camera_widget.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ExpedidorScreen extends StatefulWidget {
  const ExpedidorScreen({super.key});

  @override
  State<ExpedidorScreen> createState() => _ExpedidorScreenState();
}

class _ExpedidorScreenState extends State<ExpedidorScreen> {
  final loading = ValueNotifier<bool>(true);
  final _formKey = GlobalKey<FormState>();

  List<Municipio> listaMunicipio = [];
  Municipio? opcaoMunicipio;
  final TextEditingController municipioFilterCtrl = TextEditingController();
  List<Municipio> listaMunicipioFiltrada = [];
  bool isDropdownOpenedMunicipio = false;
  String? errorMessage;
  final TextEditingController nomeCtrl = TextEditingController();
  final TextEditingController cnpjCtrl = TextEditingController();
  final TextEditingController enderecoCtrl = TextEditingController();

  List<Expedidor> listaExpedidor = [];
  Fiscalizacao? fiscalizacao;

  Timer? _debounceMunicipio;

  @override
  void initState() {
    super.initState();
    initScreen();
  }

  @override
  void dispose() {
    nomeCtrl.dispose();
    cnpjCtrl.dispose();
    enderecoCtrl.dispose();
    municipioFilterCtrl.dispose();
    _debounceMunicipio?.cancel();
    municipioFilterCtrl.removeListener(_onSearchChangedTrans);
    super.dispose();
  }

  _onSearchChangedTrans() {
    if (_debounceMunicipio?.isActive ?? false) _debounceMunicipio!.cancel();
    _debounceMunicipio = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        listaMunicipioFiltrada = listaMunicipio.where((municipio) => municipio.nmmunicipio!.toLowerCase().contains(municipioFilterCtrl.text.toLowerCase())).toList();
      });
    });
  }

  initScreen() async {
    Utility.updateTitle(context, TitleScreen.expedidor);
    await _carregarMunicipios();
    fiscalizacao = await findFiscalizacaoByStatus();
    listaExpedidor = (await findAllExpedidorByFiscalizacao())!;
    setState(() {
      loading.value = false;
    });
  }

  Future<void> _carregarMunicipios() async {
    final municipioService = MunicipioService();
    listaMunicipio = await municipioService.getMunicipios();
    listaMunicipioFiltrada = listaMunicipio;
    municipioFilterCtrl.addListener(_onSearchChangedTrans);

    setState(() {});
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

  Widget fieldNome() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: nomeCtrl,
      decoration: const InputDecoration(
        labelText: 'Nome',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, informe o nome.';
        }
        return null;
      },
      onChanged: (value) {
        nomeCtrl.text = value.toUpperCase();
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
    );
  }

  Widget fieldCnpj() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: cnpjCtrl,
      decoration: const InputDecoration(
        labelText: 'CNPJ',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, informe o CNPJ.';
        }
        return null;
      },
      onChanged: (value) {
        cnpjCtrl.text = value.toUpperCase();
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(19),
        FilteringTextInputFormatter.digitsOnly,
        CnpjInputFormatter(),
      ],
    );
  }

  Widget fieldEndereco() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: enderecoCtrl,
      decoration: const InputDecoration(
        labelText: 'Endereco',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '';
        }
        return null;
      },
      onChanged: (value) {
        enderecoCtrl.text = value.toUpperCase();
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
    );
  }

  Widget btnOpenDialog(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: FloatingActionButton(
        heroTag: 'btnExpedidor',
        tooltip: 'Adicionar Expedidor',
        splashColor: Theme.of(context).colorScheme.secondary,
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPressed: () async {
          errorMessage = null;
          dialogExpedidor(context);
        },
        child: const FaIcon(
          FontAwesomeIcons.plus,
          // size: 50,
          color: Color(0xFF002358),
        ),
      ),
    );
  }

  void dialogExpedidor(BuildContext context) {
    final size = MediaQuery.of(context).size;
    isDropdownOpenedMunicipio = false;
    errorMessage = null;
    opcaoMunicipio = Municipio();
    municipioFilterCtrl.clear();
    nomeCtrl.clear();
    cnpjCtrl.clear();
    enderecoCtrl.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Expedidor'),
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
                    return Column(
                      children: [
                        if (!isDropdownOpenedMunicipio)
                          Row(
                            children: [
                              Expanded(
                                child: fieldNome(),
                              ),
                            ],
                          ),
                        if (!isDropdownOpenedMunicipio) SizedBox(height: size.height * 0.02),
                        if (!isDropdownOpenedMunicipio)
                          Row(
                            children: [
                              Expanded(
                                child: fieldCnpj(),
                              ),
                            ],
                          ),
                        if (!isDropdownOpenedMunicipio) SizedBox(height: size.height * 0.02),
                        if (!isDropdownOpenedMunicipio)
                          Row(
                            children: [
                              Expanded(
                                child: fieldEndereco(),
                              ),
                            ],
                          ),
                        if (!isDropdownOpenedMunicipio) SizedBox(height: size.height * 0.01),
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
                                        'Município',
                                        style: TextStyle(
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isDropdownOpenedMunicipio = !isDropdownOpenedMunicipio;
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
                                              opcaoMunicipio?.nmmunicipio != null ? '${opcaoMunicipio?.nmmunicipio} - ${opcaoMunicipio?.sgunidadefederal}' : 'Selecione um Município',
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                            Icon(isDropdownOpenedMunicipio ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (isDropdownOpenedMunicipio)
                                      Column(
                                        children: [
                                          const SizedBox(height: 8),
                                          TextField(
                                            controller: municipioFilterCtrl,
                                            onChanged: (value) => {
                                              setState(() {
                                                municipioFilterCtrl;
                                              }),
                                            },
                                            decoration: InputDecoration(
                                              prefixIcon: const Icon(Icons.search),
                                              isDense: true,
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                                              hintText: 'Filtrar município',
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
                                              itemCount: listaMunicipioFiltrada.length,
                                              itemBuilder: (context, index) {
                                                final municipio = listaMunicipioFiltrada[index];
                                                return ListTile(
                                                  title: Text(municipio.nmmunicipio != null ? '${municipio.nmmunicipio} - ${municipio.sgunidadefederal}' : ''),
                                                  onTap: () {
                                                    setState(() {
                                                      opcaoMunicipio = municipio;
                                                      isDropdownOpenedMunicipio = false;
                                                      if (!isDropdownOpenedMunicipio) {
                                                        municipioFilterCtrl.clear();
                                                      }
                                                    });
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
                        if (!isDropdownOpenedMunicipio) SizedBox(height: size.height * 0.01),
                        if (!isDropdownOpenedMunicipio)
                          Row(
                            children: [
                              Expanded(
                                child: txtErrorMessage(),
                              ),
                            ],
                          ),
                        if (!isDropdownOpenedMunicipio)
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
                                        if (nomeCtrl.text.trim() == '' || nomeCtrl.text == null) {
                                          setState(() {
                                            errorMessage = 'Por favor, informe o nome.';
                                          });
                                        } else if (cnpjCtrl.text.trim() == '' || cnpjCtrl.text == null) {
                                          setState(() {
                                            errorMessage = 'Por favor, informe o CNPJ.';
                                          });
                                        } else if (opcaoMunicipio?.nmmunicipio == null) {
                                          setState(() {
                                            errorMessage = 'Por favor, informe o município.';
                                          });
                                        } else {
                                          setState(() {
                                            errorMessage = null;
                                            loading.value = true;
                                          });
                                          Navigator.of(context).pop();
                                          await _salvar();
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
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          )
        : Container();
  }

  Widget listView() {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.8,
      child: listaExpedidor.isEmpty
          ? errorMessage != null
              ? txtErrorMessage()
              : Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Nenhum Expedidor cadastrado!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                )
          : ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: listaExpedidor.length,
              itemBuilder: (context, index) {
                final expedidor = listaExpedidor[index];
                return Card(
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
                              expedidor.nome ?? '',
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
                                Text('CNPJ: ${expedidor.cnpj ?? ''}'),
                                Text('Endereço: ${expedidor.endereco ?? ''}'),
                                Text('Município: ${expedidor.nmMunicipio ?? ''} - ${expedidor.ufMunicipio ?? ''}'),
                                const Divider(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  _salvar() async {
    setState(() {
      errorMessage = null;
      loading.value = true;
    });
    try {
      final expedidor = Expedidor(
        idFiscalizacao: fiscalizacao!.id!,
        nome: nomeCtrl.text,
        cnpj: cnpjCtrl.text,
        endereco: enderecoCtrl.text,
        nmMunicipio: opcaoMunicipio!.nmmunicipio!,
        ufMunicipio: opcaoMunicipio!.sgunidadefederal!,
        cdMunicipio: opcaoMunicipio!.cdmunicipio!.toString(),
        status: EstadoEntidade.pendente,
      );
      await ExpedidorDao().insert(expedidor);
      setState(() {
        loading.value = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('_salvar: $e');
      }
      setState(() {
        loading.value = false;
      });
    }
  }

  Future<void> _carregarDados() async {
    if (fiscalizacao!.id != null) {
      listaExpedidor = (await findAllExpedidorByFiscalizacao())!;
      setState(() {
        listaExpedidor;
        loading.value = false;
      });
    } else {
      setState(() {
        loading.value = false;
      });
    }
  }

  bool validationNextRoute() {
    if ((fiscalizacao!.cdMunicipioFiscalizacao != null && fiscalizacao!.nmMunicipioFiscalizacao != null && fiscalizacao!.ufMunicipioFiscalizacao != null) &&
        fiscalizacao!.placaUnidadeTransporte != null &&
        fiscalizacao!.renavanUnidadeTransporte != null &&
        fiscalizacao!.marcaModeloUnidadeTransporte != null &&
        fiscalizacao!.cdMunicipioUnidadeTransporte != null &&
        fiscalizacao!.nmMunicipioUnidadeTransporte != null &&
        fiscalizacao!.ufMunicipioUnidadeTransporte != null &&
        fiscalizacao!.condicaoUnidadeTransporte != null &&
        fiscalizacao!.equipamentoUnidadeTransporte != null &&
        fiscalizacao!.nomeCondutor != null &&
        fiscalizacao!.cnhCondutor != null &&
        fiscalizacao!.cpfCondutor != null) {
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
            tooltip: 'Adicionar Expedidor',
            splashColor: Theme.of(context).colorScheme.secondary,
            color: Theme.of(context).colorScheme.primary,
            iconSize: 30.0,
            icon: const FaIcon(
              FontAwesomeIcons.plus,
              color: Color(0xFF002358),
            ),
            onPressed: () async {
              errorMessage = null;
              dialogExpedidor(context);
            },
          ),
          CameraWidget(idFiscalizacao: fiscalizacao?.id, descricao: TitleScreen.expedidor),
          IconButton(
            tooltip: '${TxtToolTip.btnFloatAvancar} documento fiscal',
            splashColor: Theme.of(context).colorScheme.secondary,
            color: Theme.of(context).colorScheme.primary,
            iconSize: 35.0,
            icon: const Icon(Icons.save_rounded),
            onPressed: () async {
              if (listaExpedidor.isEmpty) {
                setState(() {
                  errorMessage = 'Por favor, insira ao menos um expedidor.';
                });
              } else {
                if (validationNextRoute()) {
                  GoRouter.of(context).pushReplacement(AppRoutes.documentoFiscalScreen);
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!loading.value) listView(),
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
