import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String textHint;
  final bool multiline;
  final TextEditingController controller;
  final String? initialText;

  const TextInput({super.key, required this.textHint, required this.multiline, required this.controller, this.initialText});

  @override
  Widget build(BuildContext context) {
    controller.text = initialText ?? '';

    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
            color: const Color(0xff1D1617).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0)
      ]),
      child: TextField(
        controller: controller,
        keyboardType: multiline ? TextInputType.multiline : TextInputType.text,
        maxLines: multiline ? 7 : 1,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
            hintText: textHint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none)),
      ),
    );
  }
}