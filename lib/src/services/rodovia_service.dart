import 'dart:convert';

import 'package:app_ppmob/src/model/rodovia.dart';
import 'package:app_ppmob/src/shared/constants/constants.dart';
import 'package:flutter/services.dart';

class RodoviaService {
  Future<List<Rodovia>> getRodovias() async {
    final String jsonString = await rootBundle.loadString(Mocks.rodovia);
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Rodovia.fromJson(json)).toList();
  }

}

