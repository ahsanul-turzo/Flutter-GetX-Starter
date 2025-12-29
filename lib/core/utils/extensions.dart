import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../network/api_result.dart';

/// String Extensions
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String capitalizeEachWord() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalizeFirst).join(' ');
  }

  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  bool get isValidPhone {
    return RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(this);
  }

  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }
}

/// DateTime Extensions
extension DateTimeExtension on DateTime {
  String format([String pattern = 'yyyy-MM-dd HH:mm:ss']) {
    return DateFormat(pattern).format(this);
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${difference.inDays >= 730 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${difference.inDays >= 60 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }
}

/// Response Extension for GetConnect
extension ResponseExtension on Response {
  ApiResult<T> toApiResult<T>({required T Function(dynamic) parser, String? customErrorMessage}) {
    try {
      if (isOk && body != null) {
        final data = parser(body);
        return Success(data);
      } else {
        final errorMessage = customErrorMessage ?? body?['message'] ?? statusText ?? 'Unknown error occurred';
        return Failure(errorMessage, statusCode: statusCode);
      }
    } catch (e) {
      return Failure('Failed to parse response: $e');
    }
  }

  bool get isSuccess => statusCode != null && statusCode! >= 200 && statusCode! < 300;
}

/// BuildContext Extensions
extension ContextExtension on BuildContext {
  // Navigation shortcuts
  Future<T?> push<T>(Widget page) {
    return Navigator.push<T>(this, MaterialPageRoute(builder: (_) => page));
  }

  void pop<T>([T? result]) {
    Navigator.pop(this, result);
  }

  // Theme shortcuts
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  // MediaQuery shortcuts
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get padding => MediaQuery.of(this).padding;
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  // Show snackbar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(
      this,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: isError ? Colors.red : null));
  }
}

/// List Extensions
extension ListExtension<T> on List<T> {
  List<T> updateWhere(bool Function(T) test, T Function(T) update) {
    return map((item) => test(item) ? update(item) : item).toList();
  }

  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

/// Num Extensions
extension NumExtension on num {
  String get currencyFormat {
    return NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(this);
  }

  String get compactFormat {
    return NumberFormat.compact().format(this);
  }
}
