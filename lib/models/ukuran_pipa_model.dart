class UkuranPipaModel {
  final int idUkuranPipa;
  final String ukuranPipa;
  bool? isloading;

  UkuranPipaModel({required this.idUkuranPipa, required this.ukuranPipa});

  factory UkuranPipaModel.fromJson(Map<String, dynamic> json) {
    return UkuranPipaModel(
      idUkuranPipa: json['IdUkuranPipa'],
      ukuranPipa: json['UkuranPipa'] ?? '',
    );
  }
}
