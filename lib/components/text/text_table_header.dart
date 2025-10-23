import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class BaseTextTableHeader extends StatelessWidget {
  final String label;
  final double size;
  final String color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final bool underline;
  final bool strikeout;

  const BaseTextTableHeader({
    super.key,
    required this.label,
    this.size = 12,
    this.color = "",
    this.fontWeight = FontWeight.w500,
    this.textAlign = TextAlign.start,
    this.underline = false,
    this.strikeout = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: textAlign,
      softWrap: true,
      style: GoogleFonts.inter(
        color: color == '' ? const Color(0XFFFFFFFF) : HexColor(color),
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
