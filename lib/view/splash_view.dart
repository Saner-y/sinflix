part of 'view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final _secureStorage = locator<SecureStorageService>();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    FlutterNativeSplash.remove();

    await Future.delayed(const Duration(seconds: 3));

    try {
      final token = await _secureStorage.getToken();

      if (mounted) {
        if (token != null && token.isNotEmpty) {
          context.go(RouteNames.home);
        } else {
          context.go(RouteNames.login);
        }
      }
    } catch (e) {
      if (mounted) {
        context.go(RouteNames.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: context.height,
        width: context.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/SinFlixSplash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Spacer(flex: 14),
            Lottie.asset('assets/lottie/lottieLoading.json'),
            Spacer(flex: 5),
          ],
        ),
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
    );
  }
}
