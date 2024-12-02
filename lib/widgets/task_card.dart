import 'package:flutter/material.dart';
import '../entity/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const TaskCard({
    required this.task,
    required this.onIncrement,
    required this.onDecrement, super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: task.totalSteps > 0 ? task.completedSteps / task.totalSteps : 0,
              backgroundColor: Colors.grey[300],
              color: Colors.green,
            ),
            const SizedBox(height: 10),
            Text('Етапів: ${task.totalSteps}'),
            Text('Завершено: ${task.completedSteps} | Не завершено: ${task.totalSteps - task.completedSteps}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: onIncrement,
                  child: const Text('Додати етап'),
                ),
                ElevatedButton(
                  onPressed: onDecrement,
                  child: const Text('Видалити етап'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
