import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_knight_alpha/models/task.dart';
import 'package:task_knight_alpha/wrappers/main_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(SlimeColorAdapter());
  Hive.registerAdapter(TaskAdapter());

  await Hive.openBox<Task>('tasks');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'VCR_OSD_MONO',
          useMaterial3: true,
        ),
        home: MainWrapper());
  }
}
