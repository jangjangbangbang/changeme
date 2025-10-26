#!/bin/bash
# iOS Flavor Setup Script
set -e

echo "Setting up iOS flavors..."

# Navigate to iOS directory
cd ios

# Clean and get dependencies
echo "Cleaning iOS project..."
flutter clean

# Get Flutter dependencies
echo "Getting Flutter dependencies..."
flutter pub get

# Build for each flavor to ensure schemes are created
echo "Building Development flavor..."
flutter build ios --flavor development -t lib/main_development.dart --debug --no-codesign

echo "Building Staging flavor..."
flutter build ios --flavor staging -t lib/main_staging.dart --debug --no-codesign

echo "Building Production flavor..."
flutter build ios --flavor production -t lib/main_production.dart --debug --no-codesign

echo "iOS flavors setup completed successfully!"
echo ""
echo "Available iOS schemes:"
echo "- Development"
echo "- Staging" 
echo "- Production"
echo ""
echo "You can now use --flavor option with iOS builds."


