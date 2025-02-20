import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:project_management/network/services/auth_api_service.dart';
import '../network/dio_client.dart';

class AuthState {
  final String? token;
  final String? username;
  final String? email;
  final String? role;
  final String? errorMessage;
  final String? successMessage;

  AuthState({
    this.token,
    this.username,
    this.email,
    this.role,
    this.errorMessage,
    this.successMessage,
  });
}

class AuthCubit extends Cubit<AuthState> {
  final AuthApiService _authService = AuthApiService();
  final DioClient _dioClient = GetIt.instance<DioClient>();

  AuthCubit() : super(AuthState());

  Future<void> login(String email, String password, BuildContext context) async {
    try {
      final response = await _authService.login(email, password);
      if (response.containsKey("token") && response.containsKey("user")) {
        final token = response["token"];
        final user = response["user"];

        _dioClient.setToken(token);

        emit(AuthState(
          token: token,
          username: user["username"],
          email: user["email"],
          role: user["role"],
          successMessage: "Đăng nhập thành công!",
        ));

        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (e is DioException) {
        emit(AuthState(errorMessage: e.response?.data["message"] ?? "Tài khoản không tồn tại!"));
      } else {
        emit(AuthState(errorMessage: "Đã có lỗi xảy ra, vui lòng thử lại!"));
      }
    }
  }

  Future<void> signUp(String name, String email, String password, BuildContext context) async {
    try {
      final response = await _authService.signUp(email, password, name);
      if (response.containsKey("token") && response.containsKey("user")) {
        final token = response["token"];
        final user = response["newUser"];

        _dioClient.setToken(token);

        emit(AuthState(
          token: token,
          username: user["username"],
          email: user["email"],
          role: user["role"],
          successMessage: "Đăng ký thành công!",
        ));

        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (e is DioException) {
        emit(AuthState(errorMessage: e.response?.data["message"] ?? "Không tìm thấy thông tin tài khoản!"));
      } else {
        emit(AuthState(errorMessage: "Đã có lỗi xảy ra, vui lòng thử lại!"));
      }
    }
  }

  void logout(BuildContext context) {
  emit(AuthState()); 
  _dioClient.clearToken(); 
  Navigator.pushReplacementNamed(context, '/login');
}
}
