import 'package:equatable/equatable.dart';
import 'package:sinflix/data/user/register/register_request.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterRequestEvent extends RegisterEvent {
  final RegisterRequest request;
  final String confirmPassword;

  const RegisterRequestEvent({
    required this.request,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [request, confirmPassword];
}

class RegisterGoogleSignInEvent extends RegisterEvent {}

class RegisterAppleSignInEvent extends RegisterEvent {}

class RegisterFacebookSignInEvent extends RegisterEvent {}

class ToggleRegisterPasswordVisibilityEvent extends RegisterEvent {}

class ToggleConfirmPasswordVisibilityEvent extends RegisterEvent {}

class ResetRegisterEvent extends RegisterEvent {}
