#!/bin/bash

# DevHelper Clean Script
# This script cleans build artifacts

set -e  # Exit on any error

PROJECT_NAME="DevHelper"
SCHEME_NAME="DevHelper"
CONFIGURATION="Debug"

echo "🧹 DevHelper Clean Script"
echo "========================"

# Check if we're in the right directory
if [ ! -d "$PROJECT_NAME.xcodeproj" ]; then
    echo "❌ Error: $PROJECT_NAME.xcodeproj not found in current directory"
    echo "Please run this script from the project root directory"
    exit 1
fi

echo "🧹 Cleaning build artifacts..."
xcodebuild clean -project "$PROJECT_NAME.xcodeproj" -scheme "$SCHEME_NAME" -configuration "$CONFIGURATION"

if [ $? -eq 0 ]; then
    echo "✅ Clean successful!"
    echo ""
    echo "💡 To build the project, use: ./build.sh"
    echo "💡 To build and run, use: ./build_and_run.sh"
else
    echo "❌ Clean failed!"
    exit 1
fi
