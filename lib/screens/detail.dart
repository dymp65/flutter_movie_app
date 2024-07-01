import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/models/movie_detail_model.dart';
import 'package:movie_app/services/movie_service.dart';
import 'package:movie_app/screens/mail.dart';
import 'package:movie_app/helpers/db_helper.dart';

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
  late Future<MovieDetailModel> movie;
  bool _favorite = false;

  Future<void> _checkFav() async {
    bool exists = await DbHelper().checkFavorite(widget.movie.id ?? 0);
    setState(() {
      _favorite = exists;
    });
  }

  Future<void> _saveFav(int movieId, String movieTitle, String movieOverview,
      String movieRelease, int movieVote) async {
    var save = await DbHelper().saveFavorite(DbMovieModel(
      movie_id: movieId.toInt(),
      title: movieTitle.toString(),
      overview: movieOverview.toString(),
      release_date: movieRelease.toString(),
      vote_average: movieVote.toInt(),
    ));

    setState(() {
      _checkFav();
    });
  }

  @override
  void initState() {
    super.initState();
    movie = MovieService().getMovieDetail(widget.movie.id ?? 0);
    _checkFav();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   titleTextStyle: TextStyle(color: Colors.white),
      //   title: Text('Movie Detail'),
      // ),
      body: FutureBuilder(
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
      ),
    );
  }

  Widget buildMovie(MovieDetailModel movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          'https://image.tmdb.org/t/p/w500/${movie.backdropPath}',
          width: double.infinity,
          // height: 200,
        ),
        const SizedBox(height: 16),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.network(
                    'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                    width: 150,
                    height: 200,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 32 - 150 - 16,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Release ${movie.releaseDate}'),
                        ElevatedButton(
                          onPressed: () {
                            _saveFav(
                              movie.id ?? 0,
                              movie.title ?? '',
                              movie.overview ?? '',
                              movie.releaseDate ?? '',
                              movie.voteAverage?.toInt() ?? 0,
                            );
                          },
                          child: Icon(_favorite
                              ? Icons.favorite
                              : Icons.favorite_border),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              const Text(
                'Overview',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(movie.overview ?? ''),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),

        // InkWell(
        //   onTap: () {
        //     Navigator.of(context)
        //         .push(MaterialPageRoute(builder: (context) => MailScreen()));
        //   },
        //   child: Text('mail to'),
        // ),
      ],
    );
  }
}
