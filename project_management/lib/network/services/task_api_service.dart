import 'package:get_it/get_it.dart';
import 'package:project_management/network/dio_client.dart';

class TaskApiService {
  final DioClient _dio = GetIt.instance<DioClient>();

  Future<Map<String, dynamic>> fetchTaskBySlug(String slugId) async {
    try {
      final response = await _dio.get('/tasks/$slugId');
      return response.data;
    } catch (e) {
      throw Exception("Không thể lấy thông tin công việc: ${e.toString()}");
    }
  }

  Future<List<dynamic>> fetchAllTasks() async {
    final response = await _dio.get('/tasks');
    return response.data;
  }

  Future<Map<String, dynamic>> createTask({
    required String projectId,
    required String title,
    required String description,
    required String assignee,
    required String priority,
    required String startDate,
    required String endDate,
  }) async {
    final response = await _dio.post('/tasks', {
      "projectId": projectId,
      "title": title,
      "description": description,
      "assignee": assignee,
      "priority": priority,
      "startDate": startDate,
      "endDate": endDate,
    });
    return response.data;
  }

  Future<List<dynamic>> getUserTasks() async {
    try {
      final response = await _dio.get('/tasks/user-tasks');
      return response.data["tasks"] as List<dynamic>;
    } catch (e) {
      throw Exception("Getting data error: ${e.toString()}");
    }
  }

  Future<Map<String, dynamic>> updateTask(String taskId, Map<String, dynamic> updatedData) async {
    try {
      final response = await _dio.put('/tasks/$taskId', updatedData);
      return response.data;
    } catch (e) {
      throw Exception("Không thể cập nhật công việc: ${e.toString()}");
    }
  }

  Future<Map<String, dynamic>> deleteTask(String taskId) async {
    try {
      final response = await _dio.delete('/tasks/$taskId');
      return response.data;
    } catch (e) {
      throw Exception("Không thể xóa công việc: ${e.toString()}");
    }
  }
}
