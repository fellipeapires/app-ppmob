// ignore_for_file: deprecated_member_use, prefer_null_aware_operators, unnecessary_null_comparison, use_build_context_synchronously, must_be_immutable

import 'package:app_ppmob/app_routes.dart';
import 'package:app_ppmob/src/component/circular_progress.dart';
import 'package:app_ppmob/src/data/dao/fiscalizacao_dao.dart';
import 'package:app_ppmob/src/model/fiscalizacao.dart';
import 'package:app_ppmob/src/screen/documentos_screen/painel_documentos_screen.dart';
import 'package:app_ppmob/src/screen/documentos_screen/qr_code_reader_screen.dart';
import 'package:app_ppmob/src/services/provider/appbar_drawe_provider.dart';
import 'package:app_ppmob/src/shared/constants/constants.dart';
import 'package:app_ppmob/src/shared/util/input_mask/qtd_integer_input_mask.dart';
import 'package:app_ppmob/src/shared/util/utility.dart';
import 'package:app_ppmob/src/shared/widget/camera_widget.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CondutorScreen extends StatefulWidget {
  String? qrCodeData;

  CondutorScreen({
    super.key,
    this.qrCodeData,
  });

  @override
  State<CondutorScreen> createState() => _CondutorScreenState();
}

class _CondutorScreenState extends State<CondutorScreen> {
  final loading = ValueNotifier<bool>(true);
  final _formKey = GlobalKey<FormState>();
  String? errorMessage;
  final TextEditingController nomeCondutorCtrl = TextEditingController();
  final TextEditingController cnhCondutorCtrl = TextEditingController();
  final TextEditingController cpfCondutorCtrl = TextEditingController();
  Fiscalizacao? fiscalizacao;
  String? dadosCnh;

  @override
  void initState() {
    super.initState();
    initScreen();
  }

  @override
  void dispose() {
    nomeCondutorCtrl.dispose();
    cnhCondutorCtrl.dispose();
    cpfCondutorCtrl.dispose();
    super.dispose();
  }

  initScreen() async {
    Utility.updateTitle(context, TitleScreen.condutor);
    fiscalizacao = await findFiscalizacaoByStatus();
    await _carregarDadosSalvos();
    if (widget.qrCodeData != null) {
      processQRCode(widget.qrCodeData.toString());
    }
  }

  Future<Fiscalizacao?> findFiscalizacaoByStatus() async {
    try {
      final fiscalizacao = await FiscalizacaoDao().findByStatus(EstadoEntidade.pendente);
      return fiscalizacao;
    } catch (e) {
      if (kDebugMode) {
        print('findFiscalizacaoByStatus: $e');
      }
    }
    return null;
  }

  _carregarDadosSalvos() {
    if (fiscalizacao!.nomeCondutor != null) {
      nomeCondutorCtrl.text = fiscalizacao!.nomeCondutor!;
    }
    if (fiscalizacao!.cnhCondutor != null) {
      cnhCondutorCtrl.text = fiscalizacao!.cnhCondutor!;
    }
    if (fiscalizacao!.cpfCondutor != null) {
      cpfCondutorCtrl.text = fiscalizacao!.cpfCondutor!;
    }
    setState(() {
      loading.value = false;
    });
  }

  Widget fieldNome() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: nomeCondutorCtrl,
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
        nomeCondutorCtrl.text = value.toUpperCase();
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
    );
  }

  Widget fieldCnh() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: cnhCondutorCtrl,
      inputFormatters: [
        QtdIntegerInputMask(),
        LengthLimitingTextInputFormatter(11),
      ],
      decoration: const InputDecoration(
        labelText: 'CNH',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, informe a CNH.';
        }
        return null;
      },
      onChanged: (value) {
        cnhCondutorCtrl.text = value.toUpperCase();
      },
    );
  }

  Widget fieldCpf() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: cpfCondutorCtrl,
      decoration: const InputDecoration(
        labelText: 'CPF',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, informe o CPF.';
        }
        return null;
      },
      onChanged: (value) {
        cpfCondutorCtrl.text = value.toUpperCase();
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(14),
        FilteringTextInputFormatter.digitsOnly,
        CpfInputFormatter(),
      ],
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

  Future<void> readQRCode(BuildContext context) async {
    try {
      String code = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000',
        'CANCELAR',
        true,
        ScanMode.QR,
      );
      if (code == '-1') return;
      if (kDebugMode) {
        print(code);
      }
    } catch (e) {
      if (kDebugMode) {
        print('readQRCode: $e');
      }
    }
  }

  void processQRCode(String qrCodeData) {
    try {
      // final decodedData = jsonDecode(qrCodeData);
      //  final decodedData = utf8.decode(base64Decode(qrCodeData));
      qrCodeData = qrCodeData.replaceAll(RegExp(r'[^\x20-\x7E]'), ''); // Remove caracteres não ASCII
      if (kDebugMode) {
        print('Processed QR Code: $qrCodeData');
      }
      dadosCnh = '';
      if (kDebugMode) {
        print('Raw data: ${qrCodeData.codeUnits}');
      }
      for (int unit in qrCodeData.codeUnits) {
        if (kDebugMode) {
          print('Character: $unit -> ${String.fromCharCode(unit)}');
        }
        dadosCnh = '$dadosCnh${String.fromCharCode(unit)}';
      }
      if (kDebugMode) {
        print(qrCodeData);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao decodificar os dados do QR Code: $e');
      }
    }
  }

  // void processQRCode(String qrCodeData) {
  //   try {
  //     qrCodeData = qrCodeData.replaceAll(RegExp(r'[^\x20-\x7E]'), ''); // Remove caracteres não ASCII
  //     if (kDebugMode) {
  //       print('Processed QR Code: $qrCodeData');
  //     }

  //     if (kDebugMode) {
  //       print('Raw data: ${qrCodeData.codeUnits}');
  //       for (int unit in qrCodeData.codeUnits) {
  //         print('Character: $unit -> ${String.fromCharCode(unit)}');
  //       }
  //     }
  //     final decodedData = utf8.decode(base64Decode(qrCodeData));
  //     if (kDebugMode) {
  //       print('Dados decodificados: $decodedData');
  //       print('Dados brutos do QR Code: ${qrCodeData.codeUnits}');
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Erro ao decodificar dados: $e');
  //     }
  //   }
  // }

  //  void processQRCode(String qrCodeData) {
  //   try {
  //     // Remove caracteres não ASCII
  //     qrCodeData = qrCodeData.replaceAll(RegExp(r'[^\x20-\x7E]'), '');

  //     if (kDebugMode) {
  //       print('Processed QR Code: $qrCodeData');
  //     }

  //     // Criação da chave e IV para descriptografar
  //     final key = encrypt.Key.fromLength(32); // Chave de 256 bits
  //     final iv = encrypt.IV.fromLength(16); // IV de 128 bits

  //     // Inicializa o encrypter com AES
  //     final encrypter = encrypt.Encrypter(encrypt.AES(key));

  //     // Decodificando os dados do QR Code
  //     final decodedData = utf8.decode(base64Decode(qrCodeData));
  //     if (kDebugMode) {
  //       print('Dados decodificados: $decodedData');
  //     }

  //     // Descriptografar os dados
  //     final encryptedData = encrypt.Encrypted.fromBase64(decodedData);
  //     final decryptedData = encrypter.decrypt(encryptedData, iv: iv);

  //     if (kDebugMode) {
  //       print('Dados encriptografados: $encryptedData');
  //        print('Dados descriptografados: $decryptedData');
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Erro ao decodificar ou descriptografar dados: $e');
  //     }
  //   }
  // }

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
          CameraWidget(idFiscalizacao: fiscalizacao?.id, descricao: TitleScreen.condutor),
          IconButton(
            tooltip: TxtToolTip.btnFloatQrCode,
            splashColor: Theme.of(context).colorScheme.secondary,
            color: Theme.of(context).colorScheme.primary,
            iconSize: 30.0,
            icon: const FaIcon(
              FontAwesomeIcons.qrcode,
              color: Color(0xFF002358),
            ),
            onPressed: () async {
              // readQRCode(context);
              // final qrCodeData = await Navigator.of(context).push(
              //   MaterialPageRoute(builder: (_) => const QRCodeReaderScreen()),
              // );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QRCodeReaderScreen(),
                ),
              );

              // if (widget.qrCodeData != null) {
              //   processQRCode(widget.qrCodeData.toString());
              // }
            },
          ),
          IconButton(
            tooltip: '${TxtToolTip.btnFloatAvancar} expedidor',
            splashColor: Theme.of(context).colorScheme.secondary,
            color: Theme.of(context).colorScheme.primary,
            iconSize: 35.0,
            icon: const Icon(Icons.save_rounded),
            onPressed: () async {
              if (nomeCondutorCtrl.text.trim() == '' || nomeCondutorCtrl.text == null) {
                setState(() {
                  errorMessage = 'Por favor, informe o nome.';
                });
              } else if (cnhCondutorCtrl.text.trim() == '' || cnhCondutorCtrl.text == null) {
                setState(() {
                  errorMessage = 'Por favor, informe o Nº da CNH.';
                });
              } else if (cpfCondutorCtrl.text.trim() == '' || cpfCondutorCtrl.text == null) {
                setState(() {
                  errorMessage = 'Por favor, informe o Nº do CPF.';
                });
              } else {
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
                    nmMunicipioUnidadeTransporte: fiscalizacao!.nmMunicipioUnidadeTransporte,
                    ufMunicipioUnidadeTransporte: fiscalizacao!.ufMunicipioUnidadeTransporte,
                    cdMunicipioUnidadeTransporte: fiscalizacao!.cdMunicipioUnidadeTransporte.toString(),
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
                    cdMunicipioTransportador: fiscalizacao!.cdMunicipioTransportador.toString(),
                    nomeCondutor: nomeCondutorCtrl.text,
                    cnhCondutor: cnhCondutorCtrl.text,
                    cpfCondutor: cpfCondutorCtrl.text,
                  );
                  await FiscalizacaoDao().update(fiscalizacaoAlterada);
                } catch (e) {
                  if (kDebugMode) {
                    print('btnAvancar: $e');
                  }
                  setState(() {
                    loading.value = false;
                  });
                }
                GoRouter.of(context).pushReplacement(AppRoutes.expedidorScreen);
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
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: fieldNome(),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: size.height * 0.02),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: fieldCnh(),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: size.height * 0.02),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: fieldCpf(),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                        child: txtErrorMessage(),
                                      ),
                                    ],
                                  ),
                                  dadosCnh == null
                                      ? Container()
                                      : const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('DADOS CNH:'),
                                            ],
                                          ),
                                        ),
                                  SizedBox(height: size.height * 0.02),
                                  dadosCnh == null
                                      ? Container()
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text(dadosCnh != null ? dadosCnh.toString() : ''),
                                              ),
                                            ],
                                          ),
                                        ),
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
