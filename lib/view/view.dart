import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:sinflix/bloc/homeBloc/home_bloc.dart';
import 'package:sinflix/bloc/language/language_bloc.dart';
import 'package:sinflix/bloc/profileBloc/profile_bloc.dart';
import 'package:sinflix/bloc/registerBloc/register_bloc.dart';
import 'package:sinflix/bloc/registerBloc/register_event.dart';
import 'package:sinflix/data/user/register/register_request.dart';
import 'package:sinflix/data/movie/setFavorite/set_favorite_request.dart';
import '../bloc/homeBloc/home_event.dart';
import '../bloc/homeBloc/home_state.dart';
import '../bloc/loginBloc/login_bloc.dart';
import '../bloc/loginBloc/login_event.dart';
import '../bloc/loginBloc/login_state.dart';
import '../bloc/profileBloc/profile_event.dart';
import '../bloc/profileBloc/profile_state.dart';
import '../bloc/registerBloc/register_state.dart';
import '../components/components.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/route_names.dart';
import '../core/core.dart';



part 'login_view.dart';
part 'register_view.dart';
part 'upload_profile_photo_view.dart';
part 'home_view.dart';
part 'profile_view.dart';
part 'limited_offer_view.dart';
part 'splash_view.dart';