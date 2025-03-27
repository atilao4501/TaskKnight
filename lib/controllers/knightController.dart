// knight_controller.dart
import 'package:flutter/material.dart';
import 'package:task_knight_alpha/widgets/knight.dart';
import 'package:task_knight_alpha/widgets/knightBackground.dart';

class KnightController {
  static final GlobalKey<KnightbackgroundState> knighBackgroundtKey =
      GlobalKey<KnightbackgroundState>();

  static final GlobalKey<KnightState> knightStateKey = GlobalKey<KnightState>();
}
