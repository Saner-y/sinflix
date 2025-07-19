part of '../../core.dart';

class AppError {
  final String message;
  final int? statusCode;
  final ErrorType type;

  AppError({
    required this.message,
    this.statusCode,
    required this.type,
  });
}