// ignore_for_file: unnecessary_this, prefer_collection_literals

class Rodovia {
  String? sgrodovia;
  String? nmrodovia;

  Rodovia({
    this.sgrodovia,
    this.nmrodovia,
  });

   @override
  String toString() {
    return sgrodovia ?? '';
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    map['sgrodovia'] = this.sgrodovia;
    map['nmrodovia'] = this.nmrodovia;
    return map;
  }

  Rodovia toModel(Rodovia rodovia, Map<String, dynamic> data) {
    rodovia.sgrodovia = data['sgrodovia'];
    rodovia.nmrodovia = data['nmrodovia'];
    return rodovia;
  }

  Rodovia.fromJson(Map<String, dynamic> json) {
    sgrodovia = json['sgrodovia'];
    nmrodovia = json['nmrodovia'];
  }
}
