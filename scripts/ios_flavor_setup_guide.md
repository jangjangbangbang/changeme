# iOS Flavor Setup Guide

## The Problem
Flutter expects build configurations like `Debug-Development`, `Debug-Staging`, etc., but Xcode projects only have standard configurations (`Debug`, `Release`, `Profile`).

## Solution: Manual Setup (Required)

### Step 1: Open Xcode
```bash
open ios/Runner.xcworkspace
```

### Step 2: Create Build Configurations

1. **Select the Runner PROJECT** (not target) in the project navigator
2. **Go to Editor → Add Configuration → Duplicate "Debug" Configuration**
3. **Name the new configuration**: `Debug-Development`
4. **Repeat for all needed configurations**:

#### Debug Configurations:
- `Debug-Development`
- `Debug-Staging` 
- `Debug-Production`

#### Release Configurations:
- `Release-Development`
- `Release-Staging`
- `Release-Production`

### Step 3: Configure Each Build Configuration

For each configuration, set the appropriate xcconfig file:

1. **Select the configuration** in the project settings
2. **Set the "Configurations File"** to the corresponding xcconfig:
   - `Debug-Development` → `Flutter/Development.xcconfig`
   - `Debug-Staging` → `Flutter/Staging.xcconfig`
   - `Debug-Production` → `Flutter/Production.xcconfig`
   - `Release-Development` → `Flutter/Development.xcconfig`
   - `Release-Staging` → `Flutter/Staging.xcconfig`
   - `Release-Production` → `Flutter/Production.xcconfig`

### Step 4: Update Schemes

Make sure each scheme uses the correct build configuration:

- **Development scheme** → `Debug-Development` / `Release-Development`
- **Staging scheme** → `Debug-Staging` / `Release-Staging`
- **Production scheme** → `Debug-Production` / `Release-Production`

### Step 5: Test the Setup

After completing the Xcode configuration:

```bash
# Clean and rebuild
flutter clean
flutter pub get

# Test each flavor
flutter run --flavor development -t lib/main_development.dart
flutter run --flavor staging -t lib/main_staging.dart
flutter run --flavor production -t lib/main_production.dart
```

## Alternative: Use FLUTTER_BUILD_MODE

If you prefer not to create custom build configurations, you can set `FLUTTER_BUILD_MODE=debug` in your xcconfig files and run from Xcode directly.

## Troubleshooting

### "Build configuration not found"
- Make sure you created all the required build configurations
- Verify the scheme is using the correct build configuration
- Check that the xcconfig files are properly linked

### "Scheme not found"
- Ensure the schemes are in `ios/Runner.xcodeproj/xcshareddata/xcschemes/`
- Try building each flavor once to create the schemes

### "xcconfig file not found"
- Verify the xcconfig files are in `ios/Flutter/` directory
- Check the file paths in Xcode project settings


