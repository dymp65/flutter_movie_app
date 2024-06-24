import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/services/movie_service.dart';

class DetailScreen extends StatefulWidget {
  final MovieModel movie;
  const DetailScreen({
    super.key,
    required this.movie,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<MovieModel> movie;

  @override
  void initState() {
    super.initState();
    movie = MovieService().getMovieDetail(widget.movie.id ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder(
        future: movie,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            final posts = snapshot.data!;
            return buildMovie(posts);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        }),
      )),
    );
  }

  Widget buildMovie(MovieModel movie) {
    return Text(movie.title ?? '');
  }
}
