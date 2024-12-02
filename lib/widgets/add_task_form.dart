import 'package:flutter/material.dart';

class AddTaskForm extends StatelessWidget {
  final TextEditingController taskController;
  final TextEditingController stepsController;
  final VoidCallback onAddTask;

  const AddTaskForm({
    required this.taskController,
    required this.stepsController,
    required this.onAddTask,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: taskController,
          decoration: const InputDecoration(labelText: 'Назва задачі'),
        ),
        TextField(
          controller: stepsController,
          decoration: const InputDecoration(labelText: 'Кількість етапів'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: onAddTask,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,  // Фіолетовий колір кнопки
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
          ),
          child: const Text('Додати задачу', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
