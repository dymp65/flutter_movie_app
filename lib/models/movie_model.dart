class MovieModel {
  bool? adult;
  String? backdrop_path;
  List<dynamic>? genre_ids;
  int? id;
  String? original_language;
  String? original_title;
  String? overview;
  dynamic popularity;
  String? poster_path;
  String? release_date;
  String? title;
  bool? video;
  dynamic vote_average;
  dynamic vote_count;

  MovieModel({
    this.adult,
    this.backdrop_path,
    this.genre_ids,
    this.id,
    this.original_language,
    this.original_title,
    this.overview,
    this.popularity,
    this.poster_path,
    this.release_date,
    this.title,
    this.video,
    this.vote_average,
    this.vote_count,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'adult': bool adult,
        'backdrop_path': String backdrop_path,
        'genre_ids': List<dynamic> genre_ids,
        'id': int id,
        'original_language': String original_language,
        'original_title': String original_title,
        'overview': String overview,
        'popularity': dynamic popularity,
        'poster_path': String poster_path,
        'release_date': String release_date,
        'title': String title,
        'video': bool video,
        'vote_average': dynamic vote_average,
        'vote_count': dynamic vote_count,
      } =>
        MovieModel(
          adult: adult,
          backdrop_path: backdrop_path,
          genre_ids: genre_ids,
          id: id,
          original_language: original_language,
          original_title: original_title,
          overview: overview,
          popularity: popularity,
          poster_path: poster_path,
          release_date: release_date,
          title: title,
          video: video,
          vote_average: vote_average,
          vote_count: vote_count,
        ),
      _ => throw const FormatException('Failed to load movie.'),
    };
  }
}
