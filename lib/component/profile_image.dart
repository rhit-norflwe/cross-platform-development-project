import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String? imageUrl;
  final double radius;

  const ProfileImage({
    required this.imageUrl,
    this.radius = 80.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider? image;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      image = NetworkImage(imageUrl!);
    }

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 4.0,
          color: Colors.black45,
        ),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundImage: image,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        child: image == null
            ? Icon(
                Icons.person,
                size: 1.5 * radius,
              )
            : null,
      ),
    );
  }
}
