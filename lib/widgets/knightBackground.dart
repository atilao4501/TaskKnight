import 'package:flutter/material.dart';
import 'package:task_knight_alpha/controllers/knightController.dart';
import 'package:task_knight_alpha/widgets/knight.dart';
import 'package:task_knight_alpha/widgets/slimeWidget.dart';

class Knightbackground extends StatefulWidget {
  final Widget child;

  Knightbackground({super.key, required this.child});

  List<GlobalKey<SlimeState>> slimeKeys = [];
  List<SlimeWidget> slimeWidgets = [];
  var slimeKey = GlobalKey<SlimeState>();

  @override
  State<StatefulWidget> createState() => KnightbackgroundState();
}

class KnightbackgroundState extends State<Knightbackground> {
  Future<void> spawnSlime() async {
    final newKey = GlobalKey<SlimeState>();
    final slime = SlimeWidget(key: newKey);

    setState(() {
      widget.slimeWidgets.add(slime);
      widget.slimeKeys.add(newKey);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final colors = ['Red', 'Green', 'Blue'];
      final randomColor = (colors..shuffle()).first;
      final randomBool =
          (List<bool>.generate(2, (index) => index == 0)..shuffle()).first;

      final completed =
          await newKey.currentState?.spawnSlime(randomColor, randomBool);
      if (completed == true) {
        setState(() {
          widget.slimeKeys.remove(newKey);
          widget.slimeWidgets.remove(slime);
        });
      }
    });
  }

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
        ...widget.slimeWidgets,
        widget.child,
      ],
    );
  }
}
