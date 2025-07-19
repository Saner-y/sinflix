part of '../../core.dart';

class ApiResponse<T> {
  final T? data;
  final AppError? error;

  ApiResponse({this.data, this.error});

  bool get isSuccess => error == null;
}