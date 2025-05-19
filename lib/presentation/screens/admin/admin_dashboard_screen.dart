import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_store_app/data/models/product_model.dart';
import 'package:medical_store_app/presentation/common_widgets/app_drawer.dart';
import 'package:medical_store_app/presentation/screens/admin/add_edit_product_screen.dart';
import 'package:medical_store_app/presentation/common_widgets/custom_text_field.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../logic/product/product_cubit.dart';
import '../../common_widgets/custom_button.dart';
import '../../common_widgets/loading_indicator.dart';
import '../../common_widgets/product_card.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Store'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () =>
            _navigateToAddEditScreen(context.read<ProductCubit>(), null),
      ).animate().scale(delay: 300.ms),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchField(),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state.status == ProductStatus.loading) {
                    return const LoadingIndicator();
                  } else if (state.status == ProductStatus.loaded) {
                    final products = state.products.where((product) {
                      return product.name
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase());
                    }).toList();

                    return products.isEmpty
                        ? _buildEmptyState()
                        : _buildProductGrid(products);
                  }
                  return const Text('Error loading products');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return CustomTextField(
      controller: _searchController,
      hint: 'Search products...',
      prefixIcon: Icons.search,
      suffixIcon: Icons.clear,
      contentPadding: EdgeInsets.zero,
      onChanged: (value) => setState(() => _searchQuery = value),
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildProductGrid(List<ProductModel> products) {
    final cubit = context.read<ProductCubit>();
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.83,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) => ProductCard(
        product: products[index],
        isAdmin: true,
        onTap: () => _navigateToAddEditScreen(cubit, products[index]),
        onEdit: () => _navigateToAddEditScreen(cubit, products[index]),
        onDelete: () => _confirmDelete(products[index]),
      ),
    ).animate().slideY(duration: 300.ms);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.medical_services, size: 80, color: AppColors.textLight),
          const SizedBox(height: 16),
          Text('No products found', style: TextStyles.heading3),
          const SizedBox(height: 8),
          Text('Tap + to add new products',
              style: TextStyles.bodyLarge.copyWith(color: AppColors.textLight)),
        ],
      ),
    );
  }

  void _navigateToAddEditScreen(ProductCubit cubit, ProductModel? product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: AddEditProductScreen(product: product),
        ),
      ),
    ).then((_) async {
      await Future.delayed(Duration(milliseconds: 500));
      cubit.loadProducts();
    });
  }

  void _confirmDelete(ProductModel product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete ${product.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          CustomButton(
            text: 'Delete',
            type: ButtonType.secondary,
            onPressed: () {
              context.read<ProductCubit>().deleteProduct(product.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    // Implement filter logic
  }
}
