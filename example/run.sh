#!/bin/bash

# Flutter Yuku Example - Platform Runner Script

echo "🚀 Flutter Yuku Example - Platform Runner"
echo "==========================================="
echo ""

# Check if platform argument is provided
if [ -z "$1" ]; then
    echo "Usage: ./run.sh [platform]"
    echo ""
    echo "Available platforms:"
    echo "  android   - Run on Android device/emulator"
    echo "  ios       - Run on iOS simulator"
    echo "  web       - Run in Chrome"
    echo "  macos     - Run on macOS"
    echo "  windows   - Run on Windows"
    echo "  linux     - Run on Linux"
    echo "  all       - Show all available devices"
    echo ""
    echo "Example: ./run.sh android"
    exit 1
fi

PLATFORM=$1

case $PLATFORM in
    android)
        echo "📱 Running on Android..."
        flutter run -d android
        ;;
    ios)
        echo "🍎 Running on iOS..."
        flutter run -d ios
        ;;
    web)
        echo "🌐 Running on Web..."
        flutter run -d chrome
        ;;
    macos)
        echo "💻 Running on macOS..."
        flutter run -d macos
        ;;
    windows)
        echo "🪟 Running on Windows..."
        flutter run -d windows
        ;;
    linux)
        echo "🐧 Running on Linux..."
        flutter run -d linux
        ;;
    all)
        echo "📋 Available devices:"
        flutter devices
        ;;
    *)
        echo "❌ Unknown platform: $PLATFORM"
        echo "Run './run.sh' without arguments to see available options"
        exit 1
        ;;
esac

