// TaskData class

import 'package:flutter/material.dart';
import 'package:todoo_app/models/task.dart';
import 'package:todoo_app/database/database_handler.dart';

class TaskData extends ChangeNotifier {//belongs to provider which always listens to changes //here we await any database changes and notify the listeners
  List<Task> tasks = [];

  TaskData() {
    loadTasks();
  }

  Future<void> loadTasks() async {
    tasks = await DatabaseHandler().getTasks();
    notifyListeners();
  }

  void addTask(String newTaskTitle) async {
    final task = Task(name: newTaskTitle);
    await DatabaseHandler().insertTask(task);
    tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task task) async {
    task.doneChange();
    await DatabaseHandler().updateTask(task);
    notifyListeners();
  }

  void deleteTask(Task task) async {
    tasks.remove(task);
    notifyListeners();
    await DatabaseHandler().deleteTask(task.id!);
  }
}
