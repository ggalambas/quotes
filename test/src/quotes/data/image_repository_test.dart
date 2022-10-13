import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:quotes/src/quotes/data/image_repository.dart';
import 'package:quotes/src/quotes/data/quote_repository.dart';

void main() {
  const testImageUrl =
      'https://images.pexels.com/photos/5537770/pexels-photo-5537770.jpeg';
  final testJson = {
    'photos': List.generate(
      pageSize,
      (i) => {
        'src': {'portrait': testImageUrl, 'landscape': testImageUrl}
      },
    )
  };
  late MockClient client;
  late ImageRepository imageRepository;
  setUp(() {
    client = MockClient((_) async => Response(jsonEncode(testJson), 200));
    imageRepository = ImageRepository(client: client);
  });

  group('imageRepository', () {
    test('fetchImageUrl emits a Url', () async {
      final imageUrl = await imageRepository.fetchImageUrl('');
      expect(imageUrl, isA<String>());
      expect(Uri.parse(imageUrl).isAbsolute, true);
    });
  });
}
