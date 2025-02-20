import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/app.dart';
import 'package:project_management/bloc/project_cubit.dart';
import 'package:project_management/bloc/task_cubit.dart';
import 'package:project_management/config/service_locator.dart';

void main() {
  regisDioLocator();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProjectCubit()),
        BlocProvider(create: (context) => TaskCubit()),
      ],
      child: MyApp(),
    )
  );
}

