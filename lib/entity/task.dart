class Task {
  final String name;
  final int totalSteps;
  int completedSteps;
  final bool isStepTask; // Додаємо властивість, яка визначає, чи задача має етапи

  Task(this.name, this.totalSteps, this.completedSteps, {this.isStepTask = false}); // Оновлюємо конструктор
}
