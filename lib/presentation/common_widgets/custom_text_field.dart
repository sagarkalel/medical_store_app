import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool readOnly;
  final int maxLines;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final Function(String)? onChanged;
  final Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextInputAction textInputAction;
  final String? initialValue;
  final bool showCursor;
  final double borderRadius;
  final EdgeInsets? contentPadding;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.onChanged,
    this.onTap,
    this.inputFormatters,
    this.focusNode,
    this.autofocus = false,
    this.textInputAction = TextInputAction.next,
    this.initialValue,
    this.showCursor = true,
    this.borderRadius = 8,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: readOnly,
      maxLines: maxLines,
      onChanged: onChanged,
      onTap: onTap,
      inputFormatters: inputFormatters,
      focusNode: focusNode,
      autofocus: autofocus,
      textInputAction: textInputAction,
      showCursor: showCursor,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon),
                onPressed: onSuffixIconPressed,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        fillColor: readOnly ? AppColors.background : Colors.white,
        filled: true,
      ),
    );
  }
}
