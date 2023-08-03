import 'dart:io';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import 'package:paste_uploader/utils/constants.dart';
import 'package:paste_uploader/utils/strings.dart';
import 'package:window_manager/window_manager.dart';
import 'package:http/http.dart' as http;

Future<void> appInitialize() async {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: windowSize,
      center: true,
    );

    windowManager.setMinimumSize(windowSize);
    windowManager.setMaximumSize(windowSize);

    windowManager.waitUntilReadyToShow(
      windowOptions,
      () async {
        await windowManager.show();
        await windowManager.focus();
      },
    );
  }
  print("I'm here 2");
}

void main() async {
  print("I'm here 1");
  await appInitialize();
  print("I'm here 3");
  runApp(PasteUploaderApp());
}

class PasteUploaderApp extends StatelessWidget {
  PasteUploaderApp({super.key});
  final TextEditingController passwordEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xff6750a4),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(AppStrings.appTitle),
        ),
        body: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(50.0),
                child: kIsWeb ? ExampleDragTarget() : ExampleDragTarget(),
              ),
              TextButton(
                onPressed: () async {
                  final result = await FilePicker.platform
                      .pickFiles(type: FileType.any, allowMultiple: false);

                  if (result != null) {
                    var fileBytes = result.files.first.bytes as List<int>;
                    //var fileName = result.files.first.name;
                    //var filaPath = "D:/DartProjects/1.png";

                    debugPrint(fileBytes.toString());

                    var request = http.MultipartRequest(
                        'POST', Uri.parse("https://paste.c-net.org/"));
                    request.files
                        .add(http.MultipartFile.fromBytes('file', fileBytes));
                    var res = await request.send();

                    debugPrint("Done: ${res}");
                  }
                },
                child: const Text("Clear"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExampleDragTarget extends StatefulWidget {
  const ExampleDragTarget({Key? key}) : super(key: key);

  @override
  ExampleDragTargetState createState() => ExampleDragTargetState();
}

class ExampleDragTargetState extends State<ExampleDragTarget> {
  final List<XFile> _list = [];

  bool _dragging = false;

  Offset? offset;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (detail) async {
        setState(() {
          _list.addAll(detail.files);
        });

        debugPrint('onDragDone:');
        var a = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Basic dialog title'),
              content: const Text('A dialog is a type of modal window that\n'
                  'appears in front of app content to\n'
                  'provide critical information, or prompt\n'
                  'for a decision to be made.'),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Disable'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Enable'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
          // ).then((value) => print("new value: $value"));
          // for (final file in detail.files) {
          //   await Process.run(
          //       'curl --upload-file "${file.path}" "https://paste.c-net.org"',
          //       []).then(
          //     (ProcessResult pr) {
          //       debugPrint(pr.stdout);
          //     },
          //   );
          //   debugPrint('${file.path} ${file.name}'
          //       '  ${await file.lastModified()}'
          //       '  ${await file.length()}'
          //       '  ${file.mimeType}');
          // }
        );
      },
      onDragUpdated: (details) {
        setState(() {
          offset = details.localPosition;
        });
      },
      onDragEntered: (detail) {
        setState(() {
          _dragging = true;
          offset = detail.localPosition;
        });
      },
      onDragExited: (detail) {
        setState(() {
          _dragging = false;
          offset = null;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: _dragging ? Colors.blue.withOpacity(0.4) : Colors.black26,
            borderRadius: BorderRadius.circular(10)),
        height: 350,
        width: 350,
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            if (_list.isEmpty)
              const Center(child: Text("Drop here"))
            else
              Text(_list.map((e) => e.path).join("\n")),
            if (offset != null)
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  '$offset',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              )
          ],
        ),
      ),
    );
  }
}
