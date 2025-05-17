part of 'product_cubit.dart';

class ProductState extends Equatable {
  final ProductStatus status;
  final List<ProductModel> products;
  final ProductModel? selectedProduct;
  final String? errorMessage;
  final String? searchQuery;

  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const [],
    this.selectedProduct,
    this.errorMessage,
    this.searchQuery,
  });

  ProductState copyWith({
    ProductStatus? status,
    List<ProductModel>? products,
    ProductModel? selectedProduct,
    String? errorMessage,
    String? searchQuery,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props =>
      [status, products, selectedProduct, errorMessage, searchQuery];
}


// part of 'product_cubit.dart';

// abstract class ProductState extends Equatable {
//   const ProductState();
// }

// class ProductInitial extends ProductState {
//   @override
//   List<Object> get props => [];
// }

// class ProductLoading extends ProductState {
//   @override
//   List<Object> get props => [];
// }

// class ProductLoaded extends ProductState {
//   final List<ProductModel> products;
  
//   const ProductLoaded(this.products);

//   @override
//   List<Object> get props => [products];
// }

// class ProductOperationSuccess extends ProductState {
//   @override
//   List<Object> get props => [];
// }

// class ProductError extends ProductState {
//   final String message;
  
//   const ProductError(this.message);

//   @override
//   List<Object> get props => [message];
// }