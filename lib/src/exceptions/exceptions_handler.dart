class ExceptionHandler {
  static Exception handleError(dynamic error) {
    print(error);
    return Exception('Server error; cause:$error');
  }
}
