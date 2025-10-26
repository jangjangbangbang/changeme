import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import 'core/config/app_config.dart';
import 'core/config/environment_detector.dart';
import 'app/providers.dart';

void main(List<String> args, {AppConfig? config}) {
  // Use provided config or detect from environment
  final appConfig = config ?? EnvironmentDetector.getConfig();

  // Initialize logging based on environment
  Logger.root.level = _getLogLevel(appConfig.logLevel);
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: MyApp(config: appConfig)));
}

Level _getLogLevel(String level) {
  switch (level.toUpperCase()) {
    case 'DEBUG':
      return Level.ALL;
    case 'INFO':
      return Level.INFO;
    case 'WARNING':
      return Level.WARNING;
    case 'ERROR':
      return Level.SEVERE;
    default:
      return Level.ALL;
  }
}

class MyApp extends ConsumerWidget {
  final AppConfig? config;

  const MyApp({super.key, this.config});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final appConfig = config ?? EnvironmentDetector.getConfig();

    return MaterialApp.router(
      title: appConfig.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: appConfig.isDebugMode,
    );
  }
}
