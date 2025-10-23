class SpamSummaryModel {
  final int idSpam;
  final String namaSPam;
  final double hargaM3;
  double? latitude;
  double? longitude;
  double? totalizerBulanIni;
  double? totalizerMingguIni;
  double? tekanan;
  bool? isloading;

  SpamSummaryModel({
    required this.idSpam,
    required this.namaSPam,
    required this.hargaM3,
    this.latitude,
    this.longitude,
    required this.totalizerBulanIni,
    required this.totalizerMingguIni,
    required this.tekanan,
  });

  factory SpamSummaryModel.fromJson(Map<String, dynamic> json) {
    return SpamSummaryModel(
      idSpam: json['IdSpam'],
      namaSPam: json['NamaSpam'] ?? '',
      hargaM3: json['HargaM3'] ?? 0.0,
      latitude: json["Latitude"]?.toDouble(),
      longitude: json["Longitude"]?.toDouble(),
      totalizerBulanIni: json["TotalizerBulanIni"] ?? 0.0,
      totalizerMingguIni: json["TotalizerMingguIni"] ?? 0.0,
      tekanan: json["Tekanan"] ?? 0.0,
    );
  }
}
