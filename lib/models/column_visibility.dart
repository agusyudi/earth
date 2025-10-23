class ColumnSettingModel {
  final String name;
  final String label;
  bool value;
  double? width;
  double? minimumWidth;

  ColumnSettingModel({
    required this.name,
    required this.label,
    this.value = true,
    this.width,
    this.minimumWidth,
  });

  factory ColumnSettingModel.fromJson(Map<String, dynamic> json) =>
      ColumnSettingModel(
        name: json["Name"],
        label: json["Label"],
        value: json["Value"] ?? true,
        width: json["Width"],
        minimumWidth: json["MinimumWidth"],
      );

  Map<String, dynamic> toJson() => {
    "Name": name,
    "Label": label,
    "Value": value,
    "Width": width,
    "MinimumWidth": minimumWidth,
  };

  ColumnSettingModel copy() {
    return ColumnSettingModel(
      name: name,
      label: label,
      value: value,
      width: width,
      minimumWidth: minimumWidth,
    );
  }
}
