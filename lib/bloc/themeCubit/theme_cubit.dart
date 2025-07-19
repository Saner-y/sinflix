/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sinflix/core/core.dart';

enum AppThemeMode { dark, light }

class ThemeCubit extends Cubit<AppThemeMode> {
  final _secureStorage = locator<SecureStorageService>();
  final _logger = locator<LoggerService>();

  ThemeCubit() : super(AppThemeMode.dark) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final themeString = await _secureStorage.read('theme_mode');
      if (themeString == 'light') {
        emit(AppThemeMode.light);
      } else {
        emit(AppThemeMode.dark);
      }
      _logger.info('Theme loaded: $themeString', tag: 'ThemeCubit');
    } catch (e) {
      _logger.error('Error loading theme: $e', tag: 'ThemeCubit');
      emit(AppThemeMode.dark);
    }
  }

  Future<void> toggleTheme() async {
    final newTheme = state == AppThemeMode.dark ? AppThemeMode.light : AppThemeMode.dark;
    emit(newTheme);

    try {
      await _secureStorage.write(
        'theme_mode',
        newTheme == AppThemeMode.light ? 'light' : 'dark'
      );
      _logger.info('Theme changed to: $newTheme', tag: 'ThemeCubit');
    } catch (e) {
      _logger.error('Error saving theme: $e', tag: 'ThemeCubit');
    }
  }

  ThemeData getTheme(BuildContext context) {
    return state == AppThemeMode.light
        ? sinflixLightTheme(context)
        : sinflixTheme(context);
  }
}
*/
