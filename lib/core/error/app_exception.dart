class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;
  final StackTrace? stackTrace;

  AppException(this.message, {this.statusCode, this.originalError, this.stackTrace});

  @override
  String toString() => 'AppException: $message';
}

class ServerException extends AppException {
  ServerException(super.message, {super.statusCode, super.originalError, super.stackTrace});

  @override
  String toString() => 'ServerException: $message (Code: $statusCode)';
}

class CacheException extends AppException {
  CacheException(super.message, {super.originalError, super.stackTrace});

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException extends AppException {
  NetworkException(super.message, {super.originalError, super.stackTrace});

  @override
  String toString() => 'NetworkException: $message';
}

class ValidationException extends AppException {
  final Map<String, List<String>>? errors;

  ValidationException(super.message, {this.errors, super.originalError, super.stackTrace});

  @override
  String toString() => 'ValidationException: $message';
}

class UnauthorizedException extends AppException {
  UnauthorizedException(super.message, {super.originalError, super.stackTrace}) : super(statusCode: 401);

  @override
  String toString() => 'UnauthorizedException: $message';
}

class NotFoundException extends AppException {
  NotFoundException(super.message, {super.originalError, super.stackTrace}) : super(statusCode: 404);

  @override
  String toString() => 'NotFoundException: $message';
}
