import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quotes/src/features/quotes/data/image_repository.dart';
import 'package:quotes/src/features/quotes/data/quote_repository.dart';
import 'package:quotes/src/features/quotes/domain/illustrated_quote.dart';

final quoteControllerProvider =
    StateNotifierProvider<QuoteController, List<IllustratedQuote>>((ref) {
  final quoteRepository = ref.watch(quoteRepositoryProvider);
  final imageRepository = ref.watch(imageRepositoryProvider);
  return QuoteController(
    quoteRepository: quoteRepository,
    imageRepository: imageRepository,
  );
});

class QuoteController extends StateNotifier<List<IllustratedQuote>> {
  final QuoteRepository quoteRepository;
  final ImageRepository imageRepository;

  QuoteController({
    required this.quoteRepository,
    required this.imageRepository,
  }) : super([]) {
    fetchMoreQuotes();
  }

  Future<void> fetchMoreQuotes({
    void Function(Image image)? onImageFetch,
  }) async {
    try {
      final quotes = await quoteRepository.fetchRandomQuotes();
      final illustrated = await Future.wait(
        quotes.map((quote) async {
          // print(quote.genre);
          final imageUrl = await imageRepository.fetchImageUrl(quote.genre);
          // print(imageUrl);
          final image = Image.network(imageUrl);
          onImageFetch?.call(image);
          return IllustratedQuote(quote: quote, image: image);
        }),
      );
      if (illustrated.isNotEmpty) {
        state = [...state, ...illustrated];
      }
    } catch (_) {}
  }
}
