part of '../components.dart';

class PackageCard extends StatelessWidget {
  final Color gradientColor;
  final String discountPercent;
  final String mainJeton;
  final String bonusJeton;
  final String price;

  const PackageCard({
    super.key,
    required this.gradientColor,
    required this.discountPercent,
    required this.mainJeton,
    required this.bonusJeton,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Paket seçildiğinde yapılacak işlemler
      },
      child: SizedBox(
        width: context.getDynamicWidth(27.8),
        height: context.getDynamicHeight(29),
        child: Stack(
          children: [
            Positioned(
              top: context.getDynamicHeight(1.5),
              child: Container(
                width: context.getDynamicWidth(27.8),
                height: context.getDynamicHeight(25.8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.4),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  gradient: RadialGradient(
                    colors: [gradientColor, AppColors.primary],
                    stops: [0.2, 1],
                    center: Alignment.topLeft,
                    radius: 1.5,
                    tileMode: TileMode.clamp,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withValues(alpha: 1),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: AppColors.primaryGradient,
                      spreadRadius: 0,
                      blurRadius: 15,
                      offset: Offset(4, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: context.paddingLow,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Spacer(flex: 4),
                      Expanded(
                        flex: 10,
                        child: Column(
                          children: [
                            Text(
                              context.tr(mainJeton),
                              style: context
                                  .currentThemeData
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                  ),
                            ),
                            Text(
                              context.tr(bonusJeton),
                              style: context
                                  .currentThemeData
                                  .textTheme
                                  .headlineLarge,
                            ),
                            Text(
                              context.tr(AppStrings.jeton),
                              style: context
                                  .currentThemeData
                                  .textTheme
                                  .headlineSmall,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            Divider(),
                            Text(
                              context.tr(price),
                              style: context
                                  .currentThemeData
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                            Text(
                              context.tr(AppStrings.perWeek),
                              style: context
                                  .currentThemeData
                                  .textTheme
                                  .labelMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left:
                  (context.getDynamicWidth(27.8) -
                      context.getDynamicWidth(15.2)) /
                  2,
              child: Container(
                width: context.getDynamicWidth(15.2),
                height: context.getDynamicHeight(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: AppColors.secondary),
                    BoxShadow(
                      color: gradientColor,
                      spreadRadius: -0,
                      blurRadius: 8.33,
                    ),
                  ],
                ),
                child: Center(child: Text(context.tr(discountPercent))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
