import 'package:bloc/bloc.dart';
import 'package:sinflix/core/core.dart';
import 'package:sinflix/data/data.dart';
import 'package:sinflix/data/movie/movieList/movie_list_request.dart';
import 'package:sinflix/data/movie/movieList/movie_list_response.dart';
import 'package:sinflix/data/movie/setFavorite/set_favorite_response.dart';
import '../../core/constants/app_strings.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final movieListRepository = locator<MovieListRepository>();
  final setFavoriteRepository = locator<SetFavoriteRepository>();
  final _logger = locator<LoggerService>();

  int currentPage = 1;
  int maxPage = 1;
  List<Movies> movieList = [];

  static const Duration _minimumLoadingDuration = Duration(milliseconds: 1500);

  HomeBloc() : super(HomeInitialState()) {
    on<LoadMovieList>(_onLoadMovieList);
    on<SetFavoriteEvent>(_onSetFavorite);
    on<ResetHomeEvent>((event, emit) {
      emit(HomeInitialState());
    });

    _logger.blocEvent(blocName: 'HomeBloc', eventName: 'Initialized');
  }

  Future<void> _onLoadMovieList(
    LoadMovieList event,
    Emitter<HomeState> emit,
  ) async {
    _logger.blocEvent(
      blocName: 'HomeBloc',
      eventName: 'LoadMovieListRequested',
      eventData: {
        'currentPage': currentPage,
        'maxPage': maxPage,
        'currentMovieCount': movieList.length,
      },
    );

    DateTime? loadingStartTime;
    if (currentPage == 1) {
      loadingStartTime = DateTime.now();
      emit(HomeLoadingState());
      _logger.blocState(blocName: 'HomeBloc', stateName: 'HomeLoadingState');
    }

    try {
      if (currentPage > maxPage && maxPage > 0) {
        _logger.info(
          'Reached max page limit',
          tag: 'HomeBloc',
          data: {'currentPage': currentPage, 'maxPage': maxPage},
        );
        return;
      }

      final request = MovieListRequest(page: currentPage.toString());
      final response = await movieListRepository.getMovieList(request: request);

      if (!response.isSuccess) {
        final errorMessage =
            response.data?.errorMessage ?? AppStrings.movieListLoadFailed;
        await _handleMinimumLoadingTime(loadingStartTime);
        _handleMovieListFailure(emit, errorMessage);
        return;
      }

      final movieData = response.data;
      if (movieData == null || !movieData.isSuccess) {
        await _handleMinimumLoadingTime(loadingStartTime);
        _handleMovieListFailure(emit, AppStrings.movieListLoadFailed);
        return;
      }

      await _handleMinimumLoadingTime(loadingStartTime);
      await _handleMovieListSuccess(emit, movieData);
    } catch (e) {
      _logger.error(
        'Movie list loading failed with exception',
        tag: 'HomeBloc',
        data: {'error': e.toString(), 'currentPage': currentPage},
      );
      await _handleMinimumLoadingTime(loadingStartTime);
      _handleMovieListFailure(emit, AppStrings.movieListLoadFailed);
    }
  }

  Future<void> _handleMinimumLoadingTime(DateTime? startTime) async {
    if (startTime != null) {
      final elapsed = DateTime.now().difference(startTime);
      if (elapsed < _minimumLoadingDuration) {
        final remainingTime = _minimumLoadingDuration - elapsed;
        await Future.delayed(remainingTime);
      }
    }
  }

  Future<void> _onSetFavorite(
    SetFavoriteEvent event,
    Emitter<HomeState> emit,
  ) async {
    _logger.blocEvent(
      blocName: 'HomeBloc',
      eventName: 'SetFavoriteRequested',
      eventData: {'movieId': event.request.movieId},
    );

    try {
      final response = await setFavoriteRepository.setFavorite(
        request: event.request,
      );

      if (!response.isSuccess) {
        final errorMessage =
            response.data?.errorMessage ?? AppStrings.setFavoriteError;
        _handleSetFavoriteFailure(emit, errorMessage, event.request.movieId);
        return;
      }

      final favoriteData = response.data;
      if (favoriteData == null || !favoriteData.isSuccess) {
        _handleSetFavoriteFailure(
          emit,
          AppStrings.setFavoriteError,
          event.request.movieId,
        );
        return;
      }

      await _handleSetFavoriteSuccess(
        emit,
        favoriteData,
        event.request.movieId,
      );
    } catch (e) {
      _logger.error(
        'Set favorite failed with exception',
        tag: 'HomeBloc',
        data: {'error': e.toString(), 'movieId': event.request.movieId},
      );
      _handleSetFavoriteFailure(
        emit,
        AppStrings.setFavoriteError,
        event.request.movieId,
      );
    }
  }

  Future<void> _handleMovieListSuccess(
    Emitter<HomeState> emit,
    MovieListResponse movieData,
  ) async {
    if (movieData.data?.pagination != null) {
      maxPage = movieData.data!.pagination!.maxPage ?? 1;
    }

    if (movieData.data?.movies != null) {
      if (currentPage == 1) {
        movieList = movieData.data!.movies!.toList();
        _logger.info(
          'Movie list loaded (first page)',
          tag: 'HomeBloc',
          data: {'movieCount': movieList.length, 'maxPage': maxPage},
        );
      } else {
        movieList.addAll(movieData.data!.movies!.toList());
        _logger.info(
          'Movie list loaded (page $currentPage)',
          tag: 'HomeBloc',
          data: {
            'newMovieCount': movieData.data!.movies!.length,
            'totalMovieCount': movieList.length,
          },
        );
      }
    }

    currentPage++;

    emit(MovieListLoadedState());
    add(ResetHomeEvent());
    _logger.blocState(blocName: 'HomeBloc', stateName: 'MovieListLoadedState');
  }

  void _handleMovieListFailure(Emitter<HomeState> emit, String errorMessage) {
    emit(HomeErrorState(error: errorMessage));

    _logger.error(
      'Movie list loading failed',
      tag: 'HomeBloc',
      data: {'errorMessage': errorMessage, 'currentPage': currentPage},
    );

    _logger.blocState(blocName: 'HomeBloc', stateName: 'HomeErrorState');
  }

  Future<void> _handleSetFavoriteSuccess(
    Emitter<HomeState> emit,
    SetFavoriteResponse favoriteData,
    String movieId,
  ) async {
    final responseMovie = favoriteData.data?.movie;
    if (responseMovie != null) {
      final movieIndex = movieList.indexWhere((movie) => movie.sId == movieId);
      if (movieIndex != -1) {
        movieList[movieIndex].isFavorite = responseMovie.isFavorite;

        _logger.info(
          'Movie favorite status updated from API response',
          tag: 'HomeBloc',
          data: {
            'movieId': movieId,
            'newFavoriteStatus': responseMovie.isFavorite,
            'movieTitle': movieList[movieIndex].title,
            'action': favoriteData.data?.action,
          },
        );
      }
    }

    emit(FavoriteSetState());
    add(ResetHomeEvent());
    _logger.blocState(blocName: 'HomeBloc', stateName: 'FavoriteSetState');
  }

  void _handleSetFavoriteFailure(
    Emitter<HomeState> emit,
    String errorMessage,
    String movieId,
  ) {
    emit(HomeErrorState(error: errorMessage));

    _logger.error(
      'Set favorite failed',
      tag: 'HomeBloc',
      data: {'errorMessage': errorMessage, 'movieId': movieId},
    );

    _logger.blocState(blocName: 'HomeBloc', stateName: 'HomeErrorState');
  }
}
