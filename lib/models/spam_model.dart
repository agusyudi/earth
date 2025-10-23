class SpamModel {
  final int idSpam;
  final String namaSPam;
  final double hargaM3;
  double? latitude;
  double? longitude;
  bool? isloading;

  SpamModel({
    required this.idSpam,
    required this.namaSPam,
    required this.hargaM3,
    required this.latitude,
    required this.longitude,
  });

  factory SpamModel.fromJson(Map<String, dynamic> json) {
    return SpamModel(
      idSpam: json['IdSpam'],
      namaSPam: json['NamaSpam'] ?? '',
      hargaM3: json['HargaM3'] ?? 0.0,
      latitude: json["Latitude"]?.toDouble(),
      longitude: json["Longitude"]?.toDouble(),
    );
  }
}
