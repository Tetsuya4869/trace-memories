#!/bin/bash

# TraceMemories iOS Setup Helper Script 🍏
# This script automates the environment setup for iOS development on Mac.

echo "🚀 Starting iOS Environment Setup for TraceMemories..."

# 1. Flutter Precache
echo "📥 Pre-caching iOS artifacts..."
flutter precache --ios

# 2. Install CocoaPods if missing
if ! command -v pod &> /dev/null
then
    echo "❌ CocoaPods could not be found. Please install it with 'sudo gem install cocoapods'."
    exit
fi

# 3. Pod Install
echo "📦 Installing CocoaPods dependencies..."
cd ios
pod install
cd ..

# 4. Check for .env file
if [ ! -f .env ]; then
    echo "⚠️  Warning: .env file not found. Please create it and add your Mapbox tokens."
fi

echo "✅ Setup complete! You can now run 'flutter run' or open 'ios/Runner.xcworkspace' in Xcode."
