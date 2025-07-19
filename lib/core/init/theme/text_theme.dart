part of '../../core.dart';

class AppTextStyles {
  static TextStyle get sinflixFont => TextStyle(fontFamily: 'Euclid');

  static TextTheme sinflixTextTheme(BuildContext context) {
    return TextTheme(
      headlineLarge: sinflixFont.copyWith(
        color: AppColors.secondary,
        fontWeight: FontWeight.w900,
        fontSize: context.getDynamicHeight(3.0), // 25px -> ~3.0% of 844
        overflow: TextOverflow.ellipsis,
      ),
      headlineMedium: sinflixFont.copyWith(
        color: AppColors.secondary,
        fontWeight: FontWeight.w700,
        fontSize: context.getDynamicHeight(2.4), // 20px -> ~2.4% of 844
        overflow: TextOverflow.ellipsis,
      ),
      headlineSmall: sinflixFont.copyWith(
        color: AppColors.secondary,
        fontWeight: FontWeight.w600,
        fontSize: context.getDynamicHeight(1.8), // 15px -> ~1.8% of 844
        overflow: TextOverflow.ellipsis,
      ),
      bodyLarge: sinflixFont.copyWith(
        color: AppColors.secondary,
        fontWeight: FontWeight.w700,
        fontSize: context.getDynamicHeight(2.1), // 18px -> ~2.1% of 844
        overflow: TextOverflow.ellipsis,
      ),
      bodyMedium: sinflixFont.copyWith(
        color: AppColors.secondary,
        fontWeight: FontWeight.w500,
        fontSize: context.getDynamicHeight(1.8), // 15px -> ~1.8% of 844
        overflow: TextOverflow.ellipsis,
      ),
      bodySmall: sinflixFont.copyWith(
        color: AppColors.secondary,
        fontWeight: FontWeight.w500,
        fontSize: context.getDynamicHeight(1.5), // 13px -> ~1.5% of 844
        overflow: TextOverflow.ellipsis,
      ),
      labelLarge: sinflixFont.copyWith(
        color: AppColors.secondary,
        fontWeight: FontWeight.w600,
        fontSize: context.getDynamicHeight(1.7), // 14px -> ~1.7% of 844
        overflow: TextOverflow.ellipsis,
      ),
      labelMedium: sinflixFont.copyWith(
        color: AppColors.secondary,
        fontWeight: FontWeight.w500,
        fontSize: context.getDynamicHeight(1.4), // 12px -> ~1.4% of 844
        overflow: TextOverflow.ellipsis,
      ),
      labelSmall: sinflixFont.copyWith(
        color: AppColors.secondary,
        fontWeight: FontWeight.w300,
        fontSize: context.getDynamicHeight(1.4), // 12px -> ~1.4% of 844
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
