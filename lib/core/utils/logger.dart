import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class Logger {
  static const String _prefix = '🔥 APP';

  static void debug(String message, [dynamic data]) {
    _log(LogLevel.debug, message, data);
  }

  static void info(String message, [dynamic data]) {
    _log(LogLevel.info, message, data);
  }

  static void warning(String message, [dynamic data]) {
    _log(LogLevel.warning, message, data);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _log(LogLevel.error, message, error);
    if (stackTrace != null && kDebugMode) {
      debugPrint('$_prefix StackTrace: $stackTrace');
    }
  }

  static void _log(LogLevel level, String message, [dynamic data]) {
    if (kDebugMode) {
      final emoji = _getEmoji(level);
      final timestamp = DateTime.now().toIso8601String();
      debugPrint('$emoji $_prefix [$level] $timestamp: $message');
      if (data != null) {
        debugPrint('$emoji $_prefix Data: $data');
      }
    }
  }

  static String _getEmoji(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🐛';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
    }
  }
}
