class DioClient {
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    // TODO: Replace with real HTTP client.
    return <String, dynamic>{"path": path, "query": queryParameters ?? {}};
  }
}
