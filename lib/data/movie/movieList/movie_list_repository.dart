part of '../../data.dart';

class MovieListRepository {
  final ApiService apiService;

  MovieListRepository(this.apiService);

  Future<ApiResponse<MovieListResponse>> getMovieList({
    required MovieListRequest request,
  }) async {
    return await apiService.get<MovieListResponse>(
      Paths.movieList,
      queryParams: request.toJson(),
      fromJson: (json) => MovieListResponse.fromJson(json),
    );
  }
}