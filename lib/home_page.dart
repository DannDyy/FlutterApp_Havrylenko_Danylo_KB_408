import 'package:flutter/material.dart';
import '../entity/task.dart';
import '../widgets/add_task_form.dart';
import '../widgets/progress_overview.dart';
import '../widgets/task_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final List<Task> tasks = [];
  final TextEditingController taskController = TextEditingController();
  final TextEditingController stepsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();  // Завантажуємо задачі при запуску сторінки
  }

  // Завантаження задач з SharedPreferences
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskList = prefs.getStringList('tasks') ?? [];
    setState(() {
      tasks.clear();
      tasks.addAll(taskList.map((task) {
        final taskParts = task.split(',');
        return Task(
          taskParts[0],
          int.parse(taskParts[1]),
          int.parse(taskParts[2]),
          isStepTask: taskParts[1] != '0', // Перевірка, чи є етапи
        );
      }).toList());
    });
  }

  // Збереження задач у SharedPreferences
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskStrings = tasks.map((task) =>
    '${task.name},${task.totalSteps},${task.completedSteps},${task.isStepTask}').toList();
    await prefs.setStringList('tasks', taskStrings);
  }

  // Функція видалення задачі
  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);  // Видаляємо задачу з списку
      _saveTasks();  // Зберігаємо оновлений список задач
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
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    onDelete: () => _deleteTask(index), // Передаємо функцію видалення
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActions(),
    );
  }

  // Плаваюча кнопка для додавання задачі
  Widget _buildFloatingActions() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton(
            onPressed: _showAddTaskDialog,
            tooltip: 'Add Task',
            backgroundColor: Colors.purple,
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }

  // Збільшення виконаних етапів
  void _incrementCompletedSteps(Task task) {
    setState(() {
      if (task.completedSteps < task.totalSteps) {
        task.completedSteps++;
      }
      _saveTasks();  // Зберігаємо задачі при кожній зміні
    });
  }

  // Зменшення виконаних етапів
  void _decrementCompletedSteps(Task task) {
    setState(() {
      if (task.completedSteps > 0) {
        task.completedSteps--;
      }
      _saveTasks();  // Зберігаємо задачі при кожній зміні
    });
  }

  // Діалог для додавання нової задачі
  void _showAddTaskDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: AddTaskForm(
            taskController: taskController,
            stepsController: stepsController,
            onAddTask: _addTask,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Функція для додавання нової задачі
  void _addTask() {
    final String name = taskController.text;
    final int totalSteps = int.tryParse(stepsController.text) ?? 0;

    if (name.isNotEmpty && totalSteps >= 0) {
      setState(() {
        tasks.add(Task(
          name,
          totalSteps,
          0,
          isStepTask: totalSteps > 0, // Якщо кількість етапів більша за 0, задача з етапами
        ));
        _saveTasks();  // Зберігаємо задачу
        taskController.clear();
        stepsController.clear();
      });
    }
  }
}
