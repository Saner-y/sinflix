part of '../../data.dart';

class RegisterRepository {
  final ApiService apiService;

  RegisterRepository(this.apiService);

  Future<ApiResponse<RegisterResponse>> register({
    required RegisterRequest request,
  }) async {
    return await apiService.post<RegisterResponse>(
      Paths.register,
      request.toJson(),
      fromJson: (json) => RegisterResponse.fromJson(json),
    );
  }
}