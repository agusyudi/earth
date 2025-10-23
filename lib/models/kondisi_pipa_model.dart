class KondisiPipaModel {
  final int idKondisiPipa;
  final String kondisiPipa;
  bool? isloading;

  KondisiPipaModel({required this.idKondisiPipa, required this.kondisiPipa});

  factory KondisiPipaModel.fromJson(Map<String, dynamic> json) {
    return KondisiPipaModel(
      idKondisiPipa: json['IdKondisiPipa'],
      kondisiPipa: json['KondisiPipa'] ?? '',
    );
  }
}
