import 'package:flutter/material.dart';
import 'package:task_knight_alpha/controllers/knightController.dart';
import 'package:task_knight_alpha/pages/home_page.dart';
import 'package:task_knight_alpha/pages/onboarding_page.dart';
import 'package:task_knight_alpha/widgets/knightBackground.dart';

class MainWrapper extends StatefulWidget {
  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Knightbackground(
      key: KnightController.knighBackgroundtKey, // ⚠️ Apenas UMA VEZ!
      child: Navigator(
        key: navigatorKey,
        onGenerateRoute: (_) {
          return MaterialPageRoute(
            builder: (_) => OnboardingPage(
              onStart: () {
                navigatorKey.currentState!.push(
                  MaterialPageRoute(builder: (_) => HomePage()),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
