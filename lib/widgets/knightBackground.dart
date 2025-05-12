import 'dart:ui';
import 'package:task_knight_alpha/controllers/knightController.dart';
import 'package:task_knight_alpha/widgets/knight.dart';
import 'package:flutter/material.dart';
import 'package:task_knight_alpha/widgets/slimeWidget.dart';

class Knightbackground extends StatefulWidget {
  final Widget child;

  const Knightbackground({super.key, required this.child});

  @override
  State<Knightbackground> createState() => KnightbackgroundState();
}

class KnightbackgroundState extends State<Knightbackground> {
  bool _blurBackground = false;
  List<GlobalKey<SlimeState>> slimeKeys = [];
  List<SlimeWidget> slimeWidgets = [];

  void setBlur(bool value) {
    setState(() {
      _blurBackground = value;
    });
  }

  Future<void> spawnSlime() async {
    final newKey = GlobalKey<SlimeState>();
    final slime = SlimeWidget(key: newKey);

    setState(() {
      slimeWidgets.add(slime);
      slimeKeys.add(newKey);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final colors = ['Red', 'Green', 'Blue'];
      final randomColor = (colors..shuffle()).first;
      final randomBool =
          (List<bool>.generate(2, (i) => i == 0)..shuffle()).first;

      final completed =
          await newKey.currentState?.spawnSlime(randomColor, randomBool);
      if (completed == true) {
        setState(() {
          slimeKeys.remove(newKey);
          slimeWidgets.remove(slime);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: _blurBackground
              ? ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Image.asset(
                    'assets/images/forestBackground.png',
                    fit: BoxFit.fill,
                    filterQuality: FilterQuality.none,
                  ),
                )
              : Image.asset(
                  'assets/images/forestBackground.png',
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.none,
                ),
        ),

        // Guerreiro fixo na base, centralizado
        Positioned(
          top: 642,
          left: 157,
          child: _blurBackground
              ? ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Knight(key: KnightController.knightStateKey),
                )
              : Knight(key: KnightController.knightStateKey),
        ),

        // Slimes dinâmicos
        ...slimeWidgets,

        // Interface da tela
        widget.child,
      ],
    );
  }
}
