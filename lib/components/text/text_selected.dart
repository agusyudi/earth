import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class BaseSelectedText extends StatelessWidget {
  const BaseSelectedText({
    super.key,
    required this.label,
    this.size = 12,
    this.color = '',
    this.fontWeight = FontWeight.w500,
    this.textAlign = TextAlign.start,
    this.underline = false,
    this.strikeout = false,
    this.useEllipsis,
  });

  final String label;
  final double size;
  final String color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final bool underline;
  final bool strikeout;
  final bool? useEllipsis;

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      label,
      textAlign: textAlign,
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
