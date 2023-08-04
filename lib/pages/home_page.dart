import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:things_todo_app/components/text_fragment.dart';
import 'package:things_todo_app/data/todo_data.dart';
import 'package:things_todo_app/models/todo.dart';
import 'package:things_todo_app/pages/settings_page.dart';
import '../components/todo_listview.dart';
import 'package:http/http.dart' as http;

final todoProvider = ChangeNotifierProvider((ref) => ToDoData());

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _newToDoNameController = TextEditingController();

  void navigateSettings() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const SettingsPage(),
      ),
    );
  }

  void sendToServer() async {
    var todoList = ref.read(todoProvider).getToDoList();
    var db = ref.read(todoProvider).db;
    var json = await compute(jsonEncode, db.converObjectToJson(todoList));

    final http.Response response = await http.post(
        Uri.parse('https://jsonplaceholder.typicode.com/albums'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json);

    String snackMessage;

    if (response.statusCode == 201) {
      snackMessage = response.body;
    } else {
      snackMessage = "Unknown fail";
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.indigo,
        content: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              const TextFragment(
                text:
                    "Later we will be able to send and store your data ONLINE",
                isOverflowClip: true,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFragment(text: snackMessage, isOverflowClip: false),
            ],
          ),
        ),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  @override
  void initState() {
    super.initState();

    ref.read(todoProvider).initializeToDoList();
  }

  @override
  Widget build(BuildContext context) {
    List<ToDo> todoList = ref.watch(todoProvider).todoList;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "thinGS",
          style: TextStyle(fontFamily: 'RobotoMono'),
        ),
        actions: [
          IconButton(
            onPressed: () => sendToServer(),
            icon: const Icon(
              Icons.ios_share_rounded,
            ),
          ),
          IconButton(
            onPressed: () => navigateSettings(),
            icon: const Icon(
              Icons.settings_rounded,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Create New ToDo"),
              content: TextField(
                controller: _newToDoNameController,
                decoration: const InputDecoration(hintText: "ToDo Name"),
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    var newToDoName = _newToDoNameController.text;
                    if (newToDoName.trim().isNotEmpty) {
                      ref.read(todoProvider).addToDo(newToDoName);
                    }

                    _newToDoNameController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
                MaterialButton(
                  onPressed: () {
                    _newToDoNameController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                )
              ],
            ),
          );
        },
        child: const Icon(Icons.add_rounded),
      ),
      body: Center(
        child: ToDoListView(
          todoList: todoList,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _newToDoNameController.dispose();
    super.dispose();
  }
}
