import 'package:get_it/get_it.dart';
import 'package:project_management/network/dio_client.dart';

class UserApiService {
  final DioClient _dio = GetIt.instance<DioClient>();

  Future<List<dynamic>> fetchUsers() async {
    final response = await _dio.get('/users');
    return response.data;
  }
}
