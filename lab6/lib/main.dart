import 'package:flutter/material.dart';

void main() => runApp(const ResponsiveMovieApp());

class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Browser',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const GenreScreen(),
    );
  }
}

class Movie {
  const Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });

  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;
}

const allMovies = <Movie>[
  Movie(
    title: 'Interstellar',
    year: 2014,
    genres: ['Drama', 'Sci-Fi'],
    posterUrl: 'https://picsum.photos/seed/interstellar/300/450',
    rating: 8.7,
  ),
  Movie(
    title: 'The Dark Knight',
    year: 2008,
    genres: ['Action', 'Drama'],
    posterUrl: 'https://picsum.photos/seed/dark-knight/300/450',
    rating: 9.0,
  ),
  Movie(
    title: 'Parasite',
    year: 2019,
    genres: ['Drama', 'Thriller'],
    posterUrl: 'https://picsum.photos/seed/parasite/300/450',
    rating: 8.5,
  ),
  Movie(
    title: 'The Grand Budapest Hotel',
    year: 2014,
    genres: ['Comedy', 'Drama'],
    posterUrl: 'https://picsum.photos/seed/budapest/300/450',
    rating: 8.1,
  ),
  Movie(
    title: 'Mad Max Fury Road',
    year: 2015,
    genres: ['Action', 'Sci-Fi'],
    posterUrl: 'https://picsum.photos/seed/mad-max/300/450',
    rating: 8.1,
  ),
  Movie(
    title: 'Toy Story',
    year: 1995,
    genres: ['Animation', 'Comedy'],
    posterUrl: 'https://picsum.photos/seed/toy-story/300/450',
    rating: 8.3,
  ),
];

enum SortOption { az, za, year, rating }

extension SortOptionLabel on SortOption {
  String get label => switch (this) {
    SortOption.az => 'A-Z',
    SortOption.za => 'Z-A',
    SortOption.year => 'Year',
    SortOption.rating => 'Rating',
  };
}

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  static const genres = [
    'Action',
    'Drama',
    'Comedy',
    'Sci-Fi',
    'Thriller',
    'Animation',
  ];

  String searchQuery = '';
  final Set<String> selectedGenres = {};
  SortOption selectedSort = SortOption.az;

  List<Movie> get visibleMovies {
    final query = searchQuery.trim().toLowerCase();
    final movies = allMovies.where((movie) {
      final matchesSearch = movie.title.toLowerCase().contains(query);
      final matchesGenre =
          selectedGenres.isEmpty || movie.genres.any(selectedGenres.contains);
      return matchesSearch && matchesGenre;
    }).toList();

    movies.sort(
          (a, b) => switch (selectedSort) {
        SortOption.az => a.title.compareTo(b.title),
        SortOption.za => b.title.compareTo(a.title),
        SortOption.year => b.year.compareTo(a.year),
        SortOption.rating => b.rating.compareTo(a.rating),
      },
    );
    return movies;
  }

  void toggleGenre(String genre, bool selected) {
    setState(() {
      selected ? selectedGenres.add(genre) : selectedGenres.remove(genre);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final movies = visibleMovies;

    return Scaffold(
      appBar: AppBar(title: const Text('Movie Browser')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth >= 800 ? 24 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Find a Movie',
                style: Theme.of(context).textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Search by title',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) => setState(() => searchQuery = value),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: genres.map((genre) {
                  return FilterChip(
                    label: Text(genre),
                    selected: selectedGenres.contains(genre),
                    onSelected: (selected) => toggleGenre(genre, selected),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('${movies.length} movie(s)'),
                  const Spacer(),
                  const Text('Sort: '),
                  DropdownButton<SortOption>(
                    value: selectedSort,
                    items: SortOption.values.map((option) {
                      return DropdownMenuItem(
                        value: option,
                        child: Text(option.label),
                      );
                    }).toList(),
                    onChanged: (option) {
                      if (option != null) {
                        setState(() => selectedSort = option);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (movies.isEmpty) {
                      return const Center(child: Text('No matching movies.'));
                    }

                    if (constraints.maxWidth < 800) {
                      return ListView.builder(
                        itemCount: movies.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: MovieCard(movie: movies[index]),
                        ),
                      );
                    }

                    return GridView.builder(
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2.4,
                      ),
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        return MovieCard(movie: movies[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  const MovieCard({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final posterWidth = constraints.maxWidth >= 400 ? 120.0 : 100.0;
          final posterHeight =
          constraints.hasBoundedHeight ? constraints.maxHeight : 150.0;
          return Row(
            children: [
              SizedBox(
                width: posterWidth,
                height: posterHeight,
                child: Image.network(
                  movie.posterUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const ColoredBox(
                    color: Color(0xFFE0E0E0),
                    child: Icon(Icons.movie, size: 40),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text('${movie.year}  |  Rating: ${movie.rating}'),
                      const SizedBox(height: 4),
                      Text(
                        movie.genres.join(', '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
