import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../core/constants/app_strings.dart';
import '../../core/core.dart';
import '../../data/data.dart';
import '../../data/user/register/register_response.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final registerRepository = locator<RegisterRepository>();
  final _logger = locator<LoggerService>();
  final _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterRequestEvent>(_onRegister);
    on<RegisterGoogleSignInEvent>(_onGoogleSignIn);
    on<RegisterAppleSignInEvent>(_onAppleSignIn);
    on<RegisterFacebookSignInEvent>(_onFacebookSignIn);
    on<ToggleRegisterPasswordVisibilityEvent>(_onTogglePasswordVisibility);
    on<ToggleConfirmPasswordVisibilityEvent>(
      _onToggleConfirmPasswordVisibility,
    );
    on<ResetRegisterEvent>(_onResetRegister);
  }

  Future<void> _onRegister(
    RegisterRequestEvent event,
    Emitter<RegisterState> emit,
  ) async {
    _logger.blocEvent(blocName: 'RegisterBloc', eventName: 'RegisterRequested');

    if (event.request.name.isEmpty) {
      _handleRegisterFailure(
        emit,
        AppStrings.validationNameEmpty,
        event.request.email,
      );
      return;
    }

    if (!AuthHelper.isValidEmail(event.request.email)) {
      _handleRegisterFailure(
        emit,
        AppStrings.validationEmailInvalid,
        event.request.email,
      );
      return;
    }

    if (event.request.password.isEmpty) {
      _handleRegisterFailure(
        emit,
        AppStrings.validationPasswordEmpty,
        event.request.email,
      );
      return;
    }

    if (!AuthHelper.isValidPassword(event.request.password)) {
      _handleRegisterFailure(
        emit,
        AppStrings.validationPasswordTooShort,
        event.request.email,
      );
      return;
    }

    if (event.request.password != event.confirmPassword) {
      _handleRegisterFailure(
        emit,
        AppStrings.validationPasswordsNotMatch,
        event.request.email,
      );
      return;
    }

    emit(RegisterLoading());
    _logger.blocState(blocName: 'RegisterBloc', stateName: 'RegisterLoading');

    try {
      final response = await registerRepository.register(
        request: event.request,
      );

      if (!response.isSuccess) {
        final errorMessage = response.error?.message ?? AppStrings.unknownError;
        _handleRegisterFailure(emit, errorMessage, event.request.email);
        return;
      }
      final registerData = response.data;
      if (registerData == null || !registerData.isSuccess) {
        final errorMessage =
            registerData?.errorMessage ?? AppStrings.registerFailed;
        _handleRegisterFailure(emit, errorMessage, event.request.email);
      }

      await _handleRegisterSuccess(emit, registerData!, event.request.email);
    } catch (e) {
      _logger.error(
        'Registration failed with exception',
        tag: 'RegisterBloc',
        data: {'error': e.toString()},
      );
      _handleRegisterFailure(
        emit,
        AppStrings.registerNetworkError,
        event.request.email,
      );
    }
  }

  Future<void> _handleRegisterSuccess(
    Emitter<RegisterState> emit,
    RegisterResponse registerData,
    String email,
  ) async {
    await AuthHelper.handleAuthSuccess(
      token: registerData.token,
      userId: registerData.data?.id,
      email: email,
      method: 'email',
      authType: 'register',
    );

    emit(RegisterSuccess());
    _logger.blocState(blocName: 'RegisterBloc', stateName: 'RegisterSuccess');
  }

  void _handleRegisterFailure(
    Emitter<RegisterState> emit,
    String errorMessage,
    String email,
  ) {
    emit(RegisterFailure(errorMessage));

    AuthHelper.logAuthFailure(
      errorMessage: errorMessage,
      email: email,
      authType: 'register',
      blocName: 'RegisterBloc',
    );

    add(ResetRegisterEvent());
  }

  Future<void> _onGoogleSignIn(
    RegisterGoogleSignInEvent event,
    Emitter<RegisterState> emit,
  ) async {
    _logger.blocEvent(
      blocName: 'RegisterBloc',
      eventName: 'GoogleSignInRequested',
    );

    emit(RegisterLoading());
    _logger.blocState(
      blocName: 'RegisterBloc',
      stateName: 'RegisterLoading (Google)',
    );

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        _handleRegisterFailure(emit, AppStrings.googleSignInCancelled, '');
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
        await _handleSocialRegisterSuccess(
          emit,
          userCredential.user!,
          'google',
        );
      } else {
        _handleRegisterFailure(emit, AppStrings.googleSignInFailed, '');
      }
    } catch (e) {
      _logger.error(
        'Google sign in failed with exception',
        tag: 'RegisterBloc',
        data: {'error': e.toString()},
      );
      _handleRegisterFailure(emit, AppStrings.socialSignInNetworkError, '');
    }
  }

  Future<void> _onAppleSignIn(
    RegisterAppleSignInEvent event,
    Emitter<RegisterState> emit,
  ) async {
    _logger.blocEvent(
      blocName: 'RegisterBloc',
      eventName: 'AppleSignInRequested',
    );

    emit(RegisterLoading());
    _logger.blocState(
      blocName: 'RegisterBloc',
      stateName: 'RegisterLoading (Apple)',
    );

    try {
      if (!await SignInWithApple.isAvailable()) {
        _handleRegisterFailure(emit, AppStrings.appleSignInFailed, '');
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
        await _handleSocialRegisterSuccess(emit, userCredential.user!, 'apple');
      } else {
        _handleRegisterFailure(emit, AppStrings.appleSignInFailed, '');
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        _handleRegisterFailure(emit, AppStrings.appleSignInCancelled, '');
      } else {
        _logger.error(
          'Apple sign in failed with authorization exception',
          tag: 'RegisterBloc',
          data: {'error': e.toString()},
        );
        _handleRegisterFailure(emit, AppStrings.appleSignInFailed, '');
      }
    } catch (e) {
      _logger.error(
        'Apple sign in failed with exception',
        tag: 'RegisterBloc',
        data: {'error': e.toString()},
      );
      _handleRegisterFailure(emit, AppStrings.socialSignInNetworkError, '');
    }
  }

  Future<void> _onFacebookSignIn(
    RegisterFacebookSignInEvent event,
    Emitter<RegisterState> emit,
  ) async {
    _logger.blocEvent(
      blocName: 'RegisterBloc',
      eventName: 'FacebookSignInRequested',
    );

    emit(RegisterLoading());
    _logger.blocState(
      blocName: 'RegisterBloc',
      stateName: 'RegisterLoading (Facebook)',
    );

    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.cancelled) {
        _handleRegisterFailure(emit, AppStrings.facebookSignInCancelled, '');
        return;
      }

      if (result.status != LoginStatus.success || result.accessToken == null) {
        _handleRegisterFailure(emit, AppStrings.facebookSignInFailed, '');
        return;
      }

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken!.tokenString);

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(facebookAuthCredential);

      if (userCredential.user != null) {
        await _handleSocialRegisterSuccess(
          emit,
          userCredential.user!,
          'facebook',
        );
      } else {
        _handleRegisterFailure(emit, AppStrings.facebookSignInFailed, '');
      }
    } catch (e) {
      _logger.error(
        'Facebook sign in failed with exception',
        tag: 'RegisterBloc',
        data: {'error': e.toString()},
      );
      _handleRegisterFailure(emit, AppStrings.socialSignInNetworkError, '');
    }
  }

  Future<void> _handleSocialRegisterSuccess(
    Emitter<RegisterState> emit,
    User firebaseUser,
    String method,
  ) async {
    await AuthHelper.handleSocialAuthSuccess(
      firebaseUser: firebaseUser,
      method: method,
      authType: 'register',
    );

    emit(RegisterSuccess());
    _logger.blocState(
      blocName: 'RegisterBloc',
      stateName: 'RegisterSuccess ($method)',
    );
  }

  void _onTogglePasswordVisibility(
    ToggleRegisterPasswordVisibilityEvent event,
    Emitter<RegisterState> emit,
  ) {
    isPasswordVisible = !isPasswordVisible;
    emit(RegisterPasswordVisibilityChanged(isPasswordVisible));
  }

  void _onToggleConfirmPasswordVisibility(
    ToggleConfirmPasswordVisibilityEvent event,
    Emitter<RegisterState> emit,
  ) {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    emit(RegisterConfirmPasswordVisibilityChanged(isConfirmPasswordVisible));
  }

  void _onResetRegister(ResetRegisterEvent event, Emitter<RegisterState> emit) {
    emit(RegisterInitial());
  }
}
