import 'package:flutter/material.dart';
import '../entity/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback onDelete;  // Додаємо функцію для видалення

  const TaskCard({
    required this.task,
    this.onIncrement,
    this.onDecrement,
    required this.onDelete,  // Додаємо ініціалізацію для видалення
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (task.isStepTask) ...[
              Text('Кроки: ${task.completedSteps} / ${task.totalSteps}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: onDecrement,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: onIncrement,
                  ),
                ],
              ),
            ] else ...[
              const Text('Це проста задача без етапів.'),
            ],
            // Кнопка для видалення
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,  // Виклик функції видалення
              ),
            ),
          ],
        ),
      ),
    );
  }
}
