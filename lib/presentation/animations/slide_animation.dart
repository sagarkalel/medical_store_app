import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum SlideDirection { fromLeft, fromRight, fromTop, fromBottom }

class SlideAnimation extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final SlideDirection direction;
  final double distance;

  const SlideAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.delay = Duration.zero,
    this.curve = Curves.easeInOut,
    this.direction = SlideDirection.fromBottom,
    this.distance = 0.2,
  });

  @override
  Widget build(BuildContext context) {
    final Offset begin = _getBeginOffset();

    return child.animate(
      delay: delay,
      effects: [
        SlideEffect(
          duration: duration,
          curve: curve,
          begin: begin,
          end: Offset.zero,
        ),
      ],
    );
  }

  Offset _getBeginOffset() {
    switch (direction) {
      case SlideDirection.fromLeft:
        return Offset(-distance, 0);
      case SlideDirection.fromRight:
        return Offset(distance, 0);
      case SlideDirection.fromTop:
        return Offset(0, -distance);
      case SlideDirection.fromBottom:
        return Offset(0, distance);
    }
  }
}
