#!/bin/bash

# DevHelper Run Script
# This script runs the DevHelper app if it's already built

set -e  # Exit on any error

PROJECT_NAME="DevHelper"

echo "🚀 DevHelper Run Script"
echo "======================="

# Check if we're in the right directory
if [ ! -d "$PROJECT_NAME.xcodeproj" ]; then
    echo "❌ Error: $PROJECT_NAME.xcodeproj not found in current directory"
    echo "Please run this script from the project root directory"
    exit 1
fi

# Find the built app (exclude Index.noindex folder)
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "$PROJECT_NAME.app" -type d | grep "/Build/Products/" | grep -v "Index.noindex" | head -1)

if [ -n "$APP_PATH" ]; then
    echo "📱 Found built app at: $APP_PATH"
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
else
    echo "❌ No built app found!"
    echo ""
    echo "💡 To build the app first, use: ./build.sh"
    echo "💡 To build and run in one command, use: ./build_and_run.sh"
    exit 1
fi
