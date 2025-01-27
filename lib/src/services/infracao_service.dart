
import 'dart:convert';

import 'package:app_ppmob/src/model/infracao.dart';
import 'package:app_ppmob/src/shared/constants/constants.dart';
import 'package:flutter/services.dart';

class InfracaoService {
  Future<List<Infracao>> getInfracoes() async {
    final String jsonString = await rootBundle.loadString(Mocks.infracao);
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Infracao.fromJson(json)).toList();
  }

  Future<List<Infracao>> getInfracoesByCategoria(String categoria) async {
    return (await getInfracoes()).where((infracao) => infracao.categoria == categoria).toList();
  }
}