/// Environment enum for different app flavors
enum Environment {
  development,
  staging,
  production;

  bool get isDevelopment => this == Environment.development;
  bool get isStaging => this == Environment.staging;
  bool get isProduction => this == Environment.production;

  String get name {
    switch (this) {
      case Environment.development:
        return 'Development';
      case Environment.staging:
        return 'Staging';
      case Environment.production:
        return 'Production';
    }
  }

  String get shortName {
    switch (this) {
      case Environment.development:
        return 'DEV';
      case Environment.staging:
        return 'STAGING';
      case Environment.production:
        return 'PROD';
    }
  }
}
