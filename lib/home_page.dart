import 'package:flutter/material.dart';
import '../entity/task.dart';
import '../widgets/add_task_form.dart';
import '../widgets/progress_overview.dart';
import '../widgets/task_card.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Tracker'),
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
                  return TaskCard(
                    task: tasks[index],
                    onIncrement: () => _incrementCompletedSteps(tasks[index]),
                    onDecrement: () => _decrementCompletedSteps(tasks[index]),
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

  void _incrementCompletedSteps(Task task) {
    setState(() {
      if (task.completedSteps < task.totalSteps) {
        task.completedSteps++;
      }
    });
  }

  void _decrementCompletedSteps(Task task) {
    setState(() {
      if (task.completedSteps > 0) {
        task.completedSteps--;
      }
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

  void _addTask() {
    final String name = taskController.text;
    final int totalSteps = int.tryParse(stepsController.text) ?? 0;

    if (name.isNotEmpty && totalSteps > 0) {
      setState(() {
        tasks.add(Task(name, totalSteps, 0));
        taskController.clear();
        stepsController.clear();
      });
    }
  }
}
