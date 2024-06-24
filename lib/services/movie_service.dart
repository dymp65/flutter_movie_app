import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_app/models/movie_model.dart';

class MovieService {
  var token = '4abcfd4e655612553d85f764f939613a';

  Future<List<MovieModel>> fetchDiscoverMovie() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/discover/movie?api_key=$token'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      final List result = data['results'];

      return result.map((e) => MovieModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load movie');
    }
  }

  Future<MovieModel> getMovieDetail(int id) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/discover/movie?api_key=$token/$id'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return MovieModel.fromJson(data);
    } else {
      throw Exception('Failed to load movie detail');
    }
  }
}
