class MovieListRequest {
  final String page;

  MovieListRequest({
    required this.page
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
    };
  }
}