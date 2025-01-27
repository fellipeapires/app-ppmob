// ignore_for_file: deprecated_member_use, use_build_context_synchronously, sort_child_properties_last

import 'package:app_ppmob/app_routes.dart';
import 'package:app_ppmob/src/component/circular_progress.dart';
import 'package:app_ppmob/src/data/dao/documento_fiscal_dao.dart';
import 'package:app_ppmob/src/data/dao/expedidor_dao.dart';
import 'package:app_ppmob/src/data/dao/fiscalizacao_dao.dart';
import 'package:app_ppmob/src/data/dao/foto_dao.dart';
import 'package:app_ppmob/src/data/dao/item_documento_fiscal_dao.dart';
import 'package:app_ppmob/src/data/dao/unidade_acoplada_dao.dart';
import 'package:app_ppmob/src/model/fiscalizacao.dart';
import 'package:app_ppmob/src/screen/login_screen/login_screen.dart';
import 'package:app_ppmob/src/services/provider/appbar_drawe_provider.dart';
import 'package:app_ppmob/src/shared/constants/constants.dart';
import 'package:app_ppmob/src/shared/util/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final loading = ValueNotifier<bool>(true);
  Fiscalizacao? fiscalizacao;

  @override
  void initState() {
    super.initState();
    Utility.updateTitle(context, TitleScreen.home);
    setState(() {
      loading.value = false;
    });
  }

  _isStatusUser(BuildContext context) async {
    if (await Utility.isInternet()) {
      Utility.setStatusUserProvider(context, '');
    } else {
      Utility.setStatusUserProvider(context, '(offline)');
    }
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

  Future<void> cadastrarFiscalizacao(BuildContext context) async {
    setState(() {
      loading.value = true;
    });
    try {
      fiscalizacao = await findFiscalizacaoByStatus();
      if (fiscalizacao == null) {
        fiscalizacao = Fiscalizacao(
          status: EstadoEntidade.pendente,
          sincronizado: EstadoEntidade.naoSincronizado,
          dataCadastro: Utility.getDateTime().toString(),
        );
        await FiscalizacaoDao().insert(fiscalizacao!);
        GoRouter.of(context).push(AppRoutes.painelDocumentosScreen);
      } else {
        _showDeleteConfirmation(context);
      }
      // GoRouter.of(context).push(AppRoutes.identificaoAutuacaoScreen);
      setState(() {
        loading.value = false;
      });
    } catch (e) {
      setState(() {
        loading.value = false;
      });
      if (kDebugMode) {
        print('cadastrarFiscalizacao: $e');
      }
    }
  }

  Widget btnCadastrarFiscalizacao(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () async => await cadastrarFiscalizacao(context),
      child: Container(
        width: size.width * 0.85,
        height: size.height * 0.15,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          image: const DecorationImage(
            image: AssetImage(ImagensAssets.imagemBtn),
            fit: BoxFit.cover,
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
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).colorScheme.secondary,
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

  Widget txtRodape(BuildContext context) {
    final usernameProvider = Utility.getUserNameProvider(context);
    final statusUserProvider = Utility.getStatusUserProvider(context);
    return Center(
      child: Text(
        '${usernameProvider!} ${statusUserProvider!}',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: const Text(
            "Nova fiscalização ou continuar anterior?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'Ao selecionar "NOVA FISCALIZAÇÃO", a fiscalização anterior será excluída permanentemente!',
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                  child: SizedBox(
                    width: size.width * 0.50,
                    height: size.height * 0.06,
                    child: TextButton(
                      child: const Text(
                        "NOVA FISCALIZAÇÃO",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          loading.value = true;
                        });
                        try {
                          await ItemDocumentoFiscalDao().deleteByIdFiscalizacao(fiscalizacao!.id!);
                          await DocumentoFiscalDao().deleteByIdFiscalizacao(fiscalizacao!.id!);
                          await UnidadeAcopladaDao().deleteByIdFiscalizacao(fiscalizacao!.id!);
                          await ExpedidorDao().deleteByIdFiscalizacao(fiscalizacao!.id!);
                          await FotoDao().deleteByIdFiscalizacao(fiscalizacao!.id!);
                          await FiscalizacaoDao().deleteById(fiscalizacao!.id!);
                          fiscalizacao = Fiscalizacao(
                            status: EstadoEntidade.pendente,
                            sincronizado: EstadoEntidade.naoSincronizado,
                            dataCadastro: Utility.getDateTime().toString(),
                          );
                          await FiscalizacaoDao().insert(fiscalizacao!);
                        } catch (e) {
                          if (kDebugMode) {
                            print('_showDeleteConfirmation $e');
                          }
                          setState(() {
                            loading.value = false;
                          });
                        }
                        GoRouter.of(context).push(AppRoutes.painelDocumentosScreen);
                        setState(() {
                          loading.value = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.grey,
                        elevation: 15,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: Colors.white54,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                  child: SizedBox(
                    width: size.width * 0.50,
                    height: size.height * 0.06,
                    child: TextButton(
                      child: const Text(
                        "CONTINUAR ANTERIOR",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.grey,
                        elevation: 15,
                        foregroundColor: Colors.white,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: Colors.white54,
                            width: 1.0,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        GoRouter.of(context).push(AppRoutes.painelDocumentosScreen);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _isStatusUser(context);
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
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
        drawer: Consumer<DrawerProvider>(
          builder: (context, drawerProvider, _) {
            return drawerProvider.drawer;
          },
        ),
        body: ValueListenableBuilder(
          valueListenable: loading,
          builder: (context, value, child) {
            if (value) {
              return const CircularProgressComponent();
            } else {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.08,
                  vertical: size.height * 0.04,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    btnCadastrarFiscalizacao(context),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        txtRodape(context),
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
