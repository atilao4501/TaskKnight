import 'dart:io';

import 'package:flutter/material.dart';
import 'package:task_knight_alpha/wrappers/main_wrapper.dart';
import 'package:window_manager/window_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
