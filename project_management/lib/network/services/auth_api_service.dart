import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:project_management/network/dio_client.dart';

class AuthApiService {
  final DioClient _dio = GetIt.instance<DioClient>();

  Future<Map<String, dynamic>> login(String email, String password) async {

    final response = await _dio.post('/auth/login', {
      "email": email,
      "password": password,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> signUp(String email, String password, String name) async {
    final response = await _dio.post('/auth/register', {
      "username": name,
      "email": email,
      "password": password,
    });
    return response.data; 
  }
}
