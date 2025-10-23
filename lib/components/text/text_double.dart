import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class BaseTextDouble extends StatelessWidget {
  final double label;
  final double size;
  final String color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final bool underline;
  final bool strikeout;
  final String simbol;
  final bool? isPercentase;
  final String suffix;
  final bool? isM3;
  final String format1;
  final String format2;

  const BaseTextDouble({
    super.key,
    required this.label,
    this.size = 11.7,
    this.color = "",
    this.fontWeight = FontWeight.w500,
    this.textAlign = TextAlign.start,
    this.underline = false,
    this.strikeout = false,
    this.simbol = '',
    this.isPercentase = false,
    this.isM3 = false,
    this.suffix = '',
    this.format1 = "##,##0",
    this.format2 = "#,##0.00",
  });

  @override
  Widget build(BuildContext context) {
    var angka = '0';
    var labelFinal = 0.0;

    if (label < 0) {
      labelFinal = label * -1;
    } else {
      labelFinal = label;
    }

    if (labelFinal % 1 == 0) {
      angka =
          '${simbol == '' ? '' : simbol}${NumberFormat(format1, "id_ID").format(labelFinal)}${isPercentase == true
              ? '%'
              : isM3 == true
              ? ' m3'
              : ''}';
    } else {
      angka =
          '${simbol == '' ? '' : simbol}${NumberFormat(format2, 'id_ID').format(labelFinal)}${isPercentase == true
              ? '%'
              : isM3 == true
              ? ' m3'
              : ''}';
    }

    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        label < 0 ? '($angka${' $suffix'})' : '$angka${' $suffix'}',
        textAlign: textAlign,
        softWrap: true,
        style: GoogleFonts.inter(
          color: color == ''
              ? Theme.of(context).textTheme.bodyMedium!.color
              : HexColor(color),
          fontSize: size,
          fontWeight: fontWeight,
          fontStyle: label < 0 ? FontStyle.italic : null,
          decoration: underline == true
              ? TextDecoration.underline
              : strikeout == true
              ? TextDecoration.lineThrough
              : null,
        ),
      ),
    );
  }
}
