import 'dart:io';

/// Lightweight connectivity check to gate network calls.
class NetworkChecker {
  Future<bool> get isConnected async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }
}
