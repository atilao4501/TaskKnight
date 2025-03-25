import 'dart:async';

import 'package:flutter/material.dart';

class Knight extends StatefulWidget {
  final double height;
  final double width;

  const Knight({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  State<Knight> createState() => _KnightState();
}

class _KnightState extends State<Knight> {
  String status = 'Attack';

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (status == 'Attack') {
        setState(() {
          status = 'Idle';
        });
      } else {
        setState(() {
          status = 'Attack';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.height * 0.70,
      left: widget.width * 0.35,
      child: Image.asset(
        'assets/images/Warrior$status.gif',
        width: 115,
        height: 115,
      ),
    );
  }
}
