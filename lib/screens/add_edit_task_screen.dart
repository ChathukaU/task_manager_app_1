import 'package:flutter/material.dart';
import 'package:task_manager_app_1/models/task.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Function(Task) onTaskAdded;
  final Task? initialTask;

  AddEditTaskScreen({required this.onTaskAdded, this.initialTask});

  @override
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late DateTime _dueDate;
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _dueDate = DateTime.now();
    _isCompleted = false;

    // If there is an initial task, populate the fields for editing
    if (widget.initialTask != null) {
      _nameController.text = widget.initialTask!.name;
      _descriptionController.text = widget.initialTask!.description;
      _dueDate = widget.initialTask!.dueDate;
      _isCompleted = widget.initialTask!.isCompleted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialTask != null ? 'Edit Task' : 'Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Task Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Task Description'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _selectDueDate(context),
              child: Text('Select Due Date'),
            ),
            SizedBox(height: 16.0),
            CheckboxListTile(
              title: Text('Completed'),
              value: _isCompleted,
              onChanged: (value) {
                setState(() {
                  _isCompleted = value!;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _saveTask(context),
              child: Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDueDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _dueDate) {
      setState(() {
        _dueDate = pickedDate;
      });
    }
  }

  void _saveTask(BuildContext context) {
    String name = _nameController.text.trim();
    String description = _descriptionController.text.trim();

    if (name.isNotEmpty) {
      Task newTask = Task(
        name: name,
        description: description,
        dueDate: _dueDate,
        isCompleted: _isCompleted,
      );

      if (widget.initialTask == null) {
        widget.onTaskAdded(newTask); // Adding a new task
      } else {
        // Editing an existing task
        // You can implement logic here to update the existing task in the list
        // For simplicity, I'll just call onTaskAdded to simulate updating the task
        widget.onTaskAdded(newTask);
      }

      Navigator.pop(context); // Close the AddEditTaskScreen
    } else {
      // Show an error message or handle invalid input
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task name cannot be empty'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}