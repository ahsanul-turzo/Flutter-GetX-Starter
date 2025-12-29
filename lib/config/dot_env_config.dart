import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class DotEnvConfig {
  DotEnvConfig._(); // prevent instantiation

  static bool _envBool(String key, {required bool fallback}) {
    final v = dotenv.env[key]?.trim().toLowerCase();
    if (v == null) return fallback;
    return v == 'true' || v == '1' || v == 'yes';
  }

  static bool get isLive => _envBool('IS_LIVE', fallback: kReleaseMode);

  static String get apiBaseUrl {
    final url = dotenv.env['API_URL'];

    if (url == null || url.isEmpty) {
      throw StateError('❌ API_URL is missing in .env');
    }

    return url;
  }
}
