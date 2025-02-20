import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/bloc/auth_cubit.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isLogin = true;

  void _submit(BuildContext context) async {
    setState(() => _isLoading = true);

    final authCubit = context.read<AuthCubit>();

    if (_isLogin) {
      await authCubit.login(_emailController.text, _passwordController.text);
    } else {
      await authCubit.signUp(
          _nameController.text, _emailController.text, _passwordController.text);
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? "Đăng nhập" : "Đăng ký")),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!_isLogin)
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: "Tên"),
                  ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Mật khẩu"),
                ),
                const SizedBox(height: 20),
                if (state.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      state.errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () => _submit(context),
                        child: Text(_isLogin ? "Đăng nhập" : "Đăng ký"),
                      ),
                Row(
                  children: [
                    Text(_isLogin ? "Chưa có tài khoản?" : "Đã có tài khoản?"),
                    TextButton(
                      onPressed: () {
                        setState(() => _isLogin = !_isLogin);
                      },
                      child: Text(_isLogin ? " Đăng ký" :  "Đăng nhập"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
