import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class BaseTextDateTime extends StatelessWidget {
  final DateTime? label;
  final String customFormat;
  final double size;
  final String color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final bool underline;
  final bool longFormat;
  final bool strikeout;
  final bool showTime;

  const BaseTextDateTime({
    super.key,
    required this.label,
    this.customFormat = "",
    this.size = 12,
    this.color = "",
    this.fontWeight = FontWeight.w500,
    this.textAlign = TextAlign.start,
    this.longFormat = false,
    this.underline = false,
    this.strikeout = false,
    this.showTime = false,
  });

  String get dateTimeFormat {
    if (customFormat.trim() != "") {
      return customFormat;
    }
    if (longFormat) {
      return "dd MMMM yyyy ${showTime ? "HH:mm" : ""}";
    }
    return "dd MMMM yyyy ${showTime ? "HH:mm" : ""}";
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      label == null
          ? "-"
          : DateFormat(dateTimeFormat, 'id_ID').format(label ?? DateTime.now()),
      textAlign: textAlign,
      softWrap: true,
      style: GoogleFonts.inter(
        color: color == ''
            ? Theme.of(context).textTheme.bodyMedium!.color
            : HexColor(color),
        fontSize: size,
        fontWeight: fontWeight,
        decoration: underline == true
            ? TextDecoration.underline
            : strikeout == true
            ? TextDecoration.lineThrough
            : null,
      ),
    );
  }
}
