import 'package:flutter/material.dart';
import 'package:todolist_app/models/task.dart';


class NewTask extends StatefulWidget{
const NewTask({super.key , required this.onAddTask});
final void Function(Task task) onAddTask;
@override
State<NewTask> createState() {
return _NewTaskState();
} }
class _NewTaskState extends State<NewTask>{

Category _selectedCategory = Category.personal; 
final _titleController = TextEditingController();
final _descriptionController = TextEditingController();

void _submitTaskData() {
if (_titleController.text.trim().isEmpty) {
showDialog(
context: context,
builder: (ctx) => AlertDialog(
title: const Text('Erreur'),
content: const Text(
'Merci de saisir le titre de la tâche à ajouter dans la liste'),
actions: [
TextButton(
onPressed: () {
Navigator.pop(ctx);
},
child: const Text('Okay'),
),
],
),
);
return;
}
widget.onAddTask(
Task(
title: _titleController.text,
description: _descriptionController.text,
date: DateTime(2023, 10, 16, 14, 30),
category: _selectedCategory,
)
);

}

@override
void dispose() {
_titleController.dispose();
_descriptionController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
return Padding(
 padding: const EdgeInsets.all(16),
 child: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
   TextField(
    controller: _titleController,
    maxLength: 50,
    decoration: const InputDecoration(
    label: Text('Task title'),
    ),
   ),
   Row(
    children: [
     DropdownButton<Category>(
      value: _selectedCategory,
      items: Category.values
          .map(
            (category) => DropdownMenuItem<Category>(
              value: category,
              child: Text(category.name.toUpperCase()),
            ),
          )
          .toList(),
      onChanged: (value) {

        if (value == null) {
        return;
        }
        setState(() {
        _selectedCategory = value!;
        });
      },
    ),
     ElevatedButton(
       onPressed: () {
        print(_titleController.text);
        },
       child: const Text('Enregistrer'),
     ),
    ],
   ),
  ],
 ),
);
}
}