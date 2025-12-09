import 'dart:io';

import '../core/constants/api_constants.dart';

class Env {
  static const String _localApiKey = 'a222100b53bd56f6ab68f892489224b3';

  static String get apiKey {
    const fromDefine = String.fromEnvironment(
      ApiConstants.apiKeyEnvKey,
      defaultValue: 'a222100b53bd56f6ab68f892489224b3',
    );
    if (fromDefine.isNotEmpty) return fromDefine;
    final fromEnv = Platform.environment[ApiConstants.apiKeyEnvKey];
    if (fromEnv != null && fromEnv.isNotEmpty) return fromEnv;
    return _localApiKey;
  }

  static const String baseUrl = ApiConstants.baseUrl;
}
