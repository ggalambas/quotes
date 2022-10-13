import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quotes/src/quotes/domain/illustrated_quote.dart';
import 'package:quotes/src/quotes/domain/quote.dart';
import 'package:quotes/src/quotes/presentation/quote_controller.dart';

import '../../mocks.dart';

void main() {
  const testQuote = Quote(text: 'Test quote', author: 'Me', genre: 'Test');
  const testImageUrl =
      'https://images.pexels.com/photos/5537770/pexels-photo-5537770.jpeg';
  late MockQuoteRepository quoteRepository;
  late MockImageRepository imageRepository;
  late QuoteController controller;
  setUp(() {
    quoteRepository = MockQuoteRepository();
    imageRepository = MockImageRepository();
    controller = QuoteController(
      quoteRepository: quoteRepository,
      imageRepository: imageRepository,
    );
  });

  group('QuoteController', () {
    test('initial state is empty list', () {
      expect(controller.debugState, hasLength(0));
    });
    group('fetchMoreQuotes', () {
      test('fetchMoreQuotes success', () async {
        // setup
        when(() => quoteRepository.fetchRandomQuotes())
            .thenAnswer((_) => Future.value([testQuote]));
        when(() => imageRepository.fetchImageUrl(testQuote.genre))
            .thenAnswer((_) => Future.value(testImageUrl));
        // expect later
        expectLater(
          controller.stream,
          emits([
            IllustratedQuote(
              quote: testQuote,
              image: Image.network(testImageUrl),
            )
          ]),
        );
        // run
        controller.fetchMoreQuotes();
      });
      test('fetchMoreQuotes failure', () async {
        // setup
        final exception = Exception('Connection failed');
        when(() => quoteRepository.fetchRandomQuotes()).thenThrow(exception);
        // run
        await controller.fetchMoreQuotes();
        // expect later
        expect(controller.debugState, hasLength(0));
      });
    });
  });
}
