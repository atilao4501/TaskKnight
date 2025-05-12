import 'package:flutter/material.dart';

class VirtualScreen extends StatelessWidget {
  final Widget child;
  const VirtualScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: 393,
            height: 852,
            child: child,
          ),
        ),
      ),
    );
  }
}
