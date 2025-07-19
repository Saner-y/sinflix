part of '../components.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Icon icon;

  const CustomIconButton({super.key, this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: context.getDynamicHeight(2.4),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          context.currentThemeData.colorScheme.secondary.withValues(alpha: 0.1),
        ),
        shape: WidgetStateProperty.all<CircleBorder>(
          CircleBorder(
            side: BorderSide(
              color: context.currentThemeData.colorScheme.secondary.withValues(
                alpha: 0.2,
              ),
              width: 1.0,
            ),
          ),
        ),
      ),
      onPressed: onPressed,
      icon: icon,
    );
  }
}
