import 'package:flutter/material.dart';
import '../entity/task.dart';

class ProgressOverview extends StatelessWidget {
  final List<Task> tasks;

  const ProgressOverview({required this.tasks, super.key});

  @override
  Widget build(BuildContext context) {
    final int totalSteps = tasks.fold(0, (sum, item) => sum + item.totalSteps);
    final int completedSteps = tasks.fold(0, (sum, item) => sum + item.completedSteps);
    final int pendingSteps = totalSteps - completedSteps;
    final double completionRate = totalSteps > 0 ? completedSteps / totalSteps : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Прогрес виконання задач',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: completionRate,
          backgroundColor: Colors.grey[300],
          color: Colors.blue,
        ),
        const SizedBox(height: 10),
        Text('Завершено: $completedSteps етапів'),
        Text('Виконано: $pendingSteps етапів'),
      ],
    );
  }
}
