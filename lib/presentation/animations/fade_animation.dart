import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FadeAnimation extends StatelessWidget {
  final Widget child;
  final double durationInSec;
  final double delayInSec;
  final Curve curve;
  final double begin;
  final double end;

  const FadeAnimation({
    super.key,
    required this.child,
    this.durationInSec = 0.3,
    this.delayInSec = 0,
    this.curve = Curves.easeInOut,
    this.begin = 0.0,
    this.end = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return child.animate(
      delay: Duration(milliseconds: (delayInSec * 1000).toInt()),
      effects: [
        FadeEffect(
          duration: Duration(milliseconds: (durationInSec * 1000).toInt()),
          curve: curve,
          begin: begin,
          end: end,
        ),
      ],
    );
  }
}
