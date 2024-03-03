
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MediaMetadata extends StatelessWidget {
  const MediaMetadata(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.title});
  final String imageUrl;
  final String title;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(2, 4), blurRadius: 4)
          ], borderRadius: BorderRadius.circular(10)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              height: 300,
              width: 300,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          name,
          style: const TextStyle(color: Colors.black, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
