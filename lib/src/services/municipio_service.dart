import 'dart:convert';

import 'package:app_ppmob/src/model/municipio.dart';
import 'package:app_ppmob/src/shared/constants/constants.dart';
import 'package:flutter/services.dart';

class MunicipioService {
  Future<List<Municipio>> getMunicipios() async {
    final String jsonString = await rootBundle.loadString(Mocks.municipios);
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Municipio.fromJson(json)).toList();
  }

  Future<List<Municipio>> getMunicipiosByEstado(String estado) async {
    return (await getMunicipios()).where((municipio) => municipio.sgunidadefederal == estado).toList();
  }
}