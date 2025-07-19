part of '../../core.dart';

ThemeData sinflixTheme(BuildContext context) {
  return ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      error: AppColors.error,
    ),
    primaryColor: AppColors.primary,
    textTheme: AppTextStyles.sinflixTextTheme(context),
  );
}
