import 'package:flutter/material.dart';
import 'package:things_todo_app/data/hive_database.dart';
import 'package:things_todo_app/models/task.dart';
import 'package:things_todo_app/models/todo.dart';

class ToDoData extends ChangeNotifier {
  final db = HiveDataBase();
  List<ToDo> todoList = [
    ToDo(name: "ToDo 1", tasks: [
      Task(
        name: "Task 1-1",
        description: "Do this",
      ),
      Task(
        name: "Task 1-2",
        description: "Do this again",
      ),
    ]),
    ToDo(name: "ToDo 2", tasks: [
      Task(
        name: "Task 2-1",
        description: "Do",
      ),
      Task(
        name: "Task 1-2",
        description: "Do this again-again",
      ),
    ]),
    ...List.generate(25, (index) => ToDo(name: "ToDo $index", tasks: []))
  ];

  void initializeToDoList() {
    if (db.dataAlreadyExists()) {
      todoList = db.readFromDatabase();
    } else {
      db.saveToDatabase(todoList);
    }
  }

  List<ToDo> getToDoList() {
    return todoList;
  }

  ToDo findToDo(int todoIndex) {
    return todoList[todoIndex];
  }

  Task findTask(int todoIndex, int taskIndex) {
    var foundToDo = findToDo(todoIndex);
    return foundToDo.tasks[taskIndex];
  }

  void addToDo(String todoName) {
    todoList.add(ToDo(name: todoName, tasks: []));

    notifyListeners();
    db.saveToDatabase(todoList);
  }

  void changeToDo(int todoIndex, String newToDoName) {
    var foundToDo = findToDo(todoIndex);
    foundToDo.name = newToDoName;

    notifyListeners();
    db.saveToDatabase(todoList);
  }

  void deleteToDo(int todoIndex) {
    todoList.removeAt(todoIndex);

    notifyListeners();
    db.saveToDatabase(todoList);
  }

  void addTask(int todoIndex, String taskName, String description) {
    var foundToDo = findToDo(todoIndex);

    foundToDo.tasks.add(
      Task(
        name: taskName,
        description: description,
      ),
    );

    notifyListeners();
    db.saveToDatabase(todoList);
  }

  void deleteTask(int todoIndex, int taskIndex) {
    var foundToDo = findToDo(todoIndex);
    foundToDo.tasks.removeAt(taskIndex);

    notifyListeners();
    db.saveToDatabase(todoList);
  }

  void changeTaskText(int todoIndex, int taskIndex, String newTaskName,
      String newTaskDescription) {
    var foundTask = findTask(todoIndex, taskIndex);
    foundTask.name = newTaskName;
    foundTask.description = newTaskDescription;

    notifyListeners();
    db.saveToDatabase(todoList);
  }

  void changeTaskStatus(int todoIndex, int taskIndex) {
    var foundTask = findTask(todoIndex, taskIndex);
    foundTask.isCompleted = !foundTask.isCompleted;

    notifyListeners();
    db.saveToDatabase(todoList);
  }

  int amountOfTasksInToDo(int todoIndex) {
    var foundToDo = findToDo(todoIndex);
    return foundToDo.tasks.length;
  }
}
