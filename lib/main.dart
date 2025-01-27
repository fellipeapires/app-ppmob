import 'package:app_ppmob/src/services/provider/appbar_drawe_provider.dart';
import 'package:app_ppmob/src/services/provider/gps_status_provider.dart';
import 'package:app_ppmob/src/services/provider/location_permission_provider.dart';
import 'package:app_ppmob/src/services/provider/location_provider.dart';
import 'package:app_ppmob/src/services/provider/status_user_provider.dart';
import 'package:app_ppmob/src/services/provider/user_name_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppbarProvider()),
        ChangeNotifierProvider(create: (context) => DrawerProvider()),
        ChangeNotifierProvider(create: (context) => UserNameProvider()),
        ChangeNotifierProvider(create: (context) => StatusUserProvider()),
        ChangeNotifierProvider(create: (context) => GpsStatusProvider()),
        ChangeNotifierProvider(create: (context) => LocationPermissionProvider()),
        ChangeNotifierProvider(create: (context) => LocationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
