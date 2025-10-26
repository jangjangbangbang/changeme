#!/bin/bash
# Production build script
set -e

echo "Building for production environment..."

# Clean and get dependencies
flutter clean
flutter pub get

# Run tests
echo "Running tests..."
flutter test

# Build production APK and App Bundle
echo "Building production APK..."
flutter build apk --flavor production -t lib/main_production.dart --release

echo "Building production App Bundle..."
flutter build appbundle --flavor production -t lib/main_production.dart --release

echo "Production build completed successfully!"
echo "APK location: build/app/outputs/flutter-apk/app-production-release.apk"
echo "App Bundle location: build/app/outputs/bundle/productionRelease/app-production-release.aab"
