/// Abstract class for checking network connectivity
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Implementation of NetworkInfo
class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // In a real app, you would use connectivity_plus package
    // For now, we'll assume network is always available
    return true;
  }
}
