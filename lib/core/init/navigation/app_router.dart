part of '../../core.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.splash,
  redirect: (context, state) async {
    final secureStorageService = locator<SecureStorageService>();
    final logger = locator<LoggerService>();

    final currentLocation = state.matchedLocation;

    final hasToken = await secureStorageService.hasToken();

    final publicRoutes = [
      RouteNames.login,
      RouteNames.register,
      RouteNames.splash,
    ];

    if (currentLocation == RouteNames.splash) {
      return null;
    }

    if (!hasToken && !publicRoutes.contains(currentLocation)) {
      logger.navigationEvent(
        routeName: RouteNames.login,
        action: 'redirect (no token)',
        parameters: {'from': currentLocation},
      );
      return RouteNames.login;
    }

    final authRoutes = [RouteNames.login];

    if (hasToken && authRoutes.contains(currentLocation)) {
      logger.navigationEvent(
        routeName: RouteNames.home,
        action: 'redirect (has token)',
        parameters: {'from': currentLocation},
      );
      return RouteNames.home;
    }

    logger.navigationEvent(routeName: currentLocation, action: 'navigate');

    return null;
  },
  routes: [
    GoRoute(path: RouteNames.splash, builder: (_, _) => const SplashView()),
    GoRoute(path: RouteNames.login, builder: (_, _) => const LoginView()),
    GoRoute(path: RouteNames.register, builder: (_, _) => const RegisterView()),
    GoRoute(
      path: RouteNames.uploadProfileImage,
      builder: (_, _) => const UploadProfilePhotoView(),
    ),
    GoRoute(path: RouteNames.home, builder: (_, _) => const HomeView()),
    GoRoute(path: RouteNames.profile, builder: (_, _) => const ProfileView()),
  ],
);
