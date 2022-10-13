import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:quotes/src/quotes/data/quote_repository.dart';

final imageRepositoryProvider = Provider<ImageRepository>(
  (ref) => ImageRepository(client: http.Client()),
);

class ImageRepository {
  final http.Client client;
  ImageRepository({required this.client});

  //! Deal with this
  // https://codewithandrea.com/articles/flutter-api-keys-dart-define-env-files/
  final _apiKeys = [
    '563492ad6f917000010000015192654429284271b9175ad150bce747',
    '563492ad6f917000010000010f5ecac2ee4e44f3b751a69f3c52cca2',
  ];

  Future<String> fetchImageUrl(String query, [int keyIndex = 0]) async {
    final response = await client.get(
      Uri.https(
        'api.pexels.com',
        '/v1/search',
        {
          'query': query,
          'orientation': kIsWeb ? 'landscape' : 'portrait',
          'size': 'small',
          'per_page': '$pageSize',
        },
      ),
      headers: {'Authorization': _apiKeys[keyIndex]},
    );

    // Requests exceeded for one of the api keys
    if (response.statusCode == 429 && keyIndex < _apiKeys.length) {
      return fetchImageUrl(query, 1);
    }
    if (response.statusCode != 200) throw Exception('Failed to load image');

    final json = jsonDecode(response.body);
    final images = json['photos'] as List;
    final index = Random().nextInt(pageSize);
    final source = images[index]['src'] as Map<String, dynamic>;
    return source[kIsWeb ? 'landscape' : 'portrait'];
  }
}
