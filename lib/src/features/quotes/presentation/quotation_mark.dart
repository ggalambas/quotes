import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class QuotationMark extends StatelessWidget {
  final bool animated;
  const QuotationMark({Key? key, this.animated = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = Text(
      '"',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            fontFamily: GoogleFonts.passionOne().fontFamily,
            fontSize: 96,
            color: Theme.of(context).colorScheme.primary,
            height: 0.4,
          ),
    );
    return !animated
        ? text
        : text
            .animate(
              onPlay: (controller) => controller.repeat(),
            )
            .shake(
              delay: 250.ms,
              duration: 1.5.seconds,
              hz: 4,
              curve: Curves.easeInOutCubic,
            )
            .scale(begin: 1.0, end: 1.1, duration: 500.ms)
            .then(delay: 500.ms)
            .scale(begin: 1, end: 1 / 1.1);
  }
}
