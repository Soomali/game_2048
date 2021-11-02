import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_2048/gameState/gameState.dart';

class Tile extends StatelessWidget {
  final int number;
  const Tile({Key? key, required this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: GameState.tileSize,
      height: GameState.tileSize,
      child: number == 0
          ? ColoredBox(color: Colors.red)
          : CustomPaint(
              painter: TilePainter(number: number),
            ),
    );
  }
}

class AnimatedTile extends StatelessWidget {
  final int number;
  final Move move;
  const AnimatedTile({Key? key, required this.move, required this.number})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: 40),
        duration: Duration(milliseconds: 500),
        builder: (context, val, _) {
          return CustomPaint(
            painter: AnimatedTilePainter(number, val, move),
          );
        });
  }
}

class AnimatedTilePainter extends CustomPainter {
  final int number;
  final Move move;
  final double movement; //0 started
  AnimatedTilePainter(this.number, this.movement, this.move);
  @override
  void paint(Canvas canvas, Size size) {
    _drawRect(canvas, size);
    _drawText(canvas, size);
  }

  Offset get _movementEffect {
    switch (move) {
      case Move.right:
        return Offset(movement, 0);

      case Move.left:
        return Offset(-movement, 0);
      case Move.up:
        return Offset(0, -movement);
      case Move.down:
        return Offset(0, movement);
    }
  }

  void _drawRect(Canvas canvas, Size size) {
    final r = 255 - ((tan(number) * 255)).toInt().abs();
    final g = 255 - (cos(number) * 255).toInt().abs();
    final b = 100 + ((g / r) * 255).toInt() % 255;
    final rect = Rect.fromCenter(
        center: Offset(0, 0) + _movementEffect,
        width: GameState.tileSize,
        height: GameState.tileSize);
    final rectPaint = Paint()..color = Color.fromARGB(255, r, g, b);
    canvas.drawRect(rect, rectPaint);
  }

  void _drawText(Canvas canvas, Size size) {
    final span = TextSpan(
        text: '$number', style: TextStyle(color: Colors.black87, fontSize: 16));
    final textPainter =
        TextPainter(text: span, textDirection: TextDirection.ltr);
    textPainter.layout(maxWidth: size.width);
    textPainter.paint(
        canvas,
        Offset((size.width - textPainter.width) / 2,
                (size.height - textPainter.height) / 2) +
            _movementEffect);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class TilePainter extends CustomPainter {
  final int number;
  TilePainter({required this.number});
  @override
  void paint(Canvas canvas, Size size) {
    _drawRect(canvas, size);
    _drawText(canvas, size);
  }

  void _drawRect(Canvas canvas, Size size) {
    final r = 255 - ((tan(number) * 255)).toInt().abs();
    final g = 255 - (cos(number) * 255).toInt().abs();
    final b = 100 + ((g / r) * 255).toInt() % 255;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rectPaint = Paint()..color = Color.fromARGB(255, r, g, b);
    canvas.drawRect(rect, rectPaint);
  }

  void _drawText(Canvas canvas, Size size) {
    final span = TextSpan(
        text: '$number', style: TextStyle(color: Colors.black87, fontSize: 16));
    final textPainter =
        TextPainter(text: span, textDirection: TextDirection.ltr);
    textPainter.layout(maxWidth: size.width);
    textPainter.paint(
        canvas,
        Offset((size.width - textPainter.width) / 2,
            (size.height - textPainter.height) / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
