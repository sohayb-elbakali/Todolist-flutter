import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todolist_app/models/task.dart';
import 'package:todolist_app/services/firestore.dart';
import 'package:todolist_app/widgets/new_task.dart';
import 'package:todolist_app/widgets/task_item.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  final FirestoreService firestoreService = FirestoreService();

  String get userName {
    final user = FirebaseAuth.instance.currentUser;
    return user?.email?.split('@')[0] ?? 'User';
  }

  
  void _openAddTaskOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => NewTask(onAddTask: _addTask),
    );
  }

  Future<void> _addTask(Task task) async {
    // Add task to Firestore immediately without delay
    await firestoreService.addTask(task);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Task added successfully!'),
          backgroundColor: const Color(0xFF6C63FF),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 45, 20, 15),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C63FF).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Hello, $userName 👋',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'My Tasks',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.task_alt_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF8F9FE),
                    Color(0xFFE8EEFF),
                  ],
                ),
              ),
              child: TasksList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddTaskOverlay,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Task'),
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }
}

// Classe TasksList avec StreamBuilder
class TasksList extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();
  TasksList({super.key});

  Future<void> _deleteTask(Task task) async {
    if (task.docId != null) {
      await firestoreService.deleteTask(task.docId!);
    }
  }

  void _editTask(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => NewTask(
        onAddTask: (updatedTask) async {
          if (task.docId != null) {
            await firestoreService.updateTask(task.docId!, updatedTask);
            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Task updated successfully!'),
                  backgroundColor: const Color(0xFF6C63FF),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          }
        },
        existingTask: task,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreService.getTasks(),
      builder: (context, snapshot) {
        // Vérifier si les données sont disponibles
        if (snapshot.hasData) {
          // Créer la variable taskLists qui accède aux documents
          final taskLists = snapshot.data!.docs;
          
          // Liste pour stocker les tâches converties
          List<Task> taskItems = [];
          
          // Parcourir la liste taskLists pour convertir les documents en Task
          for (int index = 0; index < taskLists.length; index++) {
            // Obtenir le document à l'index courant
            DocumentSnapshot document = taskLists[index];
            
            // Convertir les données du document en Map
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            
            // Extraire les données du document
            String title = data['taskTitle'];
            String description = data['taskDesc'];
            DateTime date = DateTime.parse(data['taskDate']);
            String categoryString = data['taskCategory'];
            
            // Convertir la catégorie string en enum Category
            Category category;
            switch (categoryString) {
              case 'personal':
                category = Category.personal;
                break;
              case 'work':
                category = Category.work;
                break;
              case 'shopping':
                category = Category.shopping;
                break;
              default:
                category = Category.others;
            }
            
            // Créer l'objet Task avec le document ID
            Task task = Task(
              title: title,
              description: description,
              date: date,
              category: category,
              docId: document.id,
            );
            
            // Ajouter la tâche à la liste
            taskItems.add(task);
          }
          
          // Afficher la liste des tâches
          if (taskItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt_rounded,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks yet',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the button below to add your first task',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: taskItems.length,
            itemBuilder: (ctx, index) {
              return TaskItem(
                taskItems[index],
                onDelete: () => _deleteTask(taskItems[index]),
                onEdit: () => _editTask(context, taskItems[index]),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 60,
                  color: Colors.red.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'Something went wrong',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${snapshot.error}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF6C63FF),
            ),
          );
        } else {
          // No data yet - show empty state
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.task_alt_rounded,
                  size: 80,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'No tasks yet',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the button below to add your first task',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

/* Code précédent commenté:
body: ListView.builder(
  itemCount: _registeredTasks.length,
  itemBuilder: (context, index) {
    final task = _registeredTasks[index];
    return ListTile(
      title: Text(task.title),
      subtitle: Text(task.description),
    );
  },
),
*/
