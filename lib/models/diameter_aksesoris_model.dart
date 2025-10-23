class DiameterAksesorisModel {
  final int idDiameterAksesoris;
  final String diameterAksesoris;
  bool? isloading;

  DiameterAksesorisModel({
    required this.idDiameterAksesoris,
    required this.diameterAksesoris,
  });

  factory DiameterAksesorisModel.fromJson(Map<String, dynamic> json) {
    return DiameterAksesorisModel(
      idDiameterAksesoris: json['IdDiameterAksesoris'],
      diameterAksesoris: json['DiameterAksesoris'] ?? '',
    );
  }
}
