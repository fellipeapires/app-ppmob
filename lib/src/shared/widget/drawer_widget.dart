// ignore_for_file: use_build_context_synchronously

import 'package:app_ppmob/app_routes.dart';
import 'package:app_ppmob/src/shared/util/utility.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late Map<String, dynamic> infoApp = {};

  @override
  void initState() {
    super.initState();
    _getVersaoApp();
  }

  _getVersaoApp() async {
    infoApp = await Utility.getInfoApp();
    setState(() {
      infoApp;
    });
  }

  _isSinalInternet(BuildContext context) async {
    if (await Utility.isInternet()) {
      Utility.setStatusUserProvider(context, '');
    } else {
      Utility.setStatusUserProvider(context, '(offline)');
    }
  }

  @override
  Widget build(BuildContext context) {
    _isSinalInternet(context);
    final usernameProvider = Utility.getUserNameProvider(context);
    final statusUserProvider = Utility.getStatusUserProvider(context);
    return Drawer(
      child: ListView(
        children: [
          Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.only(right: 0.0),
            // child: Image.asset(ImagensAssets.imagemSplash),
          ),
          ListTile(
            leading: const Icon(
              Icons.person,
            ),
            title: usernameProvider != null ? Text('$usernameProvider $statusUserProvider') : const Text('Carregando...'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.house_outlined),
            title: const Text("Página inicial"),
            onTap: () => GoRouter.of(context).push(AppRoutes.homeScreen),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.power_settings_new),
            title: const Text("Sair"),
            onTap: () => GoRouter.of(context).pushReplacement(AppRoutes.loginScreen),
          ),
          const Divider(),
          ListTile(
            leading: null,
            title: Align(
              alignment: Alignment.center,
              child: Text('Versão ${infoApp['version']}'),
            ),
            onTap: () => GoRouter.of(context).pushReplacement(AppRoutes.loginScreen),
          ),
        ],
      ),
    );
  }
}
