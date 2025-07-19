part of '../core.dart';

class BaseView extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final bool hasNavbar;
  final bool isHome;

  const BaseView({
    super.key,
    this.appBar,
    this.body,
    this.hasNavbar = false,
    this.isHome = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: context.currentThemeData.colorScheme.surface,
      body: Padding(
        padding: isHome ? context.paddingZero : context.paddingMedium,
        child: body,
      ),
      bottomNavigationBar: hasNavbar ? MainNavbar() : null,
      primary: true,
      extendBodyBehindAppBar: false,
      extendBody: true,
      resizeToAvoidBottomInset: false,
    );
  }
}
