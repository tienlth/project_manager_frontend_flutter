import 'package:flutter/material.dart';
import 'package:project_management/bloc/project_cubit.dart';
import 'package:project_management/views/projects_page.dart';
import 'package:project_management/views/tasks_page.dart';
import 'package:project_management/views/widgets/app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'projects_page.dart';
// import 'tasks_page.dart';
// import 'quotations_page.dart';
// import 'contracts_page.dart';
// import 'settings_page.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ProjectsPage(),
    const TasksPage(),
    // const QuotationsPage(),
    // const ContractsPage(),
    // const SettingsPage(),

    Container(),
    Container(),
    Container(),
  ];

  final List<String> _titles = [
    "Dự án",
    "Công việc",
    "Báo giá",
    "Hợp đồng",
    "Cài đặt",
  ];

  final List<List<Widget>> _actions = [
    [], 
    [],
    [],
    [],
    [],
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: _titles[_selectedIndex], actions: _actions[_selectedIndex]),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Projects'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Quotations'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Contracts'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
