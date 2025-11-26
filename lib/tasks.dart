import 'package:flutter/material.dart';
import 'models/task.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  final List<Task> _registeredTasks = [
    Task(
      title: 'Apprendre Flutter',
      description: 'Suivre le cours pour apprendre de nouvelles compétences',
      date: DateTime.now(),
      category: Category.work,
    ),
    Task(
      title: 'Faire les courses',
      description: 'Acheter des provisions pour la semaine',
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: Category.shopping,
    ),
    Task(
      title: 'Rediger un CR',
      description: '',
      date: DateTime.now().subtract(const Duration(days: 2)),
      category: Category.personal,
    ),
  ];

  
  void _openAddTaskOverlay() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => const Text('Exemple de fenêtre'),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ToDoList'),
        actions: [
          IconButton(
            onPressed:_openAddTaskOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
