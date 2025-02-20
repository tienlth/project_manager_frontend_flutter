import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio = Dio();

  DioClient() {
    _dio.options = BaseOptions(
      baseUrl: "http://10.0.2.2:8000/api",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {"Content-Type": "application/json"},
      validateStatus: (status) {
        return status != null; 
      },
    );

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print("[DIO] Request: ${options.method} ${options.baseUrl}${options.path}");
        if (options.data != null) {
          print("[DIO] Data: ${options.data}");
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print("[DIO] Response: ${response.statusCode} ${response.data}");
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print("[DIO] Error: ${e.response?.statusCode} ${e.message}");
        return handler.next(e);
      },
    ));
  }

  void setToken(String token) {
    _dio.options.headers["Authorization"] = "Bearer $token";
  }

  void clearToken() {
    _dio.options.headers.remove("Authorization");
  }

  Future<Response> get(String path) async {
    try {
      return await _dio.get(path);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String path, dynamic data) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(String path, dynamic data) async {
    try {
      return await _dio.put(path, data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } catch (e) {
      rethrow;
    }
  }
}
