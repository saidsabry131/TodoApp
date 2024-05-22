import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoo_app/widgets/task_tile.dart';
import 'package:todoo_app/models/task_data.dart';
import 'package:todoo_app/models/task.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        if (taskData.tasks.isEmpty) {
          return const Center(
            child: Text('No tasks yet!'),
          );
        }
        return ListView.builder(
          itemCount: taskData.tasks.length,
          itemBuilder: (context, index) {
            final task = taskData.tasks[index];
            return Dismissible(
              key: Key(task.id.toString()),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                taskData.deleteTask(task);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${task.name} dismissed')),
                );
              },
              child: GestureDetector(
                onTap: () => _showUpdateTaskDialog(context, task, taskData),
                child: TaskTile(
                  initialIsChecked: task.isDone,
                  taskTitle: task.name,
                  checkboxChange: (newValue) {
                    task.isDone = newValue ?? false;
                    taskData.updateTask(task);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showUpdateTaskDialog(BuildContext context, Task task, TaskData taskData) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _controller = TextEditingController(text: task.name);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Task'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _controller,
              autofocus: true,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(hintText: 'Enter new task name'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Task name is required';
                }
                if (value.length < 3) {
                  return 'Task name must be at least 3 characters long';
                }
                if (RegExp(r'\d').hasMatch(value)) {
                  return 'Task name must not contain numbers';
                }
                return null;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  task.name = _controller.text;
                  taskData.updateTask(task);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
