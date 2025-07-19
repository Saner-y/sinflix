part of '../components.dart';

class MainSnackBar {
  static void showMainSnackBar(
    BuildContext context,
    String message,
    Color backgroundColor,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        showCloseIcon: true,
        closeIconColor: context.currentThemeData.colorScheme.secondary,
        content: Text(
          context.tr(message),
          style: context.currentThemeData.textTheme.labelMedium,
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }
}
