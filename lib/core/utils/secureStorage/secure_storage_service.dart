part of '../../core.dart';

class SecureStorageService {
  static const String _tokenKey = 'auth_token';

  final FlutterSecureStorage _secureStorage;
  final _logger = locator<LoggerService>();
  String? _tokenCache;

  SecureStorageService(this._secureStorage);

  Future<void> saveToken(String token) async {
    try {
      if (token.isEmpty) {
        throw ArgumentError('Token cannot be empty');
      }
      await _secureStorage.write(key: _tokenKey, value: token);
      _tokenCache = token;

      _logger.secureStorageOperation(
        operation: 'SAVE',
        key: _tokenKey,
        success: true,
      );
    } catch (e) {
      _logger.secureStorageOperation(
        operation: 'SAVE',
        key: _tokenKey,
        success: false,
        errorMessage: e.toString(),
      );
      throw SecureStorageException('Failed to save token: $e');
    }
  }

  Future<String?> getToken() async {
    try {
      if (_tokenCache != null) {
        _logger.secureStorageOperation(
          operation: 'READ (Cache)',
          key: _tokenKey,
          success: true,
        );
        return _tokenCache;
      }

      _tokenCache = await _secureStorage.read(key: _tokenKey);

      _logger.secureStorageOperation(
        operation: 'READ',
        key: _tokenKey,
        success: true,
      );

      return _tokenCache;
    } catch (e) {
      _logger.secureStorageOperation(
        operation: 'READ',
        key: _tokenKey,
        success: false,
        errorMessage: e.toString(),
      );
      throw SecureStorageException('Failed to read token: $e');
    }
  }

  Future<void> deleteToken() async {
    try {
      await _secureStorage.delete(key: _tokenKey);
      _tokenCache = null;

      _logger.secureStorageOperation(
        operation: 'DELETE',
        key: _tokenKey,
        success: true,
      );
    } catch (e) {
      _logger.secureStorageOperation(
        operation: 'DELETE',
        key: _tokenKey,
        success: false,
        errorMessage: e.toString(),
      );
      throw SecureStorageException('Failed to delete token: $e');
    }
  }

  Future<bool> hasToken() async {
    try {
      final token = await getToken();
      final hasToken = token != null && token.isNotEmpty;

      _logger.secureStorageOperation(
        operation: 'CHECK',
        key: _tokenKey,
        success: true,
      );

      return hasToken;
    } catch (e) {
      _logger.secureStorageOperation(
        operation: 'CHECK',
        key: _tokenKey,
        success: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<void> clearAll() async {
    try {
      await _secureStorage.deleteAll();
      _tokenCache = null;

      _logger.secureStorageOperation(
        operation: 'CLEAR_ALL',
        key: 'ALL_KEYS',
        success: true,
      );
    } catch (e) {
      _logger.secureStorageOperation(
        operation: 'CLEAR_ALL',
        key: 'ALL_KEYS',
        success: false,
        errorMessage: e.toString(),
      );
      throw SecureStorageException('Failed to clear all data: $e');
    }
  }

  void clearCache() {
    _tokenCache = null;
    _logger.info('Token cache cleared', tag: 'SecureStorageService');
  }
}
