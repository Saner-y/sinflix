part of '../components.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback googleTap;
  final VoidCallback appleTap;
  final VoidCallback facebookTap;

  const SocialLoginButtons({
    super.key,
    required this.googleTap,
    required this.appleTap,
    required this.facebookTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: context.getDynamicWidth(2),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: googleTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            height: context.getDynamicHeight(7.1),
            width: context.getDynamicWidth(15),
            decoration: BoxDecoration(
              color: context.currentThemeData.colorScheme.secondary.withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                width: 1,
                color: context.currentThemeData.colorScheme.secondary
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Image.asset('assets/images/google.png'),
          ),
        ),
        InkWell(
          onTap: appleTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            height: context.getDynamicHeight(7.1),
            width: context.getDynamicWidth(15),
            decoration: BoxDecoration(
              color: context.currentThemeData.colorScheme.secondary.withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                width: 1,
                color: context.currentThemeData.colorScheme.secondary
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Icon(Icons.apple),
          ),
        ),
        InkWell(
          onTap: facebookTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            height: context.getDynamicHeight(7.1),
            width: context.getDynamicWidth(15),
            decoration: BoxDecoration(
              color: context.currentThemeData.colorScheme.secondary.withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                width: 1,
                color: context.currentThemeData.colorScheme.secondary
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Icon(Icons.facebook),
          ),
        ),
      ],
    );
  }
}
