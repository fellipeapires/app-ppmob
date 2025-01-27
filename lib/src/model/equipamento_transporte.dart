// ignore_for_file: unnecessary_this, prefer_collection_literals

class EquipamentoTransporte {
  String? nmEquipamentoTransporte;

  EquipamentoTransporte({
    this.nmEquipamentoTransporte,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    map['nm_equipamento_transporte'] = this.nmEquipamentoTransporte;
    return map;
  }

  EquipamentoTransporte toModel(Map<String, dynamic> data) {
    EquipamentoTransporte tipoCarga = EquipamentoTransporte(nmEquipamentoTransporte: data['nm_equipamento_transporte']);
    return tipoCarga;
  }

  EquipamentoTransporte.fromJson(Map<String, dynamic> json) {
    nmEquipamentoTransporte = json['nmequipamento'];
  }
}
