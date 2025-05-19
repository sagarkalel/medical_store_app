import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_store_app/core/utils/extensions.dart';
import 'package:medical_store_app/core/utils/validators.dart';
import 'package:medical_store_app/presentation/common_widgets/image_error_container.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../data/models/product_model.dart';
import '../../../logic/product/product_cubit.dart';
import '../../common_widgets/custom_button.dart';
import '../../common_widgets/custom_text_field.dart';

class AddEditProductScreen extends StatefulWidget {
  final ProductModel? product;

  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late ProductModel _product;
  final List<String> _imagePaths = [];
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _product = widget.product?.copyWith() ??
        ProductModel(
          name: '',
          description: '',
          price: 0,
          brand: '',
          imageUrls: [],
          category: '',
          stockQuantity: 0,
          dosage: '',
          uses: '',
          sideEffects: '',
          expiryDate: DateTime.now(),
        );
    _imagePaths.addAll(_product.imageUrls);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
        actions: [
          if (widget.product != null)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _submitForm,
            ),
        ],
      ),
      body: BlocListener<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state.status == ProductStatus.updated) {
            context.showSnackBar('Successfully updated!');
            Navigator.pop(context);
          } else if (state.status == ProductStatus.deleted) {
            context.showSnackBar('Successfully delted!');
            Navigator.pop(context);
          } else if (state.status == ProductStatus.newAdded) {
            context.showSnackBar('Successfully added!');
            Navigator.pop(context);
          } else if (state.status == ProductStatus.error) {
            context.showSnackBar(state.errorMessage!);
            Navigator.pop(context);
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildImagePickerSection(),
                const SizedBox(height: 24),
                _buildProductFormFields(),
                const SizedBox(height: 32),
                if (widget.product == null)
                  CustomButton(
                    text: 'Save Product',
                    onPressed: _submitForm,
                    isLoading: context.watch<ProductCubit>().state.status ==
                        ProductStatus.loading,
                  ),
              ],
            ).animate().fadeIn(delay: 200.ms),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePickerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Product Images', style: TextStyles.bodyLarge),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.2,
          ),
          itemCount: _imagePaths.length + 1,
          itemBuilder: (context, index) {
            if (index == _imagePaths.length) {
              return _buildAddImageButton();
            }
            return _buildImageItem(_imagePaths[index]);
          },
        ),
      ],
    );
  }

  Widget _buildAddImageButton() {
    return InkWell(
      onTap: _pickImages,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        child:
            const Icon(Icons.add_a_photo, size: 40, color: AppColors.primary),
      ),
    );
  }

  Widget _buildImageItem(String imagePath) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            height: 120,
            errorBuilder: (c, _, s) => const ImageErrorContainer(),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removeImage(imagePath),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductFormFields() {
    return Column(
      children: [
        CustomTextField(
          label: 'Product Name',
          initialValue: _product.name,
          validator: Validators.required,
          onChanged: (value) => _product.name = value,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Description',
          initialValue: _product.description,
          maxLines: 3,
          validator: Validators.required,
          onChanged: (value) => _product.description = value,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Price',
                initialValue: _product.price.toString(),
                keyboardType: TextInputType.number,
                validator: Validators.requiredNumber,
                onChanged: (value) => _product.price = double.parse(value),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                label: 'Discount %',
                initialValue: _product.discountPercentage.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    _product.discountPercentage = double.parse(value),
              ),
            ),
          ],
        ),
        // Add more form fields following the same pattern

        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Brand',
                initialValue: _product.brand,
                validator: Validators.validateBrand,
                onChanged: (value) => _product.brand = value,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                label: 'Category',
                initialValue: _product.category,
                validator: Validators.validateCategory,
                onChanged: (value) => _product.category = value,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Stock Quantity',
          initialValue: _product.stockQuantity.toString(),
          keyboardType: TextInputType.number,
          validator: Validators.validateStockQuantity,
          onChanged: (value) => _product.stockQuantity = int.parse(value),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Dosage',
          initialValue: _product.dosage,
          validator: Validators.validateDosage,
          maxLines: 2,
          onChanged: (value) => _product.dosage = value,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Uses',
          initialValue: _product.uses,
          validator: Validators.validateUses,
          maxLines: 3,
          onChanged: (value) => _product.uses = value,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Side Effects',
          initialValue: _product.sideEffects,
          validator: Validators.validateSideEffects,
          maxLines: 3,
          onChanged: (value) => _product.sideEffects = value,
        ),
        const SizedBox(height: 16),
        _buildExpiryDateField(),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Prescription Required'),
          value: _product.prescriptionRequired,
          onChanged: (value) =>
              setState(() => _product.prescriptionRequired = value),
        ),
      ],
    );
  }

  Widget _buildExpiryDateField() {
    return ListTile(
      title: const Text('Expiry Date'),
      subtitle: Text(
          '${_product.expiryDate.day}/${_product.expiryDate.month}/${_product.expiryDate.year}'),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _product.expiryDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          setState(() => _product.expiryDate = date);
        }
      },
    );
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _imagePaths.addAll(pickedFiles.map((file) => file.path));
        _product.imageUrls = _imagePaths;
      });
    }
  }

  void _removeImage(String path) {
    setState(() {
      _imagePaths.remove(path);
      _product.imageUrls = _imagePaths;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (widget.product == null) {
        context.read<ProductCubit>().addProduct(_product);
      } else {
        context.read<ProductCubit>().updateProduct(_product);
      }
    }
  }
}
