// ignore_for_file: deprecated_member_use, unnecessary_to_list_in_spreads, use_build_context_synchronously, unnecessary_null_comparison, prefer_null_aware_operators

import "dart:async";

import "package:app_ppmob/app_routes.dart";
import "package:app_ppmob/src/component/circular_progress.dart";
import "package:app_ppmob/src/data/dao/fiscalizacao_dao.dart";
import "package:app_ppmob/src/model/fiscalizacao.dart";
import "package:app_ppmob/src/model/municipio.dart";
import "package:app_ppmob/src/model/rodovia.dart";
import "package:app_ppmob/src/screen/documentos_screen/painel_documentos_screen.dart";
import "package:app_ppmob/src/services/municipio_service.dart";
import "package:app_ppmob/src/services/provider/appbar_drawe_provider.dart";
import "package:app_ppmob/src/services/rodovia_service.dart";
import "package:app_ppmob/src/shared/constants/constants.dart";
import "package:app_ppmob/src/shared/util/input_mask/km_input_mask.dart";
import "package:app_ppmob/src/shared/util/utility.dart";
import "package:app_ppmob/src/shared/widget/camera_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:go_router/go_router.dart";
import "package:provider/provider.dart";

class LocalFiscalizacaoScreen extends StatefulWidget {
  const LocalFiscalizacaoScreen({super.key});

  @override
  State<LocalFiscalizacaoScreen> createState() => _LocalFiscalizacaoScreenState();
}

class _LocalFiscalizacaoScreenState extends State<LocalFiscalizacaoScreen> {
  final loading = ValueNotifier<bool>(true);
  final _formKey = GlobalKey<FormState>();
  String? errorMessage;
  final TextEditingController kmCtrl = TextEditingController();

  List<Municipio> listaMunicipio = [];
  Municipio? opcaoMunicipio;
  final TextEditingController municipioFilterCtrl = TextEditingController();
  List<Municipio> listaMunicipioFiltrada = [];
  bool isDropdownOpenedMunicipio = false;

  List<Rodovia> listaRodovia = [];
  Rodovia? opcaoRodovia;
  final TextEditingController rodoviaFilterCtrl = TextEditingController();
  List<Rodovia> listaRodoviaFiltrada = [];
  bool isDropdownOpenedRodovia = false;

  Fiscalizacao? fiscalizacao;

  Timer? _debounceMunicipio;
  Timer? _debounceRodovia;

  @override
  void initState() {
    super.initState();
    initScreen();
  }

  @override
  void dispose() {
    _debounceMunicipio?.cancel();
    municipioFilterCtrl.removeListener(_onSearchChanged);
    municipioFilterCtrl.dispose();

    _debounceRodovia?.cancel();
    rodoviaFilterCtrl.removeListener(_onSearchChangedRodovia);
    rodoviaFilterCtrl.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    if (_debounceMunicipio?.isActive ?? false) _debounceMunicipio!.cancel();
    _debounceMunicipio = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        listaMunicipioFiltrada = listaMunicipio.where((municipio) => municipio.nmmunicipio!.toLowerCase().contains(municipioFilterCtrl.text.toLowerCase())).toList();
      });
    });
  }

  _onSearchChangedRodovia() {
    if (_debounceRodovia?.isActive ?? false) _debounceRodovia!.cancel();
    _debounceRodovia = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        listaRodoviaFiltrada = listaRodovia.where((rodovia) => rodovia.sgrodovia!.toLowerCase().contains(rodoviaFilterCtrl.text.toLowerCase())).toList();
      });
    });
  }

  initScreen() async {
    Utility.updateTitle(context, TitleScreen.localFiscalizacao);
    await _carregarMunicipios();
    await _carregarRodovias();
    fiscalizacao = await findFiscalizacaoByStatus();
    await _carregarDadosSalvos();
  }

  Future<void> _carregarMunicipios() async {
    final municipioService = MunicipioService();
    listaMunicipio = await municipioService.getMunicipiosByEstado('SC');
    listaMunicipioFiltrada = listaMunicipio;
    municipioFilterCtrl.addListener(_onSearchChanged);
    setState(() {});
  }

  Future<void> _carregarRodovias() async {
    final rodoviaService = RodoviaService();
    listaRodovia = await rodoviaService.getRodovias();
    listaRodoviaFiltrada = listaRodovia;
    rodoviaFilterCtrl.addListener(_onSearchChangedRodovia);
    setState(() {});
  }

  _carregarDadosSalvos() {
    if (fiscalizacao!.nmMunicipioFiscalizacao != null) {
      opcaoMunicipio = listaMunicipio.firstWhere((municipio) => municipio.nmmunicipio!.toLowerCase().contains(fiscalizacao!.nmMunicipioFiscalizacao!.toLowerCase()));
    }
    if (fiscalizacao!.sgRodovia != null) {
      opcaoRodovia = listaRodovia.firstWhere((rodovia) => rodovia.sgrodovia!.toLowerCase().contains(fiscalizacao!.sgRodovia!.toLowerCase()));
    }
    if (fiscalizacao!.km != null) {
      kmCtrl.text = fiscalizacao!.km!;
    }
    setState(() {
      loading.value = false;
    });
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

  Widget dropDownMunicipio(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
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
    );
  }

  Widget dropDownRodovia(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: const Text(
              'Rodovia',
              style: TextStyle(
                fontSize: 12.0,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isDropdownOpenedRodovia = !isDropdownOpenedRodovia;
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
                    opcaoRodovia?.sgrodovia ?? 'Selecione uma Rodovia',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Icon(isDropdownOpenedRodovia ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          if (isDropdownOpenedRodovia)
            Column(
              children: [
                const SizedBox(height: 8),
                TextField(
                  controller: rodoviaFilterCtrl,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                    hintText: 'Filtrar Rodovia',
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
                    itemCount: listaRodoviaFiltrada.length,
                    itemBuilder: (context, index) {
                      final rodovia = listaRodoviaFiltrada[index];
                      return ListTile(
                        title: Text(rodovia.sgrodovia ?? ''),
                        onTap: () {
                          setState(() {
                            opcaoRodovia = rodovia;
                            isDropdownOpenedRodovia = false;
                            if (!isDropdownOpenedRodovia) {
                              rodoviaFilterCtrl.clear();
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
    );
  }

  Widget fieldKm() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: kmCtrl,
      inputFormatters: [
        KmInputMask(),
        LengthLimitingTextInputFormatter(12),
      ],
      decoration: const InputDecoration(
        // prefixIcon: Icon(Icons.track_changes),
        labelText: 'Km',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, informe o Km da Rodovia.';
        }
        return null;
      },
      onChanged: (value) {
        kmCtrl.text = value.toUpperCase();
      },
    );
  }

  Widget txtTituloDropDown(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        overflow: TextOverflow.clip,
      ),
    );
  }

  Widget txtErrorMessage() {
    return errorMessage != null
        ? Text(
            errorMessage!,
            style: TextStyle(
              overflow: TextOverflow.clip,
              color: Theme.of(context).colorScheme.error,
            ),
          )
        : Container();
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
          CameraWidget(idFiscalizacao: fiscalizacao?.id, descricao: TitleScreen.localFiscalizacao),
          IconButton(
            tooltip: '${TxtToolTip.btnFloatAvancar} veículo',
            splashColor: Theme.of(context).colorScheme.secondary,
            color: Theme.of(context).colorScheme.primary,
            iconSize: 35.0,
            icon: const Icon(Icons.save_rounded),
            onPressed: () async {
              if (opcaoMunicipio?.nmmunicipio == null) {
                setState(() {
                  errorMessage = 'Por favor, informe o município.';
                });
              } else if (opcaoRodovia?.sgrodovia == null) {
                setState(() {
                  errorMessage = 'Por favor, informe a rodovia.';
                });
              } else if (kmCtrl.text.trim() == '' || kmCtrl.text == null) {
                setState(() {
                  errorMessage = 'Por favor, informe o km da rodovia.';
                });
              } else {
                setState(() {
                  errorMessage = null;
                });
                try {
                  setState(() {
                    loading.value = true;
                  });
                  final fiscalizacaoAlterada = Fiscalizacao(
                    id: fiscalizacao!.id!,
                    nmMunicipioFiscalizacao: opcaoMunicipio!.nmmunicipio!,
                    ufMunicipioFiscalizacao: opcaoMunicipio!.sgunidadefederal!,
                    cdMunicipioFiscalizacao: opcaoMunicipio!.cdmunicipio!.toString(),
                    sgRodovia: opcaoRodovia!.sgrodovia!,
                    km: kmCtrl.text.trim(),
                    status: EstadoEntidade.pendente,
                    sincronizado: EstadoEntidade.naoSincronizado,
                    dataCadastro: Utility.getDateTime().toString(),
                    nmMunicipioUnidadeTransporte: fiscalizacao!.nmMunicipioUnidadeTransporte,
                    ufMunicipioUnidadeTransporte: fiscalizacao!.ufMunicipioUnidadeTransporte,
                    cdMunicipioUnidadeTransporte: fiscalizacao!.cdMunicipioUnidadeTransporte != null ? fiscalizacao!.cdMunicipioUnidadeTransporte.toString() : null,
                    placaUnidadeTransporte: fiscalizacao!.placaUnidadeTransporte,
                    renavanUnidadeTransporte: fiscalizacao!.renavanUnidadeTransporte,
                    marcaModeloUnidadeTransporte: fiscalizacao!.marcaModeloUnidadeTransporte,
                    condicaoUnidadeTransporte: fiscalizacao!.condicaoUnidadeTransporte,
                    equipamentoUnidadeTransporte: fiscalizacao!.equipamentoUnidadeTransporte,
                    tipoPessoaTransportador: fiscalizacao!.tipoPessoaTransportador,
                    nomeTransportador: fiscalizacao!.nomeTransportador,
                    cpfCnpjTransportador: fiscalizacao!.cpfCnpjTransportador,
                    nmMunicipioTransportador: fiscalizacao!.nmMunicipioTransportador,
                    ufMunicipioTransportador: fiscalizacao!.ufMunicipioTransportador,
                    cdMunicipioTransportador: fiscalizacao!.cdMunicipioTransportador,
                    nomeCondutor: fiscalizacao!.nomeCondutor,
                    cnhCondutor: fiscalizacao!.cnhCondutor,
                    cpfCondutor: fiscalizacao!.cpfCondutor,
                  );
                  await FiscalizacaoDao().update(fiscalizacaoAlterada);
                  GoRouter.of(context).pushReplacement(AppRoutes.transportadorScreen);
                  setState(() {
                    loading.value = false;
                  });
                } catch (e) {
                  setState(() {
                    loading.value = false;
                  });
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
        body: ValueListenableBuilder(
          valueListenable: loading,
          builder: (context, value, child) {
            if (value) {
              return const CircularProgressComponent();
            } else {
              return SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!isDropdownOpenedRodovia)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: dropDownMunicipio(context),
                                        ),
                                      ],
                                    ),
                                  if (!isDropdownOpenedMunicipio && !isDropdownOpenedRodovia) SizedBox(height: size.height * 0.01),
                                  if (!isDropdownOpenedMunicipio)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: dropDownRodovia(context),
                                        ),
                                      ],
                                    ),
                                  if (!isDropdownOpenedMunicipio && !isDropdownOpenedRodovia) SizedBox(height: size.height * 0.02),
                                  if (!isDropdownOpenedMunicipio && !isDropdownOpenedRodovia)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: fieldKm(),
                                        ),
                                      ],
                                    ),
                                  if (!isDropdownOpenedMunicipio && !isDropdownOpenedRodovia) txtErrorMessage(),
                                ],
                              ),
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
