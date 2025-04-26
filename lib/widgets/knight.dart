import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class Knight extends StatefulWidget {
  Knight({super.key});

  @override
  State<Knight> createState() => KnightState();
}

class KnightState extends State<Knight> {
  String _status = 'Idle';
  String _message = '';
  bool _lookLeft = false;

  Timer? _typingTimer;
  Timer? _dotTimer;
  Timer? _clearTimer;

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

  void changeMessage(String newMessage) {
    _typingTimer?.cancel();
    _dotTimer?.cancel();
    _clearTimer?.cancel();

    setState(() {
      _message = '';
    });

    _typingTimer = Timer.periodic(Duration(milliseconds: 300), (timer) {
      if (_message.length < newMessage.length) {
        setState(() {
          _message += newMessage[_message.length];
        });
      } else {
        timer.cancel();
        _dotTimer = Timer.periodic(Duration(milliseconds: 500), (dotTimer) {
          if (_message.endsWith('...')) {
            dotTimer.cancel();
            _clearTimer = Timer(Duration(seconds: 10), () {
              setState(() {
                _message = '';
              });
            });
          } else {
            setState(() {
              _message += '.';
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _dotTimer?.cancel();
    _clearTimer?.cancel();
    super.dispose();
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
