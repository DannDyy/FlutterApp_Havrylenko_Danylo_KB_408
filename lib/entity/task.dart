class Task {
  final String name;
  final int totalSteps;
  int completedSteps;
  final bool isStepTask;
  final String description;
  final String recommendation;

  Task({
    required this.name,
    required this.totalSteps,
    required this.completedSteps,
    required this.isStepTask,
    required this.description,
    required this.recommendation,
  });
}
