import 'package:flutter/material.dart';

class DisplayCard extends StatelessWidget {
  final String labelText;
  final String displayText;
  final String subjectText;

  const DisplayCard({
    super.key,
    required this.labelText,
    required this.displayText,
    required this.subjectText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 30.0,
            fontFamily: "Rowdies",
          ),
        ),
        Text(
          subjectText,
          style: const TextStyle(
            fontSize: 25.0,
            fontFamily: "Rowdies",
          ),
        ),
        Card(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Text(
                    displayText,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}