class APIResponse<T> {
  late final String message;
  late final dynamic data;
  late final int? statusCode;

  APIResponse.fromJson(dynamic jsonResponse, this.statusCode) {
    message = jsonResponse['message'] ?? '';
    data = jsonResponse['data'];
  }

  @override
  String toString() {
    return 'APIResponse{message: $message, data: $data}';
  }
}
