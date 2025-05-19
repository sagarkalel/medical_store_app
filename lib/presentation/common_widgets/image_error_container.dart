import 'package:flutter/material.dart';
import 'package:medical_store_app/core/theme/app_colors.dart';
import 'package:medical_store_app/core/utils/extensions.dart';

class ImageErrorContainer extends StatelessWidget {
  const ImageErrorContainer({super.key, this.height});
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      decoration:
          BoxDecoration(color: context.theme.primaryColor.withAlpha(20)),
      child: const Icon(
        Icons.image_not_supported,
        size: 40,
        color: AppColors.textLight,
      ),
    );
  }
}
