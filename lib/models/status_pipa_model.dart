class StatusPipaModel {
  final int idStatusPipa;
  final String statusPipa;
  bool? isloading;

  StatusPipaModel({required this.idStatusPipa, required this.statusPipa});

  factory StatusPipaModel.fromJson(Map<String, dynamic> json) {
    return StatusPipaModel(
      idStatusPipa: json['IdStatusPipa'],
      statusPipa: json['StatusPipa'] ?? '',
    );
  }
}
