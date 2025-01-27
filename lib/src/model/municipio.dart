// ignore_for_file: unnecessary_this, prefer_collection_literals

class Municipio {
  int? cdmunicipio;
  String? nmmunicipio;
  String? sgunidadefederal;
  int? cdmunicipioibge;
  String? cdcodigotom;
  String? cddigitotom;
  String? flforauso;

  Municipio({
    this.cdmunicipio,
    this.nmmunicipio,
    this.sgunidadefederal,
    this.cdmunicipioibge,
    this.cdcodigotom,
    this.cddigitotom,
    this.flforauso,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    map['cdmunicipio'] = this.cdmunicipio;
    map['nmmunicipio'] = this.nmmunicipio;
    map['sgunidadefederal'] = this.sgunidadefederal;
    map['cdmunicipioibge'] = this.cdmunicipioibge;
    map['cdcodigotom'] = this.cdcodigotom;
    map['cddigitotom'] = this.cddigitotom;
    map['flforauso'] = this.flforauso;
    return map;
  }

  Municipio toModel(Map<String, dynamic> data) {
    Municipio municipio = Municipio();
    municipio.cdmunicipio = data['cdmunicipio'];
    municipio.nmmunicipio = data['nmmunicipio'];
    municipio.sgunidadefederal = data['sgunidadefederal'];
    municipio.cdmunicipioibge = data['cdmunicipioibge'];
    municipio.cdcodigotom = data['cdcodigotom'];
    municipio.cddigitotom = data['cddigitotom'];
    municipio.flforauso = data['flforauso'];
    return municipio;
  }

  Municipio.fromJson(Map<String, dynamic> json) {
    cdmunicipio = json['cdmunicipio'];
    nmmunicipio = json['nmmunicipio'];
    sgunidadefederal = json['sgunidadefederal'];
    cdmunicipioibge = json['cdmunicipioibge'];
    cdcodigotom = json['cdcodigotom'];
    cddigitotom = json['cddigitotom'];
    flforauso = json['flforauso'];
  }

}
