import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sinflix/core/core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'bloc/language/language_bloc.dart';
import 'core/constants/app_strings.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp();

  await setupLocator();

  final logger = locator<LoggerService>();
  logger.configure(
    isEnabled: true,
    minLogLevel: kDebugMode ? LogLevel.debug : LogLevel.info,
    enableFirebase: true,
  );

  FlutterError.onError = (errorDetails) {
    logger.critical(
      'Flutter framework error',
      tag: 'FlutterError',
      data: {
        'exception': errorDetails.exception.toString(),
        'library': errorDetails.library,
        'context': errorDetails.context.toString(),
      },
      stackTrace: errorDetails.stack,
    );
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    logger.critical(
      'Platform dispatcher error',
      tag: 'PlatformDispatcher',
      data: {'error': error.toString()},
      stackTrace: stack,
    );
    return true;
  };

  logger.info('Application started', tag: 'Main');

  runApp(BlocProvider(create: (context) => LanguageCubit(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, Locale>(
      builder: (context, locale) {
        return MaterialApp.router(
          routerConfig: appRouter,
          title: AppStrings.appName,
          theme: sinflixTheme(context),
          debugShowCheckedModeBanner: false,
          locale: locale,
          supportedLocales: const [Locale('en', ''), Locale('tr', '')],
          localizationsDelegates: [
            AppLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
    );
  }
}