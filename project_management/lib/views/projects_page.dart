import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/bloc/project_cubit.dart';
import 'package:project_management/views/project_detail_page.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProjectCubit>().fetchUserProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text("Tạo dự án", style: TextStyle(fontSize: 18)),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showCreateProjectDialog(context),
              ),
            ],
          ),
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProjectDetailPage(projectId: project["_id"]),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
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

  void _showCreateProjectDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime? startDate;
    DateTime? endDate;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Tạo dự án mới"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameController, decoration: const InputDecoration(labelText: "Tên dự án")),
                  TextField(controller: descriptionController, decoration: const InputDecoration(labelText: "Mô tả")),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(startDate == null
                          ? "Chọn ngày bắt đầu"
                          : "Bắt đầu: ${startDate!.toIso8601String().split('T')[0]}"),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: startDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              startDate = pickedDate;
                            });
                          }
                        },
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Text(endDate == null
                          ? "Chọn ngày kết thúc"
                          : "Kết thúc: ${endDate!.toIso8601String().split('T')[0]}"),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: endDate ?? startDate ?? DateTime.now(),
                            firstDate: startDate ?? DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              endDate = pickedDate;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
                TextButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty && startDate != null && endDate != null) {
                      context.read<ProjectCubit>().createProject(
                            nameController.text,
                            descriptionController.text,
                            startDate!,
                            endDate!,
                          );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Tạo"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
