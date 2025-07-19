import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {}

class ProfileError extends ProfileState {
  final String errorMessage;

  const ProfileError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class ProfileSuccess extends ProfileState {}

class TokenError extends ProfileState {
  final String errorMessage;

  const TokenError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class FavoritesLoaded extends ProfileState {}
