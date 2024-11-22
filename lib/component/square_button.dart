import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  final String displayText;
  final Function() onPressCallback;

  const SquareButton({
    required this.displayText,
    required this.onPressCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.0,
      height: 40.0,
      margin: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: TextButton(
        onPressed: onPressCallback,
        child: Text(
          displayText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}