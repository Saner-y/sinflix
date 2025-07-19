import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sinflix/bloc/profileBloc/profile_event.dart';
import 'package:sinflix/bloc/profileBloc/profile_state.dart';
import 'package:sinflix/core/constants/app_strings.dart';
import 'package:sinflix/core/core.dart';
import 'package:sinflix/data/data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sinflix/data/movie/favorites/favorites_response.dart';
import 'package:sinflix/data/user/profile/profile_response.dart';
import 'package:sinflix/data/user/uploadPhoto/upload_photo_response.dart';
import '../../data/user/uploadPhoto/upload_photo_request.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final profileRepository = locator<ProfileRepository>();
  final uploadPhotoRepository = locator<UploadPhotoRepository>();
  final favoritesRepository = locator<FavoritesRepository>();
  final _logger = locator<LoggerService>();
  final _secureStorage = locator<SecureStorageService>();
  Map<String, dynamic> loadedProfile = {};
  List<FavoritesData> favoriteMovies = [];
  String imageUrl = '';

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfileData>(_onProfileLoad);
    on<LoadFavoriteMovies>(_onFavoriteMoviesLoad);
    on<UploadProfilePhotoEvent>(_onProfilePhotoUpload);
    on<ResetProfileEvent>((event, emit) {
      emit(ProfileInitial());
      _logger.blocState(
        blocName: 'ProfileBloc',
        stateName: 'ProfileInitial (Reset)',
      );
    });

    _logger.blocEvent(blocName: 'ProfileBloc', eventName: 'Initialized');
  }

  Future<void> _onProfileLoad(
    LoadProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    _logger.blocEvent(
      blocName: 'ProfileBloc',
      eventName: 'LoadProfileDataRequested',
    );

    emit(ProfileLoading());
    _logger.blocState(blocName: 'ProfileBloc', stateName: 'ProfileLoading');

    try {
      final response = await profileRepository.getProfile();

      if (!response.isSuccess) {
        final errorMessage =
            response.data?.errorMessage ?? AppStrings.profileLoadFailed;
        _handleProfileFailure(emit, errorMessage, 'LoadProfile');
        return;
      }

      final profileData = response.data;
      if (profileData == null || !profileData.isSuccess) {
        final errorMessage =
            profileData?.errorMessage ??
            AppStrings.profileDataNullOrNotSuccessful;
        _handleProfileFailure(emit, errorMessage, 'LoadProfile');
        return;
      }

      if (response.data!.data == null) {
        _handleProfileFailure(
          emit,
          AppStrings.profileDataNullOrNotSuccessful,
          'LoadProfile',
        );
        return;
      }

      _handleProfileLoadSuccess(emit, response.data!);
    } catch (e) {
      _logger.error(
        'Profile load failed with exception',
        tag: 'ProfileBloc',
        data: {'error': e.toString()},
      );
      _handleProfileFailure(emit, e.toString(), 'LoadProfile');
    }
  }

  Future<void> _onFavoriteMoviesLoad(
    LoadFavoriteMovies event,
    Emitter<ProfileState> emit,
  ) async {
    _logger.blocEvent(
      blocName: 'ProfileBloc',
      eventName: 'LoadFavoriteMoviesRequested',
    );

    emit(ProfileLoading());
    _logger.blocState(
      blocName: 'ProfileBloc',
      stateName: 'ProfileLoading (Favorites)',
    );

    try {
      final response = await favoritesRepository.getFavorites();

      if (!response.isSuccess || response.data == null) {
        final errorMessage =
            response.data?.errorMessage ?? AppStrings.favoritesLoadFailed;
        _handleProfileFailure(emit, errorMessage, 'LoadFavorites');
        return;
      }

      _handleFavoritesLoadSuccess(emit, response.data!);
    } catch (e) {
      _logger.error(
        'Favorites load failed with exception',
        tag: 'ProfileBloc',
        data: {'error': e.toString()},
      );
      _handleProfileFailure(emit, e.toString(), 'LoadFavorites');
    }
  }

  Future<void> _onProfilePhotoUpload(
    UploadProfilePhotoEvent event,
    Emitter<ProfileState> emit,
  ) async {
    _logger.blocEvent(
      blocName: 'ProfileBloc',
      eventName: 'UploadProfilePhotoRequested',
    );

    emit(ProfileLoading());
    _logger.blocState(
      blocName: 'ProfileBloc',
      stateName: 'ProfileLoading (PhotoUpload)',
    );

    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        _handleProfileFailure(emit, AppStrings.noImageSelected, 'PhotoUpload');
        return;
      }

      final request = UploadPhotoRequest(file: File(image.path));

      final response = await uploadPhotoRepository.uploadPhoto(
        request: request,
      );

      if (!response.isSuccess || response.data == null) {
        final errorMessage =
            response.data?.errorMessage ?? AppStrings.photoUploadFailed;
        _handleProfileFailure(emit, errorMessage, 'PhotoUpload');
        return;
      }

      await _handlePhotoUploadSuccess(emit, response.data!);
    } catch (e) {
      _logger.error(
        'Photo upload failed with exception',
        tag: 'ProfileBloc',
        data: {'error': e.toString()},
      );
      _handleProfileFailure(emit, e.toString(), 'PhotoUpload');
    }
  }

  void _handleProfileLoadSuccess(
    Emitter<ProfileState> emit,
    ProfileResponse profileData,
  ) {
    imageUrl = profileData.data!.photoUrl ?? '';
    loadedProfile = profileData.data!.toJson();
    emit(ProfileLoaded());
    _logger.blocState(blocName: 'ProfileBloc', stateName: 'ProfileLoaded');
  }

  void _handleFavoritesLoadSuccess(
    Emitter<ProfileState> emit,
    dynamic favoritesData,
  ) {
    favoriteMovies = favoritesData.data ?? [];
    emit(FavoritesLoaded());
    _logger.blocState(blocName: 'ProfileBloc', stateName: 'FavoritesLoaded');
  }

  Future<void> _handlePhotoUploadSuccess(
    Emitter<ProfileState> emit,
    UploadPhotoResponse uploadData,
  ) async {
    imageUrl = uploadData.data?.photoUrl ?? '';
    emit(ProfileSuccess());
    _logger.blocState(
      blocName: 'ProfileBloc',
      stateName: 'ProfileSuccess (PhotoUpload)',
    );

    add(LoadProfileData());
  }

  void _handleProfileFailure(
    Emitter<ProfileState> emit,
    String errorMessage,
    String operation,
  ) {
    emit(ProfileError(errorMessage: errorMessage));

    _logger.blocState(
      blocName: 'ProfileBloc',
      stateName: 'ProfileError ($operation)',
    );

    add(ResetProfileEvent());
  }

  Future<void> logout() async {
    _logger.blocState(
      blocName: 'ProfileBloc',
      stateName: 'ProfileInitial (Logout)',
    );
    await _secureStorage.clearAll();
  }
}
