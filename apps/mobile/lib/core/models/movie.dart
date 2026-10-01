class Movie {
  final String id;
  final String name;
  final String originName;
  final String slug;
  final String originalId;
  final String type;
  final String status;
  final String? content;
  final String? notify;
  final String? showtimes;
  final String? trailerUrl;
  final String? posterUrl;
  final String? thumbUrl;
  final String? quality;
  final String? time;
  final String? lang;
  final int? year;
  final int? view;
  final String? episodeCurrent;
  final String? episodeTotal;
  final bool? chieurap;
  final bool? subDocquyen;
  final bool? isCopyright;
  
  // Nested objects
  final List<Map<String, dynamic>>? country;
  final List<Map<String, dynamic>>? category;
  final List<String>? director;
  final List<String>? actor;
  final List<String>? alternativeNames;
  final Map<String, dynamic>? tmdb;
  final Map<String, dynamic>? imdb;
  final Map<String, dynamic>? price;
  final List<Map<String, dynamic>>? episodes;
  
  // Timestamps
  final DateTime? originalCreatedAt;
  final DateTime? originalModifiedAt;
  final Map<String, dynamic>? createdAt;
  final Map<String, dynamic>? updatedAt;

  Movie({
    required this.id,
    required this.name,
    required this.originName,
    required this.slug,
    required this.originalId,
    required this.type,
    required this.status,
    this.content,
    this.notify,
    this.showtimes,
    this.trailerUrl,
    this.posterUrl,
    this.thumbUrl,
    this.quality,
    this.time,
    this.lang,
    this.year,
    this.view,
    this.episodeCurrent,
    this.episodeTotal,
    this.chieurap,
    this.subDocquyen,
    this.isCopyright,
    this.country,
    this.category,
    this.director,
    this.actor,
    this.alternativeNames,
    this.tmdb,
    this.imdb,
    this.price,
    this.episodes,
    this.originalCreatedAt,
    this.originalModifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  /// Builds a [Movie] from the API's `MovieSummaryResponse` / `MovieDetailResponse`.
  ///
  /// The API reports prices in integer USD cents and ratings on a 0-5 scale; the rest of the app still reads
  /// `price['usd'|'vnd']` and `tmdb['vote_average']` (0-10), so those shapes are reproduced here.
  /// Stream URLs are never part of this model: they come from the playback endpoint after an access check.
  factory Movie.fromApi(Map<String, dynamic> json) {
    int? asInt(dynamic v) => v is num ? v.toInt() : null;
    String? asStr(dynamic v) => v?.toString();
    List<String>? strings(dynamic v) =>
        v is List ? v.map((e) => e.toString()).where((e) => e.isNotEmpty).toList() : null;

    final cents = asInt(json['priceCents']) ?? 0;
    final usd = cents / 100.0;
    final rating = (json['rating'] as num?)?.toDouble();

    // Summaries list genre names, details list {id, slug, name}.
    final rawGenres = json['genres'];
    final category = rawGenres is List
        ? rawGenres
            .map<Map<String, dynamic>>((g) => g is Map
                ? {'id': g['id']?.toString(), 'name': g['name'], 'slug': g['slug']}
                : {'name': g.toString()})
            .toList()
        : null;

    final rawCountries = json['countries'];

    return Movie(
      id: asStr(json['id']) ?? '',
      name: asStr(json['name']) ?? '',
      originName: asStr(json['originName']) ?? '',
      slug: asStr(json['slug']) ?? '',
      originalId: '',
      type: asStr(json['type']) ?? '',
      status: asStr(json['status']) ?? '',
      content: asStr(json['content']),
      trailerUrl: asStr(json['trailerUrl']),
      posterUrl: asStr(json['posterUrl']),
      thumbUrl: asStr(json['thumbUrl']),
      quality: asStr(json['quality']),
      time: asStr(json['duration']),
      lang: asStr(json['lang']),
      year: asInt(json['year']),
      view: asInt(json['viewCount']),
      episodeCurrent: asStr(json['episodeCurrent']),
      episodeTotal: asStr(json['episodeTotal']),
      chieurap: json['cinema'] as bool?,
      subDocquyen: json['subExclusive'] as bool?,
      country: rawCountries is List
          ? rawCountries.whereType<Map>().map(Map<String, dynamic>.from).toList()
          : null,
      category: category,
      director: strings(json['directors']),
      actor: strings(json['actors']),
      tmdb: rating == null
          ? null
          : {'vote_average': rating * 2, 'vote_count': asInt(json['ratingCount']) ?? 0},
      price: {'usd': usd, 'vnd': (usd * 23000).round()},
    );
  }

  // Helper getters để lấy dữ liệu dễ dàng
  String get imageUrl => posterUrl ?? thumbUrl ?? '';
  
  double? get rating {
    if (tmdb != null && tmdb!['vote_average'] != null) {
      return (tmdb!['vote_average'] as num).toDouble() / 2.0;
    }
    if (imdb != null && imdb!['vote_average'] != null) {
      return (imdb!['vote_average'] as num).toDouble() / 2.0;
    }
    return null;
  }
  
  int? get ratingCount {
    if (tmdb != null && tmdb!['vote_count'] != null) {
      return tmdb!['vote_count'] as int?;
    }
    if (imdb != null && imdb!['vote_count'] != null) {
      return imdb!['vote_count'] as int?;
    }
    return null;
  }
  
  double? get priceUsd {
    if (price != null && price!['usd'] != null) {
      return (price!['usd'] as num).toDouble();
    }
    return null;
  }
  
  List<String> get genres {
    if (category == null) return [];
    return category!.map((e) => e['name']?.toString() ?? '').where((e) => e.isNotEmpty).toList();
  }
  
  String get directorString {
    if (director == null || director!.isEmpty) return '';
    return director!.where((e) => e.isNotEmpty).join(', ');
  }
  
  String get viewsString {
    if (view == null) return '0';
    if (view! >= 1000000) {
      return '${(view! / 1000000).toStringAsFixed(1)}M+';
    }
    if (view! >= 1000) {
      return '${(view! / 1000).toStringAsFixed(1)}K+';
    }
    return view.toString();
  }

  String get size {
    if (quality == null || quality!.isEmpty) return 'Unknown';
    if (quality!.contains('1080') || quality!.contains('4K')) {
      return '5.0 GB';
    }
    if (quality!.contains('720')) {
      return '3.0 GB';
    }
    return '2.0 GB';
  }

  String get description {
    if (content == null || content!.isEmpty) return 'No description available.';
    if (content!.length > 200) {
      return '${content!.substring(0, 200)}...';
    }
    // Remove HTML tags if any
    return content!.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }

  String get metadata {
    final ratingValue = rating ?? 0.0;
    return '⭐ ${ratingValue.toStringAsFixed(1)} / 5 • ${time ?? "Unknown"} • $size • $viewsString';
  }

  String get title => name.isNotEmpty ? name : originName;

  double? get priceValue {
    if (priceUsd != null) return priceUsd;
    final priceMap = price;
    if (priceMap != null && priceMap['vnd'] != null) {
      return (priceMap['vnd'] as num).toDouble() / 23000;
    }
    return null;
  }

  String? get franchiseId {
    if (slug.isEmpty) return null;
    final parts = slug.split('-');
    if (parts.isEmpty) return null;
    return parts.first;
  }

  String? get franchiseName => name;
}

