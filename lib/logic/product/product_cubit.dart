import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

part 'product_state.dart';

enum ProductStatus {
  initial,
  loading,
  loaded,
  error,
  updated,
  newAdded,
  deleted
}

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _productRepository;

  ProductCubit(productRepository)
      : _productRepository = productRepository,
        super(const ProductState()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    emit(state.copyWith(status: ProductStatus.loading));

    try {
      final products = _productRepository.getAllProducts();
      emit(state.copyWith(
        status: ProductStatus.loaded,
        products: products,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProductStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> getProductById(String id) async {
    emit(state.copyWith(status: ProductStatus.loading));

    try {
      final product = _productRepository.getProductById(id);
      emit(state.copyWith(
        status: ProductStatus.loaded,
        selectedProduct: product,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProductStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> addProduct(ProductModel product) async {
    emit(state.copyWith(status: ProductStatus.loading));

    try {
      await _productRepository.addProduct(product);
      final products = _productRepository.getAllProducts();
      emit(state.copyWith(
        status: ProductStatus.newAdded,
        products: products,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProductStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    emit(state.copyWith(status: ProductStatus.loading));

    try {
      await _productRepository.updateProduct(product);
      final products = _productRepository.getAllProducts();
      emit(state.copyWith(
        status: ProductStatus.updated,
        products: products,
        selectedProduct: product,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProductStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> deleteProduct(String id) async {
    emit(state.copyWith(status: ProductStatus.loading));

    try {
      await _productRepository.deleteProduct(id);
      final products = _productRepository.getAllProducts();
      emit(state.copyWith(
        status: ProductStatus.deleted,
        products: products,
        selectedProduct: null,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProductStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> searchProducts(String query) async {
    emit(state.copyWith(status: ProductStatus.loading));

    try {
      final products = query.isEmpty
          ? _productRepository.getAllProducts()
          : _productRepository.searchProducts(query);

      emit(state.copyWith(
        status: ProductStatus.loaded,
        products: products,
        searchQuery: query,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProductStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
