import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class BaseText extends StatelessWidget {
  final String label;
  final double size;
  final String color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final bool underline;
  final bool strikeout;
  final bool? useEllipsis;
  final bool? italic;

  const BaseText({
    super.key,
    required this.label,
    this.size = 12,
    this.color = "",
    this.fontWeight = FontWeight.w500,
    this.textAlign = TextAlign.start,
    this.underline = false,
    this.strikeout = false,
    this.useEllipsis = false,
    this.italic = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: textAlign,
      softWrap: true,
      overflow: useEllipsis == true ? TextOverflow.ellipsis : null,
      style: GoogleFonts.inter(
        fontStyle: italic == true ? FontStyle.italic : null,
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
