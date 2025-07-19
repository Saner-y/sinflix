part of '../components.dart';

class BonusImageCard extends StatelessWidget {
  final String assetPath;
  final String title;
  const BonusImageCard({super.key, required this.assetPath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: context.getDynamicWidth(13.6),
          height: context.getDynamicHeight(6.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              const BoxShadow(
                color: Colors.white,
              ),
              const BoxShadow(
                color: AppColors.primaryGradient,
                spreadRadius: -0,
                blurRadius: 8.33,
              ),
            ],
          ),
          child: Image.asset(assetPath),
        ),
        SizedBox(height: context.getDynamicHeight(1.5)),
        SizedBox(          width: context.getDynamicWidth(18.6),

          child: Text(
            context.tr(title),
            style: context.currentThemeData.textTheme.labelMedium,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}