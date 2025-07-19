part of '../../core.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton(() => FlutterSecureStorage());
  locator.registerLazySingleton(() => ApiService());
  locator.registerLazySingleton(() => SecureStorageService(locator()));
  locator.registerLazySingleton(() => LoggerService());
  locator.registerLazySingleton(() => LoginRepository(locator()));
  locator.registerLazySingleton(() => RegisterRepository(locator()));
  locator.registerLazySingleton(() => UploadPhotoRepository(locator()));
  locator.registerLazySingleton(() => ProfileRepository(locator()));
  locator.registerLazySingleton(() => MovieListRepository(locator()));
  locator.registerLazySingleton(() => SetFavoriteRepository(locator()));
  locator.registerLazySingleton(() => FavoritesRepository(locator()));
}