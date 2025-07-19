import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sinflix/core/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../../core/constants/app_strings.dart';
import '../../data/data.dart';
import '../../data/user/login/login_request.dart';
import '../../data/user/login/login_response.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final loginRepository = locator<LoginRepository>();
  final _logger = locator<LoggerService>();
  final _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  bool isPasswordVisible = false;

  LoginBloc() : super(LoginInitial()) {
    on<LoginRequestEvent>(_onLogin);
    on<GoogleSignInEvent>(_onGoogleSignIn);
    on<AppleSignInEvent>(_onAppleSignIn);
    on<FacebookSignInEvent>(_onFacebookSignIn);
    on<TogglePasswordVisibilityEvent>(_onTogglePasswordVisibility);
    on<ResetStateEvent>((event, emit) {
      emit(LoginInitial());
      _logger.blocState(
        blocName: 'LoginBloc',
        stateName: 'LoginInitial (Reset)',
      );
    });

    _logger.blocEvent(blocName: 'LoginBloc', eventName: 'Initialized');
  }

  Future<void> _onLogin(
    LoginRequestEvent event,
    Emitter<LoginState> emit,
  ) async {
    _logger.blocEvent(
      blocName: 'LoginBloc',
      eventName: 'LoginRequested',
      eventData: {
        'email': event.email,
        'hasPassword': event.password.isNotEmpty,
      },
    );

    print('Attempting login with email: ${event.email}');
    print(
      'Attempting login with password: ${event.password.isNotEmpty ? '******' : 'empty'}',
    );
    if (!event.email.isValidEmail) {
      _handleLoginFailure(emit, AppStrings.validationEmailInvalid, event.email);
      return;
    }

    if (event.password.isEmpty) {
      _handleLoginFailure(
        emit,
        AppStrings.validationPasswordEmpty,
        event.email,
      );
      return;
    }

    if (event.password.length < 6) {
      _handleLoginFailure(
        emit,
        AppStrings.validationPasswordTooShort,
        event.email,
      );
      return;
    }

    emit(LoginLoading());
    _logger.blocState(blocName: 'LoginBloc', stateName: 'LoginLoading');

    try {
      final request = LoginRequest(
        email: event.email,
        password: event.password,
      );

      final response = await loginRepository.login(request: request);

      if (!response.isSuccess) {
        final errorMessage = response.error?.message ?? AppStrings.unknownError;
        _handleLoginFailure(emit, errorMessage, event.email);
        return;
      }

      final loginData = response.data;
      if (loginData == null || !loginData.isSuccess) {
        final errorMessage = loginData?.errorMessage ?? AppStrings.loginFailed;
        _handleLoginFailure(emit, errorMessage, event.email);
        return;
      }

      await _handleLoginSuccess(emit, loginData, event.email);
    } catch (e) {
      _logger.error(
        'Login failed with exception',
        tag: 'LoginBloc',
        data: {'error': e.toString()},
      );
      _handleLoginFailure(emit, AppStrings.loginNetworkError, event.email);
    }
  }

  void _onTogglePasswordVisibility(
    TogglePasswordVisibilityEvent event,
    Emitter<LoginState> emit,
  ) {
    isPasswordVisible = !isPasswordVisible;
    emit(ToggleVisibilityState());
    add(ResetStateEvent());
  }

  Future<void> _handleLoginSuccess(
    Emitter<LoginState> emit,
    LoginResponse loginData,
    String email,
  ) async {
    await AuthHelper.handleAuthSuccess(
      token: loginData.token,
      userId: loginData.data?.id,
      email: email,
      method: 'email',
      authType: 'login',
    );

    emit(LoginSuccess());
    _logger.blocState(blocName: 'LoginBloc', stateName: 'LoginSuccess');
  }

  void _handleLoginFailure(
    Emitter<LoginState> emit,
    String errorMessage,
    String email,
  ) {
    emit(LoginFailure(errorMessage));

    AuthHelper.logAuthFailure(
      errorMessage: errorMessage,
      email: email,
      authType: 'login',
      blocName: 'LoginBloc',
    );

    add(ResetStateEvent());
  }

  Future<void> _onGoogleSignIn(
    GoogleSignInEvent event,
    Emitter<LoginState> emit,
  ) async {
    _logger.blocEvent(
      blocName: 'LoginBloc',
      eventName: 'GoogleSignInRequested',
    );

    emit(LoginLoading());
    _logger.blocState(
      blocName: 'LoginBloc',
      stateName: 'LoginLoading (Google)',
    );

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        _handleLoginFailure(emit, AppStrings.googleSignInCancelled, '');
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      if (userCredential.user != null) {
        await _handleSocialLoginSuccess(emit, userCredential.user!, 'google');
      } else {
        _handleLoginFailure(emit, AppStrings.googleSignInFailed, '');
      }
    } catch (e) {
      _logger.error(
        'Google sign in failed with exception',
        tag: 'LoginBloc',
        data: {'error': e.toString()},
      );
      _handleLoginFailure(emit, AppStrings.socialSignInNetworkError, '');
    }
  }

  Future<void> _onAppleSignIn(
    //Temsili login fonksiyonu baglantilar yuzde yuz yapilmadi
    AppleSignInEvent event,
    Emitter<LoginState> emit,
  ) async {
    _logger.blocEvent(blocName: 'LoginBloc', eventName: 'AppleSignInRequested');

    emit(LoginLoading());
    _logger.blocState(blocName: 'LoginBloc', stateName: 'LoginLoading (Apple)');

    try {
      if (!await SignInWithApple.isAvailable()) {
        _handleLoginFailure(emit, AppStrings.appleSignInFailed, '');
        return;
      }

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(oauthCredential);

      if (userCredential.user != null) {
        await _handleSocialLoginSuccess(emit, userCredential.user!, 'apple');
      } else {
        _handleLoginFailure(emit, AppStrings.appleSignInFailed, '');
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        _handleLoginFailure(emit, AppStrings.appleSignInCancelled, '');
      } else {
        _logger.error(
          'Apple sign in failed with authorization exception',
          tag: 'LoginBloc',
          data: {'error': e.toString()},
        );
        _handleLoginFailure(emit, AppStrings.appleSignInFailed, '');
      }
    } catch (e) {
      _logger.error(
        'Apple sign in failed with exception',
        tag: 'LoginBloc',
        data: {'error': e.toString()},
      );
      _handleLoginFailure(emit, AppStrings.socialSignInNetworkError, '');
    }
  }

  Future<void> _onFacebookSignIn(
    //Temsili login fonksiyonu baglantilar yuzde yuz yapilmadi
    FacebookSignInEvent event,
    Emitter<LoginState> emit,
  ) async {
    _logger.blocEvent(
      blocName: 'LoginBloc',
      eventName: 'FacebookSignInRequested',
    );

    emit(LoginLoading());
    _logger.blocState(
      blocName: 'LoginBloc',
      stateName: 'LoginLoading (Facebook)',
    );

    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.cancelled) {
        _handleLoginFailure(emit, AppStrings.facebookSignInCancelled, '');
        return;
      }

      if (result.status != LoginStatus.success || result.accessToken == null) {
        _handleLoginFailure(emit, AppStrings.facebookSignInFailed, '');
        return;
      }

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken!.tokenString);

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(facebookAuthCredential);

      if (userCredential.user != null) {
        await _handleSocialLoginSuccess(emit, userCredential.user!, 'facebook');
      } else {
        _handleLoginFailure(emit, AppStrings.facebookSignInFailed, '');
      }
    } catch (e) {
      _logger.error(
        'Facebook sign in failed with exception',
        tag: 'LoginBloc',
        data: {'error': e.toString()},
      );
      _handleLoginFailure(emit, AppStrings.socialSignInNetworkError, '');
    }
  }

  Future<void> _handleSocialLoginSuccess(
    Emitter<LoginState> emit,
    User firebaseUser,
    String method,
  ) async {
    await AuthHelper.handleSocialAuthSuccess(
      firebaseUser: firebaseUser,
      method: method,
      authType: 'login',
    );

    emit(LoginSuccess());
    _logger.blocState(
      blocName: 'LoginBloc',
      stateName: 'LoginSuccess ($method)',
    );
  }
}
