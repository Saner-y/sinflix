part of '../core.dart';

class AuthHelper {
  static Future<void> handleAuthSuccess({
    required String? token,
    required String? userId,
    required String email,
    required String method,
    required String authType,
  }) async {
    final storageService = locator<SecureStorageService>();
    final logger = locator<LoggerService>();

    if (token != null && token.isNotEmpty) {
      await storageService.saveToken(token);
    }

    if (authType == 'login') {
      logger.logLogin(method: method);
    } else if (authType == 'register') {
      logger.logLogin(method: method);
    }

    if (userId != null) {
      logger.setUserId(userId);
    }

    logger.setCustomKey('user_email', email);
    logger.setCustomKey('${authType}_time', DateTime.now().toIso8601String());
    logger.setCustomKey('${authType}_method', method);

    logger.info('User ${authType}ed successfully with $method',
      tag: 'AuthHelper',
      data: {'email': email, 'userId': userId, 'method': method});
  }

  static Future<void> handleSocialAuthSuccess({
    required User firebaseUser,
    required String method,
    required String authType,
  }) async {
    final email = firebaseUser.email ?? '';
    final userId = firebaseUser.uid;
    final idToken = await firebaseUser.getIdToken();

    await handleAuthSuccess(
      token: idToken,
      userId: userId,
      email: email,
      method: method,
      authType: authType,
    );
  }

  static void logAuthFailure({
    required String errorMessage,
    required String email,
    required String authType,
    required String blocName,
  }) {
    final logger = locator<LoggerService>();

    logger.blocState(
      blocName: blocName,
      stateName: '${authType.capitalize}Failure',
      stateData: {'error': errorMessage},
    );

    logger.logCustomEvent(
      eventName: '${authType}_failure',
      parameters: {
        'error_message': errorMessage,
        'email_domain': email.isNotEmpty ? email.split('@').last : 'unknown',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );

    logger.error('${authType.capitalize} failed',
      tag: 'AuthHelper',
      data: {'error': errorMessage, 'email': email});
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  static String getFirebaseErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return AppStrings.userNotFound;
        case 'wrong-password':
          return AppStrings.wrongPassword;
        case 'email-already-in-use':
          return AppStrings.emailAlreadyInUse;
        case 'weak-password':
          return AppStrings.weakPassword;
        case 'invalid-email':
          return AppStrings.invalidEmail;
        case 'user-disabled':
          return AppStrings.userDisabled;
        case 'too-many-requests':
          return AppStrings.tooManyRequests;
        default:
          return error.message ?? AppStrings.unknownError;
      }
    }
    return AppStrings.unknownError;
  }
}

extension StringExtension on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
