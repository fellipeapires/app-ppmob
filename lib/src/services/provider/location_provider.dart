import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider with ChangeNotifier {
  static final LocationProvider _instance = LocationProvider._internal();

  LocationProvider._internal();

  factory LocationProvider() {
    return _instance;
  }

  // Timer? _debounce;
  Position? _currentPosition;
  Map<String, dynamic>? _nearestHighway;
  // List<dynamic>? _rodovias;

  Position? get currentPosition => _currentPosition;
  Map<String, dynamic>? get nearestHighway => _nearestHighway;

  Future<void> startLocationTracking() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    if (_currentPosition == null) {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      notifyListeners();
    }

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 50,
      ),
    ).listen((Position position) {
      _currentPosition = position;
      // verificarProximidadeDebounce(position);
      notifyListeners();
    });
  }

  // Função para calcular a distância entre dois pontos (em metros)
  double calcularDistancia(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // Math.PI / 180
    final a = 0.5 -
        math.cos((lat2 - lat1) * p) / 2 +
        math.cos(lat1 * p) *
            math.cos(lat2 * p) *
            (1 - math.cos((lon2 - lon1) * p)) /
            2;

    return 12742000 * math.asin(math.sqrt(a)); // 2 * R; R = 6371 km em metros
  }

  // Future<void> carregarRodovias() async {
  //   if (_rodovias == null) {
  //     try {
  //       final jsonString = await rootBundle.loadString(Mocks.coordenadasRodovias);
  //       _rodovias = jsonDecode(jsonString);
  //     } catch (e) {
  //       if (kDebugMode) {
  //         print('Erro ao carregar rodovias: $e');
  //       }
  //     }
  //   }
  // }

  // void verificarProximidadeDebounce(Position position) {
  //   if (kDebugMode) {
  //     print('verificarProximidadeDebounce');
  //   }
  //   if (_debounce?.isActive ?? false) _debounce!.cancel();
  //   _debounce = Timer(const Duration(milliseconds: 500), () {
  //     verificarRodoviaMaisProxima(position);
  //   });
  // }

  // Função para verificar rodovia mais próxima usando Isolate
  // Future<void> verificarRodoviaMaisProxima(Position posicao) async {
  //   if (kDebugMode) {
  //     print('verificando proximidade / verificarRodoviaMaisProxima');
  //   }

  //   await carregarRodovias();

  //   // Usa o compute para mover o cálculo para outro isolate
  //   final resultado = await compute(_calcularRodoviaMaisProxima, {
  //     'posicao': posicao.toJson(),
  //     'rodovias': _rodovias,
  //   });

  //   if (resultado != null) {
  //     _nearestHighway = resultado;
  //     notifyListeners(); // Atualiza os ouvintes com a rodovia mais próxima
  //   } else {
  //     if (kDebugMode) {
  //       print('Nenhum local encontrado.');
  //     }
  //   }
  // }

  // Função que será executada no isolate
  // static Map<String, dynamic>? _calcularRodoviaMaisProxima(Map<String, dynamic> data) {
  //   Position posicao = Position.fromMap(data['posicao']);
  //   List<dynamic> rodovias = data['rodovias'];

  //   double menorDistancia = double.infinity;
  //   Map<String, dynamic>? localMaisProximo;

  //   for (final rodovia in rodovias) {
  //     final double distancia = _calcularDistancia(
  //       posicao.latitude,
  //       posicao.longitude,
  //       rodovia['VLLATITUDE'],
  //       rodovia['VLLONGITUDE'],
  //     );

  //     if (distancia < menorDistancia && distancia <= 50) {
  //       menorDistancia = distancia;
  //       localMaisProximo = rodovia;
  //     }
  //   }

  //   if (localMaisProximo != null) {
  //     return {
  //       'sgrodovia': localMaisProximo['SGRODOVIA'] ?? '',
  //       'kmRodovia': localMaisProximo['NUKM'] ?? 0,
  //       'latitude': localMaisProximo['VLLATITUDE'] ?? 0.0,
  //       'longitude': localMaisProximo['VLLONGITUDE'] ?? 0.0,
  //       'distancia': menorDistancia,
  //       'nmMunicipio': localMaisProximo['NMMUNICIPIO'] ?? '',
  //       'cdMunicipio': localMaisProximo['CDMUNICIPIO'] ?? 0,
  //     };
  //   } else {
  //     return null;
  //   }
  // }

  // Helper para calcular a distância entre dois pontos (isolated)
  // static double _calcularDistancia(double lat1, double lon1, double lat2, double lon2) {
  //   const p = 0.017453292519943295; // Math.PI / 180
  //   final a = 0.5 -
  //       math.cos((lat2 - lat1) * p) / 2 +
  //       math.cos(lat1 * p) *
  //           math.cos(lat2 * p) *
  //           (1 - math.cos((lon2 - lon1) * p)) /
  //           2;

  //   return 12742000 * math.asin(math.sqrt(a)); // 2 * R; R = 6371 km em metros
  // }
}
