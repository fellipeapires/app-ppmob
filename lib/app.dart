// import 'package:app_sie_fiscal/src/shared/themes/color_schemes.g.dart';
import 'package:app_ppmob/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PPMOB - Cargas Perigosas App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: const Color(0xFF002358),
              secondary: const Color(0xFF1C7ED6),
              tertiary: const Color(0xFF78B7EE),
              error: const Color(0xFFBA1A1A),
            ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
        ),
        fontFamily: 'OpenSans-Regular',
      ),
      routerDelegate: Routes.routes.routerDelegate,
      routeInformationParser: Routes.routes.routeInformationParser,
      routeInformationProvider: Routes.routes.routeInformationProvider,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
    );
  }
}
