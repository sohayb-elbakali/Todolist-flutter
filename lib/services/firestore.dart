import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task.dart';

class FirestoreService {
  final CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');

  // Get current user ID
  String? get userId => FirebaseAuth.instance.currentUser?.uid;

  // Add task with user ID
  Future<void> addTask(Task task) {
    return FirebaseFirestore.instance.collection('tasks').add({
      'taskTitle': task.title.toString(),
      'taskDesc': task.description.toString(),
      'taskDate': task.date.toIso8601String(),
      'taskCategory': task.category.name,
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get tasks for current user only
  Stream<QuerySnapshot> getTasks() {
    if (userId == null) {
      return const Stream.empty();
    }
    return tasks.where('userId', isEqualTo: userId).snapshots();
  }

  // Update task
  Future<void> updateTask(String docId, Task task) {
    return tasks.doc(docId).update({
      'taskTitle': task.title.toString(),
      'taskDesc': task.description.toString(),
      'taskDate': task.date.toIso8601String(),
      'taskCategory': task.category.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Delete task
  Future<void> deleteTask(String docId) {
    return tasks.doc(docId).delete();
  }
}