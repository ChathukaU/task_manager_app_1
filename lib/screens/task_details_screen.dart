// task_details_screen.dart

import 'package:flutter/material.dart';
import 'package:task_manager_app_1/models/task.dart';
import 'package:task_manager_app_1/screens/add_edit_task_screen.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;

  TaskDetailsScreen({required this.task});

  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
  
  void onTaskAdded(Task task) {}
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _editTask(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteTask(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${widget.task.name}'),
            Text('Description: ${widget.task.description}'),
            Text('Due Date: ${widget.task.dueDate.toLocal()}'),
            Text('Status: ${widget.task.isCompleted ? 'Completed' : 'Incomplete'}'),
          ],
        ),
      ),
    );
  }

  void _editTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTaskScreen(
          initialTask: widget.task,
          onTaskAdded: (editedTask) {
            // Implement logic to update the existing task in the list
            setState(() {
              widget.task.name = editedTask.name;
              widget.task.description = editedTask.description;
              widget.task.dueDate = editedTask.dueDate;
              widget.task.isCompleted = editedTask.isCompleted;
            });
          },
        ),
      ),
    );
  }

  void _deleteTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _handleTaskDeleted();
                Navigator.pop(context);
                Navigator.pop(context); // Close the TaskDetailsScreen
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _handleTaskDeleted() {
    // Implement logic to delete the task from the list
    // For simplicity, I'll just call onTaskAdded with an empty task
    widget.onTaskAdded(Task(name: '', description: '', dueDate: DateTime.now(), isCompleted: false));
  }
}
