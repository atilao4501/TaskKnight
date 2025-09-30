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
  String title = 'Task1';
  double valueToMove = 0;

  Future<bool> spawnSlime(
      String color, String title, bool spawnInTheRight) async {
    setState(() {
      this.title = title;
      this.color = color;
      spawned = true;
    });

    const double canvasWidth = 393.0;
    const double slimeWidth = 60.0;
    const double targetX = (canvasWidth / 2) - (slimeWidth / 2);
    const double step = 0.5;
    const Duration frameDelay = Duration(milliseconds: 30); // ~33fps

    if (spawnInTheRight) {
      valueToMove = canvasWidth;

      while (spawned && valueToMove > targetX) {
        await Future.delayed(frameDelay);

        setState(() {
          valueToMove -= step;

          if (valueToMove <= targetX + 65) {
            KnightController.knightStateKey.currentState?.lookRight();
            KnightController.knightStateKey.currentState?.attack();
          }

          if (valueToMove <= targetX + 25) {
            spawned = false;
            KnightController.knightStateKey.currentState?.idle();
          }
        });
      }
    } else {
      valueToMove = -slimeWidth;

      while (spawned && valueToMove < targetX) {
        await Future.delayed(frameDelay);

        setState(() {
          valueToMove += step;

          if (valueToMove >= targetX - 65) {
            KnightController.knightStateKey.currentState?.lookLeft();
            KnightController.knightStateKey.currentState?.attack();
          }

          if (valueToMove >= targetX - 25) {
            spawned = false;
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
            top: 658,
            left: valueToMove,
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xFFFFE100),
                    fontSize: 12,
                    fontFamily: 'VCR OSD Mono',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: 60,
                  height: 34,
                  child: Image.asset(
                    'assets/images/Run${color}SlimeCrop.gif',
                    filterQuality: FilterQuality.none,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
