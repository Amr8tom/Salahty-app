import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final double? opacity;
  final AlignmentGeometry? aligment;
  final double? height;
  final String? imagePath;

  const CustomImage({
    super.key,
    this.imagePath,
    this.height,
    this.opacity, this.aligment,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity!,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Align(
          alignment:aligment?? Alignment.center,
          child: Image.asset(
            imagePath!,
            height: height,
          ),
        ),
      ),
    );
  }
}
