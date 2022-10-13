import 'package:mocktail/mocktail.dart';
import 'package:quotes/src/quotes/data/image_repository.dart';
import 'package:quotes/src/quotes/data/quote_repository.dart';

class MockQuoteRepository extends Mock implements QuoteRepository {}

class MockImageRepository extends Mock implements ImageRepository {}
