import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../models/task.dart';
import '../models/todo.dart';

class HiveDataBase {
  final _myBox = Hive.box("todo_db");

  List<String> convertObjectToToDoList(List<ToDo> todoList) {
    List<String> list = [];
    for (int i = 0; i < todoList.length; i++) {
      list.add(todoList[i].name);
    }

    return list;
  }

  List<Map<String, List<List<String>>>> converObjectToJson(
      List<ToDo> todoList) {
    final convertedToDoList = convertObjectToToDoList(todoList);
    final convertedTasks = convertObjectToTaskList(todoList);

    List<Map<String, List<List<String>>>> json = [];
    for (int i = 0; i < convertedToDoList.length; i++) {
      Map<String, List<List<String>>> currentMap = {};
      currentMap[convertedToDoList[i].toString()] = convertedTasks[i];

      json.add(currentMap);
    }
    if (kDebugMode) print(json);
    return json;
  }

  List<List<List<String>>> convertObjectToTaskList(List<ToDo> todoList) {
    List<List<List<String>>> list = [];
    for (int i = 0; i < todoList.length; i++) {
      List<Task> tasksInToDo = todoList[i].tasks;

      List<List<String>> individualToDo = [];
      for (int j = 0; j < tasksInToDo.length; j++) {
        List<String> individualTask = [];
        individualTask.addAll([
          tasksInToDo[j].name,
          tasksInToDo[j].description,
          tasksInToDo[j].isCompleted.toString()
        ]);
        individualToDo.add(individualTask);
      }
      list.add(individualToDo);
    }

    return list;
  }

  bool dataAlreadyExists() {
    if (_myBox.isEmpty) {
      if (kDebugMode) print("Data doesn't exist");
      return false;
    } else {
      if (kDebugMode) print("Data exists");
      return true;
    }
  }

  List<ToDo> readFromDatabase() {
    List<ToDo> mySavedToDoList = [];

    List<String> todoNames = _myBox.get("TODO_LIST");
    final tasksDetails = _myBox.get("TASKS");

    for (int i = 0; i < todoNames.length; i++) {
      List<Task> tasksInEachToDo = [];

      for (int j = 0; j < tasksDetails[i].length; j++) {
        tasksInEachToDo.add(
          Task(
              name: tasksDetails[i][j][0],
              description: tasksDetails[i][j][1],
              isCompleted: tasksDetails[i][j][2] == "true" ? true : false),
        );
      }

      ToDo todo = ToDo(name: todoNames[i], tasks: tasksInEachToDo);
      mySavedToDoList.add(todo);
    }

    return mySavedToDoList;
  }

  void saveToDatabase(List<ToDo> todoList) {
    final convertedToDoList = convertObjectToToDoList(todoList);
    final convertedTasks = convertObjectToTaskList(todoList);

    _myBox.put("TODO_LIST", convertedToDoList);
    _myBox.put("TASKS", convertedTasks);
  }
}
