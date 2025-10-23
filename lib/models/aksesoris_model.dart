class AksesorisModel {
  int? id;
  String? kode;
  String? nama;
  int? idJenisAksesoris;
  String? jenisAksesoris;
  int? idDiameterAksesoris;
  String? diameterAksesoris;
  String? keterangan;
  String? color;
  String? icon;
  String? warning;
  double? latitude;
  double? longitude;
  dynamic frequency;
  dynamic voltage;
  dynamic current;
  dynamic speed;
  dynamic power;
  dynamic igbtTemp;
  dynamic flowRate;
  dynamic pressure;
  dynamic totalizer;
  dynamic powerStatus;
  dynamic ptStatus;
  dynamic pressureBoost;
  dynamic proportional;
  dynamic integral;
  dynamic setPoint;
  dynamic aksesorisModelIsOverPressure;
  dynamic aksesorisModelIsUnderPressure;
  dynamic deadBand;
  dynamic ptCurrent;
  dynamic ptVoltage;
  dynamic waterTemp;
  dynamic ph;
  dynamic turbidityValue;
  dynamic chlorine;
  dynamic level;
  dynamic runningCount;
  dynamic isForceStop;
  dynamic isBoosting;
  dynamic isUnderPressure;
  dynamic isOverPressure;
  dynamic isPressureTransmitterError;
  dynamic isWaterShortage;
  dynamic isAnalogInputError;
  dynamic isAnalogOutputFault;
  dynamic isDigitalOutputFault;

  AksesorisModel({
    this.id,
    this.kode,
    this.nama,
    this.idJenisAksesoris,
    this.jenisAksesoris,
    this.idDiameterAksesoris,
    this.diameterAksesoris,
    this.keterangan,
    this.color,
    this.icon,
    this.warning,
    this.latitude,
    this.longitude,
    this.frequency,
    this.voltage,
    this.current,
    this.speed,
    this.power,
    this.igbtTemp,
    this.flowRate,
    this.pressure,
    this.totalizer,
    this.powerStatus,
    this.ptStatus,
    this.pressureBoost,
    this.proportional,
    this.integral,
    this.setPoint,
    this.aksesorisModelIsOverPressure,
    this.aksesorisModelIsUnderPressure,
    this.deadBand,
    this.ptCurrent,
    this.ptVoltage,
    this.waterTemp,
    this.ph,
    this.turbidityValue,
    this.chlorine,
    this.level,
    this.runningCount,
    this.isForceStop,
    this.isBoosting,
    this.isUnderPressure,
    this.isOverPressure,
    this.isPressureTransmitterError,
    this.isWaterShortage,
    this.isAnalogInputError,
    this.isAnalogOutputFault,
    this.isDigitalOutputFault,
  });

  factory AksesorisModel.fromJson(Map<String, dynamic> json) => AksesorisModel(
    id: json["Id"],
    kode: json["Kode"],
    nama: json["Nama"],
    idJenisAksesoris: json["IdJenisAksesoris"],
    jenisAksesoris: json["JenisAksesoris"],
    idDiameterAksesoris: json["IdDiameterAksesoris"],
    diameterAksesoris: json["DiameterAksesoris"],
    keterangan: json["Keterangan"],
    color: json["Color"],
    icon: json["Icon"],
    warning: labelwarning(json["Warning"] ?? 0),
    latitude: json["Latitude"]?.toDouble(),
    longitude: json["Longitude"]?.toDouble(),
    frequency: json["Frequency"],
    voltage: json["Voltage"],
    current: json["Current"],
    speed: json["Speed"],
    power: json["Power"],
    igbtTemp: json["Igbt_temp"],
    flowRate: json["Flow_rate"],
    pressure: json["Pressure"],
    totalizer: json["Totalizer"],
    powerStatus: json["Power_status"],
    ptStatus: json["Pt_status"],
    pressureBoost: json["Pressure_boost"],
    proportional: json["Proportional"],
    integral: json["Integral"],
    setPoint: json["Set_point"],
    aksesorisModelIsOverPressure: json["Is_over_pressure"],
    aksesorisModelIsUnderPressure: json["Is_under_pressure"],
    deadBand: json["Dead_band"],
    ptCurrent: json["Pt_current"],
    ptVoltage: json["Pt_voltage"],
    waterTemp: json["Water_temp"],
    ph: json["Ph"],
    turbidityValue: json["Turbidity_value"],
    chlorine: json["Chlorine"],
    level: json["Level"],
    runningCount: json["RunningCount"],
    isForceStop: json["IsForceStop"],
    isBoosting: json["IsBoosting"],
    isUnderPressure: json["IsUnderPressure"],
    isOverPressure: json["IsOverPressure"],
    isPressureTransmitterError: json["IsPressureTransmitterError"],
    isWaterShortage: json["IsWaterShortage"],
    isAnalogInputError: json["IsAnalogInputError"],
    isAnalogOutputFault: json["IsAnalogOutputFault"],
    isDigitalOutputFault: json["IsDigitalOutputFault"],
  );
}

String? labelwarning(int value) {
  switch (value) {
    case 1:
      return "Perlu Perawatan";
    case 2:
      return "Rusak";
    default:
  }

  return "";
}
