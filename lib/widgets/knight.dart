import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class Knight extends StatefulWidget {
  const Knight({super.key});

  @override
  State<Knight> createState() => KnightState();
}

class KnightState extends State<Knight> {
  String _status = 'Idle';
  String _message = '';
  bool _lookLeft = false;

  void lookLeft() {
    setState(() {
      _lookLeft = true;
    });
  }

  void lookRight() {
    setState(() {
      _lookLeft = false;
    });
  }

  void changeStatus() {
    setState(() {
      _status = _status == 'Attack' ? 'Idle' : 'Attack';
    });
  }

  void attack() {
    setState(() {
      _status = 'Attack';
    });
  }

  void idle() {
    setState(() {
      _status = 'Idle';
    });
  }

  void changeMessage(String newMessage) async {
    setState(() {
      _message = '';
    });

    for (int i = 0; i < newMessage.length; i++) {
      await Future.delayed(Duration(milliseconds: 300));
      setState(() {
        _message += newMessage[i];
      });
    }

    for (int i = 0; i < 3; i++) {
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        _message += '.';
      });
    }

    await Future.delayed(Duration(seconds: 10));
    setState(() {
      _message = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: Transform(
              alignment: Alignment.center,
              transform: _lookLeft
                  ? (Matrix4.identity()..scale(-1.0, 1.0))
                  : Matrix4.identity(),
              child: Image.asset(
                'assets/images/Warrior$_status.gif',
              ),
            ),
          ),
        ),
        if (_message.isNotEmpty)
          Positioned(
            top: 0,
            child: Opacity(
              opacity: 0.7,
              child: IntrinsicWidth(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 182),
                  child: Container(
                    height: 39,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontFamily: 'VCR_OSD_MONO',
                        height: 1.3,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
