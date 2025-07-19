part of '../components.dart';

class FavoriteButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isFavorite;

  const FavoriteButton({
    super.key,
    required this.onPressed,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(82),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 7.5, sigmaY: 7.5),
        child: InkWell(
          borderRadius: BorderRadius.circular(82),
          onTap: onPressed,
          child: Container(
            height: context.getDynamicHeight(8.5),
            width: context.getDynamicWidth(12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(82),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.favorite,
              color: isFavorite ? AppColors.primary : AppColors.secondary,
            ),
          ),
        ),
      ),
    );
  }
}
