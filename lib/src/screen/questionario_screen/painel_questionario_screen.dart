// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:app_ppmob/src/component/circular_progress.dart';
import 'package:app_ppmob/src/data/dao/fiscalizacao_dao.dart';
import 'package:app_ppmob/src/model/fiscalizacao.dart';
import 'package:app_ppmob/src/screen/documentos_screen/painel_documentos_screen.dart';
import 'package:app_ppmob/src/screen/foto_screen/foto_screen.dart';
import 'package:app_ppmob/src/screen/questionario_screen/questionario_autuacao_screen.dart';
import 'package:app_ppmob/src/services/provider/appbar_drawe_provider.dart';
import 'package:app_ppmob/src/shared/constants/constants.dart';
import 'package:app_ppmob/src/shared/util/utility.dart';
import 'package:app_ppmob/src/shared/widget/camera_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PainelQuestionarioScreen extends StatefulWidget {
  const PainelQuestionarioScreen({super.key});

  @override
  State<PainelQuestionarioScreen> createState() => _PainelQuestionarioScreenState();
}

class _PainelQuestionarioScreenState extends State<PainelQuestionarioScreen> {
  final loading = ValueNotifier<bool>(true);
  bool isBtnAvancar = true;
  Fiscalizacao? fiscalizacao;

  @override
  void initState() {
    super.initState();
    initScreen();
  }

  initScreen() async {
    Utility.updateTitle(context, TitleScreen.painelQuestionario);
    await findFiscalizacaoByStatus();
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

  

  Widget btnDocumentos(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionarioAutuacaoScreen(
              categoria: TitleScreen.documentosQuestionario.toString().toUpperCase(),
            ),
          ),
        );
      },
      child: Container(
        width: size.width * 0.85, // Mantém o tamanho proporcional à tela
        height: size.height * 0.12, // Aumentado para acomodar o texto e o ícone
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                TitleBtnPainel.documentosQuestionario,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center, // Centraliza o texto
                maxLines: 2, // Permite até 2 linhas para evitar overflow
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8), // Espaço entre o texto e o ícone
              CircleAvatar(
                backgroundColor: isBackgroundIconColor(true),
                child: iconBtn(true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget btnVeiculo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionarioAutuacaoScreen(
              categoria: TitleScreen.veiculoQuestionario.toString().toUpperCase(),
            ),
          ),
        );
      },
      child: Container(
        width: size.width * 0.85,
        height: size.height * 0.12,
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                TitleBtnPainel.veiculoQuestionario,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              CircleAvatar(
                backgroundColor: isBackgroundIconColor(false),
                child: iconBtn(false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget btnSinalizacaoVeiculo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionarioAutuacaoScreen(
              categoria: TitleScreen.sinalizacaoVeiculoQuestionario.toString().toUpperCase(),
            ),
          ),
        );
      },
      child: Container(
        width: size.width * 0.85,
        height: size.height * 0.12,
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                TitleBtnPainel.sinalizacaoVeiculoQuestionario,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              CircleAvatar(
                backgroundColor: isBackgroundIconColor(true),
                child: iconBtn(true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget btnEmbalagem(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionarioAutuacaoScreen(
              categoria: TitleScreen.embalagensQuestionario.toString().toUpperCase(),
            ),
          ),
        );
      },
      child: Container(
        width: size.width * 0.85,
        height: size.height * 0.12,
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                TitleBtnPainel.embalagensQuestionario,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              CircleAvatar(
                backgroundColor: isBackgroundIconColor(false),
                child: iconBtn(false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget btnEpi(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionarioAutuacaoScreen(
              categoria: TitleScreen.epiQuestionario.toString().toUpperCase(),
            ),
          ),
        );
      },
      child: Container(
        width: size.width * 0.85,
        height: size.height * 0.12,
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                TitleBtnPainel.epiQuestionario,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              CircleAvatar(
                backgroundColor: isBackgroundIconColor(true),
                child: iconBtn(true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget btnCondicoesApresentadas(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionarioAutuacaoScreen(
              categoria: TitleScreen.condicoesApresentadasQuestionario.toString().toUpperCase(),
            ),
          ),
        );
      },
      child: Container(
        width: size.width * 0.85,
        height: size.height * 0.12,
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                TitleBtnPainel.condicoesApresentadasQuestionario,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              CircleAvatar(
                backgroundColor: isBackgroundIconColor(false),
                child: iconBtn(false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget btnIncompatibilidade(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionarioAutuacaoScreen(
              categoria: TitleScreen.incompatibilidadeQuestionario.toString().toUpperCase(),
            ),
          ),
        );
      },
      child: Container(
        width: size.width * 0.85,
        height: size.height * 0.12,
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                TitleBtnPainel.incompatibilidadeQuestionario,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              CircleAvatar(
                backgroundColor: isBackgroundIconColor(true),
                child: iconBtn(true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget btnSituacaoEmergencia(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionarioAutuacaoScreen(
              categoria: TitleScreen.situacaoEmergenciaQuestionario.toString().toUpperCase(),
            ),
          ),
        );
      },
      child: Container(
        width: size.width * 0.85,
        height: size.height * 0.12,
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                TitleBtnPainel.situacaoEmergenciaQuestionario,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              CircleAvatar(
                backgroundColor: isBackgroundIconColor(true),
                child: iconBtn(true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color isBackgroundIconColor(bool isColor) {
    return isColor ? Colors.green : Colors.white;
  }

  Widget iconBtn(bool isColor) {
    return isColor
        ? Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          )
        : FaIcon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).colorScheme.secondary,
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
            tooltip: TxtToolTip.btnfinalizarCheckList,
            splashColor: Theme.of(context).colorScheme.secondary,
            color: Theme.of(context).colorScheme.primary,
            iconSize: 35.0,
            icon: const Icon(Icons.save_rounded),
            // FaIcon(
            //   FontAwesomeIcons.share,
            //   color: (!isBtnAvancar ? Color(0xFF002358) : Color(0xFF002358).withOpacity(0.5)),
            // ),
            onPressed: () {
              if (!isBtnAvancar) {}
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> buttons = [
      btnDocumentos(context),
      btnVeiculo(context),
      btnSinalizacaoVeiculo(context),
      btnEmbalagem(context),
      btnEpi(context),
      btnCondicoesApresentadas(context),
      btnIncompatibilidade(context),
      btnSituacaoEmergencia(context),
    ];
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
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Dois botões por linha
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 1.2, // Proporção ajustada para caber o texto
                        ),
                        itemCount: buttons.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: double.infinity,
                            child: buttons[index],
                          );
                        },
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
