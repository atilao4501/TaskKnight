import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

extension StringExtension on String {
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';
}

enum KnightStatus { idle, attack }

class Knight extends StatefulWidget {
  const Knight({super.key});

  @override
  State<Knight> createState() => KnightState();
}

class KnightState extends State<Knight> {
  KnightStatus _status = KnightStatus.idle;
  String _message = '';
  bool _lookLeft = false;

  Timer? _typingTimer;
  Timer? _dotTimer;
  Timer? _clearTimer;

  // Layout constants
  static const double _knightWidth = 116;
  static const double _knightHeight = 74;
  static const double _balloonOffsetX = -15;
  static const double _balloonOffsetY = -6;
  static const double _balloonMaxWidth = 182;

  @override
  void initState() {
    super.initState();
    changeMessage("I Will Defeat Your Worst Taskmares...");
  }

  // Public API
  void lookLeft() => setState(() => _lookLeft = true);
  void lookRight() => setState(() => _lookLeft = false);
  void attack() => setState(() => _status = KnightStatus.attack);
  void idle() => setState(() => _status = KnightStatus.idle);

  void changeMessage(String newMessage) {
    resetMessageTimers();
    setState(() => _message = '');

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
              setState(() => _message = '');
            });
          } else {
            setState(() => _message += '.');
          }
        });
      }
    });
  }

  // Internals
  void resetMessageTimers() {
    _typingTimer?.cancel();
    _dotTimer?.cancel();
    _clearTimer?.cancel();
  }

  Widget _buildKnightImage() {
    return Transform(
      alignment: Alignment.center,
      transform: _lookLeft
          ? (Matrix4.identity()..scale(-1.0, 1.0))
          : Matrix4.identity(),
      child: Image.asset(
        'assets/images/Warrior${_status.name.capitalize()}.gif',
        width: _knightWidth,
        height: _knightHeight,
        fit: BoxFit.fill,
        filterQuality: FilterQuality.none,
      ),
    );
  }

  Widget _buildMessageBubble() {
    return Positioned(
      bottom: _knightHeight,
      left: 0,
      right: 0,
      child: Transform.translate(
        offset: Offset(_balloonOffsetX, _balloonOffsetY),
        child: Opacity(
          opacity: 0.85,
          child: IntrinsicWidth(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: _balloonMaxWidth),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
    );
  }

  @override
  void dispose() {
    resetMessageTimers();
    super.dispose();
  }

  // Widget size: 116x74 (from Figma)
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          _buildKnightImage(),
          if (_message.isNotEmpty) _buildMessageBubble(),
        ],
      ),
    );
  }
}
