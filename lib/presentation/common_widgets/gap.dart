import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  const Gap(this.val, {super.key});
  final double val;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: val, width: val);
  }
}
