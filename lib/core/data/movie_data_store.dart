import '../../core/models/movie_item.dart';
import '../../core/utils/image_constant.dart';

/// Movie Data Store - Centralized NoSQL-style data storage for all mock movie data
/// All repositories query from this single source of truth
class MovieDataStore {
  static final MovieDataStore _instance = MovieDataStore._internal();
  factory MovieDataStore() => _instance;
  MovieDataStore._internal();

  // Main database - list of all movies with full metadata
  final List<Map<String, dynamic>> _movies = [
    {
      'id': '1',
      'title': 'Avengers: Endgame',
      'subtitle': 'The Final Battle',
      'director': 'Anthony Russo, Joe Russo',
      'cast': ['Robert Downey Jr.', 'Chris Evans', 'Mark Ruffalo'],
      'genres': ['Action', 'Adventure', 'Drama'],
      'rating': 8.4,
      'ratingCount': 25000,
      'price': 9.99,
      'discountPrice': null,
      'imageUrl': ImageConstant.imgCard,
      'releaseDate': 'April 26, 2019',
      'duration': '3h 1m',
      'size': '4.5 GB',
      'views': '50M+',
      'description': 'The epic conclusion to the Infinity Saga. The Avengers assemble one last time to stop Thanos.',
      'isTrending': true,
      'isNew': false,
      'isFree': false,
      'soldCount': 500000,
      'franchiseId': 'avengers',
      'franchiseName': 'Avengers',
      'partNumber': 4,
    },
    {
      'id': '2',
      'title': 'Avatar: The Way of Water',
      'subtitle': 'Return to Pandora',
      'director': 'James Cameron',
      'cast': ['Sam Worthington', 'Zoe Saldana', 'Sigourney Weaver'],
      'genres': ['Action', 'Adventure', 'Fantasy'],
      'rating': 7.8,
      'ratingCount': 18000,
      'price': 12.99,
      'discountPrice': null,
      'imageUrl': ImageConstant.imgCard,
      'releaseDate': 'December 16, 2022',
      'duration': '3h 12m',
      'size': '6.2 GB',
      'views': '45M+',
      'description': 'Jake Sully and Ney\'tiri have formed a family and are doing everything to stay together.',
      'isTrending': true,
      'isNew': false,
      'isFree': false,
      'soldCount': 420000,
      'franchiseId': 'avatar',
      'franchiseName': 'Avatar',
      'partNumber': 2,
    },
    {
      'id': '3',
      'title': 'Black Panther: Wakanda Forever',
      'subtitle': 'The Legacy Continues',
      'director': 'Ryan Coogler',
      'cast': ['Letitia Wright', 'Lupita Nyong\'o', 'Danai Gurira'],
      'genres': ['Action', 'Adventure', 'Drama'],
      'rating': 7.3,
      'ratingCount': 12000,
      'price': 10.99,
      'discountPrice': null,
      'imageUrl': ImageConstant.imgCard,
      'releaseDate': 'November 11, 2022',
      'duration': '2h 41m',
      'size': '5.1 GB',
      'views': '38M+',
      'description': 'The nation of Wakanda is pitted against intervening world powers as they mourn the loss of their king T\'Challa.',
      'isTrending': true,
      'isNew': false,
      'isFree': false,
      'soldCount': 380000,
      'franchiseId': 'black-panther',
      'franchiseName': 'Black Panther',
      'partNumber': 2,
    },
    {
      'id': '4',
      'title': 'Top Gun: Maverick',
      'subtitle': 'The Need for Speed',
      'director': 'Joseph Kosinski',
      'cast': ['Tom Cruise', 'Miles Teller', 'Jennifer Connelly'],
      'genres': ['Action', 'Drama'],
      'rating': 8.3,
      'ratingCount': 22000,
      'price': 11.99,
      'discountPrice': null,
      'imageUrl': ImageConstant.imgCard,
      'releaseDate': 'May 27, 2022',
      'duration': '2h 10m',
      'size': '4.8 GB',
      'views': '52M+',
      'description': 'After thirty years, Maverick is still pushing the envelope as a top naval aviator.',
      'isTrending': true,
      'isNew': false,
      'isFree': false,
      'soldCount': 480000,
      'franchiseId': 'top-gun',
      'franchiseName': 'Top Gun',
      'partNumber': 2,
    },
    {
      'id': '5',
      'title': 'Spider-Man: No Way Home',
      'subtitle': 'Multiverse of Madness',
      'director': 'Jon Watts',
      'cast': ['Tom Holland', 'Zendaya', 'Benedict Cumberbatch'],
      'genres': ['Action', 'Adventure', 'Fantasy'],
      'rating': 8.2,
      'ratingCount': 20000,
      'price': 9.99,
      'discountPrice': null,
      'imageUrl': ImageConstant.imgCard,
      'releaseDate': 'December 17, 2021',
      'duration': '2h 28m',
      'size': '5.5 GB',
      'views': '55M+',
      'description': 'With Spider-Man\'s identity now revealed, Peter asks Doctor Strange for help.',
      'isTrending': true,
      'isNew': false,
      'isFree': false,
      'soldCount': 510000,
      'franchiseId': 'spider-man',
      'franchiseName': 'Spider-Man',
      'partNumber': 3,
    },
    {
      'id': '6',
      'title': 'The Batman',
      'subtitle': 'Dark Knight Returns',
      'director': 'Matt Reeves',
      'cast': ['Robert Pattinson', 'Zoë Kravitz', 'Paul Dano'],
      'genres': ['Action', 'Crime', 'Drama'],
      'rating': 7.8,
      'ratingCount': 15000,
      'price': 8.99,
      'discountPrice': null,
      'imageUrl': ImageConstant.imgCard,
      'releaseDate': 'March 4, 2022',
      'duration': '2h 56m',
      'size': '5.8 GB',
      'views': '42M+',
      'description': 'Batman ventures into Gotham City\'s underworld when a sadistic killer leaves a trail of cryptic clues.',
      'isTrending': false,
      'isNew': false,
      'isFree': false,
      'soldCount': 350000,
      'franchiseId': 'batman',
      'franchiseName': 'The Batman',
      'partNumber': 1,
    },
    {
      'id': '7',
      'title': 'Doctor Strange in the Multiverse of Madness',
      'subtitle': 'Reality Breaks',
      'director': 'Sam Raimi',
      'cast': ['Benedict Cumberbatch', 'Elizabeth Olsen', 'Chiwetel Ejiofor'],
      'genres': ['Action', 'Adventure', 'Fantasy'],
      'rating': 6.9,
      'ratingCount': 14000,
      'price': 10.99,
      'discountPrice': null,
      'imageUrl': ImageConstant.imgCard,
      'releaseDate': 'May 6, 2022',
      'duration': '2h 6m',
      'size': '4.9 GB',
      'views': '36M+',
      'description': 'Dr. Stephen Strange casts a forbidden spell that opens the door to the multiverse.',
      'isTrending': false,
      'isNew': false,
      'isFree': false,
      'soldCount': 320000,
      'franchiseId': 'doctor-strange',
      'franchiseName': 'Doctor Strange',
      'partNumber': 2,
    },
    {
      'id': '8',
      'title': 'Thor: Love and Thunder',
      'subtitle': 'God of Thunder',
      'director': 'Taika Waititi',
      'cast': ['Chris Hemsworth', 'Natalie Portman', 'Christian Bale'],
      'genres': ['Action', 'Adventure', 'Comedy'],
      'rating': 6.3,
      'ratingCount': 11000,
      'price': 9.99,
      'discountPrice': null,
      'imageUrl': ImageConstant.imgCard,
      'releaseDate': 'July 8, 2022',
      'duration': '1h 58m',
      'size': '4.2 GB',
      'views': '33M+',
      'description': 'Thor enlists the help of Valkyrie, Korg and ex-girlfriend Jane Foster to fight Gorr the God Butcher.',
      'isTrending': false,
      'isNew': false,
      'isFree': false,
      'soldCount': 300000,
      'franchiseId': 'thor',
      'franchiseName': 'Thor',
      'partNumber': 4,
    },
    {
      'id': '9',
      'title': 'Harry Potter and the Deathly Hallows',
      'subtitle': 'Part 2',
      'director': 'David Yates',
      'cast': ['Daniel Radcliffe', 'Emma Watson', 'Rupert Grint'],
      'genres': ['Fantasy', 'Adventure', 'Action'],
      'rating': 4.9,
      'ratingCount': 6800,
      'price': 9.99,
      'discountPrice': null,
      'imageUrl': ImageConstant.imgCard,
      'releaseDate': 'July 15, 2011',
      'duration': '2h 10m',
      'size': '5.6 GB',
      'views': '50M+',
      'description': 'Harry Potter and the Deathly Hallows is the final film in the Harry Potter series. It follows Harry, Ron, and Hermione as they search for Voldemort\'s remaining Horcruxes while avoiding his Death Eaters.',
      'isTrending': false,
      'isNew': false,
      'isFree': false,
      'soldCount': 600000,
      'franchiseId': 'harry-potter',
      'franchiseName': 'Harry Potter',
      'partNumber': 8,
    },
    {
      'id': '10',
      'title': 'Harry Potter and the Half-Blood Prince',
      'subtitle': 'Part 6',
      'director': 'David Yates',
      'cast': ['Daniel Radcliffe', 'Emma Watson', 'Rupert Grint'],
      'genres': ['Fantasy', 'Adventure', 'Drama'],
      'rating': 4.8,
      'ratingCount': 6200,
      'price': 9.99,
      'discountPrice': null,
      'imageUrl': ImageConstant.imgCard,
      'releaseDate': 'July 15, 2009',
      'duration': '2h 33m',
      'size': '5.9 GB',
      'views': '48M+',
      'description': 'As Harry Potter begins his sixth year at Hogwarts, he discovers an old book marked as "the property of the Half-Blood Prince".',
      'isTrending': false,
      'isNew': false,
      'isFree': false,
      'soldCount': 580000,
      'franchiseId': 'harry-potter',
      'franchiseName': 'Harry Potter',
      'partNumber': 6,
    },
    {
      'id': '11',
      'title': 'Harry Potter and the Order of the Phoenix',
      'subtitle': 'Part 5',
      'director': 'David Yates',
      'cast': ['Daniel Radcliffe', 'Emma Watson', 'Rupert Grint'],
      'genres': ['Fantasy', 'Adventure', 'Action'],
      'rating': 4.9,
      'ratingCount': 6000,
      'price': 9.99,
      'discountPrice': null,
      'imageUrl': ImageConstant.imgCard,
      'releaseDate': 'July 11, 2007',
      'duration': '2h 18m',
      'size': '5.3 GB',
      'views': '46M+',
      'description': 'With their warning about Lord Voldemort\'s return scoffed at, Harry and Dumbledore are targeted by the Wizard authorities.',
      'isTrending': false,
      'isNew': false,
      'isFree': false,
      'soldCount': 560000,
      'franchiseId': 'harry-potter',
      'franchiseName': 'Harry Potter',
      'partNumber': 5,
    },
    {
      'id': '12',
      'title': 'Harry Potter and the Goblet of Fire',
      'subtitle': 'Part 4',
      'director': 'Mike Newell',
      'cast': ['Daniel Radcliffe', 'Emma Watson', 'Rupert Grint'],
      'genres': ['Fantasy', 'Adventure', 'Action'],
      'rating': 4.7,
      'ratingCount': 5800,
      'price': 9.99,
      'discountPrice': null,
      'imageUrl': ImageConstant.imgCard,
      'releaseDate': 'November 18, 2005',
      'duration': '2h 37m',
      'size': '5.7 GB',
      'views': '44M+',
      'description': 'Harry finds himself competing in a hazardous tournament between rival schools of magic.',
      'isTrending': false,
      'isNew': false,
      'isFree': false,
      'soldCount': 540000,
      'franchiseId': 'harry-potter',
      'franchiseName': 'Harry Potter',
      'partNumber': 4,
    },
    {
      'id': '13',
      'title': 'Harry Potter and the Prisoner of Azkaban',
      'subtitle': 'Part 3',
      'director': 'Alfonso Cuarón',
      'cast': ['Daniel Radcliffe', 'Emma Watson', 'Rupert Grint'],
      'genres': ['Fantasy', 'Adventure', 'Action'],
      'rating': 4.8,
      'ratingCount': 5900,
      'price': 9.99,
      'discountPrice': null,
      'imageUrl': ImageConstant.imgCard,
      'releaseDate': 'June 4, 2004',
      'duration': '2h 22m',
      'size': '5.4 GB',
      'views': '42M+',
      'description': 'Harry, Ron and Hermione return to Hogwarts School of Witchcraft and Wizardry for their third year of study.',
      'isTrending': false,
      'isNew': false,
      'isFree': false,
      'soldCount': 520000,
      'franchiseId': 'harry-potter',
      'franchiseName': 'Harry Potter',
      'partNumber': 3,
    },
    {
      'id': '14',
      'title': 'Harry Potter and the Chamber of Secrets',
      'subtitle': 'Part 2',
      'director': 'Chris Columbus',
      'cast': ['Daniel Radcliffe', 'Emma Watson', 'Rupert Grint'],
      'genres': ['Fantasy', 'Adventure', 'Action'],
      'rating': 4.6,
      'ratingCount': 5700,
      'price': 9.99,
      'discountPrice': null,
      'imageUrl': ImageConstant.imgCard,
      'releaseDate': 'November 15, 2002',
      'duration': '2h 41m',
      'size': '5.9 GB',
      'views': '40M+',
      'description': 'An ancient prophecy seems to be coming true when a mysterious presence begins stalking the corridors of Hogwarts.',
      'isTrending': false,
      'isNew': false,
      'isFree': false,
      'soldCount': 500000,
      'franchiseId': 'harry-potter',
      'franchiseName': 'Harry Potter',
      'partNumber': 2,
    },
    {
      'id': '15',
      'title': 'Harry Potter and the Philosopher\'s Stone',
      'subtitle': 'Part 1',
      'director': 'Chris Columbus',
      'cast': ['Daniel Radcliffe', 'Emma Watson', 'Rupert Grint'],
      'genres': ['Fantasy', 'Adventure', 'Action'],
      'rating': 4.5,
      'ratingCount': 5500,
      'price': 9.99,
      'discountPrice': null,
      'imageUrl': ImageConstant.imgCard,
      'releaseDate': 'November 16, 2001',
      'duration': '2h 32m',
      'size': '5.8 GB',
      'views': '38M+',
      'description': 'An orphaned boy enrolls in a school of wizardry, where he learns the truth about himself.',
      'isTrending': false,
      'isNew': false,
      'isFree': false,
      'soldCount': 480000,
      'franchiseId': 'harry-potter',
      'franchiseName': 'Harry Potter',
      'partNumber': 1,
    },
    {
      'id': '16',
      'title': 'A Court of Thorns & Roses',
      'subtitle': 'Part 1',
      'director': 'Sarah J. Maas',
      'cast': [],
      'genres': ['Fantasy', 'Romance', 'Adventure'],
      'rating': 4.6,
      'ratingCount': 5200,
      'price': 6.50,
      'discountPrice': null,
      'imageUrl': ImageConstant.imgCard,
      'releaseDate': 'May 5, 2015',
      'duration': '2h 15m',
      'size': '4.8 GB',
      'views': '35M+',
      'description': 'Feyre kills a wolf in the woods, and a beast-like creature arrives to demand retribution.',
      'isTrending': false,
      'isNew': false,
      'isFree': false,
      'soldCount': 400000,
      'franchiseId': 'acotar',
      'franchiseName': 'A Court of Thorns & Roses',
      'partNumber': 1,
    },
    {
      'id': '17',
      'title': 'The Batman Who Laughs',
      'subtitle': 'Issues 1-7',
      'director': 'Scott Snyder',
      'cast': [],
      'genres': ['Action', 'Crime', 'Horror'],
      'rating': 4.3,
      'ratingCount': 4800,
      'price': 10.44,
      'discountPrice': null,
      'imageUrl': ImageConstant.imgCard,
      'releaseDate': 'December 26, 2018',
      'duration': '2h 5m',
      'size': '4.6 GB',
      'views': '32M+',
      'description': 'Batman faces the ultimate test as he confronts a twisted version of himself from the Dark Multiverse.',
      'isTrending': false,
      'isNew': false,
      'isFree': false,
      'soldCount': 350000,
      'franchiseId': 'batman-who-laughs',
      'franchiseName': 'The Batman Who Laughs',
      'partNumber': 1,
    },
    {
      'id': '18',
      'title': 'Game of Thrones: A Song of Ice & Fire',
      'subtitle': 'Season 1',
      'director': 'David Benioff, D.B. Weiss',
      'cast': ['Sean Bean', 'Peter Dinklage', 'Emilia Clarke'],
      'genres': ['Fantasy', 'Drama', 'Adventure'],
      'rating': 4.4,
      'ratingCount': 5000,
      'price': 7.79,
      'discountPrice': null,
      'imageUrl': ImageConstant.imgCard,
      'releaseDate': 'April 17, 2011',
      'duration': '10h 0m',
      'size': '25.0 GB',
      'views': '55M+',
      'description': 'Nine noble families fight for control over the lands of Westeros.',
      'isTrending': false,
      'isNew': false,
      'isFree': false,
      'soldCount': 450000,
      'franchiseId': 'game-of-thrones',
      'franchiseName': 'Game of Thrones',
      'partNumber': 1,
    },
    {
      'id': '19',
      'title': 'Song of Silver, Flame Like Night',
      'subtitle': 'Part 1',
      'director': 'Amélie Wen Zhao',
      'cast': [],
      'genres': ['Fantasy', 'Adventure'],
      'rating': 4.0,
      'ratingCount': 4500,
      'price': 10.00,
      'discountPrice': null,
      'imageUrl': ImageConstant.imgCard,
      'releaseDate': 'January 3, 2023',
      'duration': '2h 20m',
      'size': '5.1 GB',
      'views': '28M+',
      'description': 'A warrior girl with forbidden magic must protect her world from demons.',
      'isTrending': false,
      'isNew': true,
      'isFree': false,
      'soldCount': 300000,
      'franchiseId': 'song-of-silver',
      'franchiseName': 'Song of Silver',
      'partNumber': 1,
    },
    {
      'id': '20',
      'title': 'Alpha Magic: Reverse Harem Paranormal',
      'subtitle': 'Part 1',
      'director': 'Jaymin Eve',
      'cast': [],
      'genres': ['Fantasy', 'Romance'],
      'rating': 4.4,
      'ratingCount': 4100,
      'price': null,
      'discountPrice': null,
      'imageUrl': ImageConstant.imgCard,
      'releaseDate': 'June 15, 2022',
      'duration': '1h 55m',
      'size': '4.2 GB',
      'views': '25M+',
      'description': 'A free paranormal romance with reverse harem elements.',
      'isTrending': false,
      'isNew': false,
      'isFree': true,
      'soldCount': 280000,
      'franchiseId': 'alpha-magic',
      'franchiseName': 'Alpha Magic',
      'partNumber': 1,
    },
    {
      'id': '21',
      'title': 'Taken by the Dragon King',
      'subtitle': 'Dragon Shifter',
      'director': 'Roxie Ray',
      'cast': [],
      'genres': ['Fantasy', 'Romance'],
      'rating': 4.6,
      'ratingCount': 4300,
      'price': null,
      'discountPrice': null,
      'imageUrl': ImageConstant.imgCard,
      'releaseDate': 'August 10, 2022',
      'duration': '2h 0m',
      'size': '4.5 GB',
      'views': '30M+',
      'description': 'A free dragon shifter romance adventure.',
      'isTrending': false,
      'isNew': false,
      'isFree': true,
      'soldCount': 320000,
      'franchiseId': 'dragon-king',
      'franchiseName': 'Dragon King',
      'partNumber': 1,
    },
    {
      'id': '22',
      'title': 'Free Movie Series: Complete Collection',
      'subtitle': 'All Parts',
      'director': 'Various',
      'cast': [],
      'genres': ['Action', 'Adventure', 'Comedy'],
      'rating': 4.2,
      'ratingCount': 3900,
      'price': null,
      'discountPrice': null,
      'imageUrl': ImageConstant.imgCard,
      'releaseDate': 'September 5, 2022',
      'duration': '8h 30m',
      'size': '18.0 GB',
      'views': '40M+',
      'description': 'A complete collection of free action-adventure movies.',
      'isTrending': false,
      'isNew': false,
      'isFree': true,
      'soldCount': 360000,
      'franchiseId': 'free-series',
      'franchiseName': 'Free Series',
      'partNumber': 1,
    },
    {
      'id': '23',
      'title': 'Indie Author Freebie: First Movie',
      'subtitle': 'Part 1',
      'director': 'Independent',
      'cast': [],
      'genres': ['Drama', 'Romance'],
      'rating': 4.5,
      'ratingCount': 4000,
      'price': null,
      'discountPrice': null,
      'imageUrl': ImageConstant.imgCard,
      'releaseDate': 'October 12, 2022',
      'duration': '1h 45m',
      'size': '3.8 GB',
      'views': '22M+',
      'description': 'An independent filmmaker\'s first free release.',
      'isTrending': false,
      'isNew': false,
      'isFree': true,
      'soldCount': 260000,
      'franchiseId': 'indie-freebie',
      'franchiseName': 'Indie Freebie',
      'partNumber': 1,
    },
    {
      'id': '24',
      'title': 'Son of the Poison Rose',
      'subtitle': 'A Kagen a Da',
      'director': 'Howard Andrew Jones',
      'cast': [],
      'genres': ['Fantasy', 'Adventure'],
      'rating': 4.0,
      'ratingCount': 4400,
      'price': 9.00,
      'discountPrice': null,
      'imageUrl': ImageConstant.imgCard,
      'releaseDate': 'January 17, 2023',
      'duration': '2h 25m',
      'size': '5.3 GB',
      'views': '26M+',
      'description': 'A new fantasy epic begins with the son of a legendary hero.',
      'isTrending': false,
      'isNew': true,
      'isFree': false,
      'soldCount': 290000,
      'franchiseId': 'poison-rose',
      'franchiseName': 'Poison Rose',
      'partNumber': 1,
    },
    {
      'id': '25',
      'title': 'The New Fantasy Epic: Book One',
      'subtitle': 'Part 1',
      'director': 'New Director',
      'cast': [],
      'genres': ['Fantasy', 'Adventure'],
      'rating': 4.3,
      'ratingCount': 4600,
      'price': 11.99,
      'discountPrice': null,
      'imageUrl': ImageConstant.imgCard,
      'releaseDate': 'February 14, 2023',
      'duration': '2h 30m',
      'size': '5.5 GB',
      'views': '31M+',
      'description': 'A new fantasy epic with breathtaking visuals and epic battles.',
      'isTrending': false,
      'isNew': true,
      'isFree': false,
      'soldCount': 340000,
      'franchiseId': 'new-fantasy',
      'franchiseName': 'New Fantasy Epic',
      'partNumber': 1,
    },
    {
      'id': '26',
      'title': 'Latest Mystery Thriller: Unraveled',
      'subtitle': 'Part 1',
      'director': 'Thriller Master',
      'cast': [],
      'genres': ['Mystery', 'Thriller', 'Crime'],
      'rating': 4.1,
      'ratingCount': 4200,
      'price': 8.99,
      'discountPrice': null,
      'imageUrl': ImageConstant.imgCard,
      'releaseDate': 'March 20, 2023',
      'duration': '2h 8m',
      'size': '4.7 GB',
      'views': '27M+',
      'description': 'A detective must unravel a complex mystery that threatens the city.',
      'isTrending': false,
      'isNew': true,
      'isFree': false,
      'soldCount': 310000,
      'franchiseId': 'mystery-thriller',
      'franchiseName': 'Mystery Thriller',
      'partNumber': 1,
    },
  ];

  // ========== Query Methods ==========

  /// Get all movies
  List<Map<String, dynamic>> getAll() => List.from(_movies);

  /// Get movie by ID
  Map<String, dynamic>? getById(String id) {
    try {
      return _movies.firstWhere((movie) => movie['id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// Get movies by list of IDs
  List<Map<String, dynamic>> getByIds(List<String> ids) {
    return _movies.where((movie) => ids.contains(movie['id'])).toList();
  }

  /// Get movies by genre
  List<Map<String, dynamic>> getByGenre(String genre) {
    return _movies.where((movie) {
      final genres = movie['genres'] as List<dynamic>;
      return genres.any((g) => g.toString().toLowerCase().contains(genre.toLowerCase()));
    }).toList();
  }

  /// Get movies by multiple genres (any match)
  List<Map<String, dynamic>> getByGenres(List<String> genres) {
    if (genres.isEmpty) return getAll();
    return _movies.where((movie) {
      final movieGenres = (movie['genres'] as List<dynamic>).map((g) => g.toString().toLowerCase()).toList();
      return genres.any((genre) => movieGenres.contains(genre.toLowerCase()));
    }).toList();
  }

  /// Get top selling movies (by soldCount)
  List<Map<String, dynamic>> getTopSelling({int limit = 10}) {
    final sorted = List<Map<String, dynamic>>.from(_movies);
    sorted.sort((a, b) => (b['soldCount'] as int).compareTo(a['soldCount'] as int));
    return sorted.take(limit).toList();
  }

  /// Get top charts (by rating and views)
  List<Map<String, dynamic>> getTopCharts({int limit = 10}) {
    final sorted = List<Map<String, dynamic>>.from(_movies);
    sorted.sort((a, b) {
      final aScore = (a['rating'] as double) * (a['ratingCount'] as int);
      final bScore = (b['rating'] as double) * (b['ratingCount'] as int);
      return bScore.compareTo(aScore);
    });
    return sorted.take(limit).toList();
  }

  /// Get top free movies
  List<Map<String, dynamic>> getTopFree({int limit = 10}) {
    final freeMovies = _movies.where((movie) => movie['isFree'] == true).toList();
    freeMovies.sort((a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
    return freeMovies.take(limit).toList();
  }

  /// Get top new releases
  List<Map<String, dynamic>> getTopNewReleases({int limit = 10}) {
    final newMovies = _movies.where((movie) => movie['isNew'] == true).toList();
    newMovies.sort((a, b) {
      final aDate = DateTime.parse(_extractDate(b['releaseDate'] as String));
      final bDate = DateTime.parse(_extractDate(a['releaseDate'] as String));
      return aDate.compareTo(bDate);
    });
    return newMovies.take(limit).toList();
  }

  /// Get trending movies
  List<Map<String, dynamic>> getTrending({int limit = 10}) {
    final trending = _movies.where((movie) => movie['isTrending'] == true).toList();
    trending.sort((a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
    return trending.take(limit).toList();
  }

  /// Get movies by franchise
  List<Map<String, dynamic>> getByFranchise(String franchiseId) {
    final franchise = _movies.where((movie) => movie['franchiseId'] == franchiseId).toList();
    franchise.sort((a, b) => (a['partNumber'] as int).compareTo(b['partNumber'] as int));
    return franchise;
  }

  /// Search movies by query (title, subtitle, director, cast)
  List<Map<String, dynamic>> search(String query) {
    if (query.isEmpty) return [];
    final lowerQuery = query.toLowerCase();
    return _movies.where((movie) {
      final title = (movie['title'] as String).toLowerCase();
      final subtitle = (movie['subtitle'] as String? ?? '').toLowerCase();
      final director = (movie['director'] as String).toLowerCase();
      final cast = (movie['cast'] as List<dynamic>).map((c) => c.toString().toLowerCase()).join(' ');
      return title.contains(lowerQuery) ||
          subtitle.contains(lowerQuery) ||
          director.contains(lowerQuery) ||
          cast.contains(lowerQuery);
    }).toList();
  }

  /// Get similar movies (by genres and rating)
  List<Map<String, dynamic>> getSimilar(String movieId, {int limit = 10}) {
    final movie = getById(movieId);
    if (movie == null) return [];
    
    final movieGenres = (movie['genres'] as List<dynamic>).map((g) => g.toString().toLowerCase()).toList();
    final movieRating = movie['rating'] as double;
    
    final similar = _movies.where((m) {
      if (m['id'] == movieId) return false;
      final genres = (m['genres'] as List<dynamic>).map((g) => g.toString().toLowerCase()).toList();
      final hasCommonGenre = movieGenres.any((g) => genres.contains(g));
      final ratingDiff = ((m['rating'] as double) - movieRating).abs();
      return hasCommonGenre && ratingDiff <= 1.0;
    }).toList();
    
    similar.sort((a, b) {
      final aGenres = (a['genres'] as List<dynamic>).map((g) => g.toString().toLowerCase()).toList();
      final bGenres = (b['genres'] as List<dynamic>).map((g) => g.toString().toLowerCase()).toList();
      final aCommon = movieGenres.where((g) => aGenres.contains(g)).length;
      final bCommon = movieGenres.where((g) => bGenres.contains(g)).length;
      if (aCommon != bCommon) return bCommon.compareTo(aCommon);
      final aRatingDiff = ((a['rating'] as double) - movieRating).abs();
      final bRatingDiff = ((b['rating'] as double) - movieRating).abs();
      return aRatingDiff.compareTo(bRatingDiff);
    });
    
    return similar.take(limit).toList();
  }

  /// Convert movie data to MovieItem
  MovieItem toMovieItem(Map<String, dynamic> movie) {
    return MovieItem(
      id: movie['id'] as String,
      title: movie['title'] as String,
      imageUrl: movie['imageUrl'] as String,
      rating: movie['rating'] as double?,
      price: movie['price'] as double?,
    );
  }

  /// Convert list of movies to MovieItem list
  List<MovieItem> toMovieItems(List<Map<String, dynamic>> movies) {
    return movies.map((movie) => toMovieItem(movie)).toList();
  }

  // Helper method to extract date from string
  String _extractDate(String dateString) {
    // Simple date parsing - assumes format like "January 17, 2023"
    final parts = dateString.split(',');
    if (parts.length == 2) {
      return parts[1].trim() + '-' + _monthToNumber(parts[0].split(' ')[0]) + '-' + parts[0].split(' ')[1];
    }
    return '2023-01-01'; // Default fallback
  }

  String _monthToNumber(String month) {
    const months = {
      'January': '01', 'February': '02', 'March': '03', 'April': '04',
      'May': '05', 'June': '06', 'July': '07', 'August': '08',
      'September': '09', 'October': '10', 'November': '11', 'December': '12',
    };
    return months[month] ?? '01';
  }
}

