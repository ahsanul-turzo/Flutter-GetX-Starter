// lib/services/api_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_get_starter/controllers/auth_controller.dart';
import 'package:flutter_get_starter/core/constants/app_constants.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';

import '../routes/app_routes.dart';

class ApiService extends GetConnect {
  // Add a separate GetConnect instance for custom URLs
  late final GetConnect customUrlClient;

  @override
  void onInit() {
    httpClient.baseUrl = AppConstants.apiBaseUrl;
    httpClient.timeout = const Duration(seconds: 30);

    // Initialize custom URL client WITHOUT baseUrl
    customUrlClient = GetConnect();
    customUrlClient.httpClient.baseUrl = AppConstants.rootUrl;
    customUrlClient.httpClient.timeout = const Duration(seconds: 30);
    // DON'T set baseUrl for customUrlClient

    // Request modifier for main client
    httpClient.addRequestModifier<dynamic>((request) {
      return _requestModifier(request);
    });

    // Response modifier for main client
    httpClient.addResponseModifier((request, response) {
      return _responseModifier(request, response);
    });

    // Add the SAME modifiers to custom URL client's httpClient
    customUrlClient.httpClient.addRequestModifier<dynamic>((request) {
      return _requestModifier(request);
    });

    customUrlClient.httpClient.addResponseModifier((request, response) {
      return _responseModifier(request, response);
    });

    super.onInit();
  }

  // Request modifier - adds auth token and headers
  Request _requestModifier(Request request) {
    // Add authentication token if available
    try {
      if (Get.isRegistered<AuthController>()) {
        final token = Get.find<AuthController>().token.value;
        if (token.isNotEmpty) {
          request.headers['Authorization'] = 'Bearer $token';
        }
      }
    } catch (e) {
      debugPrint('⚠️ Auth token not available');
    }

    // Add common headers
    request.headers['Content-Type'] = 'application/json';
    request.headers['Accept'] = 'application/json';
    request.headers['X-App-Version'] = AppConstants.appVersion;
    request.headers['X-Platform'] = GetPlatform.isAndroid ? 'android' : 'ios';

    // Debug logging
    if (AppConstants.enableApiLogs) {
      debugPrint('\n');
      debugPrint('╔══════════════════════════════════════════════════════════════');
      debugPrint('║ 📤 REQUEST');
      debugPrint('╠══════════════════════════════════════════════════════════════');
      debugPrint('║ Method: ${request.method}');
      debugPrint('║ URL: ${request.url}');
      debugPrint('║ Headers: ${request.headers}');
      if (request.method != 'GET' && request.files != null) {
        debugPrint('║ Body: ${request.files}');
      }
      debugPrint('╚══════════════════════════════════════════════════════════════');
      debugPrint('\n');
    }

    return request;
  }

  // Response modifier - handles global response logic
  Response _responseModifier(Request request, Response response) {
    if (AppConstants.enableApiLogs) {
      debugPrint('\n');
      debugPrint('╔══════════════════════════════════════════════════════════════');
      debugPrint('║ 📥 RESPONSE');
      debugPrint('╠══════════════════════════════════════════════════════════════');
      debugPrint('║ Status Code: ${response.statusCode}');
      debugPrint('║ Status Text: ${response.statusText}');
      debugPrint('║ Body: ${response.bodyString}');
      debugPrint('╚══════════════════════════════════════════════════════════════╠');
      debugPrint('\n');
    }

    // Handle specific status codes globally
    if (response.statusCode == 401 && !request.url.path.endsWith('/admin/auth/login')) {
      _handleUnauthorized();
    } else if (response.statusCode == 403) {
      _handleForbidden();
    } else if (response.statusCode == 503) {
      _handleMaintenanceMode();
    }

    return response;
  }

  // Handle unauthorized access
  void _handleUnauthorized() {
    if (Get.isRegistered<AuthController>()) {
      Get.find<AuthController>().logout();
      Get.offAllNamed(AppRoutes.login);
      Get.snackbar('Session Expired', 'Please login again', snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Handle forbidden access
  void _handleForbidden() {
    Get.snackbar(
      'Access Denied',
      'You do not have permission to perform this action',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Handle maintenance mode
  void _handleMaintenanceMode() {
    Get.snackbar(
      'Maintenance',
      'The app is currently under maintenance. Please try again later.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
    );
  }

  Future<Response<T>> getWithCustomUrl<T>(
    String fullUrl, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
  }) {
    return customUrlClient.get(fullUrl, headers: headers, contentType: contentType, query: query, decoder: decoder);
  }

  // Generic GET request
  @override
  Future<Response<T>> get<T>(
    String url, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
  }) {
    return super.get(url, headers: headers, contentType: contentType, query: query, decoder: decoder);
  }

  // Generic POST request
  @override
  Future<Response<T>> post<T>(
    String? url,
    dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
    Progress? uploadProgress,
  }) {
    return super.post(
      url,
      body,
      contentType: contentType,
      headers: headers,
      query: query,
      decoder: decoder,
      uploadProgress: uploadProgress,
    );
  }

  // Generic PUT request
  @override
  Future<Response<T>> put<T>(
    String url,
    dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
    Progress? uploadProgress,
  }) {
    return super.put(
      url,
      body,
      contentType: contentType,
      headers: headers,
      query: query,
      decoder: decoder,
      uploadProgress: uploadProgress,
    );
  }

  // Generic PATCH request
  @override
  Future<Response<T>> patch<T>(
    String url,
    dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
    Progress? uploadProgress,
  }) {
    return super.patch(
      url,
      body,
      contentType: contentType,
      headers: headers,
      query: query,
      decoder: decoder,
      uploadProgress: uploadProgress,
    );
  }

  // Generic DELETE request
  @override
  Future<Response<T>> delete<T>(
    String url, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
  }) {
    return super.delete(url, headers: headers, contentType: contentType, query: query, decoder: decoder);
  }
}
