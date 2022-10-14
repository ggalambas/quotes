@Timeout(Duration(milliseconds: 500))

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:quotes/src/quotes/data/quote_repository.dart';
import 'package:quotes/src/quotes/domain/quote.dart';

void main() {
  const testJson = {
    'data': [
      {'quoteText': 'text', 'quoteAuthor': 'author', 'quoteGenre': 'genre'}
    ]
  };
  late MockClient client;
  late QuoteRepository quoteRepository;

  group('QuoteRepository', () {
    group('fetchRandomQuotes', () {
      test('returns an empty list', () async {
        client = MockClient((_) async => Response(jsonEncode(testJson), 200));
        quoteRepository = QuoteRepository(client: client);
        expect(
          await quoteRepository.fetchRandomQuotes(pageSize: 0),
          [],
        );
      });
      test('returns a list with a single quote', () async {
        client = MockClient((_) async => Response(jsonEncode(testJson), 200));
        quoteRepository = QuoteRepository(client: client);
        expect(
          await quoteRepository.fetchRandomQuotes(pageSize: 1),
          [Quote.fromJson(testJson['data']!.first)],
        );
      });
      test('returns a list with pageSize quotes', () async {
        client = MockClient((_) async => Response(jsonEncode(testJson), 200));
        quoteRepository = QuoteRepository(client: client);
        expect(
          await quoteRepository.fetchRandomQuotes(),
          List.generate(
            pageSize,
            (_) => Quote.fromJson(testJson['data']!.first),
          ),
        );
      });
      test('throws an exception', () {
        client = MockClient((_) async => Response(jsonEncode(testJson), 404));
        quoteRepository = QuoteRepository(client: client);
        expect(
          () => quoteRepository.fetchRandomQuotes(),
          throwsException,
        );
      });
    });
  });
}
