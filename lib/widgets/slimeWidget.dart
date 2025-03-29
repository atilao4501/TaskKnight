import 'dart:async';

import 'package:flutter/material.dart';
import 'package:task_knight_alpha/controllers/knightController.dart';

class SlimeWidget extends StatefulWidget {
  const SlimeWidget({super.key});

  @override
  State<SlimeWidget> createState() => SlimeState();
}

class SlimeState extends State<SlimeWidget> {
  bool spawned = true;
  String color = 'Red';
  double slimePositionRight = 0;
  double valueToMove = 0;

  Future<bool> spawnSlime(String color, bool spawnInTheRight) async {
    setState(() {
      this.color = color;
      spawned = true;
    });

    final screenWidth = MediaQuery.of(context).size.width;
    final unit = screenWidth * 0.0254;

    if (spawnInTheRight) {
      valueToMove = unit * 48;

      while (spawned && valueToMove > 0) {
        await Future.delayed(const Duration(seconds: 1));

        setState(() {
          valueToMove -= unit;

          if (screenWidth * 0.80 > valueToMove) {
            KnightController.knightStateKey.currentState?.lookRight();
            KnightController.knightStateKey.currentState?.attack();
          }

          if (screenWidth * 0.75 > valueToMove) {
            spawned = false;
            valueToMove = screenWidth;
            KnightController.knightStateKey.currentState?.idle();
          }
        });
      }
    } else {
      valueToMove = unit * 4;

      while (spawned && valueToMove < screenWidth) {
        await Future.delayed(const Duration(seconds: 1));

        setState(() {
          valueToMove += unit;

          if (screenWidth * 0.45 < valueToMove) {
            KnightController.knightStateKey.currentState?.lookLeft();
            KnightController.knightStateKey.currentState?.attack();
          }

          if (screenWidth * 0.55 < valueToMove) {
            spawned = false;
            valueToMove = 0;
            KnightController.knightStateKey.currentState?.idle();
            KnightController.knightStateKey.currentState?.lookRight();
          }
        });
      }
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (spawned)
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.15,
            right: MediaQuery.of(context).size.width - valueToMove,
            child: SizedBox(
              height: 100.0,
              child: FittedBox(
                child: Image.asset(
                  'assets/images/Run${color}Slime.gif',
                ),
              ),
            ),
          ),
      ],
    );
  }
}
