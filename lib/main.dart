import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/providers/task_provider.dart';
import 'package:task_management_app/screens/add_task_screen.dart';
import 'package:task_management_app/screens/edit_task_screen.dart';
import 'package:task_management_app/screens/task_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        title: 'Task Management App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => TaskListScreen(),
          '/add-task': (context) => AddTaskScreen(),
          '/edit-task': (context) => EditTaskScreen(),
        },
      ),
    );
  }
}
