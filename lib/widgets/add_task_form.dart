import 'package:flutter/material.dart';

class AddTaskForm extends StatefulWidget {
  final TextEditingController taskController;
  final TextEditingController stepsController;
  final TextEditingController descriptionController;
  final Function(String, int, String, bool) onAddTask;

  const AddTaskForm({
    Key? key,
    required this.taskController,
    required this.stepsController,
    required this.descriptionController,
    required this.onAddTask,
  }) : super(key: key);

  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  bool isStepTask = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: widget.taskController,
          decoration: const InputDecoration(labelText: 'Назва задачі'),
        ),
        CheckboxListTile(
          title: const Text('Задача без кроків'),
          value: !isStepTask,
          onChanged: (value) {
            setState(() {
              isStepTask = !(value ?? false);
              if (!isStepTask) widget.stepsController.text = '0';
            });
          },
        ),
        if (isStepTask)
          TextField(
            controller: widget.stepsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Кількість кроків'),
          ),
        TextField(
          controller: widget.descriptionController,
          decoration: const InputDecoration(labelText: 'Опис (необов\'язково)'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = widget.taskController.text.trim();
            final steps = int.tryParse(widget.stepsController.text.trim()) ?? 0;
            final description = widget.descriptionController.text.trim();
            widget.onAddTask(name, steps, description, isStepTask);
            Navigator.of(context).pop(); // Закриває діалогове вікно після додавання задачі
          },
          child: const Text('Додати задачу'),
        ),
      ],
    );
  }
}
