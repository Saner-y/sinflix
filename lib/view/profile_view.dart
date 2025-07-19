part of 'view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = ProfileBloc();
        bloc.add(LoadProfileData());
        bloc.add(LoadFavoriteMovies());
        return bloc;
      },
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ProfileLoading) {
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
            appBar: AppBar(
              scrolledUnderElevation: 0,
              toolbarHeight: context.getDynamicHeight(4),
              elevation: 0,
              centerTitle: true,
              title: Text(
                context.tr(AppStrings.profileDetail),
                style: context.currentThemeData.textTheme.bodyMedium,
              ),
              backgroundColor: Colors.transparent,

              leading: CustomIconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
              leadingWidth: context.getDynamicWidth(20),
              actions: [
                MainButton(
                  isLimitedOffer: true,
                  text: AppStrings.limitedOffer,
                  textStyle: context.currentThemeData.textTheme.labelMedium,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor:
                          context.currentThemeData.colorScheme.surface,
                      builder: (context) {
                        return LimitedOfferView();
                      },
                    );
                  },
                ),
                SizedBox(width: context.getDynamicWidth(2)),
              ],
            ),
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: context.getDynamicWidth(10),
                          backgroundColor: context
                              .currentThemeData
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.1),
                          backgroundImage:
                              (context
                                      .read<ProfileBloc>()
                                      .imageUrl
                                      .isNotEmpty &&
                                  Uri.tryParse(
                                        context.read<ProfileBloc>().imageUrl,
                                      )?.hasAbsolutePath ==
                                      true)
                              ? NetworkImage(
                                  context.read<ProfileBloc>().imageUrl,
                                )
                              : null,
                          child:
                              (context.read<ProfileBloc>().imageUrl.isEmpty ||
                                  Uri.tryParse(
                                        context.read<ProfileBloc>().imageUrl,
                                      )?.hasAbsolutePath !=
                                      true)
                              ? Icon(
                                  Icons.person,
                                  size: context.getDynamicWidth(8),
                                  color: context
                                      .currentThemeData
                                      .colorScheme
                                      .primary,
                                )
                              : null,
                        ),
                        SizedBox(width: context.getDynamicWidth(2)),
                        SizedBox(
                          width: context.getDynamicWidth(25),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context
                                        .read<ProfileBloc>()
                                        .loadedProfile['name'] ??
                                    '',
                                style: context
                                    .currentThemeData
                                    .textTheme
                                    .bodyMedium,
                              ),
                              Text(
                                "ID: ${context.read<ProfileBloc>().loadedProfile['id'] ?? ''}",
                                style: context
                                    .currentThemeData
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color: context
                                          .currentThemeData
                                          .colorScheme
                                          .secondary
                                          .withValues(alpha: 0.5),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    MainButton(
                      text: AppStrings.addPhoto,
                      radius: 8,
                      textStyle: context.currentThemeData.textTheme.bodySmall,
                      onPressed: () =>
                          context.push(RouteNames.uploadProfileImage),
                    ),
                  ],
                ),
                SizedBox(height: context.getDynamicHeight(2)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.tr(AppStrings.likedMovies),
                      style: context.currentThemeData.textTheme.bodySmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Row(
                      children: [
                        CustomIconButton(
                          icon: Icon(Icons.logout_rounded),
                          onPressed: () async {
                            await context.read<ProfileBloc>().logout();
                            context.go(RouteNames.home);
                          },
                        ),
                        CustomIconButton(
                          icon: Icon(Icons.language_outlined),
                          onPressed: () {
                            context.read<LanguageCubit>().changeLanguage(
                              context.locale.languageCode == 'tr' ? 'en' : 'tr',
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: context.getDynamicHeight(1)),
                context.read<ProfileBloc>().favoriteMovies.isNotEmpty
                    ? Expanded(
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: context.getDynamicWidth(3),
                            mainAxisSpacing: context.getDynamicHeight(2),
                            childAspectRatio: 0.5,
                          ),
                          itemCount: context
                              .read<ProfileBloc>()
                              .favoriteMovies
                              .length,
                          itemBuilder: (context, index) {
                            final movie = context
                                .read<ProfileBloc>()
                                .favoriteMovies[index];
                            String posterUrl =
                                movie.poster ??
                                'https://ia.media-imdb.com/images/M/MV5BMjIxNTU4MzY4MF5BMl5BanBnXkFtZTgwMzM4ODI3MjE@..jpg';
                            if (posterUrl.startsWith('http://')) {
                              posterUrl = posterUrl.replaceFirst(
                                'http://',
                                'https://',
                              );
                            }
                            return FavoriteMovieCard(
                              imageUrl: posterUrl,
                              title: movie.title ?? '',
                              director: movie.director ?? '',
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Text(context.tr(AppStrings.noFavoriteMovies)),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
