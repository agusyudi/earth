class OfftakerModel {
  final int idOfftaker;
  final String namaOfftaker;
  double? latitude;
  double? longitude;
  bool? isloading;

  OfftakerModel({
    required this.idOfftaker,
    required this.namaOfftaker,
    required this.latitude,
    required this.longitude,
  });

  factory OfftakerModel.fromJson(Map<String, dynamic> json) {
    return OfftakerModel(
      idOfftaker: json['IdOfftaker'],
      namaOfftaker: json['NamaOfftaker'] ?? '',
      latitude: json["Latitude"]?.toDouble(),
      longitude: json["Longitude"]?.toDouble(),
    );
  }
}
