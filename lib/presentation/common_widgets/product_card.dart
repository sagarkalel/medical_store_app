import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:medical_store_app/presentation/common_widgets/image_error_container.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/text_styles.dart';
import '../../core/utils/extensions.dart';
import '../../data/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final bool isAdmin;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.isAdmin = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Stack(
              children: [
                SizedBox(
                  height: 100,
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: product.imageUrls.isNotEmpty
                        ? Image.asset(
                            product.imageUrls.first,
                            height: 110,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, e, s) =>
                                ImageErrorContainer(height: 80),
                          )
                        : ImageErrorContainer(height: 100),
                  ),
                ),
                if (product.discountPercentage > 0) ...[
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.discount,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                        style: TextStyles.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
                if (product.prescriptionRequired) ...[
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.prescription,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Rx',
                        style: TextStyles.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            // Product info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name
                  Text(
                    product.name,
                    style: TextStyles.heading4,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Brand
                  Text(
                    product.brand,
                    style: TextStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (product.discountPercentage > 0) ...[
                        Text(
                          product.price.toCurrency,
                          style: TextStyles.priceOriginal,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        product.discountedPrice.toCurrency,
                        style: TextStyles.priceDiscounted,
                      ),
                    ],
                  ),
                  // if (isAdmin)
                  //   Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       IconButton(
                  //         icon:
                  //             const Icon(Icons.edit, color: AppColors.primary),
                  //         onPressed: onEdit,
                  //         padding: EdgeInsets.zero,
                  //         constraints: const BoxConstraints(),
                  //       ),
                  //       const SizedBox(width: 8),
                  //       IconButton(
                  //         icon:
                  //             const Icon(Icons.delete, color: AppColors.error),
                  //         onPressed: onDelete,
                  //         padding: EdgeInsets.zero,
                  //         constraints: const BoxConstraints(),
                  //       ),
                  //     ],
                  //   ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slide(begin: const Offset(0, 0.1), duration: 300.ms);
  }
}
