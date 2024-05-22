import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoo_app/models/task_data.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String? newTaskTitle;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Add Task',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              color: Colors.yellow,
              fontWeight: FontWeight.bold,
            ),
          ),
          Form(
            key: _formKey,
            child: TextFormField(
              autofocus: true,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: 'Enter task name',
              ),
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
              onSaved: (newValue) {
                newTaskTitle = newValue;
              },
            ),
          ),
          const SizedBox(height: 30),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                Provider.of<TaskData>(context, listen: false)
                    .addTask(newTaskTitle!);
                Navigator.pop(context);
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.greenAccent,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
