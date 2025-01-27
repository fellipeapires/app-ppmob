// ignore_for_file: deprecated_member_use, use_build_context_synchronously, unnecessary_null_comparison, prefer_null_aware_operators, avoid_unnecessary_containers, sort_child_properties_last

import 'dart:async';

import 'package:app_ppmob/app_routes.dart';
import 'package:app_ppmob/src/component/circular_progress.dart';
import 'package:app_ppmob/src/data/dao/fiscalizacao_dao.dart';
import 'package:app_ppmob/src/data/dao/unidade_acoplada_dao.dart';
import 'package:app_ppmob/src/model/condicao.dart';
import 'package:app_ppmob/src/model/fiscalizacao.dart';
import 'package:app_ppmob/src/model/municipio.dart';
import 'package:app_ppmob/src/model/equipamento_transporte.dart';
import 'package:app_ppmob/src/model/unidade_acoplada.dart';
import 'package:app_ppmob/src/screen/documentos_screen/painel_documentos_screen.dart';
import 'package:app_ppmob/src/services/condicao_service.dart';
import 'package:app_ppmob/src/services/municipio_service.dart';
import 'package:app_ppmob/src/services/provider/appbar_drawe_provider.dart';
import 'package:app_ppmob/src/services/equipamento_transporte_service.dart';
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

class TransportadorScreen extends StatefulWidget {
  const TransportadorScreen({super.key});

  @override
  State<TransportadorScreen> createState() => _TransportadorScreenState();
}

class _TransportadorScreenState extends State<TransportadorScreen> {
  final loading = ValueNotifier<bool>(true);
  final _formKey = GlobalKey<FormState>();
  String? errorMessage;

  List<Municipio> listaMunicipio = [];
  List<Condicao> listaCondicao = [];
  List<EquipamentoTransporte> listaEquipamento = [];
  List<UnidadeAcoplada> listaUnidAcop = [];
  Fiscalizacao? fiscalizacao;
  final PageController _pageController = PageController(viewportFraction: 0.9);

  final TextEditingController placaUnidTransCtrl = TextEditingController();
  final TextEditingController renavanUnidTransCtrl = TextEditingController();
  final TextEditingController marcaModeloUnidTransCtrl = TextEditingController();

  Municipio? opcaoMunicipioUnidTrans;
  final TextEditingController municipioUnidTransFilterCtrl = TextEditingController();
  List<Municipio> listaMunicipioUnidTransFiltrados = [];
  bool isDropdownMunicipioUnidTrans = false;

  EquipamentoTransporte? opcaoEquipamentoUnidTrans;
  final TextEditingController equipamentoUnidTransFilterCtrl = TextEditingController();
  List<EquipamentoTransporte> listaEquipamentoUnidTransFiltrada = [];
  bool isDropdownEquipamentoUnidTrans = false;

  Condicao? opcaoCondicaoUnidTrans;
  final TextEditingController condicaoUnidTransFilterCtrl = TextEditingController();
  List<Condicao> listaCondicaoUnidTransFiltrada = [];
  bool isDropdownCondicaoUnidTrans = false;

  Timer? _debounceEquipamentoUnidTrans;
  Timer? _debounceCondicaoUnidTrans;
  Timer? _debounceMunicipioUnidTrans;

  Municipio? opcaoMunicipioTrans;
  final TextEditingController municipioTransFilterCtrl = TextEditingController();
  List<Municipio> listaMunicipiosTransFiltrados = [];
  bool isDropdownMunicipioTrans = false;

  final TextEditingController nomeTransportadorCtrl = TextEditingController();
  final TextEditingController cpfCnpjTransportadorCtrl = TextEditingController();

  String? _tipoPessoaTransportador = 'F';
  Timer? _debounceMunicipioTrans;

  final _formKeyUnidAcoplada = GlobalKey<FormState>();

  Municipio? opcaoMunicipioUnidAcop;
  final TextEditingController municipioUnidAcopFilterCtrl = TextEditingController();
  List<Municipio> listaMunicipiosUnidAcopFiltrados = [];
  bool isDropdownMunicipioUnidAcop = false;

  EquipamentoTransporte? opcaoEquipamentoUnidAcop;
  final TextEditingController equipamentoUnidAcopFilterCtrl = TextEditingController();
  List<EquipamentoTransporte> listaEquipamentoUnidAcopFiltrada = [];
  bool isDropdownEquipamentoUnidAcop = false;

  Condicao? opcaoCondicaoUnidAcop;
  final TextEditingController condicaoUnidAcopFilterCtrl = TextEditingController();
  List<Condicao> listaCondicaoUnidAcopFiltrada = [];
  bool isDropdownCondicaoUnidAcop = false;

  final TextEditingController placaUnidAcopCtrl = TextEditingController();

  String? unidadeAcopladaErrorMessage;
  Timer? _debounceMunicipioUnidAcop;
  Timer? _debounceEquipamentoUnidAcop;
  Timer? _debounceCondicaoUnidAcop;

  @override
  void initState() {
    super.initState();
    initScreen();
  }

  @override
  void dispose() {
    placaUnidTransCtrl.dispose();
    renavanUnidTransCtrl.dispose();
    marcaModeloUnidTransCtrl.dispose();

    _debounceCondicaoUnidTrans?.cancel();
    condicaoUnidTransFilterCtrl.removeListener(_onSearchChangedCondicaoUnidTrans);
    condicaoUnidTransFilterCtrl.dispose();

    _debounceEquipamentoUnidTrans?.cancel();
    equipamentoUnidTransFilterCtrl.removeListener(_onSearchChangedEquipamentoUnidTrans);
    equipamentoUnidTransFilterCtrl.dispose();

    _debounceMunicipioUnidTrans?.cancel();
    municipioUnidTransFilterCtrl.removeListener(_onSearchChangedUnidTrans);
    municipioUnidTransFilterCtrl.dispose();

    nomeTransportadorCtrl.dispose();
    cpfCnpjTransportadorCtrl.dispose();

    municipioTransFilterCtrl.dispose();
    _debounceMunicipioTrans?.cancel();
    municipioTransFilterCtrl.removeListener(_onSearchChangedTrans);

    placaUnidAcopCtrl.dispose();

    _debounceCondicaoUnidAcop?.cancel();
    condicaoUnidAcopFilterCtrl.removeListener(_onSearchChangedCondicaoUnidAcop);
    condicaoUnidAcopFilterCtrl.dispose();

    _debounceEquipamentoUnidAcop?.cancel();
    equipamentoUnidAcopFilterCtrl.removeListener(_onSearchChangedEquipamentoUnidAcop);
    equipamentoUnidAcopFilterCtrl.dispose();

    _debounceMunicipioUnidAcop?.cancel();
    municipioUnidAcopFilterCtrl.removeListener(_onSearchChangedUnidAcop);
    municipioUnidAcopFilterCtrl.dispose();

    _pageController.dispose();
    super.dispose();
  }

  _onSearchChangedUnidTrans() {
    if (_debounceMunicipioUnidTrans?.isActive ?? false) _debounceMunicipioUnidTrans!.cancel();
    _debounceMunicipioUnidTrans = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        listaMunicipioUnidTransFiltrados = listaMunicipio.where((municipio) => municipio.nmmunicipio!.toLowerCase().contains(municipioUnidTransFilterCtrl.text.toLowerCase())).toList();
      });
    });
  }

  _onSearchChangedCondicaoUnidTrans() {
    if (_debounceCondicaoUnidTrans?.isActive ?? false) _debounceCondicaoUnidTrans!.cancel();
    _debounceCondicaoUnidTrans = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        listaCondicaoUnidTransFiltrada = listaCondicao.where((categoria) => categoria.nmCondicao!.toLowerCase().contains(condicaoUnidTransFilterCtrl.text.toLowerCase())).toList();
      });
    });
  }

  _onSearchChangedEquipamentoUnidTrans() {
    if (_debounceEquipamentoUnidTrans?.isActive ?? false) _debounceEquipamentoUnidTrans!.cancel();
    _debounceEquipamentoUnidTrans = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        listaEquipamentoUnidTransFiltrada = listaEquipamento.where((equipamento) => equipamento.nmEquipamentoTransporte!.toLowerCase().contains(equipamentoUnidTransFilterCtrl.text.toLowerCase())).toList();
      });
    });
  }

  _onSearchChangedUnidAcop() {
    if (_debounceMunicipioUnidAcop?.isActive ?? false) _debounceMunicipioUnidAcop!.cancel();
    _debounceMunicipioUnidAcop = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        listaMunicipiosUnidAcopFiltrados = listaMunicipio.where((municipio) => municipio.nmmunicipio!.toLowerCase().contains(municipioUnidAcopFilterCtrl.text.toLowerCase())).toList();
      });
    });
  }

  _onSearchChangedCondicaoUnidAcop() {
    if (_debounceCondicaoUnidAcop?.isActive ?? false) _debounceCondicaoUnidAcop!.cancel();
    _debounceCondicaoUnidAcop = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        listaCondicaoUnidAcopFiltrada = listaCondicao.where((condicao) => condicao.nmCondicao!.toLowerCase().contains(condicaoUnidAcopFilterCtrl.text.toLowerCase())).toList();
      });
    });
  }

  _onSearchChangedEquipamentoUnidAcop() {
    if (_debounceEquipamentoUnidAcop?.isActive ?? false) _debounceEquipamentoUnidAcop!.cancel();
    _debounceEquipamentoUnidAcop = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        listaEquipamentoUnidAcopFiltrada = listaEquipamento.where((equipamento) => equipamento.nmEquipamentoTransporte!.toLowerCase().contains(equipamentoUnidAcopFilterCtrl.text.toLowerCase())).toList();
      });
    });
  }

  _onSearchChangedTrans() {
    if (_debounceMunicipioTrans?.isActive ?? false) _debounceMunicipioTrans!.cancel();
    _debounceMunicipioTrans = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        listaMunicipiosTransFiltrados = listaMunicipio.where((municipio) => municipio.nmmunicipio!.toLowerCase().contains(municipioTransFilterCtrl.text.toLowerCase())).toList();
      });
    });
  }

  initScreen() async {
    Utility.updateTitle(context, TitleScreen.transportador);
    await _carregarMunicipios();
    await _carregarCondicao();
    await _carregarEquipamentoTransporte();
    fiscalizacao = await findFiscalizacaoByStatus();
    await _carregarDadosSalvos();
  }

  Future<void> _carregarMunicipios() async {
    final municipioService = MunicipioService();
    listaMunicipio = await municipioService.getMunicipios();

    listaMunicipioUnidTransFiltrados = listaMunicipio;
    municipioUnidTransFilterCtrl.addListener(_onSearchChangedUnidTrans);

    listaMunicipiosUnidAcopFiltrados = listaMunicipio;
    municipioUnidAcopFilterCtrl.addListener(_onSearchChangedUnidAcop);

    listaMunicipiosTransFiltrados = listaMunicipio;
    municipioTransFilterCtrl.addListener(_onSearchChangedTrans);

    setState(() {});
  }

  Future<void> _carregarCondicao() async {
    final condicaoService = CondicaoService();
    listaCondicao = await condicaoService.getCondicao();

    listaCondicaoUnidTransFiltrada = listaCondicao;
    condicaoUnidTransFilterCtrl.addListener(_onSearchChangedCondicaoUnidTrans);

    listaCondicaoUnidAcopFiltrada = listaCondicao;
    condicaoUnidAcopFilterCtrl.addListener(_onSearchChangedCondicaoUnidAcop);

    setState(() {});
  }

  Future<void> _carregarEquipamentoTransporte() async {
    final equipamentoTransporteService = EquipamentoTransporteService();
    listaEquipamento = await equipamentoTransporteService.getEquipamentoTransporte();

    listaEquipamentoUnidTransFiltrada = listaEquipamento;
    equipamentoUnidTransFilterCtrl.addListener(_onSearchChangedEquipamentoUnidTrans);

    listaEquipamentoUnidAcopFiltrada = listaEquipamento;
    equipamentoUnidAcopFilterCtrl.addListener(_onSearchChangedEquipamentoUnidAcop);

    setState(() {});
  }

  _carregarDadosSalvos() {
    if (fiscalizacao!.placaUnidadeTransporte != null) {
      placaUnidTransCtrl.text = fiscalizacao!.placaUnidadeTransporte!;
    }
    if (fiscalizacao!.renavanUnidadeTransporte != null) {
      renavanUnidTransCtrl.text = fiscalizacao!.renavanUnidadeTransporte!;
    }
    if (fiscalizacao!.marcaModeloUnidadeTransporte != null) {
      marcaModeloUnidTransCtrl.text = fiscalizacao!.marcaModeloUnidadeTransporte!;
    }
    if (fiscalizacao!.nmMunicipioUnidadeTransporte != null) {
      opcaoMunicipioUnidTrans = listaMunicipio.firstWhere((municipio) => municipio.nmmunicipio!.toLowerCase().contains(fiscalizacao!.nmMunicipioUnidadeTransporte!.toLowerCase()));
    }
    if (fiscalizacao!.nomeTransportador != null) {
      nomeTransportadorCtrl.text = fiscalizacao!.nomeTransportador!;
    }
    if (fiscalizacao!.cpfCnpjTransportador != null) {
      cpfCnpjTransportadorCtrl.text = fiscalizacao!.cpfCnpjTransportador!;
    }
    if (fiscalizacao!.nmMunicipioTransportador != null) {
      opcaoMunicipioTrans = listaMunicipio.firstWhere((municipio) => municipio.nmmunicipio!.toLowerCase().contains(fiscalizacao!.nmMunicipioTransportador!.toLowerCase()));
    }
    if (fiscalizacao!.tipoPessoaTransportador != null) {
      _tipoPessoaTransportador = fiscalizacao!.tipoPessoaTransportador;
    }
    if (fiscalizacao!.condicaoUnidadeTransporte != null) {
      opcaoCondicaoUnidTrans = listaCondicao.firstWhere((condicao) => condicao.nmCondicao!.toLowerCase().contains(fiscalizacao!.condicaoUnidadeTransporte!.toLowerCase()));
    }
    if (fiscalizacao!.equipamentoUnidadeTransporte != null) {
      opcaoEquipamentoUnidTrans = listaEquipamento.firstWhere((equipamento) => equipamento.nmEquipamentoTransporte!.toLowerCase().contains(fiscalizacao!.equipamentoUnidadeTransporte!.toLowerCase()));
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

  Future<List<UnidadeAcoplada>?> findAllUnidAcoplaByFiscalizacao() async {
    try {
      final List<UnidadeAcoplada>? lista = await UnidadeAcopladaDao().findAllByIdFiscalizacao(fiscalizacao!.id!);
      return lista;
    } catch (e) {
      if (kDebugMode) {
        print('findAllUnidAcoplaByFiscalizacao: $e');
      }
    }
    return [];
  }

  Widget fieldPlacaUnidadeTrans() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: placaUnidTransCtrl,
      decoration: const InputDecoration(
        labelText: 'Placa Unid. Transporte',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, informe a placa do veículo.';
        }
        return null;
      },
      onChanged: (value) {
        placaUnidTransCtrl.text = value.toUpperCase();
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(7),
      ],
    );
  }

  Widget fieldRenavanUnidadeTrans() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: renavanUnidTransCtrl,
      decoration: const InputDecoration(
        labelText: 'Renavan Unid. Transporte',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, informe o renavan do veículo.';
        }
        return null;
      },
      onChanged: (value) {
        renavanUnidTransCtrl.text = value.toUpperCase();
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(11),
      ],
    );
  }

  Widget fieldMarcaModeloUnidadeTrans() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: marcaModeloUnidTransCtrl,
      decoration: const InputDecoration(
        labelText: 'Marca/Modelo Unid. Transporte',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, informe a marca do veículo.';
        }
        return null;
      },
      onChanged: (value) {
        marcaModeloUnidTransCtrl.text = value.toUpperCase();
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(35),
      ],
    );
  }

  Widget dropDownMunicipioUnidadeTrans(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: const Text(
              'Município Unid. Transporte',
              style: TextStyle(
                fontSize: 12.0,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isDropdownMunicipioUnidTrans = !isDropdownMunicipioUnidTrans;
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
                    opcaoMunicipioUnidTrans?.nmmunicipio != null ? '${opcaoMunicipioUnidTrans?.nmmunicipio} - ${opcaoMunicipioUnidTrans?.sgunidadefederal}' : 'Selecione um Município',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Icon(isDropdownMunicipioUnidTrans ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          if (isDropdownMunicipioUnidTrans)
            Column(
              children: [
                const SizedBox(height: 8),
                TextField(
                  controller: municipioUnidTransFilterCtrl,
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
                    itemCount: listaMunicipioUnidTransFiltrados.length,
                    itemBuilder: (context, index) {
                      final municipio = listaMunicipioUnidTransFiltrados[index];
                      return ListTile(
                        title: Text(municipio.nmmunicipio != null ? '${municipio.nmmunicipio} - ${municipio.sgunidadefederal}' : ''),
                        onTap: () {
                          setState(() {
                            opcaoMunicipioUnidTrans = municipio;
                            isDropdownMunicipioUnidTrans = false;
                            if (!isDropdownMunicipioUnidTrans) {
                              municipioUnidTransFilterCtrl.clear();
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

  Widget dropDownCondicao(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: const Text(
              'Condição',
              style: TextStyle(
                fontSize: 12.0,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isDropdownCondicaoUnidTrans = !isDropdownCondicaoUnidTrans;
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
                    opcaoCondicaoUnidTrans?.nmCondicao ?? 'Selecione uma Condição',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Icon(isDropdownCondicaoUnidTrans ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          if (isDropdownCondicaoUnidTrans)
            Column(
              children: [
                const SizedBox(height: 8),
                TextField(
                  controller: condicaoUnidTransFilterCtrl,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                    hintText: 'Filtrar Condição',
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
                    itemCount: listaCondicaoUnidTransFiltrada.length,
                    itemBuilder: (context, index) {
                      final categoria = listaCondicaoUnidTransFiltrada[index];
                      return ListTile(
                        title: Text(categoria.nmCondicao ?? ''),
                        onTap: () {
                          setState(() {
                            opcaoCondicaoUnidTrans = categoria;
                            isDropdownCondicaoUnidTrans = false;
                            if (!isDropdownCondicaoUnidTrans) {
                              condicaoUnidTransFilterCtrl.clear();
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

  Widget dropDownEquiTrans(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: const Text(
              'Equipamento de Transporte',
              style: TextStyle(
                fontSize: 12.0,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isDropdownEquipamentoUnidTrans = !isDropdownEquipamentoUnidTrans;
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
                    opcaoEquipamentoUnidTrans?.nmEquipamentoTransporte ?? 'Selecione o Equipamento de Transporte',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Icon(isDropdownEquipamentoUnidTrans ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          if (isDropdownEquipamentoUnidTrans)
            Column(
              children: [
                const SizedBox(height: 8),
                TextField(
                  controller: equipamentoUnidTransFilterCtrl,
                  onChanged: (value) => {
                    setState(() {
                      equipamentoUnidTransFilterCtrl;
                    }),
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                    hintText: 'Filtrar Equipamento de Transporte',
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
                    itemCount: listaEquipamentoUnidTransFiltrada.length,
                    itemBuilder: (context, index) {
                      final tipoCarga = listaEquipamentoUnidTransFiltrada[index];
                      return ListTile(
                        title: Text(tipoCarga.nmEquipamentoTransporte ?? ''),
                        onTap: () {
                          setState(() {
                            opcaoEquipamentoUnidTrans = tipoCarga;
                            isDropdownEquipamentoUnidTrans = false;
                            if (!isDropdownEquipamentoUnidTrans) {
                              equipamentoUnidTransFilterCtrl.clear();
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

  Widget fieldNomeTransportador() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: nomeTransportadorCtrl,
      decoration: const InputDecoration(
        labelText: 'Nome Transportador',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, informe o nome do transportador.';
        }
        return null;
      },
      onChanged: (value) {
        nomeTransportadorCtrl.text = value.toUpperCase();
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
    );
  }

  Widget radioButtomPessoa() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Row(
              children: [
                Radio<String>(
                  value: "F",
                  groupValue: _tipoPessoaTransportador,
                  onChanged: (String? valor) {
                    setState(() {
                      _tipoPessoaTransportador = valor;
                      cpfCnpjTransportadorCtrl.clear();
                    });
                  },
                ),
                const Text('Pessoa Física'),
              ],
            ),
            const SizedBox(width: 5),
            Row(
              children: [
                Radio<String>(
                  value: "J",
                  groupValue: _tipoPessoaTransportador,
                  onChanged: (String? valor) {
                    setState(() {
                      _tipoPessoaTransportador = valor;
                      cpfCnpjTransportadorCtrl.clear();
                    });
                  },
                ),
                const Text('Pessoa Jurídica'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget fieldCpfCnpjTransportador() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: cpfCnpjTransportadorCtrl,
      decoration: InputDecoration(
        // prefixIcon: Icon(Icons.track_changes),
        labelText: _tipoPessoaTransportador == 'F' ? 'CPF' : 'CNPJ',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, informe o CNPJ.';
        }
        return null;
      },
      onChanged: (value) {
        cpfCnpjTransportadorCtrl.text = value.toUpperCase();
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(19),
        FilteringTextInputFormatter.digitsOnly,
        _tipoPessoaTransportador! == 'F' ? CpfInputFormatter() : CnpjInputFormatter(),
      ],
    );
  }

  Widget dropDownMunicipioTrans(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: const Text(
              'Município Transportador',
              style: TextStyle(
                fontSize: 12.0,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isDropdownMunicipioTrans = !isDropdownMunicipioTrans;
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
                    opcaoMunicipioTrans?.nmmunicipio != null ? '${opcaoMunicipioTrans?.nmmunicipio} - ${opcaoMunicipioTrans?.sgunidadefederal}' : 'Selecione um Município',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Icon(isDropdownMunicipioTrans ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          if (isDropdownMunicipioTrans)
            Column(
              children: [
                const SizedBox(height: 8),
                TextField(
                  controller: municipioTransFilterCtrl,
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
                    itemCount: listaMunicipiosTransFiltrados.length,
                    itemBuilder: (context, index) {
                      final municipio = listaMunicipiosTransFiltrados[index];
                      return ListTile(
                        title: Text(municipio.nmmunicipio != null ? '${municipio.nmmunicipio} - ${municipio.sgunidadefederal}' : ''),
                        onTap: () {
                          setState(() {
                            opcaoMunicipioTrans = municipio;
                            isDropdownMunicipioTrans = false;
                            if (!isDropdownMunicipioTrans) {
                              municipioTransFilterCtrl.clear();
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

  Widget txtErrorMessage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 4.0),
      child: errorMessage != null
          ? Text(
              errorMessage!,
              style: TextStyle(
                overflow: TextOverflow.clip,
                color: Theme.of(context).colorScheme.error,
              ),
            )
          : Container(),
    );
  }

  Widget btnOpenDialogUnid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: FloatingActionButton(
        heroTag: 'btnUnid',
        tooltip: 'Adicionar Unidade Acoplada',
        splashColor: Theme.of(context).colorScheme.secondary,
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPressed: () async {
          if (placaUnidTransCtrl.text.trim() == '' ||
              placaUnidTransCtrl.text == null ||
              renavanUnidTransCtrl.text.trim() == '' ||
              renavanUnidTransCtrl.text == null ||
              marcaModeloUnidTransCtrl.text.trim() == '' ||
              marcaModeloUnidTransCtrl.text == null ||
              opcaoMunicipioUnidTrans?.nmmunicipio == null ||
              opcaoCondicaoUnidTrans?.nmCondicao == null ||
              opcaoEquipamentoUnidTrans?.nmEquipamentoTransporte == null) {
            setState(() {
              errorMessage = 'Por favor, informe os dados do veículo \npara inserir a unidade acoplada.';
            });
          } else {
            if (fiscalizacao!.placaUnidadeTransporte == null ||
                fiscalizacao!.renavanUnidadeTransporte == null ||
                fiscalizacao!.marcaModeloUnidadeTransporte == null ||
                fiscalizacao!.nmMunicipioUnidadeTransporte == null ||
                fiscalizacao!.condicaoUnidadeTransporte == null ||
                fiscalizacao!.equipamentoUnidadeTransporte == null) {
              await _salvarTransportador();
            }
            dialogUnidadeAcoplada(context);
          }
        },
        child: const FaIcon(
          FontAwesomeIcons.truckLoading,
          // size: 50,
          color: Color(0xFF002358),
        ),
      ),
    );
  }

  void dialogUnidadeAcoplada(BuildContext context) {
    final size = MediaQuery.of(context).size;
    opcaoMunicipioUnidAcop = Municipio();
    municipioUnidAcopFilterCtrl.clear();
    placaUnidAcopCtrl.clear();
    opcaoCondicaoUnidAcop = Condicao();
    condicaoUnidAcopFilterCtrl.clear();
    opcaoEquipamentoUnidAcop = EquipamentoTransporte();
    equipamentoUnidAcopFilterCtrl.clear();
    isDropdownMunicipioUnidAcop = false;
    isDropdownEquipamentoUnidTrans = false;
    isDropdownCondicaoUnidTrans = false;
    isDropdownMunicipioUnidTrans = false;
    unidadeAcopladaErrorMessage = null;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Unidade Acoplada'),
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
                key: _formKeyUnidAcoplada,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      children: [
                        if (!isDropdownMunicipioUnidAcop && !isDropdownEquipamentoUnidAcop && !isDropdownCondicaoUnidAcop) fieldPlacaUnidadeAcoplada(),
                        if (!isDropdownMunicipioUnidAcop && !isDropdownEquipamentoUnidAcop && !isDropdownCondicaoUnidAcop) SizedBox(height: size.height * 0.005),
                        if (!isDropdownMunicipioUnidAcop && !isDropdownEquipamentoUnidAcop)
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: const Text(
                                    'Condição',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isDropdownCondicaoUnidAcop = !isDropdownCondicaoUnidAcop;
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
                                          opcaoCondicaoUnidAcop?.nmCondicao ?? 'Selecione uma Condição',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Icon(isDropdownCondicaoUnidAcop ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                                      ],
                                    ),
                                  ),
                                ),
                                if (isDropdownCondicaoUnidAcop)
                                  Column(
                                    children: [
                                      const SizedBox(height: 8),
                                      TextField(
                                        controller: condicaoUnidAcopFilterCtrl,
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(Icons.search),
                                          isDense: true,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                                          hintText: 'Filtrar Condição',
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
                                          itemCount: listaCondicaoUnidAcopFiltrada.length,
                                          itemBuilder: (context, index) {
                                            final condicao = listaCondicaoUnidAcopFiltrada[index];
                                            return ListTile(
                                              title: Text(condicao.nmCondicao ?? ''),
                                              onTap: () {
                                                setState(() {
                                                  opcaoCondicaoUnidAcop = condicao;
                                                  isDropdownCondicaoUnidAcop = false;
                                                  if (!isDropdownCondicaoUnidAcop) {
                                                    condicaoUnidAcopFilterCtrl.clear();
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
                        if (!isDropdownMunicipioUnidAcop && !isDropdownEquipamentoUnidAcop && !isDropdownCondicaoUnidAcop) SizedBox(height: size.height * 0.005),
                        if (!isDropdownMunicipioUnidAcop && !isDropdownCondicaoUnidAcop)
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: const Text(
                                    'Equipamento de Transporte',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isDropdownEquipamentoUnidAcop = !isDropdownEquipamentoUnidAcop;
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
                                          opcaoEquipamentoUnidAcop?.nmEquipamentoTransporte ?? 'Selecione o Equipamento de Transporte',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Icon(isDropdownEquipamentoUnidAcop ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                                      ],
                                    ),
                                  ),
                                ),
                                if (isDropdownEquipamentoUnidAcop)
                                  Column(
                                    children: [
                                      const SizedBox(height: 8),
                                      TextField(
                                        controller: equipamentoUnidAcopFilterCtrl,
                                        onChanged: (value) => {
                                          setState(() {
                                            equipamentoUnidAcopFilterCtrl;
                                          }),
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(Icons.search),
                                          isDense: true,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                                          hintText: 'Filtrar Equipamento de Transporte',
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
                                          itemCount: listaEquipamentoUnidAcopFiltrada.length,
                                          itemBuilder: (context, index) {
                                            final equipamento = listaEquipamentoUnidAcopFiltrada[index];
                                            return ListTile(
                                              title: Text(equipamento.nmEquipamentoTransporte ?? ''),
                                              onTap: () {
                                                setState(() {
                                                  opcaoEquipamentoUnidAcop = equipamento;
                                                  isDropdownEquipamentoUnidAcop = false;
                                                  if (!isDropdownEquipamentoUnidAcop) {
                                                    equipamentoUnidAcopFilterCtrl.clear();
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
                        if (!isDropdownMunicipioUnidAcop && !isDropdownEquipamentoUnidAcop && !isDropdownCondicaoUnidAcop) SizedBox(height: size.height * 0.005),
                        if (!isDropdownEquipamentoUnidAcop && !isDropdownCondicaoUnidAcop)
                          Padding(
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
                                      isDropdownMunicipioUnidAcop = !isDropdownMunicipioUnidAcop;
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
                                          opcaoMunicipioUnidAcop?.nmmunicipio != null ? '${opcaoMunicipioUnidAcop?.nmmunicipio} - ${opcaoMunicipioUnidAcop?.sgunidadefederal}' : 'Selecione um Município',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Icon(isDropdownMunicipioUnidAcop ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                                      ],
                                    ),
                                  ),
                                ),
                                if (isDropdownMunicipioUnidAcop)
                                  Column(
                                    children: [
                                      const SizedBox(height: 8),
                                      TextField(
                                        controller: municipioUnidAcopFilterCtrl,
                                        onChanged: (value) => {
                                          setState(() {
                                            municipioUnidAcopFilterCtrl;
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
                                          itemCount: listaMunicipiosUnidAcopFiltrados.length,
                                          itemBuilder: (context, index) {
                                            final municipio = listaMunicipiosUnidAcopFiltrados[index];
                                            return ListTile(
                                              title: Text(municipio.nmmunicipio != null ? '${municipio.nmmunicipio} - ${municipio.sgunidadefederal}' : ''),
                                              onTap: () {
                                                setState(() {
                                                  opcaoMunicipioUnidAcop = municipio;
                                                  isDropdownMunicipioUnidAcop = false;
                                                  if (!isDropdownMunicipioUnidAcop) {
                                                    municipioUnidAcopFilterCtrl.clear();
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
                        if (!isDropdownMunicipioUnidAcop && !isDropdownEquipamentoUnidAcop && !isDropdownCondicaoUnidAcop) SizedBox(height: size.height * 0.015),
                        if (!isDropdownMunicipioUnidAcop && !isDropdownEquipamentoUnidAcop && !isDropdownCondicaoUnidAcop) txtUnidAcopErrorMessage(),
                        if (!isDropdownMunicipioUnidAcop && !isDropdownEquipamentoUnidAcop && !isDropdownCondicaoUnidAcop)
                          Padding(
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
                                  if (placaUnidAcopCtrl.text.trim() == '' || placaUnidAcopCtrl.text == null) {
                                    setState(() {
                                      unidadeAcopladaErrorMessage = 'Por favor, informe a placa.';
                                    });
                                  } else if (opcaoCondicaoUnidAcop?.nmCondicao == null) {
                                    setState(() {
                                      unidadeAcopladaErrorMessage = 'Por favor, informe a condição.';
                                    });
                                  } else if (opcaoEquipamentoUnidAcop?.nmEquipamentoTransporte == null) {
                                    setState(() {
                                      unidadeAcopladaErrorMessage = 'Por favor, informe o equipamento de transporte.';
                                    });
                                  } else if (opcaoMunicipioUnidAcop?.nmmunicipio == null) {
                                    setState(() {
                                      unidadeAcopladaErrorMessage = 'Por favor, informe o município.';
                                    });
                                  } else {
                                    setState(() {
                                      unidadeAcopladaErrorMessage = null;
                                      loading.value = true;
                                    });
                                    Navigator.of(context).pop();
                                    try {
                                      final uinidadeAcoplada = UnidadeAcoplada(
                                        idFiscalizacao: fiscalizacao!.id,
                                        placa: placaUnidAcopCtrl.text,
                                        nmMunicipio: opcaoMunicipioUnidAcop!.nmmunicipio!,
                                        ufMunicipio: opcaoMunicipioUnidAcop!.sgunidadefederal!,
                                        cdMunicipio: opcaoMunicipioUnidAcop!.cdmunicipio!.toString(),
                                        condicao: opcaoCondicaoUnidAcop!.nmCondicao!,
                                        equipamentoTransporte: opcaoEquipamentoUnidAcop!.nmEquipamentoTransporte!,
                                        status: EstadoEntidade.pendente,
                                      );
                                      await UnidadeAcopladaDao().insert(uinidadeAcoplada);
                                      setState(() {
                                        loading.value = false;
                                      });
                                    } catch (e) {
                                      if (kDebugMode) {
                                        print('btnAdicionarUnid: $e');
                                      }
                                      setState(() {
                                        loading.value = false;
                                      });
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

  Widget fieldPlacaUnidadeAcoplada() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: placaUnidAcopCtrl,
      decoration: const InputDecoration(
        labelText: 'Placa',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, informe da unidade acoplada.';
        }
        return null;
      },
      onChanged: (value) {
        placaUnidAcopCtrl.text = value.toUpperCase();
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(7),
      ],
    );
  }

  Widget txtUnidAcopErrorMessage() {
    return unidadeAcopladaErrorMessage != null
        ? Align(
            alignment: Alignment.topLeft,
            child: Text(
              unidadeAcopladaErrorMessage!,
              style: TextStyle(
                overflow: TextOverflow.clip,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          )
        : Container();
  }

  Widget listView() {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.18,
          child: listaUnidAcop.isEmpty
              ? Container()
              : PageView.builder(
                  controller: _pageController,
                  itemCount: listaUnidAcop.length,
                  itemBuilder: (context, index) {
                    final unidadeAcoplada = listaUnidAcop[index];
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
                      margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                // title: Text(
                                //   'Placa: ${unidadeAcoplada.placa}',
                                //   style: const TextStyle(
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                                subtitle: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Placa:  ${unidadeAcoplada.placa}'),
                                    Divider(
                                      endIndent: MediaQuery.of(context).size.width * 0.2,
                                    ),
                                    Text('Município: ${unidadeAcoplada.nmMunicipio} - ${unidadeAcoplada.ufMunicipio}'),
                                    Text('Condição: ${unidadeAcoplada.condicao}'),
                                    Text('Equipamento: ${unidadeAcoplada.equipamentoTransporte}'),
                                    // const Divider(),
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
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            listaUnidAcop.length,
            (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                height: 8.0,
                width: 8.0,
                decoration: BoxDecoration(
                  color: _pageController.hasClients && _pageController.page == index ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  _salvarTransportador() async {
    setState(() {
      errorMessage = null;
      loading.value = true;
    });
    try {
      final fiscalizacaoAlterada = Fiscalizacao(
        id: fiscalizacao!.id!,
        nmMunicipioFiscalizacao: fiscalizacao!.nmMunicipioFiscalizacao,
        ufMunicipioFiscalizacao: fiscalizacao!.ufMunicipioFiscalizacao,
        cdMunicipioFiscalizacao: fiscalizacao!.cdMunicipioFiscalizacao != null ? fiscalizacao!.cdMunicipioFiscalizacao.toString() : null,
        sgRodovia: fiscalizacao!.sgRodovia,
        km: fiscalizacao!.km != null ? fiscalizacao!.km.toString() : null,
        status: EstadoEntidade.pendente,
        sincronizado: EstadoEntidade.naoSincronizado,
        dataCadastro: Utility.getDateTime().toString(),
        nmMunicipioUnidadeTransporte: opcaoMunicipioUnidTrans!.nmmunicipio!,
        ufMunicipioUnidadeTransporte: opcaoMunicipioUnidTrans!.sgunidadefederal!,
        cdMunicipioUnidadeTransporte: opcaoMunicipioUnidTrans!.cdmunicipio!.toString(),
        placaUnidadeTransporte: placaUnidTransCtrl.text,
        renavanUnidadeTransporte: renavanUnidTransCtrl.text,
        marcaModeloUnidadeTransporte: marcaModeloUnidTransCtrl.text,
        condicaoUnidadeTransporte: opcaoCondicaoUnidTrans!.nmCondicao.toString(),
        equipamentoUnidadeTransporte: opcaoEquipamentoUnidTrans!.nmEquipamentoTransporte.toString(),
        tipoPessoaTransportador: _tipoPessoaTransportador,
        nomeTransportador: nomeTransportadorCtrl.text,
        cpfCnpjTransportador: cpfCnpjTransportadorCtrl.text,
        nmMunicipioTransportador: opcaoMunicipioTrans!.nmmunicipio,
        ufMunicipioTransportador: opcaoMunicipioTrans!.sgunidadefederal,
        cdMunicipioTransportador: opcaoMunicipioTrans!.cdmunicipio!.toString(),
        nomeCondutor: fiscalizacao!.nomeCondutor,
        cnhCondutor: fiscalizacao!.cnhCondutor,
        cpfCondutor: fiscalizacao!.cpfCondutor,
      );
      await FiscalizacaoDao().update(fiscalizacaoAlterada);
      setState(() {
        loading.value = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('_salvarVeiculo: $e');
      }
      setState(() {
        loading.value = false;
      });
    }
  }

  Future<void> carregarDados() async {
    fiscalizacao = await findFiscalizacaoByStatus();
    if (fiscalizacao!.id != null) {
      listaUnidAcop = (await findAllUnidAcoplaByFiscalizacao())!;
      setState(() {
        listaUnidAcop;
        loading.value = false;
      });
    } else {
      setState(() {
        loading.value = false;
      });
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
            tooltip: 'Adicionar Unidade Acoplada',
            splashColor: Theme.of(context).colorScheme.secondary,
            color: Theme.of(context).colorScheme.primary,
            iconSize: 30.0,
            icon: const FaIcon(
              FontAwesomeIcons.truckLoading,
              color: Color(0xFF002358),
            ),
            onPressed: () async {
              if (placaUnidTransCtrl.text.trim() == '' ||
                  placaUnidTransCtrl.text == null ||
                  renavanUnidTransCtrl.text.trim() == '' ||
                  renavanUnidTransCtrl.text == null ||
                  marcaModeloUnidTransCtrl.text.trim() == '' ||
                  marcaModeloUnidTransCtrl.text == null ||
                  opcaoMunicipioUnidTrans?.nmmunicipio == null ||
                  opcaoCondicaoUnidTrans?.nmCondicao == null ||
                  opcaoEquipamentoUnidTrans?.nmEquipamentoTransporte == null) {
                setState(() {
                  errorMessage = 'Por favor, informe os dados da unid. de transporte \n para inserir a unidade acoplada.';
                });
              } else {
                if (fiscalizacao!.placaUnidadeTransporte == null ||
                    fiscalizacao!.renavanUnidadeTransporte == null ||
                    fiscalizacao!.marcaModeloUnidadeTransporte == null ||
                    fiscalizacao!.nmMunicipioUnidadeTransporte == null ||
                    fiscalizacao!.condicaoUnidadeTransporte == null ||
                    fiscalizacao!.equipamentoUnidadeTransporte == null) {
                  await _salvarTransportador();
                }
                dialogUnidadeAcoplada(context);
              }
            },
          ),
          CameraWidget(idFiscalizacao: fiscalizacao?.id, descricao: TitleScreen.transportador),
          IconButton(
            tooltip: '${TxtToolTip.btnFloatAvancar} condutor',
            splashColor: Theme.of(context).colorScheme.secondary,
            color: Theme.of(context).colorScheme.primary,
            iconSize: 35.0,
            icon: const Icon(Icons.save_rounded),
            onPressed: () async {
              if (placaUnidTransCtrl.text.trim() == '' || placaUnidTransCtrl.text == null) {
                setState(() {
                  errorMessage = 'Por favor, informe a placa da unid. de transporte.';
                });
              } else if (renavanUnidTransCtrl.text.trim() == '' || renavanUnidTransCtrl.text == null) {
                setState(() {
                  errorMessage = 'Por favor, informe o renavan da unid. de transporte.';
                });
              } else if (marcaModeloUnidTransCtrl.text.trim() == '' || marcaModeloUnidTransCtrl.text == null) {
                setState(() {
                  errorMessage = 'Por favor, informe a marca/modelo \n da unid. de transporte.';
                });
              } else if (opcaoMunicipioUnidTrans?.nmmunicipio == null) {
                setState(() {
                  errorMessage = 'Por favor, informe o município \n da unid. de transporte.';
                });
              } else if (opcaoCondicaoUnidTrans?.nmCondicao == null) {
                setState(() {
                  errorMessage = 'Por favor, informe a condição.';
                });
              } else if (opcaoEquipamentoUnidTrans?.nmEquipamentoTransporte == null) {
                setState(() {
                  errorMessage = 'Por favor, informe o equipamento de transporte.';
                });
              } else if (nomeTransportadorCtrl.text.trim() == '' || nomeTransportadorCtrl.text == null) {
                setState(() {
                  errorMessage = 'Por favor, informe o nome do transportador.';
                });
              } else if (cpfCnpjTransportadorCtrl.text.trim() == '' || cpfCnpjTransportadorCtrl.text == null) {
                setState(() {
                  errorMessage = 'Por favor, informe o CPF/CNPJ do transportador.';
                });
              } else if (opcaoMunicipioTrans?.nmmunicipio == null) {
                setState(() {
                  errorMessage = 'Por favor, informe o município do transportador.';
                });
              } else {
                await _salvarTransportador();
                GoRouter.of(context).pushReplacement(AppRoutes.condutorScreen);
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
          future: carregarDados(),
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
                          Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!isDropdownMunicipioUnidTrans && !isDropdownCondicaoUnidTrans && !isDropdownMunicipioTrans && !isDropdownEquipamentoUnidTrans) SizedBox(height: size.height * 0.015),
                                  if (!isDropdownMunicipioUnidTrans && !isDropdownCondicaoUnidTrans && !isDropdownMunicipioTrans && !isDropdownEquipamentoUnidTrans)
                                    Row(
                                      children: [
                                        Flexible(
                                          child: SizedBox(
                                            width: size.width * 0.45,
                                            child: fieldPlacaUnidadeTrans(),
                                          ),
                                        ),
                                        SizedBox(width: size.width * 0.02),
                                        Flexible(
                                          child: SizedBox(
                                            width: size.width * 0.45,
                                            child: fieldRenavanUnidadeTrans(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (!isDropdownMunicipioUnidTrans && !isDropdownCondicaoUnidTrans && !isDropdownMunicipioTrans && !isDropdownEquipamentoUnidTrans) SizedBox(height: size.height * 0.015),
                                  if (!isDropdownMunicipioUnidTrans && !isDropdownCondicaoUnidTrans && !isDropdownMunicipioTrans && !isDropdownEquipamentoUnidTrans)
                                    Row(
                                      children: [
                                        Expanded(
                                          child: fieldMarcaModeloUnidadeTrans(),
                                        ),
                                      ],
                                    ),
                                  if (!isDropdownMunicipioUnidTrans && !isDropdownCondicaoUnidTrans && !isDropdownMunicipioTrans && !isDropdownEquipamentoUnidTrans) SizedBox(height: size.height * 0.005),
                                  if (!isDropdownCondicaoUnidTrans && !isDropdownMunicipioTrans && !isDropdownEquipamentoUnidTrans)
                                    Row(
                                      children: [
                                        Expanded(
                                          child: dropDownMunicipioUnidadeTrans(context),
                                        ),
                                      ],
                                    ),
                                  if (!isDropdownMunicipioUnidTrans && !isDropdownCondicaoUnidTrans && !isDropdownMunicipioTrans && !isDropdownEquipamentoUnidTrans) SizedBox(height: size.height * 0.005),
                                  if (!isDropdownMunicipioUnidTrans && !isDropdownMunicipioTrans && !isDropdownEquipamentoUnidTrans)
                                    Row(
                                      children: [
                                        Flexible(
                                          child: SizedBox(
                                            width: size.width * 0.95,
                                            child: dropDownCondicao(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (!isDropdownMunicipioUnidTrans && !isDropdownCondicaoUnidTrans && !isDropdownMunicipioTrans && !isDropdownEquipamentoUnidTrans) SizedBox(height: size.height * 0.005),
                                  if (!isDropdownMunicipioUnidTrans && !isDropdownCondicaoUnidTrans && !isDropdownMunicipioTrans)
                                    Row(
                                      children: [
                                        Flexible(
                                          child: SizedBox(
                                            width: size.width * 0.95,
                                            child: dropDownEquiTrans(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (!isDropdownMunicipioUnidTrans && !isDropdownCondicaoUnidTrans && !isDropdownMunicipioTrans && !isDropdownEquipamentoUnidTrans)
                                    Row(
                                      children: [
                                        Expanded(child: radioButtomPessoa()),
                                      ],
                                    ),
                                  if (!isDropdownMunicipioUnidTrans && !isDropdownCondicaoUnidTrans && !isDropdownMunicipioTrans && !isDropdownEquipamentoUnidTrans)
                                    Row(
                                      children: [
                                        Expanded(child: fieldNomeTransportador()),
                                      ],
                                    ),
                                  if (!isDropdownMunicipioUnidTrans && !isDropdownCondicaoUnidTrans && !isDropdownMunicipioTrans && !isDropdownEquipamentoUnidTrans) SizedBox(height: size.height * 0.015),
                                  if (!isDropdownMunicipioUnidTrans && !isDropdownCondicaoUnidTrans && !isDropdownMunicipioTrans && !isDropdownEquipamentoUnidTrans)
                                    Row(
                                      children: [
                                        Expanded(child: fieldCpfCnpjTransportador()),
                                      ],
                                    ),
                                  if (!isDropdownMunicipioUnidTrans && !isDropdownCondicaoUnidTrans && !isDropdownMunicipioTrans && !isDropdownEquipamentoUnidTrans) SizedBox(height: size.height * 0.005),
                                  if (!isDropdownMunicipioUnidTrans && !isDropdownCondicaoUnidTrans && !isDropdownEquipamentoUnidTrans)
                                    Row(
                                      children: [
                                        Expanded(child: dropDownMunicipioTrans(context)),
                                      ],
                                    ),
                                  if (!isDropdownMunicipioUnidTrans && !isDropdownCondicaoUnidTrans && !isDropdownMunicipioTrans && !isDropdownEquipamentoUnidTrans) SizedBox(height: size.height * 0.015),
                                  if (!isDropdownMunicipioUnidTrans && !isDropdownCondicaoUnidTrans && !isDropdownMunicipioTrans && !isDropdownEquipamentoUnidTrans)
                                    Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                          child: txtErrorMessage(),
                                        ),
                                      ],
                                    ),
                                  if (!isDropdownMunicipioUnidTrans && !isDropdownCondicaoUnidTrans && !isDropdownMunicipioTrans && !isDropdownEquipamentoUnidTrans) listView(),
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
