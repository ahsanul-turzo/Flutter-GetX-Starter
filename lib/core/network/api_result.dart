/// Sealed class for API results - Type-safe response handling
sealed class ApiResult<T> {
  const ApiResult();
}

class Success<T> extends ApiResult<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends ApiResult<T> {
  final String message;
  final int? statusCode;
  final dynamic error;

  const Failure(this.message, {this.statusCode, this.error});
}

class Loading<T> extends ApiResult<T> {
  const Loading();
}

/// Extension methods for easier handling
extension ApiResultExtension<T> on ApiResult<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
  bool get isLoading => this is Loading<T>;

  T? get dataOrNull => this is Success<T> ? (this as Success<T>).data : null;
  String? get errorOrNull => this is Failure<T> ? (this as Failure<T>).message : null;

  void when({
    required void Function(T data) success,
    required void Function(String message) failure,
    void Function()? loading,
  }) {
    switch (this) {
      case Success<T>(:final data):
        success(data);
      case Failure<T>(:final message):
        failure(message);
      case Loading<T>():
        loading?.call();
    }
  }

  R map<R>({
    required R Function(T data) success,
    required R Function(String message) failure,
    required R Function() loading,
  }) {
    return switch (this) {
      Success<T>(:final data) => success(data),
      Failure<T>(:final message) => failure(message),
      Loading<T>() => loading(),
    };
  }
}
