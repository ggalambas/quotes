import 'package:flutter/material.dart';
import 'package:flutter_animate/animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quotes/src/features/quotes/data/image_repository.dart';
import 'package:quotes/src/features/quotes/data/quote_repository.dart';
import 'package:quotes/src/features/quotes/presentation/quote_page.dart';
import 'package:quotes/src/features/quotes/presentation/quote_screen.dart';

class QuotesRobot {
  final WidgetTester tester;
  QuotesRobot(this.tester);

  Future<void> pumpQuoteScreen({
    QuoteRepository? quoteRepository,
    ImageRepository? imageRepository,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          if (quoteRepository != null)
            quoteRepositoryProvider.overrideWithValue(quoteRepository),
          if (imageRepository != null)
            imageRepositoryProvider.overrideWithValue(imageRepository),
        ],
        child: const MaterialApp(
          home: QuoteScreen(),
        ),
      ),
    );
  }

  void expectLoadingFound() {
    final loading = find.byKey(kQuotePageLoadingKey);
    expect(loading, findsOneWidget);
  }

  void expectPageFound(int i) {
    final page = find.byKey(kQuotePageKey(i));
    expect(page, findsOneWidget);
  }

  Future<void> firstPageAnimation() async {
    await tester.pumpAndSettle(Animate.defaultDuration);
  }

  Future<void> scrollUp() async {
    await tester.dragFrom(const Offset(0, 0.5), const Offset(0, -1));
    await tester.pump();
  }
}
