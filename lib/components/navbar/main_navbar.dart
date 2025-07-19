part of '../components.dart';

class MainNavbar extends StatelessWidget {
  const MainNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.getDynamicHeight(9),
      decoration: BoxDecoration(
        color: context.currentThemeData.colorScheme.surface,
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            context.currentThemeData.colorScheme.surface.withValues(alpha: 0.8),
            context.currentThemeData.colorScheme.surface,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.1, 0.2],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: context.getDynamicWidth(3),
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              NavbarItem(
                icon: Icon(
                  Icons.home,
                  color: context.currentThemeData.colorScheme.secondary,
                  size: 28,
                ),
                onPressed: () => context.go(RouteNames.home),
                text: 'home',
              ),
              NavbarItem(
                icon: Icon(
                  Icons.person,
                  color: context.currentThemeData.colorScheme.secondary,
                  size: 28,
                ),
                onPressed: () => context.push(RouteNames.profile),
                text: 'profile',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
