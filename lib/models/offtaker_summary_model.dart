class OfftakerSummaryModel {
  final int idOfftaker;
  final String namaOfftaker;
  double? latitude;
  double? longitude;
  double? totalizerBulanIni;
  int? countOfftaker;
  double? perkiraanTagihan;
  bool? isloading;

  OfftakerSummaryModel({
    required this.idOfftaker,
    required this.namaOfftaker,
    required this.latitude,
    required this.longitude,
    required this.totalizerBulanIni,
    required this.countOfftaker,
    required this.perkiraanTagihan,
  });

  factory OfftakerSummaryModel.fromJson(Map<String, dynamic> json) {
    return OfftakerSummaryModel(
      idOfftaker: json['IdOfftaker'],
      namaOfftaker: json['NamaOfftaker'] ?? '',
      latitude: json["Latitude"]?.toDouble(),
      longitude: json["Longitude"]?.toDouble(),
      totalizerBulanIni: json["TotalizerBulanIni"] ?? 0.0,
      countOfftaker: json["CountOfftaker"] ?? 0,
      perkiraanTagihan: json["PerkiraanTagihan"] ?? 0.0,
    );
  }
}
