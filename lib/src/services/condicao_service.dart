import 'dart:convert';

import 'package:app_ppmob/src/model/condicao.dart';
import 'package:app_ppmob/src/shared/constants/constants.dart';
import 'package:flutter/services.dart';

class CondicaoService {
  Future<List<Condicao>> getCondicao() async {
    final String jsonString = await rootBundle.loadString(Mocks.condicao);
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Condicao.fromJson(json)).toList();
  }

}

