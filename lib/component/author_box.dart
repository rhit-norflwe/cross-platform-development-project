import 'package:flutter/material.dart';
import 'package:notesbysubject/component/profile_image.dart';

class AuthorBox extends StatelessWidget {
  final String imageUrl;
  final String name;

  const AuthorBox({
    required this.imageUrl,
    required this.name,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ProfileImage(
              imageUrl: imageUrl,
              radius: 50.0,
            ),
            Text(name.isEmpty ? "Unknown" : name),
          ],
        ),
      ),
    );
  }
}
