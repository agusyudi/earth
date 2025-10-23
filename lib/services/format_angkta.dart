import 'package:intl/intl.dart';

String formatAngkaTanpaNol(double value) {
  // Simpan apakah negatif
  bool isNegative = value < 0;

  // Ambil nilai absolut (tanpa tanda minus)
  double absValue = value.abs();

  // Format ke 3 desimal
  String str = absValue.toStringAsFixed(3);

  // Hapus nol di belakang koma, dan titik jika tidak dibutuhkan
  str = str.replaceFirst(RegExp(r'\.?0+$'), '');

  // Ganti titik dengan koma
  str = str.replaceAll('.', ',');

  // Jika negatif, bungkus dengan tanda kurung
  if (isNegative) {
    str = '($str)';
  }

  return str;
}

String formatAngkaIndonesia(double value) {
  final isNegative = value < 0;
  final absValue = value.abs();

  // Format 3 desimal
  String str = absValue.toStringAsFixed(3);

  // Hapus nol yang tidak perlu di akhir
  str = str.replaceFirst(RegExp(r'\.?0+$'), '');

  // Pisahkan bagian integer dan desimal
  List<String> parts = str.split('.');
  String integerPart = parts[0];
  String decimalPart = parts.length > 1 ? parts[1] : '';

  // Format bagian ribuan dengan delimiter "."
  final formatter = NumberFormat("#,##0", "id_ID");
  integerPart = formatter.format(int.parse(integerPart));

  // Gabungkan kembali dengan koma sebagai pemisah desimal
  String formatted = decimalPart.isNotEmpty
      ? '$integerPart,$decimalPart'
      : integerPart;

  // Jika minus → bungkus dengan tanda kurung
  return isNegative ? '($formatted)' : formatted;
}

String formatInteger(int value) {
  final isNegative = value < 0;
  final absValue = value.abs();
  final formatter = NumberFormat("#,##0", "id_ID");
  String formatted = formatter.format(absValue);
  formatted = formatted.replaceAll(',', '.');
  return isNegative ? '($formatted)' : formatted;
}
