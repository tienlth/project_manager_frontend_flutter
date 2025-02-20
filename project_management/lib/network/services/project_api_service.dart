import 'package:get_it/get_it.dart';
import 'package:project_management/network/dio_client.dart';

class ProjectApiService {
  final DioClient _dio = GetIt.instance<DioClient>();

  Future<List<dynamic>> fetchProjects() async {
    final response = await _dio.get('/projects');
    return response.data;
  }

  Future<Map<String, dynamic>> createProject(String name, String description, String startDate, String endDate) async {
    final response = await _dio.post('/projects', {
      "projectName": name,
      "description": description,
      "startDate": startDate,
      "endDate": endDate,
    });
    return response.data;
  }

  Future<List<dynamic>> getUserProjects() async {
    try {
      final response = await _dio.get('/projects/user-projects');
      return response.data["projects"] as List<dynamic>;
    } catch (e) {
      throw Exception("Getting data error: ${e.toString()}");
    }
  }
}
