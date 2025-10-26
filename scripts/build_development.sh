#!/bin/bash
# Development build script
set -e

echo "Building for development environment..."

# Clean and get dependencies
flutter clean
flutter pub get

# Run tests
echo "Running tests..."
flutter test

# Build development APK
echo "Building development APK..."
flutter build apk --flavor development -t lib/main_development.dart --debug

echo "Development build completed successfully!"
echo "APK location: build/app/outputs/flutter-apk/app-development-debug.apk"
