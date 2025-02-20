import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/bloc/auth_cubit.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
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
    );
  }
}
