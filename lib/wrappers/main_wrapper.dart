import 'package:flutter/material.dart';
import 'package:task_knight_alpha/controllers/knightController.dart';
import 'package:task_knight_alpha/pages/home_page.dart';
import 'package:task_knight_alpha/pages/onboarding_page.dart';
import 'package:task_knight_alpha/widgets/knightBackground.dart';
import 'package:task_knight_alpha/widgets/virtual_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return VirtualScreen(
      child: Knightbackground(
        key: KnightController.knighBackgroundtKey,
        child: Navigator(
          key: navigatorKey,
          onGenerateRoute: (_) {
            return MaterialPageRoute(
              builder: (_) => OnboardingPage(
                onStart: () {
                  KnightController.knighBackgroundtKey.currentState
                      ?.setBlur(true);
                  navigatorKey.currentState!.push(
                    MaterialPageRoute(builder: (_) => HomePage()),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
