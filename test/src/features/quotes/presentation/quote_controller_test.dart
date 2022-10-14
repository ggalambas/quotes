@Timeout(Duration(milliseconds: 500))

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quotes/src/features/quotes/domain/illustrated_quote.dart';
import 'package:quotes/src/features/quotes/domain/quote.dart';
import 'package:quotes/src/features/quotes/presentation/quote_controller.dart';

import '../../../mocks.dart';

void main() {
  const testQuote = Quote(text: 'Test quote', author: 'Me', genre: 'Test');
  const testImageUrl =
      'https://images.pexels.com/photos/5537770/pexels-photo-5537770.jpeg';
  final testIllustratedQuote =
      IllustratedQuote(quote: testQuote, image: Image.network(testImageUrl));
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
    group('fetchMoreQuotes', () {
      test('fetchMoreQuotes updates state with a quote', () async {
        // setup
        when(() => quoteRepository.fetchRandomQuotes())
            .thenAnswer((_) => Future.value([testQuote]));
        when(() => imageRepository.fetchImageUrl(testQuote.genre))
            .thenAnswer((_) => Future.value(testImageUrl));
        // expect later
        expectLater(
          controller.stream,
          emits([testIllustratedQuote]),
        );
        // run
        controller.fetchMoreQuotes();
      });
      test('fetchMoreQuotes gets empty list, does not update state', () async {
        // setup
        when(() => quoteRepository.fetchRandomQuotes())
            .thenAnswer((_) => Future.value([]));
        // run
        await controller.fetchMoreQuotes();
        // expect
        expect(controller.debugState, []);
      });
      test('fetchMoreQuotes catches exception, does not update state ',
          () async {
        // setup
        final exception = Exception('Connection failed');
        when(() => quoteRepository.fetchRandomQuotes()).thenThrow(exception);
        // run
        await controller.fetchMoreQuotes();
        // expect
        expect(controller.debugState, []);
      });
    });
  });
}
