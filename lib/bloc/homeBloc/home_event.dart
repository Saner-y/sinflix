import 'package:equatable/equatable.dart';
import 'package:sinflix/data/movie/setFavorite/set_favorite_request.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadMovieList extends HomeEvent {}

class SetFavoriteEvent extends HomeEvent {
  final SetFavoriteRequest request;

  const SetFavoriteEvent({required this.request});

  @override
  List<Object> get props => [request];
}

class ResetHomeEvent extends HomeEvent {}
