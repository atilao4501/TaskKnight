import 'package:flutter/material.dart';

class BackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const BackButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 10,
      top: 0,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 38,
          height: 63,
          child: Center(
            child: Text(
              '←',
              style: TextStyle(
                fontFamily: 'VCR_OSD_MONO',
                fontSize: 64,
                color: Colors.white,
                height: 1.0,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    color: Colors.black,
                  ),
                  Shadow(
                    offset: Offset(-1, -1),
                    color: Colors.black,
                  ),
                  Shadow(
                    offset: Offset(1, -1),
                    color: Colors.black,
                  ),
                  Shadow(
                    offset: Offset(-1, 1),
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
