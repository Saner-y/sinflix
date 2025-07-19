part of '../components.dart';

class MainButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLimitedOffer;
  final TextStyle? textStyle;
  final double radius;

  const MainButton({
    super.key,
    this.onPressed,
    required this.text,
    this.isLimitedOffer = false,
    this.textStyle,
    this.radius = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          context.currentThemeData.colorScheme.primary,
        ),
        foregroundColor: WidgetStateProperty.all<Color>(
          context.currentThemeData.colorScheme.secondary,
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: BorderSide.none,
          ),
        ),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
          context.paddingZero,
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: context.paddingLowHorizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isLimitedOffer)
              Icon(
                Icons.diamond_rounded,
                color: context.currentThemeData.colorScheme.secondary,
                size: context.getDynamicWidth(4),
              ),
            if (isLimitedOffer) SizedBox(width: context.getDynamicWidth(1)),
            Text(
              context.tr(text),
              style: textStyle ?? context.currentThemeData.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
