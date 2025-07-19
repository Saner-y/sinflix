import '../../../core/constants/app_strings.dart';

class FavoritesResponse {
  Response? response;
  List<FavoritesData>? data;

  FavoritesResponse({this.response, this.data});

  bool get isSuccess => response?.code == 200 && data != null;
  bool get hasError => !isSuccess;
  String get errorMessage => response?.message ?? AppStrings.unknownError;

  FavoritesResponse.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
    if (json['data'] != null) {
      data = <FavoritesData>[];
      json['data'].forEach((v) {
        data!.add(new FavoritesData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  int? code;
  String? message;

  Response({this.code, this.message});

  Response.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}

class FavoritesData {
  String? sId;
  String? id;
  String? title;
  String? year;
  String? rated;
  String? released;
  String? runtime;
  String? genre;
  String? director;
  String? writer;
  String? actors;
  String? plot;
  String? language;
  String? country;
  String? awards;
  String? poster;
  String? metascore;
  String? imdbRating;
  String? imdbVotes;
  String? imdbID;
  String? type;
  String? response;
  List<String>? images;
  bool? comingSoon;
  bool? isFavorite;

  FavoritesData(
      {this.sId,
        this.id,
        this.title,
        this.year,
        this.rated,
        this.released,
        this.runtime,
        this.genre,
        this.director,
        this.writer,
        this.actors,
        this.plot,
        this.language,
        this.country,
        this.awards,
        this.poster,
        this.metascore,
        this.imdbRating,
        this.imdbVotes,
        this.imdbID,
        this.type,
        this.response,
        this.images,
        this.comingSoon,
        this.isFavorite});

  FavoritesData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    title = json['Title'];
    year = json['Year'];
    rated = json['Rated'];
    released = json['Released'];
    runtime = json['Runtime'];
    genre = json['Genre'];
    director = json['Director'];
    writer = json['Writer'];
    actors = json['Actors'];
    plot = json['Plot'];
    language = json['Language'];
    country = json['Country'];
    awards = json['Awards'];
    poster = json['Poster'];
    metascore = json['Metascore'];
    imdbRating = json['imdbRating'];
    imdbVotes = json['imdbVotes'];
    imdbID = json['imdbID'];
    type = json['Type'];
    response = json['Response'];
    images = json['Images'].cast<String>();
    comingSoon = json['ComingSoon'];
    isFavorite = json['isFavorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['Title'] = this.title;
    data['Year'] = this.year;
    data['Rated'] = this.rated;
    data['Released'] = this.released;
    data['Runtime'] = this.runtime;
    data['Genre'] = this.genre;
    data['Director'] = this.director;
    data['Writer'] = this.writer;
    data['Actors'] = this.actors;
    data['Plot'] = this.plot;
    data['Language'] = this.language;
    data['Country'] = this.country;
    data['Awards'] = this.awards;
    data['Poster'] = this.poster;
    data['Metascore'] = this.metascore;
    data['imdbRating'] = this.imdbRating;
    data['imdbVotes'] = this.imdbVotes;
    data['imdbID'] = this.imdbID;
    data['Type'] = this.type;
    data['Response'] = this.response;
    data['Images'] = this.images;
    data['ComingSoon'] = this.comingSoon;
    data['isFavorite'] = this.isFavorite;
    return data;
  }
}
