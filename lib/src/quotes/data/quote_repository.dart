import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:quotes/src/quotes/domain/quote.dart';

final quoteRepositoryProvider = Provider<QuoteRepository>(
  (ref) => QuoteRepository(client: http.Client()),
);

const pageSize = 10;

class QuoteRepository {
  final http.Client client;
  QuoteRepository({required this.client});

  /// Fetch [count] random quotes
  Future<List<Quote>> fetchRandomQuotes({int pageSize = pageSize}) async {
    if (pageSize == 0) return [];

    final response = await client.get(Uri.https(
      'quote-garden.herokuapp.com',
      '/api/v3/quotes/random',
      {
        'count': '$pageSize',
        'limit': '$pageSize',
      },
    ));

    if (response.statusCode != 200) throw Exception('Failed to load quote');

    final json = jsonDecode(response.body);
    final jsonData = json['data'] as List;
    final quotes = jsonData
        .map((json) => Quote.fromJson(json))
        .toList()
        .where((quote) => quote.text.length < 200);

    return [
      ...quotes,
      ...await fetchRandomQuotes(pageSize: pageSize - quotes.length),
    ];
  }
}
