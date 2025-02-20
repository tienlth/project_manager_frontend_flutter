// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:project_management/bloc/task_cubit.dart';

// class CreateTaskDialog extends StatefulWidget {
//   @override
//   _CreateTaskDialogState createState() => _CreateTaskDialogState();
// }

// class _CreateTaskDialogState extends State<CreateTaskDialog> {
//   final titleController = TextEditingController();
//   final descriptionController = TextEditingController();
//   DateTime? startDate;
//   DateTime? endDate;
//   String priority = "Medium";
//   String? selectedUser;
//   List<String> users = ["User A", "User B", "User C"];

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text("Tạo công việc mới"),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextField(controller: titleController, decoration: const InputDecoration(labelText: "Tiêu đề")),
//           TextField(controller: descriptionController, decoration: const InputDecoration(labelText: "Mô tả")),
//           const SizedBox(height: 10),
          
//           Row(
//             children: [
//               Text(startDate == null
//                   ? "Chọn ngày bắt đầu"
//                   : "Bắt đầu: ${startDate!.toIso8601String().split('T')[0]}"),
//               IconButton(
//                 icon: const Icon(Icons.calendar_today),
//                 onPressed: () async {
//                   DateTime? pickedDate = await showDatePicker(
//                     context: context,
//                     initialDate: startDate ?? DateTime.now(),
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime(2100),
//                   );
//                   if (pickedDate != null) {
//                     setState(() {
//                       startDate = pickedDate;
//                     });
//                   }
//                 },
//               ),
//             ],
//           ),

//           Row(
//             children: [
//               Text(endDate == null
//                   ? "Chọn ngày kết thúc"
//                   : "Kết thúc: ${endDate!.toIso8601String().split('T')[0]}"),
//               IconButton(
//                 icon: const Icon(Icons.calendar_today),
//                 onPressed: () async {
//                   DateTime? pickedDate = await showDatePicker(
//                     context: context,
//                     initialDate: endDate ?? startDate ?? DateTime.now(),
//                     firstDate: startDate ?? DateTime.now(),
//                     lastDate: DateTime(2100),
//                   );
//                   if (pickedDate != null) {
//                     setState(() {
//                       endDate = pickedDate;
//                     });
//                   }
//                 },
//               ),
//             ],
//           ),

//           DropdownButton<String>(
//             value: priority,
//             onChanged: (value) => setState(() => priority = value!),
//             items: ["High", "Medium", "Low"]
//                 .map((e) => DropdownMenuItem(value: e, child: Text("Ưu tiên: $e")))
//                 .toList(),
//           ),

//           DropdownButton<String>(
//             value: selectedUser,
//             hint: const Text("Chọn người thực hiện"),
//             onChanged: (value) => setState(() => selectedUser = value),
//             items: users.map((user) => DropdownMenuItem(value: user, child: Text(user))).toList(),
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
//         TextButton(
//           onPressed: () {
//             if (titleController.text.isNotEmpty &&
//               startDate != null &&
//               endDate != null &&
//               selectedUser != null) {
//                 context.read<TaskCubit>().createTask(
//                   projectId: projectId, 
//                   title: titleController.text,
//                   description: descriptionController.text,
//                   assignee: selectedUser!,
//                   priority: priority,
//                   startDate: startDate!,
//                   endDate: endDate!,
//               );
//               Navigator.pop(context);
//             }
//           },
//           child: const Text("Tạo"),
//         ),
//       ],
//     );
//   }
// }
