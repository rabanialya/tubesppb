import 'package:flutter/material.dart';

class HomeCarousel extends StatelessWidget {
  final List<String> images;
  final PageController controller;

  const HomeCarousel({
    super.key,
    required this.images,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: controller,
        itemCount: images.length,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(images[i], fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}