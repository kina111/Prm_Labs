import 'package:flutter/material.dart';
import 'model/Movie.dart';
import 'screen/HomeScreen.dart';


// ==========================================
// 2. SAMPLE STATIC DATA
// ==========================================

void main() {
  runApp(const MovieDetailApp());
}

final List<Movie> sampleMovies = [
  const Movie(
    id: 'm1',
    title: 'Inception',
    posterUrl: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=800&auto=format&fit=crop',
    overview:
    'A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O., but his tragic past may doom the project and his team to disaster.',
    genres: ['Action', 'Sci-Fi', 'Adventure'],
    rating: 8.8,
    trailers: [
      Trailer(id: 't1', title: 'Official Trailer 1', duration: '2:30'),
      Trailer(id: 't2', title: 'Teaser Trailer', duration: '1:15'),
      Trailer(id: 't3', title: 'IMAX Special Preview', duration: '3:05'),
    ],
  ),
  const Movie(
    id: 'm2',
    title: 'Interstellar',
    posterUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800&auto=format&fit=crop',
    overview:
    'When Earth becomes uninhabitable in the future, a farmer and ex-NASA pilot, Joseph Cooper, is tasked to pilot a spacecraft, along with a team of researchers, to find a new planet for humans.',
    genres: ['Adventure', 'Drama', 'Sci-Fi'],
    rating: 8.7,
    trailers: [
      Trailer(id: 't4', title: 'Final Announcement Trailer', duration: '2:45'),
      Trailer(id: 't5', title: 'Space Exploration Featurette', duration: '4:10'),
    ],
  ),
  const Movie(
    id: 'm3',
    title: 'The Dark Knight',
    posterUrl: 'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=800&auto=format&fit=crop',
    overview:
    'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.',
    genres: ['Action', 'Crime', 'Drama'],
    rating: 9.0,
    trailers: [
      Trailer(id: 't6', title: 'Theatrical Trailer', duration: '2:20'),
      Trailer(id: 't7', title: 'Joker Character Teaser', duration: '1:45'),
    ],
  ),
];

class MovieDetailApp extends StatelessWidget {
  const MovieDetailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Detail App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: HomeScreen(movies: sampleMovies),
    );
  }
}