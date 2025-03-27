import 'dart:io';

import 'package:flutter/material.dart';
import 'package:task_knight_alpha/pages/onboarding_page.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isMacOS) {
    await windowManager.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setSize(const Size(393, 852));
      await windowManager.setResizable(false);
      await windowManager.setTitle('Task Knight');
      await windowManager.show();
      await windowManager.focus();
    });
  }

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
      home: OnboardingPage(),
    );
  }
}
