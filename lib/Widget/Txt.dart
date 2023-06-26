import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Txt extends StatelessWidget {
  final String heading;
  final Color clr;
  final FontWeight fWeight;
  final double fsize;
  const Txt({
    super.key,
    required this.heading,
    required this.clr,
    required this.fWeight,
    required this.fsize,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      heading,
      style: GoogleFonts.montserrat(
          color: clr, fontSize: fsize, fontWeight: fWeight),
    );
  }
}
