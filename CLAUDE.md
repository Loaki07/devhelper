# DevHelper - Claude Context

## Project Overview
DevHelper is a native macOS application built with SwiftUI that provides essential developer utilities in a single, unified interface. The app contains 8 fully-functional tools commonly used by developers.

## Current Status
**✅ COMPLETE** - All 8 tools are fully implemented and working.

## Tools Implemented

### 1. Timestamp Converter (`TimestampConverterView.swift`)
- **Status**: ✅ Complete
- **Features**: Auto-detection of timestamp formats (seconds/milliseconds/microseconds/nanoseconds), bidirectional conversion, timezone support (Local/UTC), current timestamp generation
- **UI**: Two-column layout with real-time conversion

### 2. Unit Converter (`UnitConverterView.swift`)
- **Status**: ✅ Complete
- **Features**: 7 categories (Length, Weight, Temperature, Data, Time, Area, Volume), real-time conversion, special temperature handling
- **UI**: Category picker with from/to unit selection

### 3. JSON Formatter (`JSONFormatterView.swift`)
- **Status**: ✅ Complete
- **Features**: Format (pretty print), minify, validate, escape for strings, syntax error highlighting
- **UI**: Two-panel layout with mode selection

### 4. Base64 Encoder/Decoder (`Base64View.swift`)
- **Status**: ✅ Complete
- **Features**: Text encoding/decoding, URL-safe Base64 variant, swap functionality
- **UI**: Tabbed interface with encode/decode modes

### 5. UUID Generator (`UUIDGeneratorView.swift`)
- **Status**: ✅ Complete
- **Features**: Multiple formats, bulk generation (1-100), UUID validation, common pattern examples
- **UI**: Generation controls with scrollable results list

### 6. URL Tools (`URLToolsView.swift`)
- **Status**: ✅ Complete
- **Features**: URL encoding/decoding, comprehensive URL parsing, query parameter breakdown
- **UI**: Three-tab interface (Encoder/Decoder/Parser)

### 7. Regex Tester (`RegexTesterView.swift`)
- **Status**: ✅ Complete
- **Features**: Pattern matching, capture groups, replacement, common patterns library, regex flags
- **UI**: Pattern input with results display and common pattern buttons

### 8. HTTP Request Tool (`HTTPRequestView.swift`)
- **Status**: ✅ Complete
- **Features**: All HTTP methods, header management, authentication (Basic/Bearer), multiple body types, response viewer, cURL export
- **UI**: Request builder with response viewer

## Architecture

### Project Structure
```
DevHelper/
├── DevHelper.xcodeproj/
├── DevHelper/
│   ├── DevHelperApp.swift          # Main app entry point
│   ├── ContentView.swift           # Navigation split view
│   ├── Models/
│   │   └── ToolType.swift          # Tool definitions
│   └── Views/                      # All 8 tool implementations
│       ├── TimestampConverterView.swift
│       ├── UnitConverterView.swift
│       ├── JSONFormatterView.swift
│       ├── Base64View.swift
│       ├── UUIDGeneratorView.swift
│       ├── URLToolsView.swift
│       ├── RegexTesterView.swift
│       └── HTTPRequestView.swift
└── DESIGN.md                       # Comprehensive design document
```

### Technical Stack
- **Platform**: macOS 14.0+
- **Framework**: SwiftUI
- **Language**: Swift 5.0
- **Architecture**: MVVM pattern with @State and @Published
- **Navigation**: NavigationSplitView with sidebar

## Key Implementation Details

### Navigation Pattern
- All tools are defined in `ToolType` enum with titles and SF Symbols icons
- `ContentView` uses NavigationSplitView with sidebar selection
- Each tool is a separate SwiftUI view with consistent styling

### Common UI Patterns
- **Two-column layouts**: Input/output sections with arrow indicators
- **Tabbed interfaces**: Multiple related functions in single tool
- **Copy functionality**: Ubiquitous copy-to-clipboard buttons
- **Sample data**: Quick testing with provided examples
- **Real-time processing**: Instant results as user types

### Shared Components
- Consistent button styling (`.bordered`, `.borderedProminent`)
- Monospace fonts for technical data
- Color coding (green for success, red for errors)
- Rounded border text field styling

## Build Configuration

### Target Settings
- **Bundle ID**: com.devhelper.DevHelper
- **Minimum macOS**: 14.0
- **Entitlements**: App Sandbox enabled, Network access for HTTP tool

### Dependencies
- SwiftUI for UI framework
- Combine for reactive programming
- Foundation for core utilities
- AppKit for clipboard access (NSPasteboard)

## Common Development Tasks

### Adding a New Tool
1. Add case to `ToolType` enum in `Models/ToolType.swift`
2. Create new SwiftUI view file in `Views/`
3. Add switch case in `ContentView.swift`
4. Follow established UI patterns and styling

### Modifying Existing Tools
- Each tool is self-contained in its own file
- Use established state management patterns
- Maintain consistent UI styling and copy functionality

### Testing
- Each tool has sample data/examples for quick testing
- SwiftUI Previews available for all views
- Manual testing covers error cases and edge conditions

## Known Issues & Solutions

### Fixed Issues
- ✅ **Unit Converter keyboardType error**: Removed iOS-specific `.keyboardType(.decimalPad)` modifier
- ✅ **HTTP Response headers type conversion**: Fixed `AnyHashable` to `String` conversion for response headers

### Common Gotchas
- **macOS vs iOS modifiers**: Some SwiftUI modifiers are iOS-only
- **Clipboard access**: Use `NSPasteboard` for macOS, not `UIPasteboard`
- **Network requests**: Ensure app has network entitlements for HTTP tool

## Future Enhancements

### Potential Features
- **Preferences window**: User customization options
- **Themes**: Light/dark mode preferences
- **Keyboard shortcuts**: Quick access to common functions
- **Export/Import**: Save tool configurations
- **Request history**: Persistent storage for HTTP requests

### Technical Improvements
- **Performance**: Optimize for large text processing
- **Accessibility**: Enhanced VoiceOver support
- **Localization**: Multi-language support

## Development Commands

### Build & Run
```bash
# Build project
xcodebuild -project DevHelper.xcodeproj -scheme DevHelper -configuration Debug

# Or open in Xcode
open DevHelper.xcodeproj
```

### Project Management
- **Design Document**: `DESIGN.md` contains comprehensive architecture details
- **This File**: `CLAUDE.md` provides context for future Claude sessions
- **README**: `README.md` contains user-facing project information

## Success Metrics
- ✅ All 8 tools fully implemented
- ✅ Consistent UI/UX across all tools
- ✅ Real-time processing and feedback
- ✅ Professional macOS native experience
- ✅ Comprehensive error handling
- ✅ Copy-to-clipboard functionality throughout

---

**Last Updated**: Initial implementation complete with all 8 tools working.
**Next Steps**: App icon, branding, and distribution configuration (optional enhancements).