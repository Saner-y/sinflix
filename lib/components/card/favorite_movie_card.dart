part of '../components.dart';

class FavoriteMovieCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String director;

  const FavoriteMovieCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.director,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: context.getDynamicHeight(25.3),
          width: context.getDynamicWidth(38.1),
          decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(imageUrl)),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        SizedBox(height: context.getDynamicHeight(1.5)),
        Text(title, style: context.currentThemeData.textTheme.labelMedium),
        Text(director, style: context.currentThemeData.textTheme.labelSmall),
      ],
    );
  }
}
