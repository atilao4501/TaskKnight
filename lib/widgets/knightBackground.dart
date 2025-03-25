import 'package:flutter/material.dart';
import 'package:task_knight_alpha/widgets/knight.dart';

class Knightbackground extends StatefulWidget {
  final Widget child;

  const Knightbackground({super.key, required this.child});

  @override
  State<StatefulWidget> createState() => _KnightbackgroundState();
}

class _KnightbackgroundState extends State<Knightbackground> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;

        return Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/forestBackground.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Knight(height: height, width: width),
            widget.child,
          ],
        );
      },
    );
  }
}
