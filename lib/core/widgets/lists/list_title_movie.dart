import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_fe/core/enums/movie_type.dart';
import 'package:movie_fe/core/models/movie_item.dart';
import 'package:movie_fe/core/widgets/cards/movie_card.dart';

class ListTitleMovie extends ConsumerWidget {
  const ListTitleMovie({super.key, required this.movies});

  final List<MovieItem> movies;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) => MovieCard(
        movie: movies[index],
        movieCardType: MovieCardType.vertical,
        width: 120,
        height: 184,
        genres: [
          'Action', 'Drama'
        ],
      ),
      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 24),
      itemCount: movies.length,
    );
  }
}
