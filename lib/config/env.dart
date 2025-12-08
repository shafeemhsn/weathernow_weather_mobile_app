import '../core/constants/api_constants.dart';

class Env {
  /// API key should be provided via --dart-define or env to avoid shipping secrets.
  static const String apiKey = String.fromEnvironment(
    ApiConstants.apiKeyEnvKey,
    defaultValue: '',
  );

  static const String baseUrl = ApiConstants.baseUrl;
}
