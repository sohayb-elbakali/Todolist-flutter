import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum Category { personal, work, shopping, others }

class Task {
  Task({
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    this.docId,
  }) : id = uuid.v4();

  final String id;
  final String? docId; // Firestore document ID
  final String title;
  final String description;
  final DateTime date;
  final Category category;

  Task copyWith({
    String? title,
    String? description,
    DateTime? date,
    Category? category,
    String? docId,
  }) {
    return Task(
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      category: category ?? this.category,
      docId: docId ?? this.docId,
    );
  }
}