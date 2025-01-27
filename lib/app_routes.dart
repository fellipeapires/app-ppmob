import 'package:app_ppmob/src/screen/documentos_screen/condutor_screen.dart';
import 'package:app_ppmob/src/screen/documentos_screen/expedidor_screen.dart';
import 'package:app_ppmob/src/screen/documentos_screen/painel_documentos_screen.dart';
import 'package:app_ppmob/src/screen/documentos_screen/local_fiscalizacao_screen.dart';
import 'package:app_ppmob/src/screen/documentos_screen/documento_fiscal_screen.dart';
import 'package:app_ppmob/src/screen/documentos_screen/transportador_screen.dart';
import 'package:app_ppmob/src/screen/home_screen/home_screen.dart';
import 'package:app_ppmob/src/screen/login_screen/login_screen.dart';
import 'package:app_ppmob/src/screen/questionario_screen/painel_questionario_screen.dart';
import 'package:app_ppmob/src/screen/splash_screen/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const splashScreen = '/';
  static const loginScreen = '/loginScreen';
  static const homeScreen = '/homeScreen';
  static const painelDocumentosScreen = '/painelDocumentosScreen';
  static const localFiscalizacaoScreen = '/localFiscalizacaoScreen';
  static const transportadorScreen = '/transportadorScreen';
  static const expedidorScreen = '/expedidorScreen';
  static const condutorScreen = '/condutorScreen';
  static const documentoFiscalScreen = '/documentoFiscalScreen';
  static const detalheDocumentoFiscalScreen = '/detalheDocumentoFiscalScreen';
  static const painelQuestionarioScreen = '/painelQuestionarioScreen';
}

class Routes {
  static final routes = GoRouter(
    initialLocation: AppRoutes.splashScreen,
    routes: [
      GoRoute(
        path: AppRoutes.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.loginScreen,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.homeScreen,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.painelDocumentosScreen,
        builder: (context, state) => const PainelDocumentosScreen(),
      ),
      GoRoute(
        path: AppRoutes.localFiscalizacaoScreen,
        builder: (context, state) => const LocalFiscalizacaoScreen(),
      ),
      GoRoute(
        path: AppRoutes.condutorScreen,
        builder: (context, state) => CondutorScreen(),
      ),
      GoRoute(
        path: AppRoutes.expedidorScreen,
        builder: (context, state) => const ExpedidorScreen(),
      ),
      GoRoute(
        path: AppRoutes.transportadorScreen,
        builder: (context, state) => const TransportadorScreen(),
      ),
      GoRoute(
        path: AppRoutes.documentoFiscalScreen,
        builder: (context, state) => const DocumentoFiscalScreen(),
      ),
      GoRoute(
        path: AppRoutes.painelQuestionarioScreen,
        builder: (context, state) => const PainelQuestionarioScreen(),
      ),
    ],
  );
}
