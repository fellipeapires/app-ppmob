// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:app_ppmob/app_routes.dart';
import 'package:app_ppmob/src/component/circular_progress.dart';
import 'package:app_ppmob/src/data/dao/expedidor_dao.dart';
import 'package:app_ppmob/src/data/dao/fiscalizacao_dao.dart';
import 'package:app_ppmob/src/data/dao/item_documento_fiscal_dao.dart';
import 'package:app_ppmob/src/model/expedidor.dart';
import 'package:app_ppmob/src/model/fiscalizacao.dart';
import 'package:app_ppmob/src/screen/foto_screen/foto_screen.dart';
import 'package:app_ppmob/src/screen/home_screen/home_screen.dart';
import 'package:app_ppmob/src/screen/questionario_screen/painel_questionario_screen.dart';
import 'package:app_ppmob/src/services/provider/appbar_drawe_provider.dart';
import 'package:app_ppmob/src/shared/constants/constants.dart';
import 'package:app_ppmob/src/shared/util/utility.dart';
import 'package:app_ppmob/src/shared/widget/camera_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PainelDocumentosScreen extends StatefulWidget {
  const PainelDocumentosScreen({super.key});

  @override
  State<PainelDocumentosScreen> createState() => _PainelDocumentosScreenState();
}

class _PainelDocumentosScreenState extends State<PainelDocumentosScreen> {
  final loading = ValueNotifier<bool>(true);
  bool isBtnAvancar = true;
  Fiscalizacao? fiscalizacao;
  int isExpedidor = 0;
  Expedidor? expedidor;

  int isItemDocumentoFiscal = 0;

  Color txtIconLocalColor = Color(0xFF1C7ED6);
  Color backgroundIconLocalColor = Colors.white;

  Color txtIconTransportadorColor = Color(0xFF1C7ED6);
  Color backgroundIconTransportadorColor = Colors.white;

  Color txtIconExpedidorColor = Color(0xFF1C7ED6);
  Color backgroundIconExpedidorColor = Colors.white;

  Color txtIconCondutorColor = Color(0xFF1C7ED6);
  Color backgroundIconCondutorColor = Colors.white;

  Color txtIconDocumentoFiscalColor = Color(0xFF1C7ED6);
  Color backgroundIconDocumentoFiscalColor = Colors.white;

  @override
  void initState() {
    super.initState();
    initScreen();
  }

  initScreen() async {
    Utility.updateTitle(context, TitleScreen.painelDocumentos);
    await findFiscalizacaoByStatus();
    await isExisteExpedidor();
    await isExisteItemDocumentoFiscal();
    if (fiscalizacao!.nmMunicipioFiscalizacao != null && fiscalizacao!.sgRodovia != null && fiscalizacao!.km != null) {
      setState(() {
        txtIconLocalColor = Colors.white;
        backgroundIconLocalColor = Colors.green;
      });
    } else {
      setState(() {
        txtIconLocalColor = Color(0xFF1C7ED6);
        backgroundIconLocalColor = Colors.white;
      });
    }
    if (fiscalizacao!.placaUnidadeTransporte != null &&
        fiscalizacao!.renavanUnidadeTransporte != null &&
        fiscalizacao!.marcaModeloUnidadeTransporte != null &&
        fiscalizacao!.condicaoUnidadeTransporte != null &&
        fiscalizacao!.equipamentoUnidadeTransporte != null &&
        fiscalizacao!.nomeTransportador != null &&
        fiscalizacao!.cpfCnpjTransportador != null &&
        fiscalizacao!.nmMunicipioTransportador != null) {
      setState(() {
        txtIconTransportadorColor = Colors.white;
        backgroundIconTransportadorColor = Colors.green;
      });
    } else {
      setState(() {
        txtIconTransportadorColor = Color(0xFF1C7ED6);
        backgroundIconTransportadorColor = Colors.white;
      });
    }
    if (fiscalizacao!.nomeCondutor != null && fiscalizacao!.cnhCondutor != null && fiscalizacao!.cpfCondutor != null) {
      setState(() {
        txtIconCondutorColor = Colors.white;
        backgroundIconCondutorColor = Colors.green;
      });
    } else {
      setState(() {
        txtIconCondutorColor = Color(0xFF1C7ED6);
        backgroundIconCondutorColor = Colors.white;
      });
    }
    if (isExpedidor > 0) {
      setState(() {
        txtIconExpedidorColor = Colors.white;
        backgroundIconExpedidorColor = Colors.green;
      });
    } else {
      setState(() {
        txtIconExpedidorColor = Color(0xFF1C7ED6);
        backgroundIconExpedidorColor = Colors.white;
      });
    }
    if (isItemDocumentoFiscal > 0) {
      setState(() {
        txtIconDocumentoFiscalColor = Colors.white;
        backgroundIconDocumentoFiscalColor = Colors.green;
      });
    } else {
      setState(() {
        txtIconDocumentoFiscalColor = Color(0xFF1C7ED6);
        backgroundIconDocumentoFiscalColor = Colors.white;
      });
    }
    if (fiscalizacao!.nmMunicipioFiscalizacao != null &&
        fiscalizacao!.sgRodovia != null &&
        fiscalizacao!.km != null &&
        fiscalizacao!.placaUnidadeTransporte != null &&
        fiscalizacao!.marcaModeloUnidadeTransporte != null &&
        fiscalizacao!.condicaoUnidadeTransporte != null &&
        fiscalizacao!.equipamentoUnidadeTransporte != null &&
        fiscalizacao!.nomeTransportador != null &&
        fiscalizacao!.cpfCnpjTransportador != null &&
        fiscalizacao!.nmMunicipioTransportador != null &&
        fiscalizacao!.nomeCondutor != null &&
        fiscalizacao!.cnhCondutor != null &&
        fiscalizacao!.cpfCondutor != null &&
        isExpedidor > 0 &&
        isItemDocumentoFiscal > 0) {
      isBtnAvancar = false;
    }
    setState(() {
      loading.value = false;
    });
  }

  Future<void> findFiscalizacaoByStatus() async {
    try {
      fiscalizacao = await FiscalizacaoDao().findByStatus(EstadoEntidade.pendente);
    } catch (e) {
      if (kDebugMode) {
        print('findByPendente: $e');
      }
    }
  }

  Future<void> isExisteExpedidor() async {
    try {
      var qtdExpedidor = await ExpedidorDao().isExiste(fiscalizacao!.id!);
      isExpedidor = qtdExpedidor['qtd'];
    } catch (e) {
      if (kDebugMode) {
        print('findByPendente: $e');
      }
    }
  }

  Future<void> isExisteItemDocumentoFiscal() async {
    try {
      var qtdItem = await ItemDocumentoFiscalDao().isExisteByFiscalizacao(fiscalizacao!.id!);
      isItemDocumentoFiscal = qtdItem['qtd'];
    } catch (e) {
      if (kDebugMode) {
        print('findByPendente: $e');
      }
    }
  }

  Widget btnCadLocal(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => GoRouter.of(context).push(AppRoutes.localFiscalizacaoScreen),
      child: Container(
        width: size.width * 0.85,
        height: size.height * 0.09,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 5.0),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  Text(
                    TitleScreen.localFiscalizacao,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    backgroundColor: backgroundIconLocalColor,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: txtIconLocalColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget btnCadTransportador(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => GoRouter.of(context).push(AppRoutes.transportadorScreen),
      child: Container(
        width: size.width * 0.85,
        height: size.height * 0.10,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 5.0),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  Text(
                    TitleScreen.transportador,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    backgroundColor: backgroundIconTransportadorColor,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: txtIconTransportadorColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget btnCadCondutor(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => GoRouter.of(context).push(AppRoutes.condutorScreen),
      child: Container(
        width: size.width * 0.85,
        height: size.height * 0.10,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 5.0),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  Text(
                    TitleScreen.condutor,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    backgroundColor: backgroundIconCondutorColor,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: txtIconCondutorColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget btnCadExpedidor(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => GoRouter.of(context).push(AppRoutes.expedidorScreen),
      child: Container(
        width: size.width * 0.85,
        height: size.height * 0.10,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 5.0),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  Text(
                    TitleScreen.expedidor,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    backgroundColor: backgroundIconExpedidorColor,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: txtIconExpedidorColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isBtnCadDocumentoFiscal() {
    if (isExpedidor > 0 &&
        fiscalizacao!.cdMunicipioFiscalizacao != null &&
        fiscalizacao!.nmMunicipioFiscalizacao != null &&
        fiscalizacao!.ufMunicipioFiscalizacao != null &&
        fiscalizacao!.placaUnidadeTransporte != null &&
        fiscalizacao!.renavanUnidadeTransporte != null &&
        fiscalizacao!.marcaModeloUnidadeTransporte != null &&
        fiscalizacao!.condicaoUnidadeTransporte != null &&
        fiscalizacao!.equipamentoUnidadeTransporte != null &&
        fiscalizacao!.cdMunicipioUnidadeTransporte != null &&
        fiscalizacao!.nmMunicipioUnidadeTransporte != null &&
        fiscalizacao!.ufMunicipioUnidadeTransporte != null &&
        fiscalizacao!.nomeCondutor != null &&
        fiscalizacao!.cnhCondutor != null &&
        fiscalizacao!.cpfCondutor != null &&
        fiscalizacao!.nomeTransportador != null &&
        fiscalizacao!.cpfCnpjTransportador != null &&
        fiscalizacao!.nmMunicipioTransportador != null) {
      return true;
    } else {
      return false;
    }
  }

  Widget btnCadDocumentoFiscal(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: isBtnCadDocumentoFiscal()
          ? () => {
                GoRouter.of(context).push(AppRoutes.documentoFiscalScreen),
              }
          : null,
      child: Container(
        width: size.width * 0.85,
        height: size.height * 0.10,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              isBtnCadDocumentoFiscal() ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary.withOpacity(0.5),
              isBtnCadDocumentoFiscal() ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  Text(
                    TitleScreen.documentoFiscal,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: (isBtnCadDocumentoFiscal() ? Colors.white : Colors.white.withOpacity(0.5)),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    backgroundColor: (isBtnCadDocumentoFiscal() ? backgroundIconDocumentoFiscalColor : backgroundIconDocumentoFiscalColor.withOpacity(0.5)),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: (isBtnCadDocumentoFiscal() ? txtIconDocumentoFiscalColor : txtIconDocumentoFiscalColor.withOpacity(0.5)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
            tooltip: TxtToolTip.btnFloatImage,
            splashColor: Theme.of(context).colorScheme.secondary,
            color: Theme.of(context).colorScheme.primary,
            iconSize: 30.0,
            icon: FaIcon(
              FontAwesomeIcons.solidImage,
              color: Color(0xFF002358),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FotoScreen(
                    idFiscalizacao: fiscalizacao!.id!,
                  ),
                ),
              );
            },
          ),
          CameraWidget(idFiscalizacao: fiscalizacao?.id, descricao: TitleScreen.painelDocumentos),
          IconButton(
            tooltip: TxtToolTip.btnFloatAvancarCheckList,
            splashColor: Theme.of(context).colorScheme.secondary,
            color: Theme.of(context).colorScheme.primary,
            iconSize: 30.0,
            icon: FaIcon(
              FontAwesomeIcons.share,
              color: (!isBtnAvancar ? Color(0xFF002358) : Color(0xFF002358).withOpacity(0.5)),
            ),
            onPressed: () {
              if (!isBtnAvancar) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // builder: (context) => const DocumentoQuestionarioScreen(),
                    builder: (context) => const PainelQuestionarioScreen(),
                  ),
                );
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
          MaterialPageRoute(builder: (context) => const HomeScreen()),
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
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                btnCadLocal(context),
                              ],
                            ),
                            SizedBox(height: size.height * 0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                btnCadTransportador(context),
                              ],
                            ),
                            SizedBox(height: size.height * 0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                btnCadCondutor(context),
                              ],
                            ),
                            SizedBox(height: size.height * 0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                btnCadExpedidor(context),
                              ],
                            ),
                            SizedBox(height: size.height * 0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                btnCadDocumentoFiscal(context),
                              ],
                            ),
                          ],
                        ),
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
