import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/network/services/project_api_service.dart';
import 'package:project_management/network/services/task_api_service.dart';

class TaskState {
  final List<dynamic> tasks;
  final Map<String, dynamic>? taskDetail;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  TaskState({
    this.tasks = const [],
    this.taskDetail,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  TaskState copyWith({
    List<dynamic>? tasks,
    Map<String, dynamic>? taskDetail,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      taskDetail: taskDetail ?? this.taskDetail,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

class TaskCubit extends Cubit<TaskState> {
  final TaskApiService _taskService = TaskApiService();
  final ProjectApiService _projectService = ProjectApiService();

  TaskCubit() : super(TaskState());

  Future<void> fetchUserTasks() async {
    emit(state.copyWith(isLoading: true, errorMessage: null, successMessage: null));

    try {
      final tasks = await _taskService.getUserTasks();
      emit(state.copyWith(isLoading: false, tasks: tasks));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: "Không thể tải danh sách công việc!"));
    }
  }

  Future<void> fetchTasks(String projectId) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, successMessage: null));

    try {
      final tasks = await _taskService.fetchAllTasks();
      emit(state.copyWith(isLoading: false, tasks: tasks));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: "Không thể tải danh sách công việc!"));
    }
  }

  Future<void> fetchTasksByProject(String slugId) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, successMessage: null));

    try {
      final projectData = await _projectService.fetchProjectBySlug(slugId);
      final tasks = projectData["tasks"] ?? [];

      emit(state.copyWith(isLoading: false, tasks: tasks));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: "Không thể tải danh sách công việc của dự án!"));
    }
  }

  Future<void> fetchTaskDetail(String taskId) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, taskDetail: null));

    try {
      final taskDetail = await _taskService.fetchTaskBySlug(taskId);
      emit(state.copyWith(isLoading: false, taskDetail: taskDetail));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: "Không thể tải chi tiết công việc!"));
    }
  }

  Future<void> createTask({
    required String projectId,
    required String title,
    required String description,
    required String assignee,
    required String priority,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, successMessage: null));
    try {
      final response = await _taskService.createTask(
        projectId: projectId,
        title: title,
        description: description,
        assignee: assignee,
        priority: priority,
        startDate: startDate.toIso8601String(),
        endDate: endDate.toIso8601String(),
      );

      if (response.containsKey("task")) {
        emit(state.copyWith(isLoading: false, successMessage: "Công việc đã được tạo thành công!"));
        await fetchTasks(projectId);
      } else {
        throw Exception("Lỗi không xác định!");
      }
    } catch (e) {
      if (e is DioException) {
        emit(state.copyWith(isLoading: false, errorMessage: e.response?.data["message"] ?? "Lỗi khi tạo công việc!"));
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: "Đã có lỗi xảy ra, vui lòng thử lại!"));
      }
    }
  }

  Future<void> updateTask(String taskId, Map<String, dynamic> updatedData) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, successMessage: null));

    try {
      final response = await _taskService.updateTask(taskId, updatedData);
      if (response.containsKey("task")) {
        emit(state.copyWith(isLoading: false, successMessage: "Công việc đã được cập nhật!"));

      } else {
        throw Exception("Lỗi không xác định!");
      }
    } catch (e) {
      if (e is DioException) {
        emit(state.copyWith(isLoading: false, errorMessage: e.response?.data["message"] ?? "Lỗi khi cập nhật công việc!"));
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: "Đã có lỗi xảy ra, vui lòng thử lại!"));
      }
    }
  }

  Future<void> deleteTask(String taskId) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, successMessage: null));

    try {
      final response = await _taskService.deleteTask(taskId);
      if (response.containsKey("message")) {
        emit(state.copyWith(isLoading: false, successMessage: "Công việc đã bị xóa!"));

      } else {
        throw Exception("Lỗi không xác định!");
      }
    } catch (e) {
      if (e is DioException) {
        emit(state.copyWith(isLoading: false, errorMessage: e.response?.data["message"] ?? "Lỗi khi xóa công việc!"));
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: "Đã có lỗi xảy ra, vui lòng thử lại!"));
      }
    }
  }
}
