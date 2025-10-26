import 'core/config/production_config.dart';
import 'main.dart' as app;

/// Production environment entry point
void main(List<String> args) {
  app.main(args, config: ProductionConfig());
}
