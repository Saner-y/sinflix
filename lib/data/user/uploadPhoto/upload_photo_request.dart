import 'dart:io';

class UploadPhotoRequest {
  final File file;

  UploadPhotoRequest({
    required this.file
  });

  Map<String, dynamic> toJson() {
    return {
      'file': file,
    };
  }
}