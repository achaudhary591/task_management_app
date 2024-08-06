import 'package:flutter/material.dart';
import 'package:task_management_app/helpers/database_helper.dart';
import 'package:task_management_app/models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];

  List<Task> get tasks => _filteredTasks.isEmpty ? _tasks : _filteredTasks;

  Future<void> fetchTasks() async {
    _tasks = await DatabaseHelper().getTasks();
    _filteredTasks = [];
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await DatabaseHelper().insertTask(task);
    await fetchTasks();
  }

  Future<void> updateTask(Task task) async {
    await DatabaseHelper().updateTask(task);
    await fetchTasks();
  }

  Future<void> deleteTask(int id) async {
    await DatabaseHelper().deleteTask(id);
    await fetchTasks();
  }

  void filterByCompleted(bool isCompleted) {
    _filteredTasks = _tasks.where((task) => task.isCompleted == isCompleted).toList();
    notifyListeners();
  }

  void sortByDueDate() {
    _tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    notifyListeners();
  }

  void clearFilters() {
    _filteredTasks = [];
    notifyListeners();
  }
}
