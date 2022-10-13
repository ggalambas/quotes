import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quotes/src/quotes/domain/illustrated_quote.dart';
import 'package:quotes/src/quotes/domain/quote.dart';
import 'package:share_plus/share_plus.dart';

import 'quotation_mark.dart';

class QuotePage extends ConsumerWidget {
  final bool isLoading;
  final IllustratedQuote quote;
  const QuotePage(this.quote, {Key? key, this.isLoading = false})
      : super(key: key);

  factory QuotePage.loading() => QuotePage(
        isLoading: true,
        IllustratedQuote(
          image: Image.network(kIsWeb
              ? 'https://images.pexels.com/photos/1630039/pexels-photo-1630039.jpeg'
              : 'https://images.pexels.com/photos/5537770/pexels-photo-5537770.jpeg'),
          quote: const Quote(
            text: 'Patience is bitter, but its fruit is sweet.',
            author: 'Jean-Jacques Rousseau',
            genre: 'patience',
          ),
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: 48, horizontal: kIsWeb ? 94 : 48),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: quote.image.image,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.65),
            BlendMode.darken,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          QuotationMark(animated: isLoading),
          Text(
            quote.text.toUpperCase(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontFamily: GoogleFonts.passionOne().fontFamily,
                  color: Colors.white,
                  height: 1.1,
                  fontSize: kIsWeb
                      ? Theme.of(context).textTheme.headlineMedium!.fontSize! *
                          2
                      : null,
                ),
          ),
          const SizedBox(height: 32),
          Align(
            alignment: Alignment.center,
            child: TextButton.icon(
              onPressed: () => Share.share(
                '${quote.text}\n\n~ ${quote.author}',
                subject: 'Interesting quote about ${quote.genre}!',
              ),
              icon: const Icon(Icons.share, size: 18),
              label: const Text('Share'),
            ),
          ),
          const Spacer(),
          Text(
            quote.author,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontFamily: GoogleFonts.passionOne().fontFamily,
                  fontWeight: FontWeight.w300,
                  color: Colors.white54,
                ),
          ),
        ],
      ),
    );
  }
}
