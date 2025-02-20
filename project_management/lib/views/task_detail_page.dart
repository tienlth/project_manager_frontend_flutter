import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/bloc/task_cubit.dart';

class TaskDetailPage extends StatelessWidget {
  final String taskId;

  const TaskDetailPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskCubit()..fetchTaskDetail(taskId),
      child: Scaffold(
        appBar: AppBar(title: const Text("Chi tiết Công việc")),
        body: BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.errorMessage != null) {
              return Center(child: Text(state.errorMessage!));
            }
            if (state.taskDetail == null) {
              return const Center(child: Text("Không tìm thấy thông tin công việc!"));
            }

            final task = state.taskDetail!;
            final progress = (task["progress"] as num).toDouble();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoField("Tên công việc", task["title"]),
                  _buildInfoField("Mô tả", task["description"]),
                  _buildColoredText("Ưu tiên", task["priority"], _getPriorityColor(task["priority"])),
                  _buildColoredText("Trạng thái", task["status"], _getStatusColor(task["status"])),

                  const SizedBox(height: 8),
                  const Text("Tiến độ:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  _buildProgressBar(progress),

                  const SizedBox(height: 16),
                  _buildInfoField("Ngày bắt đầu", task["startDate"]),
                  _buildInfoField("Ngày kết thúc", task["endDate"]),

                  const SizedBox(height: 16),
                  const Text("Thông tin dự án:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 8),
                  _buildInfoField("Dự án", task["project"]["projectName"]),
                ],
              ),
            );
          },
        ),
      ),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
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
