import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';

/// API Client for HTTP requests - using Public API with API Key
class ApiClient {
  late Dio _dio;

  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(milliseconds: AppConstants.connectTimeout),
        receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-API-Key': AppConstants.apiKey,
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('REQUEST[${options.method}] => ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('RESPONSE[${response.statusCode}] => ${response.requestOptions.uri}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print('ERROR[${error.response?.statusCode}] => ${error.requestOptions.uri}');
          print('ERROR MESSAGE: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  /// GET request with retry logic for Replit server wake-up
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    int maxRetries = 3,
  }) async {
    // Add API key to query parameters (backend expects it in URL)
    final params = {
      ...?queryParameters,
      'apiKey': AppConstants.apiKey,
    };
    
    Exception? lastError;
    
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        final response = await _dio.get(
          path,
          queryParameters: params,
          options: options,
        );
        
        // Check if response is HTML (server waking up)
        if (response.data is String && response.data.toString().contains('<!DOCTYPE html>')) {
          print('⚠️ Server returning HTML, retrying... (attempt $attempt/$maxRetries)');
          if (attempt < maxRetries) {
            await Future.delayed(Duration(seconds: attempt * 2)); // Exponential backoff
            continue;
          }
          throw Exception('Server not ready, please try again');
        }
        
        return response;
      } on DioException catch (e) {
        lastError = Exception(_handleError(e));
        print('❌ Request failed (attempt $attempt/$maxRetries): ${e.message}');
        
        if (attempt < maxRetries) {
          await Future.delayed(Duration(seconds: attempt * 2));
          continue;
        }
      }
    }
    
    throw lastError ?? Exception('Request failed after $maxRetries attempts');
  }

  /// POST request with retry logic
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    int maxRetries = 3,
  }) async {
    Exception? lastError;
    
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        final response = await _dio.post(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
        );
        
        // Check if response is HTML (server waking up)
        if (response.data is String && response.data.toString().contains('<!DOCTYPE html>')) {
          print('⚠️ Server returning HTML on POST, retrying... (attempt $attempt/$maxRetries)');
          if (attempt < maxRetries) {
            await Future.delayed(Duration(seconds: attempt * 2));
            continue;
          }
          throw Exception('Server not ready, please try again');
        }
        
        return response;
      } on DioException catch (e) {
        lastError = Exception(_handleError(e));
        print('❌ POST failed (attempt $attempt/$maxRetries): ${e.message}');
        
        if (attempt < maxRetries) {
          await Future.delayed(Duration(seconds: attempt * 2));
          continue;
        }
      }
    }
    
    throw lastError ?? Exception('POST request failed after $maxRetries attempts');
  }

  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    String errorMessage;
    
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Connection timeout';
        break;
      case DioExceptionType.badResponse:
        errorMessage = _handleStatusCode(error.response?.statusCode);
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request cancelled';
        break;
      default:
        errorMessage = 'Network error';
    }

    return errorMessage;
  }

  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Access forbidden';
      case 404:
        return 'Resource not found';
      case 500:
        return 'Server error';
      default:
        return 'Something went wrong';
    }
  }
}
