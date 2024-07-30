import 'package:flutter/material.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/services/database_service.dart';
import 'package:todo/widgets/custom_app_bar.dart';
import 'package:todo/widgets/custom_btn.dart';
import 'package:todo/widgets/text_input.dart';

class AddTodo extends StatefulWidget {
  final int? id;
  final String? title;
  final String? description;
  final String? creationDate;
  final int? isCompleted;
  final String btnText;
  
  const AddTodo({super.key, this.id, this.title, this.description, this.creationDate, this.isCompleted, required this.btnText});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final DatabaseService _databaseService = DatabaseService();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  Future<void> _onSave() async{
    if(widget.title != null || widget.description != null || widget.creationDate != null || widget.isCompleted != null){
      await _databaseService.updateTodo(TodoModel(id: widget.id, title: titleController.text, description: descriptionController.text, creationDate: widget.creationDate!, isCompleted: widget.isCompleted!));
    }
    else {
      DateTime today = DateTime.now();
      await _databaseService.insertTodo(TodoModel(title: titleController.text, description: descriptionController.text, creationDate: '${today.year}-${today.month}-${today.day}', isCompleted: 0));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(),
          TextInput(textHint: 'Title', multiline: false, controller: titleController, initialText: widget.title,),
          TextInput(textHint: 'Description', multiline: true, controller: descriptionController, initialText: widget.description),
          CustomBtn(text: widget.btnText, callback: () async {_onSave();})
        ],
      ),
    );
  }
}