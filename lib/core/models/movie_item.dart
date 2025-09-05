// lib/features/books/models/book_item.dart
import 'package:equatable/equatable.dart';

class MovieItem extends Equatable {
  final String id;
  final String title;
  final String imageUrl;
  final double rating;
  final double price;

  const MovieItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.price,
  });

  factory MovieItem.fromJson(Map<String, dynamic> json) {
    return MovieItem(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      imageUrl: json['image_url'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image_url': imageUrl,
      'rating': rating,
      'price': price,
    };
  }

  @override
  List<Object?> get props => [id, title, imageUrl, rating, price];
}