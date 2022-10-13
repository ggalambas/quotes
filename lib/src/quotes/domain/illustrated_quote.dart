import 'package:flutter/material.dart';

import 'quote.dart';

class IllustratedQuote extends Quote {
  final Image image;

  IllustratedQuote({required Quote quote, required this.image})
      : super(text: quote.text, author: quote.author, genre: quote.genre);
}
