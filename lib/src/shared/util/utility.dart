// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'package:app_ppmob/src/services/provider/appbar_drawe_provider.dart';
import 'package:app_ppmob/src/services/provider/status_user_provider.dart';
import 'package:app_ppmob/src/services/provider/user_name_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class Utility {

  static getDatePtBr(DateTime date) {
    String localDate = DateFormat("dd/MM/yyyy").format(date);
    return localDate;
  }

  static getDate() {
    String localDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    return localDate;
  }
  
  static getDateTime() {
    DateTime localDateTime = DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().add(const Duration(hours: -3))));
    return localDateTime;
  }

  static getNamePhoto(int index) {
    return '$index${DateFormat("yMdHHmmssSSS").format(getDateTime())}.jpg';
  }

  static void snackbar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static getUserNameProvider(BuildContext context) {
    return Provider.of<UserNameProvider>(context).username;
  }

  static setUserNameProvider(BuildContext context, String username) {
    final usernameProvider = Provider.of<UserNameProvider>(context, listen: false);
    usernameProvider.setUsername(username);
  }

  static getStatusUserProvider(BuildContext context) {
    return Provider.of<StatusUserProvider>(context).statususer;
  }

  static setStatusUserProvider(BuildContext context, String statususer) {
    final statusUserProvider = Provider.of<StatusUserProvider>(context, listen: false);
    statusUserProvider.setStatusUser(statususer);
  }

  static isInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.wifi) || connectivityResult.contains(ConnectivityResult.mobile)) {
      return true;
    } else {
      return false;
    }
  }

  static Future<Map<String, dynamic>> getInfoApp() async {
    Map<String, dynamic> infoApp = {
      'appName': '',
      'packageName': '',
      'version': '',
      'buildNumber': '',
    };
    PackageInfo.fromPlatform().then((onValue) => {
          infoApp['appName'] = onValue.appName,
          infoApp['packageName'] = onValue.packageName,
          infoApp['version'] = onValue.version,
          infoApp['buildNumber'] = onValue.buildNumber,
        });
    return infoApp;
  }

   static void updateTitle(BuildContext context, String title) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppbarProvider>(context, listen: false).updateTitle(title);
    });
  }

}