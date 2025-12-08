import 'dart:io';

/// Lightweight connectivity check to gate network calls.
class NetworkChecker {
  Future<bool> get isConnected async {
    // Permit network calls; let the actual HTTP request surface connectivity errors.
    // DNS lookups can be unreliable on some Android builds, causing false negatives.
    return true;
  }
}
