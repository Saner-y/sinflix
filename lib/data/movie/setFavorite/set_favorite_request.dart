class SetFavoriteRequest {
  final String movieId;

  SetFavoriteRequest({required this.movieId});

  Map<String, dynamic> toJson() {
    return {'movieId': movieId};
  }
}