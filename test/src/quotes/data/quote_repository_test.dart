import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:quotes/src/quotes/data/quote_repository.dart';
import 'package:quotes/src/quotes/domain/quote.dart';

void main() {
  const testJson = {
    'data': [
      {'quoteText': 'Test quote', 'quoteAuthor': 'Me', 'quoteGenre': 'Test'}
    ]
  };
  late MockClient client;
  late QuoteRepository quoteRepository;
  setUp(() {
    client = MockClient((_) async => Response(jsonEncode(testJson), 200));
    quoteRepository = QuoteRepository(client: client);
  });

  group('QuoteRepository', () {
    test('fetchRandomQuotes emits a list of pageSize Quotes', () async {
      final quotes = await quoteRepository.fetchRandomQuotes();
      expect(quotes, isA<List<Quote>>());
      expect(quotes, hasLength(pageSize));
    });
  });
}
