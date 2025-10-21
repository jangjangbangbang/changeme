import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/api_client.dart';
import '../network/network_info.dart';

/// Core providers for dependency injection
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl();
});
