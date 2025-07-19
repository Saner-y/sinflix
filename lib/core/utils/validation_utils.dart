part of '../core.dart';

class ValidationUtils {
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
    );

    return emailRegex.hasMatch(email);
  }

  static ValidationResult validateEmail(String email, BuildContext context) {
    if (email.isEmpty) {
      return ValidationResult(
        isValid: false,
        message: context.tr(AppStrings.validationEmailEmpty),
      );
    }

    if (!isValidEmail(email)) {
      return ValidationResult(
        isValid: false,
        message: context.tr(AppStrings.validationEmailInvalid),
      );
    }

    return ValidationResult(isValid: true, message: '');
  }

  static ValidationResult validatePassword(
    String password,
    BuildContext context,
  ) {
    if (password.isEmpty) {
      return ValidationResult(
        isValid: false,
        message: context.tr(AppStrings.validationPasswordEmpty),
      );
    }

    if (password.length < 6) {
      return ValidationResult(
        isValid: false,
        message: context.tr(AppStrings.validationPasswordTooShort),
      );
    }

    return ValidationResult(isValid: true, message: '');
  }

  static ValidationResult validateName(String name, BuildContext context) {
    if (name.isEmpty) {
      return ValidationResult(
        isValid: false,
        message: context.tr(AppStrings.validationNameEmpty),
      );
    }

    if (name.length < 2) {
      return ValidationResult(
        isValid: false,
        message: context.tr(AppStrings.validationNameTooShort),
      );
    }

    if (!RegExp(r'^[a-zA-ZçğıöşüÇĞIİÖŞÜ\s]+$').hasMatch(name)) {
      return ValidationResult(
        isValid: false,
        message: context.tr(AppStrings.validationNameInvalidCharacters),
      );
    }

    return ValidationResult(isValid: true, message: '');
  }

  static ValidationResult validatePasswordConfirmation(
    String password,
    String confirmPassword,
    BuildContext context,
  ) {
    if (password != confirmPassword) {
      return ValidationResult(
        isValid: false,
        message: context.tr(AppStrings.validationPasswordsNotMatch),
      );
    }

    return ValidationResult(isValid: true, message: '');
  }

  static RegisterValidationResult validateRegisterForm({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required BuildContext context,
  }) {
    final nameValidation = validateName(name, context);
    if (!nameValidation.isValid) {
      return RegisterValidationResult(
        isValid: false,
        errorMessage: nameValidation.message,
        field: 'name',
      );
    }

    final emailValidation = validateEmail(email, context);
    if (!emailValidation.isValid) {
      return RegisterValidationResult(
        isValid: false,
        errorMessage: emailValidation.message,
        field: 'email',
      );
    }

    final passwordValidation = validatePassword(password, context);
    if (!passwordValidation.isValid) {
      return RegisterValidationResult(
        isValid: false,
        errorMessage: passwordValidation.message,
        field: 'password',
      );
    }

    final confirmPasswordValidation = validatePasswordConfirmation(
      password,
      confirmPassword,
      context,
    );
    if (!confirmPasswordValidation.isValid) {
      return RegisterValidationResult(
        isValid: false,
        errorMessage: confirmPasswordValidation.message,
        field: 'confirmPassword',
      );
    }

    return RegisterValidationResult(isValid: true, errorMessage: '', field: '');
  }
}

class ValidationResult {
  final bool isValid;
  final String message;

  ValidationResult({required this.isValid, required this.message});
}

class RegisterValidationResult {
  final bool isValid;
  final String errorMessage;
  final String field;

  RegisterValidationResult({
    required this.isValid,
    required this.errorMessage,
    required this.field,
  });
}
