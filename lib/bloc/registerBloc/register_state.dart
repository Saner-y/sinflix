import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterFailure extends RegisterState {
  final String errorMessage;

  const RegisterFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class RegisterPasswordVisibilityChanged extends RegisterState {
  final bool isVisible;

  const RegisterPasswordVisibilityChanged(this.isVisible);

  @override
  List<Object> get props => [isVisible];
}

class RegisterConfirmPasswordVisibilityChanged extends RegisterState {
  final bool isVisible;

  const RegisterConfirmPasswordVisibilityChanged(this.isVisible);

  @override
  List<Object> get props => [isVisible];
}
