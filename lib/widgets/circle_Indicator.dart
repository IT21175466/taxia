import 'package:flutter/material.dart';

class DotIndicator extends Decoration {
  const DotIndicator({
    this.color = Colors.white,
    this.radius = 5.0,
    this.padding = const EdgeInsets.symmetric(vertical: 5),
  });

  final Color color;
  final double radius;
  final EdgeInsets padding;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _DotPainter(
      color: color,
      radius: radius,
      padding: padding,
      onChange: onChanged,
    );
  }
}

class _DotPainter extends BoxPainter {
  _DotPainter({
    required this.color,
    required this.radius,
    required this.padding,
    VoidCallback? onChange,
  })  : _paint = Paint()
          ..color = color
          ..style = PaintingStyle.fill,
        super(onChange);

  final Paint _paint;
  final Color color;
  final double radius;
  final EdgeInsets padding;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final double centerX = rect.bottomCenter.dx;
    final double centerY = rect.bottomCenter.dy - radius;

    final double paddingLeft = padding.left;
    final double paddingTop = padding.top;

    final double paddedCenterX = centerX + paddingLeft;
    final double paddedCenterY = centerY - paddingTop;

    canvas.drawCircle(
      Offset(paddedCenterX, paddedCenterY),
      radius,
      _paint,
    );
  }
}
