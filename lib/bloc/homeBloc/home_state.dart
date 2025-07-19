import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class MovieListLoadedState extends HomeState {}

class FavoriteSetState extends HomeState {}

class HomeErrorState extends HomeState {
  final String error;

  const HomeErrorState({required this.error});

  @override
  List<Object> get props => [error];
}

class HomeSuccessState extends HomeState {}
