import 'core/config/staging_config.dart';
import 'main.dart' as app;

/// Staging environment entry point
void main(List<String> args) {
  app.main(args, config: StagingConfig());
}
