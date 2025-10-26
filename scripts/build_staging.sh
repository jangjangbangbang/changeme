#!/bin/bash
# Staging build script
set -e

echo "Building for staging environment..."

# Clean and get dependencies
flutter clean
flutter pub get

# Run tests
echo "Running tests..."
flutter test

# Build staging APK
echo "Building staging APK..."
flutter build apk --flavor staging -t lib/main_staging.dart --release

echo "Staging build completed successfully!"
echo "APK location: build/app/outputs/flutter-apk/app-staging-release.apk"
