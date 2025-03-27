import 'package:flutter/material.dart';
import 'package:task_knight_alpha/controllers/knightController.dart';
import 'package:task_knight_alpha/widgets/knight.dart';
import 'package:task_knight_alpha/widgets/knightBackground.dart';

class OnboardingPage extends StatefulWidget {
  @override
  State<OnboardingPage> createState() => OnboardingPageState();
}

class OnboardingPageState extends State<OnboardingPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      KnightController.knightStateKey.currentState?.changeMessage('Hello');
    });
  }

  final title = Stack(
    children: [
      // Stroke
      Text(
        'Task Knight',
        style: TextStyle(
          fontSize: 40,
          fontFamily: 'VCR_OSD_MONO',
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4
            ..color = Colors.black,
        ),
      ),
      Text(
        'Task Knight',
        style: TextStyle(
          fontSize: 40,
          fontFamily: 'VCR_OSD_MONO',
          color: Color(0xFFFFFF00),
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Knightbackground(
        key: KnightController.knighBackgroundtKey,
        child: Stack(
          children: [
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Center(child: title),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () => KnightController.knightStateKey.currentState
                    ?.changeStatus(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontFamily: 'VCR_OSD_MONO',
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  elevation: 5,
                  fixedSize: Size(192, 44),
                ),
                child: Text('Start'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
