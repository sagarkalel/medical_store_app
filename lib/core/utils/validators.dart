class Validators {
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  static String? requiredNumber(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    if (double.tryParse(value) == null) return 'Invalid number';
    return null;
  }

  static String? validateCategory(String? value) {
    return required(value, fieldName: 'Category');
  }

  static String? validateBrand(String? value) {
    return required(value, fieldName: 'Brand');
  }

  static String? validateDosage(String? value) {
    return required(value, fieldName: 'Dosage');
  }

  static String? validateUses(String? value) {
    return required(value, fieldName: 'Uses');
  }

  static String? validateSideEffects(String? value) {
    return required(value, fieldName: 'Side Effects');
  }

  static String? validateStockQuantity(String? value) {
    if (value == null || value.isEmpty) return 'Stock quantity required';
    final quantity = int.tryParse(value);
    if (quantity == null) return 'Invalid number';
    if (quantity < 0) return 'Cannot be negative';
    return null;
  }

  static String? validateDiscount(String? value) {
    if (value == null || value.isEmpty) return null;
    final discount = double.tryParse(value);
    if (discount == null) return 'Invalid percentage';
    if (discount < 0 || discount > 100) return '0-100% only';
    return null;
  }

  static String? validateExpiryDate(DateTime date) {
    if (date.isBefore(DateTime.now())) return 'Expiry date cannot be in past';
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price is required';
    }
    try {
      final price = double.parse(value);
      if (price <= 0) {
        return 'Price must be greater than zero';
      }
    } catch (e) {
      return 'Please enter a valid price';
    }
    return null;
  }

  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Quantity is required';
    }
    try {
      final quantity = int.parse(value);
      if (quantity < 0) {
        return 'Quantity cannot be negative';
      }
    } catch (e) {
      return 'Please enter a valid quantity';
    }
    return null;
  }
}
