import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfileData extends ProfileEvent {}

class UploadProfilePhotoEvent extends ProfileEvent {}

class LoadFavoriteMovies extends ProfileEvent {}

class ResetProfileEvent extends ProfileEvent {}
