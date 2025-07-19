part of '../components.dart';

class ProfilePhotoCard extends StatelessWidget {
  final VoidCallback onPressed;
  final String? imageUrl;

  const ProfilePhotoCard({super.key, required this.onPressed, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(31),
      onTap: onPressed,
      child: Container(
        width: context.getDynamicWidth(42),
        height: context.getDynamicHeight(19.4),
        // Figma tasarımında kullanılan containerın kullanılan ekrana oranı
        decoration: BoxDecoration(
          image: imageUrl != null
              ? imageUrl!.isNotEmpty
                    ? DecorationImage(image: NetworkImage(imageUrl!))
                    : null
              : null,
          color: context.currentThemeData.colorScheme.secondary.withValues(
            alpha: 0.1,
          ),
          borderRadius: BorderRadius.circular(31),
          border: Border.all(
            color: context.currentThemeData.colorScheme.secondary.withValues(
              alpha: 0.2,
            ),
            width: 1.0,
          ),
        ),
        child: imageUrl == null
            ? Center(
                child: Icon(
                  Icons.add,
                  color: context.currentThemeData.colorScheme.secondary
                      .withValues(alpha: 0.5),
                ),
              )
            : imageUrl!.isNotEmpty
            ? null
            : Center(
                child: Icon(
                  Icons.add,
                  color: context.currentThemeData.colorScheme.secondary
                      .withValues(alpha: 0.5),
                ),
              ),
      ),
    );
  }
}
