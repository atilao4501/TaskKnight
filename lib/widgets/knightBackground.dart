import 'package:flutter/material.dart';
import 'package:task_knight_alpha/controllers/knightController.dart';
import 'package:task_knight_alpha/widgets/knight.dart';
import 'package:task_knight_alpha/widgets/slimeWidget.dart';

class Knightbackground extends StatefulWidget {
  final Widget child;

  const Knightbackground({super.key, required this.child});

  @override
  State<StatefulWidget> createState() => KnightbackgroundState();
}

class KnightbackgroundState extends State<Knightbackground> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/forestBackgroundWide.png',
            fit: BoxFit.none,
            alignment: Alignment(0.3, 0.5),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.15,
          left: 0,
          right: 0,
          child: Center(
            child: SizedBox(
              width: 115,
              height: 115,
              child: Knight(
                key: KnightController.knightStateKey,
              ),
            ),
          ),
        ),
        SlimeWidget(),
        widget.child,
      ],
    );
  }
}
