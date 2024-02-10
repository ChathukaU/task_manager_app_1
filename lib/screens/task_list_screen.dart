import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app_1/screens/task_details_screen.dart';
import 'package:task_manager_app_1/screens/add_edit_task_screen.dart';
import 'package:task_manager_app_1/models/task.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Manager',
          style: TextStyle(
            color: Colors.purple, // Change title color to purple
            fontWeight: FontWeight.bold, // Make title bold
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tasks[index].name),
            subtitle: Text(tasks[index].description),
            leading: Icon(tasks[index].isCompleted ? Icons.check_box : Icons.check_box_outline_blank),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailsScreen(task: tasks[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditTaskScreen(onTaskAdded: _handleTaskAdded),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? tasksJsonList = prefs.getStringList('tasks');

    if (tasksJsonList != null) {
      setState(() {
        tasks = tasksJsonList.map((taskJson) => Task.fromJson(taskJson)).toList();
      });
    }
  }

  void _handleTaskAdded(Task newTask) async {
    setState(() {
      tasks.add(newTask);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasksJsonList = tasks.map((task) => task.toJson()).cast<String>().toList();
    prefs.setStringList('tasks', tasksJsonList);
  }
}
