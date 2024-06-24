import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/screens/detail.dart';
import 'package:movie_app/services/movie_service.dart';
import 'package:five_pointed_star/five_pointed_star.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<MovieModel>> movileList;

  @override
  void initState() {
    super.initState();
    movileList = MovieService().fetchDiscoverMovie();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          title: const Text(
            'Aplikasi List Film',
          ),
        ),
        body: FutureBuilder(
          future: movileList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final posts = snapshot.data!;
              return buildMovieList(posts);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          },
        ));
  }

  Widget buildMovieList(List<MovieModel> movie) {
    return ListView.builder(
        itemCount: movie.length,
        itemBuilder: (context, index) {
          var item = movie[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailScreen(movie: item)));
            },
            child: movieCard(item),
          );
        });
  }

  Widget movieCard(MovieModel movie) {
    int rating = (movie.vote_average / 2).toInt();

    return Card(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            'https://image.tmdb.org/t/p/w500/${movie.poster_path}',
            width: 100,
          ),
          Container(
            padding: const EdgeInsets.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Release: ${movie.release_date}'),
                const SizedBox(
                  height: 8,
                ),
                FivePointedStar(
                  count: 5,
                  defaultSelectedCount: rating,
                ),
                const SizedBox(height: 16),
                Container(
                  width: MediaQuery.of(context).size.width - 120,
                  child: Text(
                    movie.overview ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
