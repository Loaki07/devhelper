#!/bin/bash

# DevHelper Build and Run Script
# This script builds and runs the DevHelper project in one command

set -e  # Exit on any error

PROJECT_NAME="DevHelper"
SCHEME_NAME="DevHelper"
CONFIGURATION="Debug"

echo "🚀 DevHelper Build & Run Script"
echo "================================"

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
    
    # Find the built app (exclude Index.noindex folder)
    APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "$PROJECT_NAME.app" -type d | grep "/Build/Products/" | grep -v "Index.noindex" | head -1)
    
    if [ -n "$APP_PATH" ]; then
        echo "📱 Found app at: $APP_PATH"
        echo "🚀 Launching $PROJECT_NAME..."
        
        # Launch the app
        open "$APP_PATH"
        
        echo ""
        echo "✅ $PROJECT_NAME is now running!"
        echo ""
        echo "💡 To stop the app:"
        echo "   • Close the app window, OR"
        echo "   • Press Cmd+Q while the app is active, OR"
        echo "   • Use Activity Monitor to quit the process"
        echo ""
        echo "💡 You can close this terminal - the app will continue running"
        echo ""
        echo "💡 For future runs (without rebuilding), use: ./run.sh"
    else
        echo "❌ Could not find built app"
        exit 1
    fi
else
    echo "❌ Build failed!"
    exit 1
fi
