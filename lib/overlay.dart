// Custom painter to create an overlay with 6 transparent corner squares
import 'package:flutter/material.dart';

class OverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.6) // Dark overlay
      ..style = PaintingStyle.fill;

    // Draw the dark overlay covering the whole screen
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Create transparent squares (holes) in the overlay
    final transparentPaint = Paint()
      ..color = Colors.transparent
      ..blendMode = BlendMode.clear;

    // Define the size of each square
    double squareSize = 80; // All squares will have equal width and height

    // Define the positions of the 6 transparent squares (4 corners + 2 on the sides)
    List<Rect> squares = [
      // Top-left corner
      Rect.fromLTWH(0, 0, squareSize, squareSize),
      // Top-right corner
      Rect.fromLTWH(size.width - squareSize, 0, squareSize, squareSize),
      // Bottom-left corner
      Rect.fromLTWH(0, size.height - squareSize, squareSize, squareSize),
      // Bottom-right corner
      Rect.fromLTWH(size.width - squareSize, size.height - squareSize,
          squareSize, squareSize),
      // // Mid-left edge
      // Rect.fromLTWH(
      //     0, size.height / 2 - squareSize / 2, squareSize, squareSize),
      // // Mid-right edge
      // Rect.fromLTWH(size.width - squareSize, size.height / 2 - squareSize / 2,
      //     squareSize, squareSize),
    ];

    // Draw the transparent squares at each position
    for (var square in squares) {
      canvas.drawRect(square, transparentPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
