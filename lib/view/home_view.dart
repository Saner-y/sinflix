part of 'view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PageController _pageController = PageController();
  HomeBloc? _homeBloc;
  bool _isLoadingMore = false;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageScroll);
  }

  void _onPageScroll() {
    final currentIndex = _pageController.page?.round() ?? 0;
    final totalMovies = _homeBloc?.movieList.length ?? 0;

    if (currentIndex >= totalMovies - 3 &&
        !_isLoadingMore &&
        _homeBloc != null &&
        _homeBloc!.currentPage <= _homeBloc!.maxPage) {
      _isLoadingMore = true;
      _homeBloc!.add(LoadMovieList());
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = HomeBloc();
        _homeBloc = bloc;
        bloc.add(LoadMovieList());
        return bloc;
      },
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is MovieListLoadedState) {
            _isLoadingMore = false;
          } else if (state is HomeErrorState) {
            _isLoadingMore = false;
            MainSnackBar.showMainSnackBar(
              context,
              state.error,
              context.currentThemeData.colorScheme.error,
            );
          } else if (state is FavoriteSetState) {
            _isLoadingMore = false;
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoadingState && _homeBloc!.movieList.isEmpty) {
              return BaseView(
                hasNavbar: true,
                isHome: true,
                body: Center(
                  child: Lottie.asset('assets/lottie/lottieLoading.json'),
                ),
              );
            }

            return BaseView(
              hasNavbar: true,
              isHome: true,
              body: RefreshIndicator(
                onRefresh: () async {
                  _homeBloc!.currentPage = 1;
                  _homeBloc!.movieList.clear();
                  _homeBloc!.add(LoadMovieList());
                },
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPageIndex = index;
                    });

                    final totalMovies = _homeBloc?.movieList.length ?? 0;

                    if (index >= totalMovies - 3 &&
                        !_isLoadingMore &&
                        _homeBloc != null &&
                        _homeBloc!.currentPage <= _homeBloc!.maxPage) {
                      _isLoadingMore = true;
                      _homeBloc!.add(LoadMovieList());
                    }
                  },
                  itemCount:
                      _homeBloc!.movieList.length +
                      (_isLoadingMore &&
                              _homeBloc!.currentPage <= _homeBloc!.maxPage
                          ? 1
                          : 0),
                  itemBuilder: (context, index) {
                    if (index >= _homeBloc!.movieList.length) {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: Lottie.asset(
                            'assets/lottie/lottieLoading.json',
                          ),
                        ),
                      );
                    }

                    final movie = _homeBloc!.movieList[index];

                    String posterUrl =
                        movie.poster ??
                        'https://ia.media-imdb.com/images/M/MV5BMjIxNTU4MzY4MF5BMl5BanBnXkFtZTgwMzM4ODI3MjE@..jpg';
                    if (posterUrl.startsWith('http://')) {
                      posterUrl = posterUrl.replaceFirst('http://', 'https://');
                    }

                    return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(posterUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: context.paddingNormal,
                        child: Column(
                          children: [
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FavoriteButton(
                                  onPressed: () {
                                    context.read<HomeBloc>().add(
                                      SetFavoriteEvent(
                                        request: SetFavoriteRequest(
                                          movieId: movie.sId ?? '',
                                        ),
                                      ),
                                    );
                                  },
                                  isFavorite: movie.isFavorite ?? false,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/images/logo.png'),
                                SizedBox(width: context.getDynamicWidth(2)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movie.title ??
                                            context.tr(AppStrings.unknownMovie),
                                        style: context
                                            .currentThemeData
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Builder(
                                            builder: (context) {
                                              final plot =
                                                  movie.plot ??
                                                  context.tr(
                                                    AppStrings
                                                        .noDescriptionAvailable,
                                                  );
                                              final words = plot.split(' ');

                                              final firstLineWords = words
                                                  .take(7)
                                                  .toList();
                                              final firstLine = firstLineWords
                                                  .join(' ');

                                              final remainingWords = words
                                                  .skip(7)
                                                  .toList();
                                              final secondLine = remainingWords
                                                  .join(' ');

                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    firstLine,
                                                    style: context
                                                        .currentThemeData
                                                        .textTheme
                                                        .bodySmall,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.visible,
                                                  ),
                                                  if (remainingWords.isNotEmpty)
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            secondLine,
                                                            style: context
                                                                .currentThemeData
                                                                .textTheme
                                                                .bodySmall,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: null,
                                                          style: TextButton.styleFrom(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            minimumSize:
                                                                Size.zero,
                                                            tapTargetSize:
                                                                MaterialTapTargetSize
                                                                    .shrinkWrap,
                                                          ),
                                                          child: Text(
                                                            context.tr(
                                                              AppStrings
                                                                  .moreDetails,
                                                            ),
                                                            style: context
                                                                .currentThemeData
                                                                .textTheme
                                                                .bodySmall
                                                                ?.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: context.getDynamicHeight(10)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
