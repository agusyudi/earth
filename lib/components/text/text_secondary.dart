import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class BaseTextSecondary extends StatelessWidget {
  final String label;
  final double size;
  final String color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final bool underline;
  final bool strikeout;
  final bool italic;
  final bool? useEllipsis;

  const BaseTextSecondary({
    super.key,
    required this.label,
    this.size = 12,
    this.color = "",
    this.fontWeight = FontWeight.w500,
    this.textAlign = TextAlign.start,
    this.underline = false,
    this.strikeout = false,
    this.italic = false,
    this.useEllipsis = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: textAlign,
      softWrap: true,
      overflow: useEllipsis == true ? TextOverflow.ellipsis : null,
      style: GoogleFonts.inter(
        color: color == ''
            ? Theme.of(context).textTheme.bodySmall!.color
            : HexColor(color),
        fontSize: size,
        fontWeight: fontWeight,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        decoration: underline == true
            ? TextDecoration.underline
            : strikeout == true
            ? TextDecoration.lineThrough
            : null,
      ),
    );
  }
}
