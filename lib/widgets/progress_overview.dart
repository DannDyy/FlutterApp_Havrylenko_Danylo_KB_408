import 'package:flutter/material.dart';
import '../entity/task.dart';

class ProgressOverview extends StatelessWidget {
  final List<Task> tasks;

  const ProgressOverview({required this.tasks, super.key});

  @override
  Widget build(BuildContext context) {
    final int totalSteps = tasks.fold(0, (sum, item) => sum + item.totalSteps);
    final int completedSteps = tasks.fold(0, (sum, item) => sum + item.completedSteps);
    final double progress = totalSteps > 0 ? completedSteps / totalSteps : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Завдання: $completedSteps / $totalSteps'),
        LinearProgressIndicator(value: progress),
      ],
    );
  }
}
