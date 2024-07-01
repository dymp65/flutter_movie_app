import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// import 'package:sqflite/sqlite_api.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  static Database? _database;

  final String tableName = 'movie';
  final String columnId = 'id';
  final String columnMovieId = 'movie_id';
  final String columnTitle = 'title';
  final String columnRelease = 'release_date';
  final String columnOverview = 'overview';
  final String columnVote = 'vote_average';

  DbHelper._internal();
  factory DbHelper() => _instance;

  //Cek database existing
  Future<Database?> get _db async {
    if (_database != null) {
      return _database;
    }

    _database = await _initDb();
    return _database;
  }

  Future<Database?> _initDb() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'movie.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    var sql = "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY, "
        "$columnMovieId INTEGER,"
        "$columnTitle TEXT,"
        "$columnRelease TEXT,"
        "$columnVote INTEGER,"
        "$columnOverview TEXT)";

    await db.execute(sql);
  }

  //get data
  Future<List?> getAllFavoriteMovie() async {
    var dbClient = await _db;

    var result = await dbClient!.query(tableName, columns: [
      columnId,
      columnMovieId,
      columnTitle,
      columnOverview,
      columnRelease,
      columnVote,
    ]);

    return result.toList();
  }

  //save data
  Future<int?> saveFavorite(DbMovieModel movie) async {
    var dbClient = await _db;
    return await dbClient!.insert(tableName, movie.toMap());
  }

  //Delete data
  Future<int?> deleteFavorite(int id) async {
    var dbClient = await _db;

    return await dbClient!
        .delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  //Get Note by ID
  Future<dynamic> getFavoriteById(int id) async {
    var dbClient = await _db;

    var result = await dbClient!.query(tableName,
        columns: [
          columnId,
          columnMovieId,
          columnTitle,
          columnOverview,
          columnRelease,
          columnVote
        ],
        where: '$columnId = ?',
        whereArgs: [id]);

    return result;
  }

  //Check Favorite
  Future<bool> checkFavorite(int movieId) async {
    var dbClient = await _db;

    // Perform the query
    var result = await dbClient!.query(
      tableName,
      columns: [
        columnId,
        columnMovieId,
        columnTitle,
        columnOverview,
        columnRelease,
        columnVote
      ],
      where: '$columnId = ?',
      whereArgs: [movieId],
    );

    // Check if the result is not empty
    return result.isNotEmpty;
  }
}

class DbMovieModel {
  int? id;
  int? movie_id;
  String? title;
  String? overview;
  String? release_date;
  int? vote_average;

  DbMovieModel({
    this.id,
    this.movie_id,
    this.title,
    this.overview,
    this.release_date,
    this.vote_average,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = id;
    }
    map['movie_id'] = movie_id;
    map['title'] = title;
    map['overview'] = overview;
    map['release_date'] = release_date;
    map['vote_average'] = vote_average;

    return map;
  }

  DbMovieModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.movie_id = map['movie_id'];
    this.title = map['title'];
    this.overview = map['overview'];
    this.release_date = map['release_date'];
    this.vote_average = map['vote_average'];
  }
}
