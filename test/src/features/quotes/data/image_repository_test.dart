@Timeout(Duration(milliseconds: 500))

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:quotes/src/features/quotes/data/image_repository.dart';
import 'package:quotes/src/features/quotes/data/quote_repository.dart';

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

  group('imageRepository', () {
    group('fetchImageUrl', () {
      test('returns a Url', () async {
        client = MockClient((_) async => Response(jsonEncode(testJson), 200));
        imageRepository = ImageRepository(client: client);
        expect(
          await imageRepository.fetchImageUrl(''),
          testImageUrl,
        );
      });
      test('throws an exception', () {
        client = MockClient((_) async => Response(jsonEncode(testJson), 404));
        imageRepository = ImageRepository(client: client);
        expectLater(
          () => imageRepository.fetchImageUrl(''),
          throwsException,
        );
      });
    });
  });
}
