#!/bin/bash

# DevHelper Build Script
# This script builds the DevHelper project without running it

set -e  # Exit on any error

PROJECT_NAME="DevHelper"
SCHEME_NAME="DevHelper"
CONFIGURATION="Debug"

echo "🔨 DevHelper Build Script"
echo "========================"

# Check if we're in the right directory
if [ ! -d "$PROJECT_NAME.xcodeproj" ]; then
    echo "❌ Error: $PROJECT_NAME.xcodeproj not found in current directory"
    echo "Please run this script from the project root directory"
    exit 1
fi

# Build the project
echo "🔨 Building $PROJECT_NAME..."
xcodebuild build -project "$PROJECT_NAME.xcodeproj" -scheme "$SCHEME_NAME" -configuration "$CONFIGURATION" CODE_SIGNING_ALLOWED=NO

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo ""
    echo "💡 To run the app, use: ./run.sh"
    echo "💡 To clean and rebuild, use: ./clean.sh"
else
    echo "❌ Build failed!"
    exit 1
fi
