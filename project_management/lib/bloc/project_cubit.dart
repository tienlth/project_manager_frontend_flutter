import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/network/services/project_api_service.dart';

class ProjectState {
  final List<dynamic> projects;
  final bool isLoading;
  final String? errorMessage;

  ProjectState({
    this.projects = const [],
    this.isLoading = false,
    this.errorMessage,
  });
}

class ProjectCubit extends Cubit<ProjectState> {
  final ProjectApiService _projectService = ProjectApiService();

  ProjectCubit() : super(ProjectState());

  Future<void> fetchUserProjects() async {
    emit(ProjectState(isLoading: true));

    try {
      final projects = await _projectService.getUserProjects();
      emit(ProjectState(projects: projects));
    } catch (e) {
      print("check1");
      print(e);
      emit(ProjectState(errorMessage: "Không thể tải danh sách dự án!"));
    }
  }
}
