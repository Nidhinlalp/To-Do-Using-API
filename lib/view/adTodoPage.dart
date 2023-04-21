import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view_model/service.dart';

class AdddToDoPage extends StatefulWidget {
  final Map? todo;
  const AdddToDoPage({super.key, this.todo});

  @override
  State<AdddToDoPage> createState() => _AdddToDoPageState();
}

class _AdddToDoPageState extends State<AdddToDoPage> {
  final controller = Get.put(Services());
  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      controllerTitle.text = title;
      controllerDescription.text = description;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit To Do' : 'Add To Do',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          TextFormField(
            controller: controllerTitle,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          TextFormField(
            controller: controllerDescription,
            decoration: const InputDecoration(
              hintText: 'Description',
            ),
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () {
              isEdit
                  ? controller
                      .updateData(controllerDescription, controllerTitle,
                          widget.todo, context)
                      .then((value) => Navigator.pop(context))
                      .then((value) => controller.fetchTodo())
                  : controller
                      .submitData(
                          controllerTitle, controllerDescription, context)
                      .then((value) => Navigator.pop(context))
                      .then((value) => controller.fetchTodo());
            },
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(isEdit ? 'Update' : 'Submite'),
            ),
          )
        ],
      ),
    );
  }

//   Future<void> updateData() async {
//     //get the daa from form
//     final todo = widget.todo;
//     if (todo == null) {
//       log('You can not call updated without todo data');
//       return;
//     }
//     final id = todo['_id'];
//     // final isCompleted = todo['is_completed'];
//     final title = controllerTitle.text;
//     final description = controllerDescription.text;
//     final body = {
//       "title": title,
//       "description": description,
//       "is_completed": false,
//     };

//     //update the data
//     final url = 'https://api.nstack.in/v1/todos/$id';
//     final uri = Uri.parse(url);

//     final response = await http.put(
//       uri,
//       body: jsonEncode(body),
//       headers: {'Content-Type': 'application/json'},
//     );
//     if (response.statusCode == 200 && context.mounted) {
//       controllerTitle.clear();
//       controllerDescription.clear();
//       showMessage('Updation Success', Colors.white, context);
//     } else {
//       showMessage('Updation Failed', Colors.red, context);
//     }
//   }

//   Future<void> submitData() async {
// //Get the data from form

//     final title = controllerTitle.text;
//     final description = controllerDescription.text;

//     final body = {
//       "title": title,
//       "description": description,
//       "is_completed": false,
//     };

// //Sumbmit data to the server
//     const url = 'https://api.nstack.in/v1/todos';
//     final uri = Uri.parse(url);
//     final response = await http.post(
//       uri,
//       body: jsonEncode(body),
//       headers: {'Content-Type': 'application/json'},
//     );
//     log(response.statusCode.toString());

// // show success or fail message based on satatus

//     if (response.statusCode == 201 && context.mounted) {
//       showMessage('Creation Success', Colors.white, context);
//       controllerTitle.clear();
//       controllerDescription.clear();
//     } else {
//       showMessage('Creation Faild', Colors.red, context);
//       log(response.body.toString());
//     }
//   }
}
