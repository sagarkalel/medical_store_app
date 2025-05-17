import 'package:hive/hive.dart';

import '../../core/constants/hive_constants.dart';
import '../models/product_model.dart';

class ProductRepository {
  final Box<ProductModel> _productBox =
      Hive.box<ProductModel>(HiveConstants.productBox);

  List<ProductModel> getAllProducts() {
    return _productBox.values.toList();
  }

  ProductModel? getProductById(String id) {
    return _productBox.get(id);
  }

  Future<void> addProduct(ProductModel product) async {
    await _productBox.put(product.id, product);
  }

  Future<void> updateProduct(ProductModel product) async {
    await _productBox.put(product.id, product);
  }

  Future<void> deleteProduct(String id) async {
    await _productBox.delete(id);
  }

  List<ProductModel> searchProducts(String query) {
    final normalizedQuery = query.toLowerCase();
    return _productBox.values.where((product) {
      return product.name.toLowerCase().contains(normalizedQuery) ||
          product.description.toLowerCase().contains(normalizedQuery) ||
          product.brand.toLowerCase().contains(normalizedQuery) ||
          product.category.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  List<ProductModel> getProductsByCategory(String category) {
    return _productBox.values
        .where((product) =>
            product.category.toLowerCase() == category.toLowerCase())
        .toList();
  }
}
