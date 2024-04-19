import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Task Manager',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromRGBO(157, 234, 220, 1)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class Task {
  String name;
  bool status;

  Task({required this.name, required this.status});
}

class MyAppState extends ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void clearTasks() {
    _tasks.clear();
    notifyListeners();
  }

  void toggleTaskStatus(int index) {
    _tasks[index].status = !_tasks[index].status;
    notifyListeners();
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Manager',
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AddTask(),
              ClearTasks(),
            ],
          ),
          TaskList(),
        ],
      ),
    );
  }
}

class AddTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AddTaskDialog(),
            );
          },
          child: Text('Add a task'),
        ),
      ],
    );
  }
}

class AddTaskDialog extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  late TextEditingController _taskController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _taskController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5.0,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add Task',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _taskController,
              focusNode: _focusNode,
              decoration: InputDecoration(hintText: 'Enter task'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String taskName = _taskController.text.trim();
                if (taskName.isNotEmpty) {
                  appState.addTask(Task(name: taskName, status: false));
                  Navigator.pop(context);
                }
              },
              child: Text('Add Task'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}

class ClearTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    return ElevatedButton(
      onPressed: appState.clearTasks,
      child: Text('Clear all'),
    );
  }
}

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final tasks = appState.tasks;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        color: Color.fromRGBO(157, 234, 220, 1),
        height: 600,
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            Task task = tasks[index];
            return ListTile(
                title: Text(
                  task.name,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                leading: Checkbox(
                  value: task.status,
                  onChanged: (value) {
                    context.read<MyAppState>().toggleTaskStatus(index);
                  },
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete,
                    size: 25,
                    color: Colors.black,
                  ),
                  onPressed: () => appState.deleteTask(index),
                ));
          },
        ),
      ),
    );
  }
}
