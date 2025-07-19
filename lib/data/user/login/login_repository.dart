part of '../../data.dart';

class LoginRepository {
  final ApiService apiService;

  LoginRepository(this.apiService);

  Future<ApiResponse<LoginResponse>> login({
    required LoginRequest request,
  }) async {
    return await apiService.post<LoginResponse>(
      Paths.login,
      request.toJson(),
      fromJson: (json) => LoginResponse.fromJson(json),
    );
  }
}