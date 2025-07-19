part of '../../data.dart';

class FavoritesRepository {
  final ApiService apiService;

  FavoritesRepository(this.apiService);

  Future<ApiResponse<FavoritesResponse>> getFavorites() async {
    return await apiService.get<FavoritesResponse>(
      Paths.favorites,
      fromJson: (json) => FavoritesResponse.fromJson(json),
    );
  }}
