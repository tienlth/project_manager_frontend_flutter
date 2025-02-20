import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/bloc/auth_cubit.dart';
import 'package:project_management/views/auth_page.dart';
import 'package:project_management/views/navigration_page.dart';
import 'package:project_management/views/projects_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthPage(),
        routes: {
          '/home': (context) => NavigationScreen(),
          '/projects': (context) => ProjectsPage(),
          '/login': (context) => AuthPage(),
        },
      ),
    );
  }
}
