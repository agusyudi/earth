class JenisAksesorisModel {
  final int idJenisAksesoris;
  final String jenisAksesoris;
  bool? isloading;

  JenisAksesorisModel({
    required this.idJenisAksesoris,
    required this.jenisAksesoris,
  });

  factory JenisAksesorisModel.fromJson(Map<String, dynamic> json) {
    return JenisAksesorisModel(
      idJenisAksesoris: json['IdJenisAksesoris'],
      jenisAksesoris: json['JenisAksesoris'] ?? '',
    );
  }
}
