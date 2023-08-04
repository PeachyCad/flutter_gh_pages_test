import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'components/starting_screen.dart';
import 'pages/home_page.dart';

void main() async {
  await Hive.initFlutter();

  Future hiveFuture = Hive.openBox("todo_db")
      .whenComplete(() => Future.delayed(const Duration(seconds: 2)));

  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: hiveFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const HomePage();
            } else {
              return const StartingScreen();
            }
          },
        ),
        theme: ThemeData(
          fontFamily: 'RobotoMono',
          primarySwatch: Colors.indigo,
          scaffoldBackgroundColor: const Color.fromARGB(255, 132, 159, 181),
        ),
      ),
    ),
  );
}
