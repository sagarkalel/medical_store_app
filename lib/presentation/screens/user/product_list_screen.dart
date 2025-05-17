import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../data/models/product_model.dart';
import '../../../logic/product/product_cubit.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/product_card.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Tablets',
    'Syrups',
    'Injectables',
    'Topical',
    'Drops',
    'Supplements',
    'Devices',
  ];

  @override
  void initState() {
    super.initState();
    // context.read<ProductCubit>().fetchAllProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildCategoryFilter(),
            _buildProductsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Medical Store',
                style: TextStyles.bodyLarge,
              ).animate().fadeIn(duration: 600.ms),
              const SizedBox(height: 4),
              Text(
                'Find your medicines & health products',
                style: TextStyles.bodySmall,
              )
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .slide(begin: const Offset(0, 0.5)),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart_outlined, size: 28),
          ).animate().scale(delay: 300.ms),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search medicines, brands...',
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(Icons.search, color: AppColors.primary),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slide(begin: const Offset(0, -0.1));
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(delay: (100 * index).ms)
              .scale(delay: (100 * index).ms);
        },
      ),
    );
  }

  Widget _buildProductsList() {
    return Expanded(
      child: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state.status == ProductStatus.loading) {
            return const Center(child: LoadingIndicator());
          } else if (state.status == ProductStatus.error) {
            return Center(
              child: Text(
                'Error: ${state.errorMessage}',
                style: TextStyles.bodyMedium,
              ),
            );
          } else if (state.products.isEmpty) {
            return const Center(
              child: Text('No products available'),
            );
          }

          final filteredProducts = _filterProducts(state.products);

          return CustomScrollView(
            slivers: [
              const SliverPadding(padding: EdgeInsets.only(top: 16)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = filteredProducts[index];
                      return ProductCard(
                        product: product,
                        onTap: () =>
                            context.push('/product-details/${product.id}'),
                      ).animate().fadeIn(
                            delay: (50 * (index % 10)).ms,
                            duration: 400.ms,
                          );
                    },
                    childCount: filteredProducts.length,
                  ),
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
            ],
          );
        },
      ),
    );
  }

  List<ProductModel> _filterProducts(List<ProductModel> products) {
    return products.where((product) {
      // Filter by category
      if (_selectedCategory != 'All' && product.category != _selectedCategory) {
        return false;
      }

      // Filter by search query
      if (_searchQuery.isEmpty) {
        return true;
      }

      final query = _searchQuery.toLowerCase();
      return product.name.toLowerCase().contains(query) ||
          product.brand.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query);
    }).toList();
  }
}
