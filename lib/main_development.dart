import 'core/config/development_config.dart';
import 'main.dart' as app;

/// Development environment entry point
void main(List<String> args) {
  app.main(args, config: DevelopmentConfig());
}
