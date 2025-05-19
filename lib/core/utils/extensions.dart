import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 0;
  bool get isTablet => screenWidth >= 600;
  bool get isDesktop => screenWidth >= 1200;

  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? theme.colorScheme.error : null,
      ),
    );
  }
}

extension StringExtensions on String {
  String get capitalize =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';
  String get capitalizeFirstLetter =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  String get capitalizeWords => isEmpty
      ? ''
      : split(' ').map((word) => word.capitalizeFirstLetter).join(' ');
  // String toTitleCase() {
  //   return split(' ')
  //       .where((word) => word.isNotEmpty)
  //       .map((word) =>
  //           '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
  //       .join(' ');
  // }
}

extension DateTimeExtensions on DateTime {
  String get formattedDate => DateFormat('dd-MM-yyyy').format(this);
  String get formattedDateTime => DateFormat('dd-MM-yyyy HH:mm').format(this);
  String get formattedTime => DateFormat('HH:mm').format(this);

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(Duration(days: 6));
    return isAfter(startOfWeek) && isBefore(endOfWeek);
  }

  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }
}

extension DoubleExtensions on double {
  String get toCurrency =>
      NumberFormat.currency(symbol: 'Rs ', decimalDigits: 2).format(this);
}
