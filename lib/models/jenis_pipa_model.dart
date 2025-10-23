class JenisPipaModel {
  final int idJenisPipa;
  final String jenisPipa;
  bool? isloading;

  JenisPipaModel({required this.idJenisPipa, required this.jenisPipa});

  factory JenisPipaModel.fromJson(Map<String, dynamic> json) {
    return JenisPipaModel(
      idJenisPipa: json['IdJenisPipa'],
      jenisPipa: json['JenisPipa'] ?? '',
    );
  }
}
