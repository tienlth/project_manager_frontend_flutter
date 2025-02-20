import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/bloc/auth_cubit.dart';
import 'package:project_management/bloc/project_cubit.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectCubit()..fetchUserProjects(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Danh sách dự án"),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                // final result = await Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const AddProjectPage()),
                // );
                // if (result == true) {
                //   context.read<ProjectCubit>().fetchUserProjects();
                // }
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthCubit>().logout(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state.username == null || state.role == null) {
                  return const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text("Đang tải thông tin người dùng..."),
                  );
                }
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  color: Colors.blueAccent.withOpacity(0.1),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Xin chào, ${state.username!}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        " (${state.role!})",
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: BlocBuilder<ProjectCubit, ProjectState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.errorMessage != null) {
                    return Center(child: Text(state.errorMessage!));
                  }
                  if (state.projects.isEmpty) {
                    return const Center(child: Text("Không có dự án nào."));
                  }
                  return ListView.builder(
                    itemCount: state.projects.length,
                    itemBuilder: (context, index) {
                      final project = state.projects[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          title: Text(project["projectName"], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Mô tả: ${project["description"]}"),
                              Text("Tiến độ: ${project["progress"]}%"),
                              Text("Trạng thái: ${project["status"]}"),
                            ],
                          ),
                          trailing: Text(
                            project["priority"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _getPriorityColor(project["priority"]),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case "High":
        return Colors.red;
      case "Medium":
        return Colors.orange;
      case "Low":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
