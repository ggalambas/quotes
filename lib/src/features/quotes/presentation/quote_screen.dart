import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quotes/src/common_widgets/drag_up_indicator.dart';
import 'package:quotes/src/features/quotes/data/quote_repository.dart';
import 'package:quotes/src/features/quotes/domain/illustrated_quote.dart';
import 'package:quotes/src/features/quotes/presentation/quote_controller.dart';
import 'package:quotes/src/features/quotes/presentation/quote_page.dart';

Key kQuotePageKey(int i) => Key('quote-page-$i');

class QuoteScreen extends ConsumerWidget {
  const QuoteScreen({Key? key}) : super(key: key);

  void precache(List<IllustratedQuote> quotes, BuildContext context) {
    for (final quote in quotes) {
      precacheImage(quote.image.image, context);
    }
  }

  Future<void> fetchMore(WidgetRef ref, BuildContext context) =>
      ref.read(quoteControllerProvider.notifier).fetchMoreQuotes(
            onImageFetch: (image) => precacheImage(image.image, context),
          );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotes = ref.watch(quoteControllerProvider);
    return Scaffold(
      body: quotes.isEmpty
          ? QuotePage.loading()
          : DragUpIndicator(
              onRefresh: () => fetchMore(ref, context),
              child: Stack(
                children: [
                  QuotePage.loading()
                      .animate()
                      .slide(begin: Offset.zero, end: const Offset(0, -1)),
                  PageView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: quotes.length,
                    itemBuilder: (context, i) {
                      if (i == 0 && quotes.length == pageSize) {
                        precache(quotes, context);
                      }
                      if (i >= quotes.length - 3) fetchMore(ref, context);
                      return QuotePage(
                        quotes[i],
                        key: kQuotePageKey(i),
                      );
                    },
                  )
                      .animate()
                      .slide(begin: const Offset(0, 1), end: Offset.zero),
                ],
              ),
            ),
    );
  }
}
