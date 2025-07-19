part of '../components.dart';

class NavbarItem extends StatelessWidget {
  final VoidCallback? onPressed;
  final Icon icon;
  final String text;

  const NavbarItem({
    super.key,
    required this.icon,
    this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all<Color>(
          context.currentThemeData.colorScheme.secondary.withValues(alpha: 0.1),
        ),
        backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
        side: WidgetStateProperty.all<BorderSide>(
          BorderSide(
            width: 1,
            color: context.currentThemeData.colorScheme.secondary.withValues(
              alpha: 0.2,
            ),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: context.getDynamicWidth(2),
        children: [
          icon,
          Text(
            context.tr(text),
            style: context.currentThemeData.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
