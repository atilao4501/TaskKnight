import 'dart:async';

import 'package:flutter/material.dart';
import 'package:task_knight_alpha/controllers/knightController.dart';

class SlimeWidget extends StatefulWidget {
  const SlimeWidget({Key? key}) : super(key: key);

  @override
  State<SlimeWidget> createState() => SlimeState();
}

class SlimeState extends State<SlimeWidget> {
  bool spawned = true;
  String color = 'Red';
  double slimePositionRight = 0;
  double valueToMove = 0;

  void spawnSlime(String color, bool spawnInTheRight) {
    setState(() {
      this.color = color;
      spawned = true;
    });

    if (spawnInTheRight) {
      valueToMove = (MediaQuery.of(context).size.width * 0.0254) * 48;

      Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!spawned) {
          timer.cancel();
        } else {
          setState(() {
            valueToMove -= (MediaQuery.of(context).size.width * 0.0254);

            if (MediaQuery.of(context).size.width * 0.80 > valueToMove) {
              KnightController.knightStateKey.currentState?.lookRight();
              KnightController.knightStateKey.currentState?.attack();
            }

            if (MediaQuery.of(context).size.width * 0.75 > valueToMove) {
              spawned = false;
              valueToMove = MediaQuery.of(context).size.width;
              KnightController.knightStateKey.currentState?.idle();
              timer.cancel();
            }
          });
        }
      });
    } else {
      valueToMove = (MediaQuery.of(context).size.width * 0.0254) * 4;
      Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!spawned) {
          timer.cancel();
        } else {
          setState(() {
            valueToMove += (MediaQuery.of(context).size.width * 0.0254);

            if (MediaQuery.of(context).size.width * 0.45 < valueToMove) {
              KnightController.knightStateKey.currentState?.lookLeft();
              KnightController.knightStateKey.currentState?.attack();
            }

            if (MediaQuery.of(context).size.width * 0.55 < valueToMove) {
              //spawned = false;
              valueToMove = 0;
              KnightController.knightStateKey.currentState?.idle();
              KnightController.knightStateKey.currentState?.lookRight();
              timer.cancel();
            }
          });
        }
      });
    }
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
      spawnSlime('Blue', true);
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
