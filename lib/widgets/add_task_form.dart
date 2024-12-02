import 'package:flutter/material.dart';
import 'package:flashlight_plugin/flashlight_plugin.dart';

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

  // Перевірка на ключову фразу та ввімкнення ліхтаря
  Future<void> _checkForSecret(String description) async {
    if (description.toLowerCase() == 'avada kedavra') {
      final isFlashOn = await FlashlightPlugin.toggleFlashlight();
      if (isFlashOn != null && isFlashOn) {
        _showSecretFoundDialog();
      }
    }
  }

  void _showSecretFoundDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Секрет знайдено!"),
        content: const Text("Ліхтарик увімкнено."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("ОК"),
          ),
        ],
      ),
    );
  }

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
          onPressed: () async {
            final name = widget.taskController.text.trim();
            final steps = int.tryParse(widget.stepsController.text.trim()) ?? 0;
            final description = widget.descriptionController.text.trim();

            // Перевірка секрету перед додаванням задачі
            await _checkForSecret(description);

            widget.onAddTask(name, steps, description, isStepTask);

            // Закриття діалогу після завершення
            Navigator.of(context).pop();
          },
          child: const Text('Додати задачу'),
        ),
      ],
    );
  }
}
