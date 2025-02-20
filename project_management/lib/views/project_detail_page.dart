import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/bloc/project_cubit.dart';

class ProjectDetailPage extends StatelessWidget {
  final String projectId;

  const ProjectDetailPage({super.key, required this.projectId});

  @override
Widget build(BuildContext context) {
  return BlocProvider(
    create: (context) => ProjectCubit()..fetchProjectDetail(projectId),
    child: BlocListener<ProjectCubit, ProjectState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!, style: const TextStyle(color: Colors.white)),
              backgroundColor: Colors.green,
            ),
          );
        }

        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!, style: const TextStyle(color: Colors.white)),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Chi tiết Dự án")),
        body: BlocBuilder<ProjectCubit, ProjectState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.errorMessage != null) {
              return Center(child: Text(state.errorMessage!));
            }
            if (state.projectDetail == null) {
              return const Center(child: Text("Không tìm thấy thông tin dự án!"));
            }
            if (state.successMessage != null) {
              return Center(child: Text(state.successMessage!, style: const TextStyle(color: Colors.green)));
            }

            final project = state.projectDetail!;
            final progress = (project["progress"] as num).toDouble();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoField("Tên dự án", project["projectName"]),
                  _buildInfoField("Mô tả", project["description"]),
                  _buildColoredText("Ưu tiên", project["priority"], _getPriorityColor(project["priority"])),
                  _buildColoredText("Trạng thái", project["status"], _getStatusColor(project["status"])),
                  const SizedBox(height: 8),
                  const Text("Tiến độ:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  _buildProgressBar(progress),

                  const SizedBox(height: 16),
                  _buildInfoField("Ngày bắt đầu", project["startDate"]),
                  _buildInfoField("Ngày kết thúc", project["endDate"]),

                  const SizedBox(height: 16),
                  const Text("Danh sách công việc:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 8),
                  ...List.generate(project["tasks"].length, (index) {
                    final task = project["tasks"][index];
                    final taskProgress = (task["progress"] as num).toDouble();

                    return Card(
                      color: Colors.grey[200],
                      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(task["title"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 6),
                            Text("Mô tả: ${task["description"]}"),
                            _buildColoredText("Trạng thái", task["status"], _getStatusColor(task["status"])),
                            _buildColoredText("Ưu tiên", task["priority"], _getPriorityColor(task["priority"])),
                            Text("Bắt đầu: ${task["startDate"]}"),
                            Text("Kết thúc: ${task["endDate"]}"),
                            const SizedBox(height: 6),
                            _buildProgressBar(taskProgress),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddTaskDialog(context),
          child: const Icon(Icons.add),
        ),
      ),
    ),
  );
}

  void _showAddTaskDialog(BuildContext context) {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController estimatedHoursController = TextEditingController();

  String selectedPriority = "Medium"; 
  DateTime? startDate;
  DateTime? endDate;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Thêm Công Việc"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: titleController, decoration: const InputDecoration(labelText: "Tên Công Việc")),
                  TextField(controller: descriptionController, decoration: const InputDecoration(labelText: "Mô Tả")),
                  TextField(
                    controller: estimatedHoursController,
                    decoration: const InputDecoration(labelText: "Ước tính giờ làm"),
                    keyboardType: TextInputType.number,
                  ),
                  
                  DropdownButtonFormField<String>(
                    value: selectedPriority,
                    decoration: const InputDecoration(labelText: "Mức Độ Ưu Tiên"),
                    items: ["High", "Medium", "Low"]
                        .map((priority) => DropdownMenuItem(value: priority, child: Text(priority)))
                        .toList(),
                    onChanged: (value) => setState(() => selectedPriority = value!),
                  ),

                  ListTile(
                    title: Text("Ngày bắt đầu: ${startDate != null ? startDate.toString().split(' ')[0] : "Chưa chọn"}"),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) setState(() => startDate = pickedDate);
                    },
                  ),

                  ListTile(
                    title: Text("Ngày kết thúc: ${endDate != null ? endDate.toString().split(' ')[0] : "Chưa chọn"}"),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: startDate ?? DateTime.now(),
                        firstDate: startDate ?? DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) setState(() => endDate = pickedDate);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
              TextButton(
                onPressed: () {
                  context.read<ProjectCubit>().addTaskToProject(
                    {
                      "projectId": projectId,
                      "title": titleController.text,
                      "description": descriptionController.text,
                      "estimatedHours": int.tryParse(estimatedHoursController.text) ?? 0,
                      "status": "Pending",
                      "priority": selectedPriority,
                      "startDate": startDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
                      "endDate": endDate?.toIso8601String() ?? DateTime.now().add(const Duration(days: 7)).toIso8601String(),
                    },
                  );
                  Navigator.pop(context);
                },
                child: const Text("Lưu"),
              ),
            ],
          );
        },
      );
    },
  );
}

  Widget _buildInfoField(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200], 
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text("$label: $value", style: const TextStyle(fontSize: 16)),
    );
  }

  Widget _buildColoredText(String label, String value, Color color) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
      decoration: BoxDecoration(
        color: Colors.grey[200], 
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 16, color: Colors.black),
            children: [
              TextSpan(text: "$label: "),
              TextSpan(
                text: value,
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress / 100,
            minHeight: 10,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor(progress)),
          ),
        ),
        const SizedBox(height: 4),
        Text("${progress.toStringAsFixed(1)}%", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "In Progress":
        return Colors.blue;
      case "Completed":
        return Colors.green;
      case "Pending":
        return Colors.orange;
      case "Planning":
        return Colors.purple;
      default:
        return Colors.black;
    }
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
        return Colors.black;
    }
  }

  Color _getProgressColor(double progress) {
    if (progress < 30) {
      return Colors.red;
    } else if (progress < 70) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}
