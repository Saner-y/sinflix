part of '../../data.dart';

class UploadPhotoRepository {
  final ApiService apiService;

  UploadPhotoRepository(this.apiService);

  Future<ApiResponse<UploadPhotoResponse>> uploadPhoto({
    required UploadPhotoRequest request,
  }) async {
    return await apiService.multipartFilePost<UploadPhotoResponse>(
      Paths.uploadPhoto,
      request.file,
      request.toJson(),
      fromJson: (json) => UploadPhotoResponse.fromJson(json),
    );
  }
}