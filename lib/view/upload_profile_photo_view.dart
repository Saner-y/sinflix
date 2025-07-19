part of 'view.dart';

class UploadProfilePhotoView extends StatelessWidget {
  const UploadProfilePhotoView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = ProfileBloc();
        bloc.add(LoadProfileData());
        return bloc;
      },
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            MainSnackBar.showMainSnackBar(
              context,
              state.errorMessage,
              context.currentThemeData.colorScheme.error,
            );
          }
        },
        builder: (context, state) => BaseView(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text(
              context.tr(AppStrings.profileDetail),
              style: context.currentThemeData.textTheme.bodyMedium,
            ),
            backgroundColor: Colors.transparent,
            leading: CustomIconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            leadingWidth: context.getDynamicWidth(20),
            actions: [
              CustomIconButton(
                icon: Icon(Icons.language_outlined),
                onPressed: () {
                  context.read<LanguageCubit>().changeLanguage(
                    context.locale.languageCode == 'tr' ? 'en' : 'tr',
                  );
                },
              ),
              SizedBox(width: context.getDynamicWidth(3)),
            ],
          ),
          body: Column(
            children: [
              Text(
                context.tr(AppStrings.uploadYourPhoto),
                style: context.currentThemeData.textTheme.bodyLarge,
              ),
              SizedBox(height: context.getDynamicHeight(8)),
              ProfilePhotoCard(
                onPressed: () {
                  context.read<ProfileBloc>().add(UploadProfilePhotoEvent());
                },
                imageUrl: context.read<ProfileBloc>().imageUrl,
              ),
              Spacer(),
              MainButton(
                onPressed: context.read<ProfileBloc>().imageUrl.isNotEmpty
                    ? () => context.go(RouteNames.home)
                    : null,
                text: AppStrings.continueText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
