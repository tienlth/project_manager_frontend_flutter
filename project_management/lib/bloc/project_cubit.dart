import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:project_management/network/services/project_api_service.dart';
import 'package:project_management/network/dio_client.dart';

class ProjectState {
  final List<dynamic> projects;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  ProjectState({
    this.projects = const [],
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  ProjectState copyWith({
    List<dynamic>? projects,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return ProjectState(
      projects: projects ?? this.projects,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

class ProjectCubit extends Cubit<ProjectState> {
  final ProjectApiService _projectService = ProjectApiService();
  final DioClient _dioClient = GetIt.instance<DioClient>();

  ProjectCubit() : super(ProjectState());

  Future<void> fetchUserProjects() async {
    emit(state.copyWith(isLoading: true, errorMessage: null, successMessage: null));

    try {
      final projects = await _projectService.getUserProjects();
      emit(state.copyWith(isLoading: false, projects: projects));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: "Không thể tải danh sách dự án!"));
    }
  }

  Future<void> createProject(String name, String description, DateTime startDate, DateTime endDate) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, successMessage: null));
    try {
      final response = await _projectService.createProject(
        projectName: name,
        description: description,
        startDate: startDate.toIso8601String(),
        endDate: endDate.toIso8601String(),
      );

      if (response.containsKey("project")) {
        emit(state.copyWith(isLoading: false, successMessage: "Dự án đã được tạo thành công!"));
        await fetchUserProjects();
      } else {
        throw Exception("Lỗi không xác định!");
      }
    } catch (e) {
      if (e is DioException) {
        emit(state.copyWith(isLoading: false, errorMessage: e.response?.data["message"] ?? "Lỗi khi tạo dự án!"));
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: "Đã có lỗi xảy ra, vui lòng thử lại!"));
      }
    }
  }

}
