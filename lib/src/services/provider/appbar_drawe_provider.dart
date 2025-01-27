import 'package:app_ppmob/src/shared/widget/appbar_widget.dart';
import 'package:app_ppmob/src/shared/widget/drawer_widget.dart';
import 'package:flutter/material.dart';


// class AppbarProvider extends ChangeNotifier {
//   final AppBarCustom _appBarWidget = const AppBarCustom();
//   AppBarCustom get appBarWidget => _appBarWidget;
// }

class AppbarProvider extends ChangeNotifier {
  String _title = '';
  AppBarCustom get appBarWidget => AppBarCustom(title: _title);

  void updateTitle(String newTitle) {
    _title = newTitle;
    notifyListeners();
  }
}


class DrawerProvider extends ChangeNotifier {
  DrawerWidget get drawer => const DrawerWidget();
}
