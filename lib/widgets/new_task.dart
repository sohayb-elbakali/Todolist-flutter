import 'package:flutter/material.dart';

class NewTask extends StatefulWidget{
const NewTask({super.key});
@override
State<NewTask> createState() {
return _NewTaskState();
} }
class _NewTaskState extends State<NewTask>{

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
}
  
final _titleController = TextEditingController();
@override
void dispose() {
_titleController.dispose();
super.dispose();
}


var _enteredTitle = '';
void _saveTitleInput(String inputValue) {
_enteredTitle = inputValue;
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
     ElevatedButton(
       onPressed: _submitTaskData,
       child: const Text('Enregistrer'),
     ),
    ],
   ),
  ],
 ),
);
}
}