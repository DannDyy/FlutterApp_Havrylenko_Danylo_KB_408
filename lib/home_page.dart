import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../entity/task.dart';
import '../widgets/add_task_form.dart';
import '../widgets/progress_overview.dart';
import '../widgets/task_card.dart';
import 'services/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final List<Task> tasks = [];
  final TextEditingController taskController = TextEditingController();
  final TextEditingController stepsController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String _randomQuote = '';
  String _weather = '';

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _fetchRandomQuote();
    _fetchWeather();
    _checkInternetConnection();
  }



  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskList = prefs.getStringList('tasks') ?? [];
    setState(() {
      tasks.clear();
      tasks.addAll(taskList.map((task) {
        final taskParts = task.split(',');
        return Task(
          name: taskParts[0],
          totalSteps: int.parse(taskParts[1]),
          completedSteps: int.parse(taskParts[2]),
          isStepTask: taskParts[1] != '0',
          description: taskParts.length > 3 ? taskParts[3] : '',
          recommendation: taskParts.length > 4 ? taskParts[4] : '',
        );
      }).toList());
    });
  }

  Future<void> _fetchRandomQuote() async {
    final quote = await fetchRandomQuote();
    setState(() {
      _randomQuote = quote;
    });
  }

  Future<void> _fetchWeather() async {
    final weather = await fetchWeather();
    setState(() {
      _weather = weather;
    });
  }

  Future<void> _checkInternetConnection() async {
    final hasConnection = await InternetConnectionChecker().hasConnection;
    if (!hasConnection) {
      _showInternetErrorDialog('Зв\'язок з інтернетом втрачено. Дані можуть бути недоступні.');
    }
  }

  Future<void> _showInternetErrorDialog(String message) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Помилка'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ОК'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskStrings = tasks.map((task) =>
    '${task.name},${task.totalSteps},${task.completedSteps},${task.description},${task.recommendation}').toList();
    await prefs.setStringList('tasks', taskStrings);
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
      _saveTasks();
    });
  }

  void _addTask(String name, int totalSteps, String description, bool isStepTask) {
    final newTask = Task(
      name: name,
      totalSteps: isStepTask ? totalSteps : 0,
      completedSteps: 0,
      isStepTask: isStepTask,
      description: description,
      recommendation: '',
    );

    setState(() {
      tasks.add(newTask);
      _saveTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Helper'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_randomQuote.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  _randomQuote,
                  style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                ),
              ),
            if (_weather.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  _weather,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ProgressOverview(tasks: tasks),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskCard(
                    task: task,
                    onIncrement: task.isStepTask ? () => _incrementCompletedSteps(task) : null,
                    onDecrement: task.isStepTask ? () => _decrementCompletedSteps(task) : null,
                    onDelete: () => _deleteTask(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        tooltip: 'Add Task',
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add, color: Colors.white, size: 40),
      ),
    );
  }

  void _incrementCompletedSteps(Task task) {
    setState(() {
      if (task.completedSteps < task.totalSteps) {
        task.completedSteps++;
      }
      _saveTasks();
    });
  }

  void _decrementCompletedSteps(Task task) {
    setState(() {
      if (task.completedSteps > 0) {
        task.completedSteps--;
      }
      _saveTasks();
    });
  }

  void _showAddTaskDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: AddTaskForm(
            taskController: taskController,
            stepsController: stepsController,
            descriptionController: descriptionController,
            onAddTask: (String name, int steps, String description, bool isStepTask) {
              _addTask(name, steps, description, isStepTask);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
