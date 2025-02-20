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
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Text("Người thực hiện: "),
                        task["assignees"].length > 0?
                        Expanded(
                          child: Wrap(
                            spacing: 8,
                            children: (task["assignees"] as List<dynamic>).map<Widget>((user) {
                              return Text(user["username"], style: TextStyle(fontWeight: FontWeight.bold));
                            }).toList(),
                          ),
                        )
                        : Text("Chưa có"),
                      ],
                    ),
                  ),
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

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _showUpdateTaskDialog(context, task, state.users),
                        icon: const Icon(Icons.edit),
                        label: const Text("Cập nhật"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _confirmDeleteTask(context),
                        icon: const Icon(Icons.delete),
                        label: const Text("Xóa"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showUpdateTaskDialog(BuildContext context, Map<String, dynamic> task, List<dynamic> users) {
  TextEditingController titleController = TextEditingController(text: task["title"]);
  TextEditingController descriptionController = TextEditingController(text: task["description"]);
  TextEditingController progressController = TextEditingController(text: task["progress"].toString());
  
  String selectedPriority = task["priority"];
  String selectedStatus = task["status"];
  String selectedAssignee = task["assignee"] ?? "";

  DateTime startDate = DateTime.parse(task["startDate"]);
  DateTime endDate = DateTime.parse(task["endDate"]);

  showDialog(
    context: context,
    builder: (context) {
      return BlocProvider.value(
        value: context.read<TaskCubit>(),
        child: StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Cập nhật Công Việc"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: titleController, decoration: const InputDecoration(labelText: "Tên Công Việc")),
                    TextField(controller: descriptionController, decoration: const InputDecoration(labelText: "Mô Tả")),
                    
                    DropdownButtonFormField<String>(
                      value: selectedPriority,
                      decoration: const InputDecoration(labelText: "Mức Độ Ưu Tiên"),
                      items: ["High", "Medium", "Low"]
                          .map((priority) => DropdownMenuItem(value: priority, child: Text(priority)))
                          .toList(),
                      onChanged: (value) => setState(() => selectedPriority = value!),
                    ),

                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: const InputDecoration(labelText: "Trạng Thái"),
                      items: ["Planning", "Pending", "In Progress", "Completed"]
                          .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                          .toList(),
                      onChanged: (value) => setState(() => selectedStatus = value!),
                    ),

                    TextField(
                      controller: progressController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Tiến Độ (%)"),
                    ),

                    ListTile(
                      title: Text("Ngày Bắt Đầu: ${startDate.toIso8601String().split('T')[0]}"),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: startDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null && picked != startDate) {
                          setState(() => startDate = picked);
                        }
                      },
                    ),

                    ListTile(
                      title: Text("Ngày Kết Thúc: ${endDate.toIso8601String().split('T')[0]}"),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: endDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null && picked != endDate) {
                          setState(() => endDate = picked);
                        }
                      },
                    ),

                    DropdownButtonFormField<dynamic>(
                      value: selectedAssignee.isNotEmpty ? selectedAssignee : null,
                      decoration: const InputDecoration(labelText: "Giao Cho"),
                      items: users 
                          .map((user) => DropdownMenuItem(value: user["_id"], child: Text(user["username"])))
                          .toList(),
                      onChanged: (value) => setState(() => selectedAssignee = value!),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
                TextButton(
                  onPressed: () {
                    context.read<TaskCubit>().updateTask(
                      task["_id"],
                      {
                        "title": titleController.text,
                        "description": descriptionController.text,
                        "priority": selectedPriority,
                        "status": selectedStatus,
                        "progress": double.tryParse(progressController.text) ?? 0.0,
                        "startDate": startDate.toIso8601String(),
                        "endDate": endDate.toIso8601String(),
                        "assignee": selectedAssignee,
                      },
                    );
                    Navigator.pop(context);
                  },
                  child: const Text("Lưu"),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}

void _confirmDeleteTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Xóa Công Việc"),
          content: const Text("Bạn có chắc chắn muốn xóa công việc này không?"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
            TextButton(
              onPressed: () {
                context.read<TaskCubit>().deleteTask(taskId);
                Navigator.pop(context);
                Navigator.pop(context); 
              },
              child: const Text("Xóa", style: TextStyle(color: Colors.red)),
            ),
          ],
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
      case "In Progress": return Colors.blue;
      case "Completed": return Colors.green;
      case "Pending": return Colors.orange;
      case "Planning": return Colors.purple;
      default: return Colors.black;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case "High": return Colors.red;
      case "Medium": return Colors.orange;
      case "Low": return Colors.green;
      default: return Colors.black;
    }
  }

  Color _getProgressColor(double progress) {
    if (progress < 30) return Colors.red;
    if (progress < 70) return Colors.orange;
    return Colors.green;
  }
}
