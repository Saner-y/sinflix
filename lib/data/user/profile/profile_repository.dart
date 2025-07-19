part of '../../data.dart';

class ProfileRepository {
  final ApiService apiService;

  ProfileRepository(this.apiService);

  Future<ApiResponse<ProfileResponse>> getProfile() async {
    return await apiService.get<ProfileResponse>(
      Paths.profile,
      fromJson: (json) => ProfileResponse.fromJson(json),
    );
  }
}