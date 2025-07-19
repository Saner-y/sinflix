part of '../../data.dart';

class SetFavoriteRepository {
  final ApiService apiService;

  SetFavoriteRepository(this.apiService);

  Future<ApiResponse<SetFavoriteResponse>> setFavorite({
    required SetFavoriteRequest request,
  }) async {
    return await apiService.post<SetFavoriteResponse>(
      "${Paths.setFavorite}/${request.movieId}",
      request.toJson(),
      fromJson: (json) => SetFavoriteResponse.fromJson(json),
    );
  }
}