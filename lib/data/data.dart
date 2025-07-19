import 'package:sinflix/data/movie/favorites/favorites_response.dart';
import 'package:sinflix/data/user/login/login_request.dart';
import 'package:sinflix/data/user/login/login_response.dart';
import 'package:sinflix/data/user/profile/profile_response.dart';
import 'package:sinflix/data/user/register/register_request.dart';
import 'package:sinflix/data/user/register/register_response.dart';
import 'package:sinflix/data/user/uploadPhoto/upload_photo_request.dart';
import 'package:sinflix/data/user/uploadPhoto/upload_photo_response.dart';

import '../core/constants/endpoint_paths.dart';
import '../core/core.dart';
import 'movie/movieList/movie_list_request.dart';
import 'movie/movieList/movie_list_response.dart';
import 'movie/setFavorite/set_favorite_request.dart';
import 'movie/setFavorite/set_favorite_response.dart';


//User
part 'user/login/login_repository.dart';
part 'user/register/register_repository.dart';
part 'user/profile/profile_repository.dart';
part 'user/uploadPhoto/upload_photo_repository.dart';
//Movie
part 'movie/movieList/movie_list_repository.dart';
part 'movie/setFavorite/set_favorite_repository.dart';
part 'movie/favorites/favorites_repository.dart';