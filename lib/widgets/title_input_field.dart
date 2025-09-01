import 'package:flutter/material.dart';

class TitleInputField extends StatelessWidget {
  final TextEditingController controller;

  const TitleInputField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        maxLength: 35,
        style: const TextStyle(
          fontFamily: 'VCR_OSD_MONO',
          fontSize: 18,
          color: Colors.black54,
        ),
        decoration: const InputDecoration(
          hintText: 'Title',
          hintStyle: TextStyle(
            fontFamily: 'VCR_OSD_MONO',
            fontSize: 18,
            color: Colors.black54,
          ),
          border: InputBorder.none,
          counterText: '',
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          isDense: true,
        ),
      ),
    );
  }
}
