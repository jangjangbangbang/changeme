# iOS Flavor Configuration

This directory contains the iOS-specific configuration for Flutter app flavors.

## Setup

1. **Run the setup script** to configure iOS flavors:
   ```bash
   ./scripts/setup_ios_flavors.sh
   ```

2. **Or manually configure** by running:
   ```bash
   flutter build ios --flavor development -t lib/main_development.dart --debug --no-codesign
   flutter build ios --flavor staging -t lib/main_staging.dart --debug --no-codesign
   flutter build ios --flavor production -t lib/main_production.dart --debug --no-codesign
   ```

## Configuration Files

### xcconfig Files
- `Flutter/Development.xcconfig` - Development environment configuration
- `Flutter/Staging.xcconfig` - Staging environment configuration  
- `Flutter/Production.xcconfig` - Production environment configuration

### Xcode Schemes
- `Runner.xcodeproj/xcshareddata/xcschemes/Development.xcscheme`
- `Runner.xcodeproj/xcshareddata/xcschemes/Staging.xcscheme`
- `Runner.xcodeproj/xcshareddata/xcschemes/Production.xcscheme`

## Usage

### Command Line
```bash
# Development
flutter run --flavor development -t lib/main_development.dart

# Staging
flutter run --flavor staging -t lib/main_staging.dart

# Production
flutter run --flavor production -t lib/main_production.dart
```

### VS Code
Use the launch configurations in `.vscode/launch.json`:
- "iOS Development"
- "iOS Staging" 
- "iOS Production"

## Troubleshooting

If you get the error "The Xcode project does not define custom schemes":

1. Run the setup script: `./scripts/setup_ios_flavors.sh`
2. Or manually build each flavor once to create the schemes
3. Make sure the xcconfig files are in the correct location (`ios/Flutter/`)

## Environment Variables

Each xcconfig file defines:
- `ENVIRONMENT` - Current environment (development/staging/production)
- `BUNDLE_IDENTIFIER` - App bundle identifier
- `APP_NAME` - Display name for the app
- `BASE_URL` - API base URL
- `API_KEY` - API key for the environment
- `DEBUG_MODE` - Whether debug mode is enabled
- `ENABLE_ANALYTICS` - Whether analytics are enabled


