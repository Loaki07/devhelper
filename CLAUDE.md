# DevHelper - Claude Context

## Project Overview
DevHelper is a native macOS application built with SwiftUI that provides essential developer utilities in a single, unified interface. The app contains 9 fully-functional tools commonly used by developers, with search functionality and modern UI design.

## Current Status
**✅ COMPLETE** - All 9 tools are fully implemented and working. Version 1.4 released.

## Tools Implemented

### 1. Timestamp Converter (`TimestampConverterView.swift`)
- **Status**: ✅ Complete
- **Features**: Auto-detection of timestamp formats (seconds/milliseconds/microseconds/nanoseconds), bidirectional conversion, timezone support (Local/UTC), current timestamp generation
- **UI**: Two-column layout with real-time conversion, **selectable text results**
- **Recent Updates**: Fixed result selectability issue - users can now select and copy results

### 2. Unit Converter (`UnitConverterView.swift`)
- **Status**: ✅ Complete
- **Features**: 6 categories (Data, Length, Weight, Temperature, Area, Volume), real-time conversion, special temperature handling
- **UI**: Category picker with from/to unit selection, **Data category moved to first position**
- **Recent Updates**: Removed Time category, Data now default selection

### 3. JSON Formatter (`JSONFormatterView.swift`)
- **Status**: ✅ Complete
- **Features**: Format (pretty print), minify, validate, escape for strings, syntax error highlighting
- **UI**: Two-panel layout with mode selection

### 4. Base64 Encode/Decode (`Base64View.swift`)
- **Status**: ✅ Complete
- **Features**: Text encoding/decoding, URL-safe Base64 variant, swap functionality
- **UI**: Tabbed interface with encode/decode modes
- **Recent Updates**: Renamed from "Base64 Encoder/Decoder" to "Base64 Encode/Decode"

### 5. Regex Tester (`RegexTesterView.swift`)
- **Status**: ✅ Complete
- **Features**: Pattern matching, capture groups, replacement, common patterns library, regex flags
- **UI**: Pattern input with results display and common pattern buttons

### 6. UUID Generator (`UUIDGeneratorView.swift`)
- **Status**: ✅ Complete
- **Features**: Multiple formats, bulk generation (1-100), UUID validation, common pattern examples
- **UI**: Generation controls with scrollable results list

### 7. URL Tools (`URLToolsView.swift`)
- **Status**: ✅ Complete
- **Features**: URL encoding/decoding, comprehensive URL parsing, query parameter breakdown
- **UI**: Three-tab interface (Encoder/Decoder/Parser)

### 8. IP Query (`IPQueryView.swift`)
- **Status**: ✅ Complete
- **Features**: Dual IP detection (international vs China networks), current IP discovery, IP geolocation query, comprehensive location information
- **UI**: Two-column layout with smart dual IP display, sample IP buttons, detailed location breakdown
- **Recent Updates**: Added User-Agent headers for bot detection avoidance, uses Baidu API for reliable China IP detection

### 9. HTTP Request (`HTTPRequestView.swift`)
- **Status**: ✅ Complete
- **Features**: Full HTTP client with all methods (GET/POST/PUT/DELETE/etc), headers management, Basic/Bearer authentication, request body support, TLS verification skip, response timing, SSE streaming support, binary download
- **UI**: Split layout with request configuration (headers/auth/body tabs) and response display (body/headers), real-time timer, status code indicators, copy/save functionality
- **Recent Updates**: Added comprehensive HTTP client with SSE streaming, binary download support, and professional request/response handling

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
│   └── Views/                      # All 9 tool implementations
│       ├── TimestampConverterView.swift
│       ├── UnitConverterView.swift
│       ├── JSONFormatterView.swift
│       ├── Base64View.swift
│       ├── UUIDGeneratorView.swift
│       ├── URLToolsView.swift
│       ├── RegexTesterView.swift
│       ├── IPQueryView.swift
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
- `ContentView` uses NavigationSplitView with sidebar selection and **search functionality**
- Each tool is a separate SwiftUI view with consistent styling
- **Search bar** in sidebar allows filtering tools by title

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
- **Version**: 1.4 (Build 5)
- **Entitlements**: App Sandbox enabled, Hardened Runtime enabled

### Dependencies
- SwiftUI for UI framework
- Combine for reactive programming
- Foundation for core utilities
- AppKit for clipboard access (NSPasteboard)

## Recent Updates (Version 1.4)

### Major New Feature
- **HTTP Request Tool**: Professional-grade HTTP client with comprehensive functionality
  - All HTTP methods (GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS)
  - Advanced headers management with common header shortcuts
  - Authentication support (Basic Auth, Bearer Token)
  - Request body support for JSON, XML, form data
  - TLS verification bypass option for development
  - Real-time request timer and response time measurement
  - Server-Sent Events (SSE) streaming support with real-time updates
  - Response viewing modes (Preview/Raw) with automatic JSON formatting
  - Binary data download functionality with file save dialog
  - Comprehensive error handling and status code visualization
  - Copy/save functionality for requests and responses

### Previous Updates (Version 1.3)
- **IP Query Tool**: Complete IP address discovery and geolocation
- **Dual IP detection**: International vs China network awareness
- **User-Agent headers**: Bot detection avoidance for API calls

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
- ✅ **macOS Color References**: Fixed all `systemGray5`, `systemGray6`, `systemBackground` references to use proper NSColor equivalents
- ✅ **Timestamp Converter Selectability**: Added `.textSelection(.enabled)` to result text areas

### Common Gotchas
- **macOS vs iOS modifiers**: Some SwiftUI modifiers are iOS-only
- **Clipboard access**: Use `NSPasteboard` for macOS, not `UIPasteboard`
- **Network requests**: Ensure app has network entitlements for IP Query tool
- **App Transport Security**: Use HTTPS endpoints to avoid ATS blocks

## Future Enhancements

### Potential Features
- **Preferences window**: User customization options
- **Themes**: Light/dark mode preferences
- **Keyboard shortcuts**: Quick access to common functions
- **Export/Import**: Save tool configurations
- **IP Query history**: Persistent storage for IP queries
- **Additional geolocation providers**: More IP data sources

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
- ✅ All 9 essential tools fully implemented
- ✅ Consistent UI/UX across all tools
- ✅ Real-time processing and feedback
- ✅ Professional macOS native experience
- ✅ Comprehensive error handling
- ✅ Copy-to-clipboard functionality throughout
- ✅ Search functionality for quick tool access
- ✅ Selectable text in results areas
- ✅ Streamlined feature set focused on core developer needs

---

**Last Updated**: Version 1.4 released with comprehensive HTTP Request tool featuring professional-grade HTTP client capabilities, SSE streaming support, and advanced request/response handling.
**Next Steps**: Optional enhancements like request history, cURL export, environment variables, or API testing collections.