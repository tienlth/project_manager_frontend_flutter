import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:project_management/network/services/auth_api_service.dart';
import '../network/dio_client.dart';

class AuthState {
  final String? token;
  final String? username;
  final String? email;
  final String? role;

  AuthState({this.token, this.username, this.email, this.role});
}

class AuthCubit extends Cubit<AuthState> {
  final AuthApiService _authService = AuthApiService();
  final DioClient _dioClient = GetIt.instance<DioClient>();

  AuthCubit() : super(AuthState());

  Future<void> login(String email, String password) async {
    try {
      final response = await _authService.login(email, password);
      final token = response["token"];
      final user = response["user"];

      _dioClient.setToken(token); 

      emit(AuthState(
        token: token,
        username: user["username"],
        email: user["email"],
        role: user["role"],
      ));
    } catch (e) {
      print("Login failed: $e");
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    try {
      final response = await _authService.signUp(email, password, name);
      final token = response["token"];
      final user = response["user"];

      _dioClient.setToken(token);

      emit(AuthState(
        token: token,
        username: user["username"],
        email: user["email"],
        role: user["role"],
      ));
    } catch (e) {
      print("SignUp failed: $e");
    }
  }
}
