import 'package:flutter/material.dart';

class NewTask extends StatefulWidget{
const NewTask({super.key});
@override
State<NewTask> createState() {
return _NewTaskState();
} }
class _NewTaskState extends State<NewTask>{

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
    onChanged: _saveTitleInput,
    maxLength: 50,
    decoration: const InputDecoration(
    label: Text('Task title'),
    ),
   ),
   Row(
    children: [
     ElevatedButton(
       onPressed: () { print(_enteredTitle);},
       child: const Text('Enregistrer'),
     ),
    ],
   ),
  ],
 ),
);
}
}