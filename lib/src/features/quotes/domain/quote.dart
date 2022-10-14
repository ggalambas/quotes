import 'package:equatable/equatable.dart';

class Quote with EquatableMixin {
  final String text;
  final String author;
  final String genre;

  const Quote({
    required this.text,
    required this.author,
    required this.genre,
  });

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        text: json['quoteText'],
        author: json['quoteAuthor'],
        genre: json['quoteGenre'],
      );

  @override
  List<Object?> get props => [text];
}
