import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/bloc/task_cubit.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().fetchUserTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.all(12.0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       const Text("Tạo công việc", style: TextStyle(fontSize: 18)),
        //       IconButton(
        //         icon: const Icon(Icons.add),
        //         onPressed: () => _showCreateTaskDialog(context),
        //       ),
        //     ],
        //   ),
        // ),
        Expanded(
          child: BlocBuilder<TaskCubit, TaskState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.errorMessage != null) {
                return Center(child: Text(state.errorMessage!));
              }
              if (state.tasks.isEmpty) {
                return const Center(child: Text("Không có công việc nào."));
              }
              return ListView.builder(
                itemCount: state.tasks.length,
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      title: Text(task["title"], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Mô tả: ${task["description"]}"),
                          Row(
                            children: [
                              const Text("Ưu tiên: "),
                              Text("${task["priority"]}", style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _getPriorityColor(task["priority"]),
                                ),
                              ),
                            ],
                          ),
                          Text("Bắt đầu: ${task["startDate"]}"),
                          Text("Kết thúc: ${task["endDate"]}"),
                          Text("Tiến độ: ${task["status"]}"),
                          Text("Trạng thái: ${task["progress"]}"),
                        ],
                      ),
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
}
