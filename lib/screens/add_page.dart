import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: "Title"),
            ),
            const SizedBox(height: 20,),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(hintText: 'Description'),
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 8,
            ),
            const SizedBox(height: 20,),
            ElevatedButton(onPressed: (){
              submitData();
            }, child: Text('Submit'))
          ],
        ),
      ),
    );
  }
  Future<void> submitData() async {
    // 1. Get the data
    final title  = titleController.text;
    final description  = descriptionController.text;
    final body = {
      "title": title,
      "description":description,
      "is_complete": false,
    }; 
    // 2. Submit the Data to the server
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    var response = await http.post(uri, body:jsonEncode(body),
    headers: {
      'Content-Type': 'application/json'
    },);
      // 3. Show success or fail message based on status(submitted or failed)
    if (response.statusCode == 201){
      titleController.text = '';
      descriptionController.text = '';
      showErrorMessage('Creation Success');
    }
    else {
      showErrorMessage("Creation Failed");
    }
  }
  void showErrorMessage(String message){
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
        ),
    backgroundColor: Colors.red,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
