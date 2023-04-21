import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/adTodoPage.dart';

class Services extends GetxController {
  //-------------update Data------------------------------
  Future<void> updateData(
      TextEditingController controllerTitle,
      TextEditingController controllerDescription,
      Map? todo,
      BuildContext context) async {
    //get the daa from form

    if (todo == null) {
      log('You can not call updated without todo data');
      return;
    }
    final id = todo['_id'];
    // final isCompleted = todo['is_completed'];
    final title = controllerTitle.text;
    final description = controllerDescription.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    //update the data
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);

    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200 && context.mounted) {
      controllerTitle.clear();
      controllerDescription.clear();
      showMessage('Updation Success', Colors.white, context);
    } else {
      showMessage('Updation Failed', Colors.red, context);
    }
  }

//------------Delete The Data-------------------------
  Future<void> delete(String id, BuildContext context) async {
    //delete the item
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200 && context.mounted) {
      //remove the item from list

      final filterd = items.where((element) => element['_id'] != id).toList();

      items = filterd;
      update();
      showMessage('Succesfuly Deleted ', Colors.white, context);
    } else {
      showMessage('Unable to Delete', Colors.red, context);
    }
  }

  //-------------------------Submit DAta------------------------------------
  List items = [];
  Future<void> submitData(TextEditingController controllerTitle,
      TextEditingController controllerDescription, BuildContext context) async {
//Get the data from form

    final title = controllerTitle.text;
    final description = controllerDescription.text;

    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

//Sumbmit data to the server
    const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    log(response.statusCode.toString());

// show success or fail message based on satatus

    if (response.statusCode == 201 && context.mounted) {
      showMessage('Creation Success', Colors.white, context);
      controllerTitle.clear();
      controllerDescription.clear();
    } else {
      showMessage('Creation Faild', Colors.red, context);
      log(response.body.toString());
    }
  }

  //---------Get Data------------------------------------------

  Future<void> fetchTodo() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    log(response.toString());
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      log(jsonDecode(response.body).toString());
      final result = json['items'] as List;
      log(result.toString());

      items = result;
      update();
      log('${items.toString()}iiiiiiiiiiii');
    } else {
      //show error
    }

    log(response.toString());
    log(response.statusCode.toString());
  }

  //////------------Navigato add page-------------

  Future<void> navigateToAddPage(BuildContext context) async {
    final route = MaterialPageRoute(
      builder: (context) => const AdddToDoPage(),
    );
    await Navigator.push(context, route);
  }

//---------------navigateToEditePage-----------------
  void navigateToEditePage(BuildContext context, Map item) {
    final route = MaterialPageRoute(
      builder: (context) => AdddToDoPage(todo: item),
    );
    Navigator.push(context, route);
  }

  //-----------snakbar-------------------------
  void showMessage(String message, Color color, BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: color,
      content: Text(
        message,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
