import 'package:get_it/get_it.dart';
import 'package:project_management/network/dio_client.dart';

class ProjectApiService {
  final DioClient _dio = GetIt.instance<DioClient>();

  Future<List<dynamic>> fetchProjects() async {
    final response = await _dio.get('/projects');
    return response.data;
  }

  Future<Map<String, dynamic>> fetchProjectBySlug(String slugId) async {
    try {
      final response = await _dio.get('/projects/$slugId');
      return response.data;
    } catch (e) {
      throw Exception("Không thể lấy thông tin dự án: ${e.toString()}");
    }
  }

  Future<Map<String, dynamic>> createProject({
    required String projectName,
    required String description,
    required String startDate,
    required String endDate,
  }) async {
    final response = await _dio.post('/projects', {
      "projectName": projectName,
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
