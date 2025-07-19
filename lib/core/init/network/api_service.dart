part of '../../core.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  ApiService._internal();

  final _secureStorage = locator<SecureStorageService>();
  final _logger = locator<LoggerService>();

  // GET
  Future<ApiResponse<T>> get<T>(
      String endpoint, {
        Map<String, dynamic>? queryParams,
        required T Function(Map<String, dynamic>) fromJson,
      }) async {
    if (!await _isConnected()) return _offlineError();

    try {
      final uri = Uri.parse(endpoint).replace(queryParameters: queryParams);
      final stopwatch = Stopwatch()..start();

      _logger.apiRequest(
        method: 'GET',
        url: uri.toString(),
        headers: await _defaultHeaders(),
      );

      final response = await http
          .get(uri, headers: await _defaultHeaders())
          .timeout(const Duration(seconds: 30));

      stopwatch.stop();

      _logger.apiResponse(
        method: 'GET',
        url: uri.toString(),
        statusCode: response.statusCode,
        responseBody: _safeJsonDecode(response.body),
        duration: stopwatch.elapsed,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      _logger.error('API GET request failed', tag: 'ApiService', data: {'endpoint': endpoint, 'error': e.toString()});
      return ApiResponse(error: _handleGeneralError(e));
    }
  }

  // POST
  Future<ApiResponse<T>> post<T>(
      String endpoint,
      Map<String, dynamic>? data, {
        Map<String, dynamic>? queryParams,
        required T Function(Map<String, dynamic>) fromJson,
      }) async {
    if (!await _isConnected()) return _offlineError();

    try {
      final url = Uri.parse(endpoint).replace(queryParameters: queryParams);
      final stopwatch = Stopwatch()..start();

      _logger.apiRequest(
        method: 'POST',
        url: url.toString(),
        headers: await _defaultHeaders(),
        body: data,
      );

      final response = await http
          .post(url, headers: await _defaultHeaders(), body: jsonEncode(data))
          .timeout(const Duration(seconds: 30));

      stopwatch.stop();

      _logger.apiResponse(
        method: 'POST',
        url: url.toString(),
        statusCode: response.statusCode,
        responseBody: _safeJsonDecode(response.body),
        duration: stopwatch.elapsed,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      _logger.error('API POST request failed', tag: 'ApiService', data: {'endpoint': endpoint, 'error': e.toString()});
      return ApiResponse(error: _handleGeneralError(e));
    }
  }

  // Multipart File POST
  Future<ApiResponse<T>> multipartFilePost<T>(
      String endpoint,
      File file,
      Map<String, dynamic> fields, {
        required T Function(Map<String, dynamic>) fromJson,
        String fileFieldKey = 'file',
      }) async {
    if (!await _isConnected()) return _offlineError();

    try {
      final url = Uri.parse(endpoint);
      final mimeTypeData = lookupMimeType(file.path)?.split('/');
      final stopwatch = Stopwatch()..start();

      _logger.apiRequest(
        method: 'POST (Multipart)',
        url: url.toString(),
        headers: await _defaultHeaders(),
        body: {'fields': fields, 'fileName': file.path.split('/').last},
      );

      final request = http.MultipartRequest('POST', url)
        ..headers.addAll(await _defaultHeaders())
        ..fields.addAll(
          fields.map((key, value) => MapEntry(key, value.toString())),
        )
        ..files.add(await http.MultipartFile.fromPath(
          fileFieldKey,
          file.path,
          contentType: mimeTypeData != null
              ? MediaType(mimeTypeData[0], mimeTypeData[1])
              : MediaType('application', 'octet-stream'),
        ));

      final streamedResponse =
      await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);

      stopwatch.stop();

      _logger.apiResponse(
        method: 'POST (Multipart)',
        url: url.toString(),
        statusCode: response.statusCode,
        responseBody: _safeJsonDecode(response.body),
        duration: stopwatch.elapsed,
      );

      if (response.statusCode == 200) {
        final body = _safeJsonDecode(response.body);
        return ApiResponse(data: fromJson(body));
      } else {
        final error = _createAppError(response.statusCode, _safeJsonDecode(response.body));
        return ApiResponse(error: error);
      }
    } catch (e) {
      _logger.error('API Multipart POST request failed', tag: 'ApiService', data: {'endpoint': endpoint, 'error': e.toString()});
      return ApiResponse(error: _handleGeneralError(e));
    }
  }

  ApiResponse<T> _handleResponse<T>(
      http.Response response,
      T Function(Map<String, dynamic>) fromJson,
      ) {
    if (response.statusCode == 200) {
      final body = _safeJsonDecode(response.body);
      return ApiResponse(data: fromJson(body));
    } else {
      final body = _safeJsonDecode(response.body);
      final error = _createAppError(response.statusCode, body);
      return ApiResponse(error: error);
    }
  }

  Future<Map<String, String>> _defaultHeaders() async {
    final token = await _secureStorage.getToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  ApiResponse<T> _offlineError<T>() {
    return ApiResponse(
      error: AppError(
        message: 'İnternet bağlantınız yok.',
        type: ErrorType.NetworkConnectTimeoutError,
      ),
    );
  }

  Map<String, dynamic> _safeJsonDecode(String body) {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (e) {
      print('JSON Decode Error: $e');
      print('Raw response body: $body');
      return {'message': 'Invalid server response'};
    }
  }

  AppError _handleGeneralError(dynamic e) {
    print('General Error: $e');
    return AppError(
      message: 'Ağ bağlantısı hatası veya sunucuya ulaşılamadı.',
      type: ErrorType.NetworkConnectTimeoutError,
    );
  }

  AppError _createAppError(int statusCode, Map<String, dynamic> responseBody) {
    final message = responseBody['message'] ?? 'Bilinmeyen bir hata oluştu.';
    ErrorType type;

    switch (statusCode) {
      case 400:
        type = ErrorType.BadRequest;
        break;
      case 401:
        type = ErrorType.Unauthorized;
        break;
      case 403:
        type = ErrorType.Forbidden;
        break;
      case 404:
        type = ErrorType.NotFound;
        break;
      case 422:
        type = ErrorType.UnprocessableEntity;
        break;
      case 429:
        type = ErrorType.TooManyRequests;
        break;
      case 500:
        type = ErrorType.Server;
        break;
      case 503:
        type = ErrorType.ServiceUnavailable;
        break;
      case 504:
        type = ErrorType.GatewayTimeout;
        break;
      default:
        type = ErrorType.Unknown;
        break;
    }
    return AppError(message: message, type: type, statusCode: statusCode);
  }



  Future<bool> _isConnected() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
