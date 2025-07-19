part of '../../core.dart';

enum LogLevel { debug, info, warning, error, critical }

class LoggerService {
  static final LoggerService _instance = LoggerService._internal();

  factory LoggerService() => _instance;

  LoggerService._internal();

  bool _isEnabled = true;
  LogLevel _minLogLevel = LogLevel.debug;
  bool _firebaseEnabled = false;

  FirebaseCrashlytics? _crashlytics;
  FirebaseAnalytics? _analytics;

  void configure({
    bool isEnabled = true,
    LogLevel minLogLevel = LogLevel.debug,
    bool enableFirebase = false,
  }) {
    _isEnabled = isEnabled;
    _minLogLevel = minLogLevel;
    _firebaseEnabled = enableFirebase;

    if (_firebaseEnabled) {
      _initializeFirebase();
    }
  }

  void _initializeFirebase() {
    try {
      _crashlytics = FirebaseCrashlytics.instance;
      _analytics = FirebaseAnalytics.instance;

      _crashlytics?.setCrashlyticsCollectionEnabled(true);

      info('Firebase services initialized successfully', tag: 'LoggerService');
    } catch (e) {
      warning(
        'Failed to initialize Firebase services: $e',
        tag: 'LoggerService',
      );
    }
  }

  void debug(String message, {String? tag, dynamic data}) {
    _log(LogLevel.debug, message, tag: tag, data: data);
  }

  void info(String message, {String? tag, dynamic data}) {
    _log(LogLevel.info, message, tag: tag, data: data);
  }

  void warning(String message, {String? tag, dynamic data}) {
    _log(LogLevel.warning, message, tag: tag, data: data);
  }

  void error(
    String message, {
    String? tag,
    dynamic data,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.error, message, tag: tag, data: data, stackTrace: stackTrace);
  }

  void critical(
    String message, {
    String? tag,
    dynamic data,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.critical,
      message,
      tag: tag,
      data: data,
      stackTrace: stackTrace,
    );
  }

  void apiRequest({
    required String method,
    required String url,
    Map<String, dynamic>? headers,
    dynamic body,
  }) {
    if (!_shouldLog(LogLevel.debug)) return;

    final logMessage = StringBuffer();
    logMessage.writeln('🌐 API REQUEST');
    logMessage.writeln('Method: $method');
    logMessage.writeln('URL: $url');

    if (headers != null && headers.isNotEmpty) {
      logMessage.writeln('Headers: ${_formatJson(headers)}');
    }

    if (body != null) {
      logMessage.writeln('Body: ${_formatData(body)}');
    }

    _log(LogLevel.debug, logMessage.toString(), tag: 'API');
  }

  void apiResponse({
    required String method,
    required String url,
    required int statusCode,
    dynamic responseBody,
    Duration? duration,
  }) {
    final logLevel = statusCode >= 400 ? LogLevel.error : LogLevel.debug;

    if (!_shouldLog(logLevel)) return;

    final logMessage = StringBuffer();
    logMessage.writeln('📡 API RESPONSE');
    logMessage.writeln('Method: $method');
    logMessage.writeln('URL: $url');
    logMessage.writeln('Status: $statusCode');

    if (duration != null) {
      logMessage.writeln('Duration: ${duration.inMilliseconds}ms');
    }

    if (responseBody != null) {
      logMessage.writeln('Response: ${_formatData(responseBody)}');
    }

    _log(logLevel, logMessage.toString(), tag: 'API');
  }

  void navigationEvent({
    required String routeName,
    String action = 'navigate',
    Map<String, dynamic>? parameters,
  }) {
    if (!_shouldLog(LogLevel.info)) return;

    final logMessage = StringBuffer();
    logMessage.writeln('🧭 NAVIGATION');
    logMessage.writeln('Action: $action');
    logMessage.writeln('Route: $routeName');

    if (parameters != null && parameters.isNotEmpty) {
      logMessage.writeln('Parameters: ${_formatJson(parameters)}');
    }

    _log(LogLevel.info, logMessage.toString(), tag: 'NAVIGATION');
  }

  void blocEvent({
    required String blocName,
    required String eventName,
    dynamic eventData,
  }) {
    if (!_shouldLog(LogLevel.debug)) return;

    final logMessage = StringBuffer();
    logMessage.writeln('🔄 BLOC EVENT');
    logMessage.writeln('Bloc: $blocName');
    logMessage.writeln('Event: $eventName');

    if (eventData != null) {
      logMessage.writeln('Data: ${_formatData(eventData)}');
    }

    _log(LogLevel.debug, logMessage.toString(), tag: 'BLOC');
  }

  void blocState({
    required String blocName,
    required String stateName,
    dynamic stateData,
  }) {
    if (!_shouldLog(LogLevel.debug)) return;

    final logMessage = StringBuffer();
    logMessage.writeln('📋 BLOC STATE');
    logMessage.writeln('Bloc: $blocName');
    logMessage.writeln('State: $stateName');

    if (stateData != null) {
      logMessage.writeln('Data: ${_formatData(stateData)}');
    }

    _log(LogLevel.debug, logMessage.toString(), tag: 'BLOC');
  }

  void secureStorageOperation({
    required String operation,
    required String key,
    bool success = true,
    String? errorMessage,
  }) {
    final logLevel = success ? LogLevel.debug : LogLevel.error;

    if (!_shouldLog(logLevel)) return;

    final logMessage = StringBuffer();
    logMessage.writeln('🔒 SECURE STORAGE');
    logMessage.writeln('Operation: $operation');
    logMessage.writeln('Key: $key');
    logMessage.writeln('Success: $success');

    if (!success && errorMessage != null) {
      logMessage.writeln('Error: $errorMessage');
    }

    _log(logLevel, logMessage.toString(), tag: 'STORAGE');
  }

  void _log(
    LogLevel level,
    String message, {
    String? tag,
    dynamic data,
    StackTrace? stackTrace,
  }) {
    if (!_isEnabled || !_shouldLog(level)) return;

    final timestamp = DateTime.now().toIso8601String();
    final levelStr = _getLevelString(level);
    final tagStr = tag != null ? '[$tag] ' : '';

    final logMessage = StringBuffer();
    logMessage.writeln('$timestamp $levelStr $tagStr$message');

    if (data != null) {
      logMessage.writeln('Data: ${_formatData(data)}');
    }

    if (stackTrace != null) {
      logMessage.writeln('StackTrace:\n$stackTrace');
    }

    final consoleMessage = _colorizeMessage(level, logMessage.toString());
    print(consoleMessage);

    _sendToFirebase(
      level,
      message,
      tag: tag,
      data: data,
      stackTrace: stackTrace,
    );

    _writeToFile(level, logMessage.toString());
  }

  void _sendToFirebase(
    LogLevel level,
    String message, {
    String? tag,
    dynamic data,
    StackTrace? stackTrace,
  }) {
    if (!_firebaseEnabled) return;

    try {
      if (level == LogLevel.error || level == LogLevel.critical) {
        _crashlytics?.recordError(
          message,
          stackTrace,
          information: [
            'Tag: ${tag ?? 'Unknown'}',
            'Level: ${_getLevelString(level)}',
            if (data != null) 'Data: ${_formatData(data)}',
          ],
          fatal: level == LogLevel.critical,
        );
      }

      _sendAnalyticsEvent(level, message, tag: tag, data: data);

      _crashlytics?.log('${_getLevelString(level)} ${tag ?? ''}: $message');
    } catch (e) {
      print('Firebase logging error: $e');
    }
  }

  void _sendAnalyticsEvent(
    LogLevel level,
    String message, {
    String? tag,
    dynamic data,
  }) {
    if (_analytics == null) return;

    try {
      if (level == LogLevel.error || level == LogLevel.critical) {
        _analytics?.logEvent(
          name: 'app_error',
          parameters: {
            'error_level': _getLevelString(level),
            'error_message': message.length > 100
                ? message.substring(0, 100)
                : message,
            'error_tag': tag ?? 'unknown',
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          },
        );
      }
    } catch (e) {
      print('Analytics logging error: $e');
    }
  }

  bool _shouldLog(LogLevel level) {
    return level.index >= _minLogLevel.index;
  }

  String _getLevelString(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '[DEBUG]';
      case LogLevel.info:
        return '[INFO] ';
      case LogLevel.warning:
        return '[WARN] ';
      case LogLevel.error:
        return '[ERROR]';
      case LogLevel.critical:
        return '[CRIT] ';
    }
  }

  String _colorizeMessage(LogLevel level, String message) {
    const reset = '\x1B[0m';

    String colorCode;
    switch (level) {
      case LogLevel.debug:
        colorCode = '\x1B[37m';
        break;
      case LogLevel.info:
        colorCode = '\x1B[36m';
        break;
      case LogLevel.warning:
        colorCode = '\x1B[33m';
        break;
      case LogLevel.error:
        colorCode = '\x1B[31m';
        break;
      case LogLevel.critical:
        colorCode = '\x1B[35m';
        break;
    }

    return '$colorCode$message$reset';
  }

  String _formatData(dynamic data) {
    if (data == null) return 'null';

    try {
      if (data is String) return data;
      if (data is Map || data is List) {
        return _formatJson(data);
      }
      return data.toString();
    } catch (e) {
      return 'Error formatting data: $e';
    }
  }

  String _formatJson(dynamic json) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(json);
    } catch (e) {
      return json.toString();
    }
  }

  void _writeToFile(LogLevel level, String message) {
    // Bu kısım gelecekte dosyaya log yazma, log rotation gibi özellikler için kullanılabilir
  }

  void setUserId(String userId) {
    if (!_firebaseEnabled) return;

    try {
      _crashlytics?.setUserIdentifier(userId);
      info('User ID set for Crashlytics: $userId', tag: 'LoggerService');
    } catch (e) {
      warning('Failed to set user ID: $e', tag: 'LoggerService');
    }
  }

  void setCustomKey(String key, dynamic value) {
    if (!_firebaseEnabled) return;

    try {
      if (value is String) {
        _crashlytics?.setCustomKey(key, value);
      } else if (value is int) {
        _crashlytics?.setCustomKey(key, value);
      } else if (value is double) {
        _crashlytics?.setCustomKey(key, value);
      } else if (value is bool) {
        _crashlytics?.setCustomKey(key, value);
      } else {
        _crashlytics?.setCustomKey(key, value.toString());
      }

      debug('Custom key set: $key = $value', tag: 'LoggerService');
    } catch (e) {
      warning('Failed to set custom key: $e', tag: 'LoggerService');
    }
  }

  void logScreenView({required String screenName, String? screenClass}) {
    if (!_firebaseEnabled) return;

    try {
      _analytics?.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );

      info('Screen view logged: $screenName', tag: 'Analytics');
    } catch (e) {
      warning('Failed to log screen view: $e', tag: 'Analytics');
    }
  }

  void logLogin({String? method}) {
    if (!_firebaseEnabled) return;

    try {
      _analytics?.logLogin(loginMethod: method);
      info('Login event logged', tag: 'Analytics', data: {'method': method});
    } catch (e) {
      warning('Failed to log login event: $e', tag: 'Analytics');
    }
  }

  void logSignUp({String? method}) {
    if (!_firebaseEnabled) return;

    try {
      _analytics?.logSignUp(signUpMethod: method ?? 'unknown');
      info('Sign up event logged', tag: 'Analytics', data: {'method': method});
    } catch (e) {
      warning('Failed to log sign up event: $e', tag: 'Analytics');
    }
  }

  void logCustomEvent({
    required String eventName,
    Map<String, Object>? parameters,
  }) {
    if (!_firebaseEnabled) return;

    try {
      _analytics?.logEvent(name: eventName, parameters: parameters);
      info(
        'Custom event logged: $eventName',
        tag: 'Analytics',
        data: parameters,
      );
    } catch (e) {
      warning('Failed to log custom event: $e', tag: 'Analytics');
    }
  }
}

extension LoggerExtension on Object {
  void logDebug(String message, {String? tag, dynamic data}) {
    LoggerService().debug(
      message,
      tag: tag ?? runtimeType.toString(),
      data: data,
    );
  }

  void logInfo(String message, {String? tag, dynamic data}) {
    LoggerService().info(
      message,
      tag: tag ?? runtimeType.toString(),
      data: data,
    );
  }

  void logWarning(String message, {String? tag, dynamic data}) {
    LoggerService().warning(
      message,
      tag: tag ?? runtimeType.toString(),
      data: data,
    );
  }

  void logError(
    String message, {
    String? tag,
    dynamic data,
    StackTrace? stackTrace,
  }) {
    LoggerService().error(
      message,
      tag: tag ?? runtimeType.toString(),
      data: data,
      stackTrace: stackTrace,
    );
  }

  void logCritical(
    String message, {
    String? tag,
    dynamic data,
    StackTrace? stackTrace,
  }) {
    LoggerService().critical(
      message,
      tag: tag ?? runtimeType.toString(),
      data: data,
      stackTrace: stackTrace,
    );
  }
}
