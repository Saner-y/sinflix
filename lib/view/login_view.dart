part of 'view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _logger = locator<LoggerService>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _logger.info('LoginView initialized', tag: 'LoginView');
    _logger.logScreenView(screenName: 'login_screen', screenClass: 'LoginView');
  }

  @override
  void dispose() {
    _logger.info('LoginView disposed', tag: 'LoginView');
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            MainSnackBar.showMainSnackBar(
              context,
              state.errorMessage,
              context.currentThemeData.colorScheme.error,
            );
          } else if (state is LoginSuccess) {
            context.go(RouteNames.home);
          }
        },
        builder: (context, state) => BaseView(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: null,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                context.tr(AppStrings.greetings),
                style: context.currentThemeData.textTheme.bodyLarge,
              ),
              SizedBox(height: context.getDynamicHeight(8)),
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
                isVisible: context.read<LoginBloc>().isPasswordVisible,
                onVisibilityToggle: () {
                  context.read<LoginBloc>().add(
                    TogglePasswordVisibilityEvent(),
                  );
                },
              ),
              SizedBox(height: context.getDynamicHeight(2)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.all<Color>(
                        context.currentThemeData.colorScheme.secondary
                            .withValues(alpha: 0.1),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      context.tr(AppStrings.forgotPassword),
                      style: context.currentThemeData.textTheme.labelMedium
                          ?.copyWith(decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.getDynamicHeight(2)),
              MainButton(
                onPressed: () {
                  context.read<LoginBloc>().add(
                    LoginRequestEvent(
                      email: _emailController.text,
                      password: _passwordController.text,
                    ),
                  );
                },
                text: AppStrings.login,
              ),
              SizedBox(height: context.getDynamicHeight(4)),
              SocialLoginButtons(
                googleTap: () {
                  // context.read<LoginBloc>().add(GoogleSignInEvent());  // temsili kodlar
                },
                appleTap: () {
                  // context.read<LoginBloc>().add(AppleSignInEvent());  // temsili kodlar
                },
                facebookTap: () {
                  // context.read<LoginBloc>().add(FacebookSignInEvent());  // temsili kodlar
                },
              ),
              SizedBox(height: context.getDynamicHeight(2)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.tr(AppStrings.dontHaveAccount),
                    style: context.currentThemeData.textTheme.labelMedium
                        ?.copyWith(
                          color: context.currentThemeData.colorScheme.secondary
                              .withValues(alpha: 0.5),
                        ),
                  ),
                  TextButton(
                    onPressed: () => context.push(RouteNames.register),
                    child: Text(
                      context.tr(AppStrings.register),
                      style: context.currentThemeData.textTheme.labelMedium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
