part of 'view.dart';

class LimitedOfferView extends StatelessWidget {
  const LimitedOfferView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.getDynamicHeight(80),
      child: Stack(
        children: [
          Container(
            height: context.height,
            width: context.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
              gradient: RadialGradient(
                colors: [
                  context.currentThemeData.colorScheme.primary,
                  Colors.transparent,
                ],
                radius: 0.75,
                center: Alignment.topCenter,
              ),
            ),
          ),
          Container(
            height: context.height,
            width: context.width,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  context.currentThemeData.colorScheme.primary,
                  Colors.transparent,
                ],
                radius: 0.75,
                center: Alignment.bottomCenter,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
              child: SizedBox(
                height: context.height,
                width: context.width,
                child: Padding(
                  padding: context.paddingLow,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: context.getDynamicHeight(2)),
                      Text(
                        context.tr(AppStrings.limitedOffer),
                        style:
                            context.currentThemeData.textTheme.headlineMedium,
                      ),
                      SizedBox(height: context.getDynamicHeight(1)),
                      SizedBox(
                        width: context.getDynamicWidth(60),
                        child: Text(
                          context.tr(AppStrings.limitedOfferDescription),
                          style: context.currentThemeData.textTheme.labelMedium,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(height: context.getDynamicHeight(3)),
                      Container(
                        height: context.getDynamicHeight(20),
                        width: context.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: RadialGradient(
                            colors: [
                              context.currentThemeData.colorScheme.secondary
                                  .withValues(alpha: 0.1),
                              context.currentThemeData.colorScheme.secondary
                                  .withValues(alpha: 0.03),
                            ],
                            radius: 1,
                            center: Alignment.center,
                          ),
                          border: Border.all(
                            color: context
                                .currentThemeData
                                .colorScheme
                                .secondary
                                .withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              context.tr(AppStrings.bonusesYouGet),
                              style:
                                  context.currentThemeData.textTheme.bodyMedium,
                            ),
                            SizedBox(height: context.getDynamicHeight(1)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: context.getDynamicWidth(5),
                              children: [
                                BonusImageCard(
                                  assetPath:
                                      'assets/images/premium_account.png',
                                  title: AppStrings.premiumAccount,
                                ),
                                BonusImageCard(
                                  assetPath: 'assets/images/more_matches.png',
                                  title: AppStrings.moreMatches,
                                ),
                                BonusImageCard(
                                  assetPath: 'assets/images/highlight.png',
                                  title: AppStrings.highlight,
                                ),
                                BonusImageCard(
                                  assetPath: 'assets/images/more_likes.png',
                                  title: AppStrings.moreLikes,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: context.getDynamicHeight(3)),
                      Text(
                        context.tr(AppStrings.choosePackageToUnlock),
                        style: context.currentThemeData.textTheme.bodyMedium,
                      ),
                      SizedBox(height: context.getDynamicHeight(3)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: context.getDynamicWidth(5),
                        children: [
                          PackageCard(
                            gradientColor: AppColors.primaryGradient,
                            discountPercent: AppStrings.firstPackagePercent,
                            mainJeton: AppStrings.firstPackageMainJeton,
                            bonusJeton: AppStrings.firstPackageBonusJeton,
                            price: AppStrings.firstPackagePrice,
                          ),
                          PackageCard(
                            gradientColor: AppColors.secondaryGradient,
                            discountPercent: AppStrings.secondPackagePercent,
                            mainJeton: AppStrings.secondPackageMainJeton,
                            bonusJeton: AppStrings.secondPackageBonusJeton,
                            price: AppStrings.secondPackagePrice,
                          ),
                          PackageCard(
                            gradientColor: AppColors.primaryGradient,
                            discountPercent: AppStrings.thirdPackagePercent,
                            mainJeton: AppStrings.thirdPackageMainJeton,
                            bonusJeton: AppStrings.thirdPackageBonusJeton,
                            price: AppStrings.thirdPackagePrice,
                          ),
                        ],
                      ),
                      SizedBox(height: context.getDynamicHeight(1)),
                      Expanded(
                        child: MainButton(text: AppStrings.seeAllJetons),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
