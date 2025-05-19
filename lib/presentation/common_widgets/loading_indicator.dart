import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class LoadingIndicator extends StatelessWidget {
  final Color color;
  final double size;
  final double strokeWidth;
  final String? message;

  const LoadingIndicator({
    super.key,
    this.color = AppColors.primary,
    this.size = 40,
    this.strokeWidth = 4,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              color: color,
              strokeWidth: strokeWidth,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
