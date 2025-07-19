part of 'view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late TextEditingController _nameSurnameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  final _logger = locator<LoggerService>();

  @override
  void initState() {
    super.initState();
    _nameSurnameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _logger.info('LoginView initialized', tag: 'LoginView');
    _logger.logScreenView(screenName: 'login_screen', screenClass: 'LoginView');
  }

  @override
  void dispose() {
    _logger.info('LoginView disposed', tag: 'LoginView');
    _nameSurnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(),
      child: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterFailure) {
            MainSnackBar.showMainSnackBar(
              context,
              state.errorMessage,
              context.currentThemeData.colorScheme.error,
            );
          } else if (state is RegisterSuccess) {
            context.push(RouteNames.uploadProfileImage);
          }
        },
        builder: (context, state) => BaseView(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: CustomIconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            leadingWidth: context.getDynamicWidth(20),
            scrolledUnderElevation: 0,
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
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    kToolbarHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    SizedBox(height: context.getDynamicHeight(3)),
                    Text(
                      context.tr(AppStrings.welcome),
                      style: context.currentThemeData.textTheme.bodyLarge,
                    ),
                    SizedBox(height: context.getDynamicHeight(8)),
                    MainInput(
                      hintText: AppStrings.nameSurname,
                      prefixIcon: Icon(Icons.person_add_alt_outlined),
                      controller: _nameSurnameController,
                    ),
                    SizedBox(height: context.getDynamicHeight(2)),
                    MainInput(
                      hintText: AppStrings.email,
                      prefixIcon: Icon(Icons.mail_outline_rounded),
                      controller: _emailController,
                    ),
                    SizedBox(height: context.getDynamicHeight(2)),
                    MainInput(
                      hintText: AppStrings.password,
                      prefixIcon: Icon(Icons.lock_open_rounded),
                      controller: _passwordController,
                      isPassword: true,
                      isVisible: context.read<RegisterBloc>().isPasswordVisible,
                      onVisibilityToggle: () {
                        context.read<RegisterBloc>().add(
                          ToggleRegisterPasswordVisibilityEvent(),
                        );
                      },
                    ),
                    SizedBox(height: context.getDynamicHeight(2)),
                    MainInput(
                      hintText: AppStrings.passwordAgain,
                      prefixIcon: Icon(Icons.lock_open_rounded),
                      controller: _confirmPasswordController,
                      isPassword: true,
                      isVisible: context
                          .read<RegisterBloc>()
                          .isConfirmPasswordVisible,
                      onVisibilityToggle: () {
                        context.read<RegisterBloc>().add(
                          ToggleConfirmPasswordVisibilityEvent(),
                        );
                      },
                    ),
                    SizedBox(height: context.getDynamicHeight(2)),
                    context.trRichText(
                      AppStrings.agreeTerms,
                      defaultStyle: context
                          .currentThemeData
                          .textTheme
                          .labelMedium
                          ?.copyWith(
                            color: context
                                .currentThemeData
                                .colorScheme
                                .secondary
                                .withValues(alpha: 0.5),
                          ),
                      underlineStyle:
                          context.currentThemeData.textTheme.labelMedium,
                    ),
                    SizedBox(height: context.getDynamicHeight(6)),
                    MainButton(
                      onPressed: () {
                        context.read<RegisterBloc>().add(
                          RegisterRequestEvent(
                            request: RegisterRequest(
                              email: _emailController.text,
                              name: _nameSurnameController.text,
                              password: _passwordController.text,
                            ),
                            confirmPassword: _confirmPasswordController.text,
                          ),
                        );
                      },
                      text: AppStrings.registerNow,
                    ),
                    SizedBox(height: context.getDynamicHeight(4)),
                    SocialLoginButtons(
                      googleTap: () {
                        // context.read<RegisterBloc>().add(RegisterGoogleSignInEvent()); // temsili kodlar
                      },
                      appleTap: () {
                        // context.read<RegisterBloc>().add(RegisterAppleSignInEvent()); // temsili kodlar
                      },
                      facebookTap: () {
                        // context.read<RegisterBloc>().add(RegisterFacebookSignInEvent()); // temsili kodlar
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.tr(AppStrings.alreadyHaveAccount),
                          style: context.currentThemeData.textTheme.labelMedium
                              ?.copyWith(
                                color: context
                                    .currentThemeData
                                    .colorScheme
                                    .secondary
                                    .withValues(alpha: 0.5),
                              ),
                        ),
                        TextButton(
                          onPressed: () => context.go(RouteNames.login),
                          child: Text(
                            context.tr(AppStrings.login),
                            style:
                                context.currentThemeData.textTheme.labelMedium,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.getDynamicHeight(2)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
