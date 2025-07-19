part of '../components.dart';

class MainInput extends StatelessWidget {
  final String hintText;
  final Icon prefixIcon;
  final bool isPassword;
  final bool? isVisible;
  final VoidCallback? onVisibilityToggle;
  final TextEditingController controller;

  const MainInput({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.isVisible,
    this.onVisibilityToggle,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: context.currentThemeData.textTheme.labelMedium,
      obscureText: isPassword && !(isVisible ?? false),
      controller: controller,
      decoration: InputDecoration(
        contentPadding: context.paddingLowHorizontal,
        fillColor: context.currentThemeData.colorScheme.secondary.withValues(
          alpha: 0.1,
        ),
        filled: true,
        hintStyle: context.currentThemeData.textTheme.labelMedium?.copyWith(
          color: context.currentThemeData.colorScheme.secondary.withValues(
            alpha: 0.5,
          ),
        ),
        hintText: context.tr(hintText),
        prefixIcon: prefixIcon,
        suffixIcon: isPassword
            ? IconButton(
                onPressed: onVisibilityToggle,
                icon: Icon(
                  (isVisible ?? false)
                      ? Icons.visibility_off_outlined
                      : Icons.remove_red_eye_outlined,
                ),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.0),
          borderSide: BorderSide(
            color: context.currentThemeData.colorScheme.secondary.withValues(
              alpha: 0.2,
            ),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.0),
          borderSide: BorderSide(
            color: context.currentThemeData.colorScheme.primary,
            width: 1,
          ),
        ),
      ),
    );
  }
}
