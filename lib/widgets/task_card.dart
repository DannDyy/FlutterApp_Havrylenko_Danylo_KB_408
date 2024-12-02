import 'package:flutter/material.dart';
import '../entity/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback? onDelete;

  const TaskCard({
    required this.task,
    this.onIncrement,
    this.onDecrement,
    this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(task.name),
        subtitle: Text(task.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onIncrement != null)
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: onIncrement,
              ),
            if (onDecrement != null)
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: onDecrement,
              ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}
