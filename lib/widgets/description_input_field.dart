import 'package:flutter/material.dart';

class DescriptionInputField extends StatelessWidget {
  final TextEditingController controller;

  const DescriptionInputField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 313,
      height: 128,
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
      child: Center(
        child: TextField(
          controller: controller,
          maxLines: 6,
          maxLength: 200,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          style: const TextStyle(
            fontFamily: 'VCR_OSD_MONO',
            fontSize: 16,
            color: Colors.black54,
          ),
          decoration: const InputDecoration(
            hintText: 'Describe your task here...',
            hintStyle: TextStyle(
              fontFamily: 'VCR_OSD_MONO',
              fontSize: 16,
              color: Colors.black54,
            ),
            border: InputBorder.none,
            counterText: '',
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            isDense: true,
          ),
        ),
      ),
    );
  }
}
