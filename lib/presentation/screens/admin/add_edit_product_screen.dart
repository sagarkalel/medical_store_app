import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../data/models/product_model.dart';
import '../../../logic/product/product_cubit.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

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
          if (state.status == ProductStatus.loaded) {
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
    return GestureDetector(
      onTap: _pickImages,
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
          child: Image.asset(imagePath, fit: BoxFit.cover),
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
          // validator: Validators.required,
          onChanged: (value) => _product.name = value,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Description',
          initialValue: _product.description,
          maxLines: 3,
          // validator: Validators.required,
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
                // validator: Validators.requiredNumber,
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
