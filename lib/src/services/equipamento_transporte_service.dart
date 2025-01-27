import 'dart:convert';

import 'package:app_ppmob/src/model/equipamento_transporte.dart';
import 'package:app_ppmob/src/shared/constants/constants.dart';
import 'package:flutter/services.dart';

class EquipamentoTransporteService {
  Future<List<EquipamentoTransporte>> getEquipamentoTransporte() async {
    final String jsonString = await rootBundle.loadString(Mocks.equipamentoTransporte);
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => EquipamentoTransporte.fromJson(json)).toList();
  }

}

