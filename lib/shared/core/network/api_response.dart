class APIResponse<T> {
  late final String message;
  late final dynamic data;
  late final int? statusCode;

  APIResponse.fromJson(dynamic jsonResponse, this.statusCode) {
    data = jsonResponse;
  }

  @override
  String toString() {
    return 'APIResponse{message: $message, data: $data}';
  }
}
