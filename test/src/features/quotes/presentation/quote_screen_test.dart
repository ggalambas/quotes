import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:quotes/src/features/quotes/domain/quote.dart';

import '../../../mocks.dart';
import '../quotes_robot.dart';

void main() {
  const testQuote = Quote(text: 'Test quote', author: 'Me', genre: 'Test');
  const testImageUrl =
      'https://images.pexels.com/photos/5537770/pexels-photo-5537770.jpeg';

  testWidgets('Confirm scroll success', (tester) async {
    mockNetworkImagesFor(() async {
      // setup
      final quoteRepository = MockQuoteRepository();
      final imageRepository = MockImageRepository();
      when(() => quoteRepository.fetchRandomQuotes()).thenAnswer(
        (_) => Future.value(List.generate(2, (_) => testQuote)),
      );
      when(() => imageRepository.fetchImageUrl(testQuote.genre)).thenAnswer(
        (_) => Future.value(testImageUrl),
      );
      // test
      final r = QuotesRobot(tester);
      await r.pumpQuoteScreen(
        quoteRepository: quoteRepository,
        imageRepository: imageRepository,
      );
      r.expectLoadingFound();
      await r.firstPageAnimation();
      r.expectPageFound(0);
      await r.scrollUp();
      r.expectPageFound(1);
    });
  });
}
